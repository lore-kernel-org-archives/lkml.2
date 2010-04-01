Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0DAR3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:29:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794Ab0DAR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:28:58 -0400
Date: Thu, 1 Apr 2010 10:24:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alex Deucher <alexdeucher@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gamil.com>, dri-devel@lists.sourceforge.net,
       stable@kernel.org
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780
  (was: Re: Linux 2.6.34-rc3)
In-Reply-To: <o2ma728f9f91004011007l4c3aee18p14daae06cda71e68@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004011019270.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>  <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>  <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
 <o2ma728f9f91004011007l4c3aee18p14daae06cda71e68@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, Alex Deucher wrote:
> 
> Clemems' "PCI quirk: RS780/RS880: disable MSI completely" patch is the
> right approach I think.  Note that it's only devices hung off the int
> gfx pci to pci bridge that have broken MSI (gfx and audio).  MSI works
> fine on the PCIE slots.  I have a similar patch for rs400 chips on bug
> 15626:
> https://bugzilla.kernel.org/show_bug.cgi?id=15626

Hmm. Does 'pci_msi_enable' only cover regular PCI devices? Or will that 
pci_no_msi() quirk disable MSI for PCIE too? I think it will trigger for 
PCIE drivers too.

Put another way: it sounds like the quirk now disables MSI for all 
devices. Maybe there would some more targeted mode?

		Linus
