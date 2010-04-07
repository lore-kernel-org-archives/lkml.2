Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab0DGRQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:16:15 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:44018 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab0DGRQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:16:11 -0400
Date: Wed, 7 Apr 2010 10:16:10 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
Message-ID: <20100407171610.GH29192@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org> <1270612783.8518.15.camel@dc7800.home> <20100407041333.GF29192@hexapodia.org> <1270614080.8518.26.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270614080.8518.26.camel@dc7800.home>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:21:20PM -0600, Bjorn Helgaas wrote:
> > The machine only has Linux installed, but I may have access to another
> > T3400 that can dual-boot.  Any preference for XP versus Win7?
> 
> Nope, whatever's more convenient for you should be fine.

On another T3400 with BIOS A03, Win7's Device Manager -> IDE ATA/ATAPI
controllers -> Standard AHCI 1.0 -> Resources -> Memory Range setting is
ff97f800-ff97ffff.  (If that's not the info you needed, let me know
where I need to look to get the answer.)

> > > Would you mind trying the patch below and the patch and kernel args
> > > here:
> > >   https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
> > > 
> > > This will (1) reserve the VGA area, so we should put the AHCI device
> > > elsewhere, and (2) collect a few more details about exactly what the
> > > BIOS is reporting.
> > 
> > I'll try that on Thursday.
> 
> Great, thanks!  Oh, and I forgot to ask: what BIOS version are you
> running?

BIOS Information
        Vendor: Dell Inc.
        Version: A04
        Release Date: 03/21/2008

> I think we still have a Linux bug in that we should be reserving the
> legacy VGA area, but if the BIOS is reporting an incorrect host bridge
> window, that will cause us to move the AHCI controller and tickle this
> bug when we wouldn't otherwise.

I'll try the debug patch tomorrow morning.

-andy
