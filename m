Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1AWMoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 07:44:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:4497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1AWMoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 07:44:13 -0500
Message-Id: <b7da2f$q7be7q@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,365,1291622400"; 
   d="scan'208";a="880130298"
Date: Sun, 23 Jan 2011 12:44:10 +0000
To: chris2553@googlemail.com
Subject: Re: [PATCH] drm/i915: Disable high-precision vblank timestamping for UMS
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201101230932.49998.chris2553@googlemail.com> <1295779801-8118-1-git-send-email-chris@chris-wilson.co.uk> <201101231128.22951.chris2553@googlemail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201101231128.22951.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 11:28:22 +0000, Chris Clayton <chris2553@googlemail.com> wrote:
> Hi Chris,
> 
> On Sunday 23 January 2011, Chris Wilson wrote:
> > We only have sufficient information for accurate (sub-frame) timestamping
> > when the modesetting is under our control.
> >
> With this patch (and the earlier one) applied, X still doesn't start. At the end 
> of xorg's log file I see:
> 
> Fatal server error:
> Failure to wait for IRQ: No such device

Now we are getting closer! The X server has been caught red-handed trying
to use an interrupt when the driver never enabled them. Ho hum.

The interrupts for UMS are only enabled between EnterVT/LeaveVT, but that
code looks defunct. What version of xf86-video-intel are you using?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
