Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790Ab2C3Mtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:49:49 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:31562 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760237Ab2C3Mtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:49:42 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 0/8 v7] fix gmbus writes and related issues
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
Date: Fri, 30 Mar 2012 13:49:17 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333111775_156407@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 19:46:35 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> This patchset addresses a couple of issues with the i915 gmbus
> implementation.
> 
> v7 adds a final patch to switch to using DRM_ERROR for reporting timeouts.
> 
> Daniel Kurtz (8):
>   drm/i915/intel_i2c: handle zero-length writes
>   drm/i915/intel_i2c: use double-buffered writes
>   drm/i915/intel_i2c: always wait for IDLE before clearing NAK
>   drm/i915/intel_i2c: use WAIT cycle, not STOP
>   drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
>   drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
>   drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
>   drm/i915/intel_i2c: use DRM_ERROR on timeouts

The only two I am still dubious about is 4/8: use WAIT cycle, not STOP,
and 8/8: use DRM_ERROR on timeouts, the rest are
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

The last is a little debatable, as i2c can be called from userspace (and
other modules) and we have not verified that the adapters we set up
correspond to devices conditions. So I think it is still possible under
normal conditions to hit the error path, so would prefer to keep the log
level as INFO.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
