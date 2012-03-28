Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2C1LpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:45:20 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:58593 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758160Ab2C1LpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:45:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 13/13 v4] drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
In-Reply-To: <CAGS+omBXmUfqGd9GYg4DhAmvn0Z1wkzGv8EZ3032_j0PikZn6g@mail.gmail.com>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org> <1332873382-29373-14-git-send-email-djkurtz@chromium.org> <1332874994_117123@CP5-2952> <CAGS+omBXmUfqGd9GYg4DhAmvn0Z1wkzGv8EZ3032_j0PikZn6g@mail.gmail.com>
Date: Wed, 28 Mar 2012 12:44:59 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332935113_126617@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 19:39:17 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Wed, Mar 28, 2012 at 3:02 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > Might as well shave this read as well.
> 
> Do you know why POSTING_READ() was there in the first place?
> As far as I can tell, these are used to ensure memory barriers are
> inserted between a group of writes, and subsequent reads to memory
> mapped io registers.
> However, the normal I915_READ() and I915_WRITE() macros already call
> readl() / writel(), which already have an explicit mb().
> So, can we just get rid of all of them, or am I missing something?

They can go. They were there just as paranoia to make sure the writes
were flushed before any timing delays and across loops. Once the code
settled I never took the liberty of removing them.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
