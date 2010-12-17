Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0LQBPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:15:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:37133 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab0LQBPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:15:36 -0500
Message-Id: <5b55a1$ivogvh@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,358,1288594800"; 
   d="scan'208";a="637289457"
Date: Fri, 17 Dec 2010 01:15:31 +0000
To: Dave Airlie <airlied@gmail.com>, Harald Dunkel <harri@afaics.de>
Subject: Re: Intel 82915G/GV/910GL, 2.6.36.2: problem with CONFIG_DRM_I915_KMS=y
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=jeJriExzNVRxbApz9VEUeuL0BpVLnRoTx_SrT@mail.gmail.com>
References: <4D0A9164.5070503@afaics.de> <AANLkTi=jeJriExzNVRxbApz9VEUeuL0BpVLnRoTx_SrT@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 10:01:26 +1000, Dave Airlie <airlied@gmail.com> wrote:
> (cc'ing Chris).
> 
> On Fri, Dec 17, 2010 at 8:23 AM, Harald Dunkel <harri@afaics.de> wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > Hi folks,
> >
> > according to http://bugs.debian.org/607300 I have to rebuild 2.6.36.2
> > with CONFIG_DRM_I915_KMS=y. Problem:
> >
> > At boot time I get a message "waiting for /dev to be fully populated",
> > then the screen goes blank and the monitor enters power save mode.
> > 2.6.36.2 without CONFIG_DRM_I915_KMS didn't show this problem.
> >
> > My grub2 configuration says
> >
> >        GRUB_GFXMODE=1280x1024
> >        GRUB_GFXPAYLOAD_LINUX="keep"
> >
> > If I comment out these 2 lines and rebuild grub.cfg, then the problem
> > goes away, too. I just get a 80x25 display for grub in this case.
> >
> 
> Is this a regression since 2.6.36 or 2.6.35?

Sounds like:

commit 47f1c6c9ffdec0c0e5a2c2709bd63c7380b325c4
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Dec 3 15:37:31 2010 +0000

    drm/i915: Clean conflicting modesetting registers upon init
    
    If we leave the registers in a conflicting state then when we attempt
    to teardown the active mode, we will not disable the pipes and planes
    in the correct order -- leaving a plane reading from a disabled pipe and
    possibly leading to undefined behaviour.
    
    Reported-and-tested-by: Andy Whitcroft <apw@canonical.com>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=32078
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: stable@kernel.org

which was prompted by an investigation as to why grub2 was causing a
modesetting failure.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
