Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2DJGtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:49:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36840 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2DJGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:49:16 -0400
Date: Tue, 10 Apr 2012 14:49:18 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        spock@gentoo.org
Subject: Re: [PATCH] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120410064918.GA7611@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, FlorianSchandinat@gmx.de,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	spock@gentoo.org
References: <20120327100136.GA3829@udknight>
 <20120327143243.015ecff6@pyramind.ukuu.org.uk>
 <20120328005238.GA3844@udknight>
 <20120401010530.GA4431@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401010530.GA4431@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 09:05:30AM +0800, Wang YanQing wrote:
> On Wed, Mar 28, 2012 at 08:52:38AM +0800, Wang YanQing wrote:
> > On Tue, Mar 27, 2012 at 02:32:43PM +0100, Alan Cox wrote:
> > > On Tue, 27 Mar 2012 18:01:36 +0800
> > > Wang YanQing <udknight@gmail.com> wrote:
> > > 
> > > > 
> > > > Ok! I try to check pcibios_enabled first, but get some opposition by Alan Cox,
> > > > but I want to make thing work and fix the oops, so I choice the simple way to
> > > > check the (__supported_pte_mask & _PAGE_NX) instead of to check this variable plus
> > > > pci kernel boot parameter, pci mmconfig works or not, and more, and more. It is not
> > > > the best method, but it works and maybe all will feel happy.
> > > 
> > > Okay let me ask the obvious question - why is it not the best method ?
> > > 
> > > Apart from adding a helper in the includes for the arch code of
> > > 
> > > 	static inline is_nx_enabled(void)
> > > 	{
> > > 		return !!(__supported_pte_mask & _PAGE_NX);
> > > 	}
> > > 
> > > is there anything else it lacks ?
> > > 
> > > Yes ideally we'd set the relevant ROM areas executable, but for a simple
> > > fix is there anything else that's a problem with it ?
> > Ok! Maybe you had missed my previous reply
> > http://permalink.gmane.org/gmane.linux.kernel/1272433
> > It is not the best method, because the check is not enough.
> > I means when NX is actively, the pci bios is NX or not also depend on
> > the code path in pci_arch_init which will be influenced by the acpi on or off, pci kernel boot
> > parameter, even kernel config like pci access method PCI_GOANY, PCI_GOMMCONFIG, or PCI_GODIRECT,
> > but if I check the pcibios_enabled, all the above can be ignored.
> > 
> > if uvesafb use the PMI when PCI BIOS is X, it can get the better work efficience then use the redraw 
> > method as a fallback when do the panning.
> Alan
> 
> I am just curious, I want to know what I describe above is right a little,
> or wrong about all the aspect.
> thanks.
> 
Hi Alan, are you decided to not reply this any? 
But maybe we are still here to wait for your proposal to 
decide the final proper solution to fix the bug in kernel.

Thanks
