Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0LEOVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 09:21:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:7129 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab0LEOVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 09:21:31 -0500
Message-Id: <5b55a1$irtpkj@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,302,1288594800"; 
   d="scan'208";a="633267859"
Date: Sun, 05 Dec 2010 14:21:27 +0000
To: Felipe Balbi <balbi@ti.com>
Subject: Re: i915 regression (??)
Cc: "Balbi, Felipe" <balbi@ti.com>, "airlied@linux.ie" <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20101123091646.GA2308@legolas.emea.dhcp.ti.com>
References: <20100920062841.GA32493@legolas.emea.dhcp.ti.com> <8u3s94$giian9@orsmga002.jf.intel.com> <20101123091646.GA2308@legolas.emea.dhcp.ti.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 11:16:46 +0200, Felipe Balbi <balbi@ti.com> wrote:
> .37-rc3 and it's still broken. Any ways I could help ? I have at least a
> machine to test (Dell e6410). It works sometimes out of luck and others,
> only rebooting.

Dave Airlie bisected the regression and it was duly reverted. That revert
is available in ickle/drm-intel-fixes, airlied/drm-fixes and linus/master:

commit 3cf2efb1a7c68d55d60dcb2ed9609e1a2fc25952
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Nov 29 10:09:55 2010 +0000

    Revert "drm/i915/dp: use VBT provided eDP params if available"
    
    This reverts commit 869184a675662bddcdf76c5b95665272facff2b8.
    
    This is required for the Sony Vaio Jesse was working on at the time, but
    breaks most other eDP machines - machines that were working in earlier
    kernels.
    
    Reported-and-tested-by: Dave Airlie <airlied@redhat.com>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=31188
    Tested-by: Zhao Jian <jian.j.zhao@intel.com>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Can you test whether this is sufficient for you as well?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
