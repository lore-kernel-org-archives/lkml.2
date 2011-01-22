Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1AVSBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 13:01:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:63530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1AVSBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 13:01:41 -0500
Message-Id: <0d30dc$kr3ing@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,363,1291622400"; 
   d="scan'208";a="699517680"
Date: Sat, 22 Jan 2011 18:01:37 +0000
To: chris2553@googlemail.com
Subject: Re: [PATCH] drm/i915: Increase the amount of defense before computing vblank timestamps
Cc: linux-kernel@vger.kernel.org
References: <:201101220935.03623.chris2553@googlemail.com> <1295691099-14276-1-git-send-email-chris@chris-wilson.co.uk> <201101221118.53141.chris2553@googlemail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201101221118.53141.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011 11:18:53 +0000, Chris Clayton <chris2553@googlemail.com> wrote:
> On Saturday 22 January 2011, Chris Wilson wrote:
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > ---
> >
> > Chris, does this help?
> >
> 
> Sorry Chris, X still doesn't start with this patch applied. The symptoms are 
> slightly different in that the monitor doesn't go into power saving mode, but 
> the screen is still black and I have to recycle the power to get the machine 
> back.
> The messages in the log file has changed though.We now have:

Despite appearances to the contrary, it is a step forward. We have the
crash under control, and now need to tackle the underlying problem.

However, I'm worried by the fact that no CRTCs are attached. Is this not
using KMS?
 
> > If you can convert the address to a line number that would pinpoint the
> 
> Not done that before and nothing jumped out of my search on google, so how do I 
> go about getting the line number for you, please?

Something like:

$ gdb drivers/gpu/drm/drm.ko
(gdb) list *drm_calc_vbltimestamp_from_scanoutpos+0x3e

should do the trick (if compiled as a module, vmlinux otherwise)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
