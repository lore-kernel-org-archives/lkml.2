Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab0DAQfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:35:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758190Ab0DAQfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:35:08 -0400
Date: Thu, 1 Apr 2010 09:29:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       Alex Deucher <alexdeucher@gamil.com>, stable@kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780
 (was: Re: Linux 2.6.34-rc3)
In-Reply-To: <201004010313.32920.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
> 
> OK, I've verified that partial revert (below) is sufficient.

Hmm. Through the DRM merge I just did, this area actually conflicted, and 
the resolved version is now

        if ((rdev->family >= CHIP_RV380) &&
            (!(rdev->flags & RADEON_IS_IGP))) {

which presumably also fixes your issue?

[ Side note: somebody in the DRM tree seems to be way too used to LISP, 
  and thinks that adding parenthesis always improves the code ;-]

However, I do suspect that we should probably revert the quirk regardless 
as being useless (ie it probably was related to those IGP chips that 
apparently don't do MSI anyway).

So the patch that reverts the quirk by Clemens (to replace it with 
disabling MSI entirely when the AMD NB doesn't accept them) seems to be a 
good idea regardless, since it's apparently not just about gfx. Jesse?

			Linus
