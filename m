Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab0DARuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:50:10 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40783 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754242Ab0DARuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:50:07 -0400
X-Sasl-enc: N8VRHnekNnYdxMftlvXFG5YTsEOZ0+Dh3A1j+BHRDAQD 1270144205
Message-ID: <4BB4DCCA.5030907@ladisch.de>
Date: Thu, 01 Apr 2010 19:50:02 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alex Deucher <alexdeucher@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>  <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>  <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org> <o2ma728f9f91004011007l4c3aee18p14daae06cda71e68@mail.gmail.com> <alpine.LFD.2.00.1004011019270.3707@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004011019270.3707@i5.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 1 Apr 2010, Alex Deucher wrote:
> > Clemems' "PCI quirk: RS780/RS880: disable MSI completely" patch is the
> > right approach I think.  Note that it's only devices hung off the int
> > gfx pci to pci bridge that have broken MSI (gfx and audio).  MSI works
> > fine on the PCIE slots.  I have a similar patch for rs400 chips on bug
> > 15626:
> > https://bugzilla.kernel.org/show_bug.cgi?id=15626
> 
> Hmm. Does 'pci_msi_enable' only cover regular PCI devices? Or will that 
> pci_no_msi() quirk disable MSI for PCIE too?

A quirk that used pci_no_msi() would disable all MSI for all devices.
However, these patches (and that in bug 15626) use PCI_BUS_FLAGS_NO_MSI
so that only the internal GPU devices are affected.

That "completely" in my patch title should better read "unconditionally".


Regards,
Clemens
