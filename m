Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2DFNhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:37:23 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:61366 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753971Ab2DFNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:37:22 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
To: Xi Wang <xi.wang@gmail.com>, Keith Packard <keithp@keithp.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <1333717099-32679-1-git-send-email-xi.wang@gmail.com>
References: <1333717099-32679-1-git-send-email-xi.wang@gmail.com>
Date: Fri, 06 Apr 2012 14:36:40 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333719431_271283@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Apr 2012 08:58:18 -0400, Xi Wang <xi.wang@gmail.com> wrote:
> A large args->buffer_count from userspace may overflow the allocation
> size, leading to out-of-bounds access.
> 
> Use kmalloc_array() to avoid that.

I can safely say that exec list larger than 4GiB is going to be an
illegal operation and would rather the ioctl failed outright with
EINVAL.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
