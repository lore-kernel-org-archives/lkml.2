Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0DGEWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 00:22:04 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:21252 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0DGEWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 00:22:00 -0400
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20100407041333.GF29192@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org>
	 <1270612783.8518.15.camel@dc7800.home>
	 <20100407041333.GF29192@hexapodia.org>
Content-Type: text/plain
Date: Tue, 06 Apr 2010 22:21:20 -0600
Message-Id: <1270614080.8518.26.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 21:13 -0700, Andy Isaacson wrote:
> On Tue, Apr 06, 2010 at 09:59:43PM -0600, Bjorn Helgaas wrote:
> > > I suspect it's due to:
> > > 
> > > [    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> > > [    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]
> > 
> > Thanks a lot for reporting this!
> > 
> > No need to bisect it.  I'm pretty sure 2.6.34-rc1 will boot fine if you
> > use "pci=use_crs" (obviously that's only a temporary workaround until we
> > fix the real problem).
> 
> pci=nocrs worked on 2.6.34-rc3-00299-g0fdf867.  I won't be back in front
> of the machine to try use_crs until Thursday.

Oops, sorry, I meant it would probably work with "pci=nocrs", as you
already confirmed.  Don't bother trying "pci=use_crs"; that's turned on
automatically on your system already.

> > If you happen to have Windows on this box, I'd love to know whether *it*
> > moves the AHCI device, too, or whether Windows interprets the BIOS
> > information differently than we do.  If you have Windows and can collect
> > screenshots of the Device Manager resources for the PCI bus and the AHCI
> > controller, that would be a good start.
> 
> The machine only has Linux installed, but I may have access to another
> T3400 that can dual-boot.  Any preference for XP versus Win7?

Nope, whatever's more convenient for you should be fine.

> > Would you mind trying the patch below and the patch and kernel args
> > here:
> >   https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
> > 
> > This will (1) reserve the VGA area, so we should put the AHCI device
> > elsewhere, and (2) collect a few more details about exactly what the
> > BIOS is reporting.
> 
> I'll try that on Thursday.

Great, thanks!  Oh, and I forgot to ask: what BIOS version are you
running?  Google found several reports of USB issues in Windows on this
box, e.g., http://tim.cexx.org/?p=529 .

I think we still have a Linux bug in that we should be reserving the
legacy VGA area, but if the BIOS is reporting an incorrect host bridge
window, that will cause us to move the AHCI controller and tickle this
bug when we wouldn't otherwise.

Bjorn


