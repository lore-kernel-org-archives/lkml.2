Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2KVUim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:38:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:35552 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab2KVTKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:10:48 -0500
Message-Id: <84c8a8$6kot4e@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,301,1352102400"; 
   d="scan'208";a="223114382"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: drm_gem_create_mmap_offset / intel_uxa_prepare_access bo problems
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: "xorg-devel@lists.x.org Development" <xorg-devel@lists.x.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <50AE44C4.1060606@t-online.de>
References: <50AE44C4.1060606@t-online.de>
Date: Thu, 22 Nov 2012 15:37:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 16:29:08 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> Hi Chris!
> 
> Problem:
> =======
> Slowdown of system, missing icons after 16 days kernel uptime and 12 days Xserver uptime.
> Xorg log: flooded with "(WW) intel(0): intel_uxa_prepare_access: bo map (use gtt? 1, access 1) failed: No space left on device" lines
> dmesg: flooded with "[drm:drm_gem_create_mmap_offset] *ERROR* failed to allocate offset for bo 0" entries
> 
> 
> Hardware
> =======
> AOpen i915GMm-hfs, Pentium-M Dothan
> 
> Software:
> =======
> linux kernel 3.6.6
> full Xorg git master, fetch/build 10 November 2012,
> video-intel: git f5d79b202dd448e61ab6ffce26fe9cbf9051d770
> xserver: git 011f8458805e443ac9130865d2840a929a00cabf
> rest of system openSuSE 12.1
> 
> Any idea?

Well you kernel and drm has all the latest protections, which is good
because it's usually a bo leak of some sort. First stop is to check
xrestop, /sys/kernel/debug/dri/0/i915_gem_objects and
intel-gpu-tools/scripts/who.sh

That will undoubtably reveal a large number of objects being held by the
X server...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
