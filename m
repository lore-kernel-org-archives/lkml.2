Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2DFOpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:45:10 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:7314 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757381Ab2DFOoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:44:46 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
To: Xi Wang <xi.wang@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <5065822E-8C69-442E-A59C-98D6C27B289D@gmail.com>
References: <1333717099-32679-1-git-send-email-xi.wang@gmail.com> <1333719431_271283@CP5-2952> <B6B08A4C-2FEA-4C08-AB2F-4A99FB8D3786@gmail.com> <1333720475_271533@CP5-2952> <5065822E-8C69-442E-A59C-98D6C27B289D@gmail.com>
Date: Fri, 06 Apr 2012 15:44:07 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333723480_272185@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012 10:01:36 -0400, Xi Wang <xi.wang@gmail.com> wrote:
> On Apr 6, 2012, at 9:54 AM, Chris Wilson wrote:
> 
> > On Fri, 6 Apr 2012 09:46:46 -0400, Xi Wang <xi.wang@gmail.com> wrote:
> >> On Apr 6, 2012, at 9:36 AM, Chris Wilson wrote:
> >> 
> >>> On Fri,  6 Apr 2012 08:58:18 -0400, Xi Wang <xi.wang@gmail.com> wrote:
> >>>> A large args->buffer_count from userspace may overflow the allocation
> >>>> size, leading to out-of-bounds access.
> >>>> 
> >>>> Use kmalloc_array() to avoid that.
> >>> 
> >>> I can safely say that exec list larger than 4GiB is going to be an
> >>> illegal operation and would rather the ioctl failed outright with
> >>> EINVAL.
> >> 
> >> On 32-bit platform?
> > 
> > On any platform. The largest it can legally be is a few tens of megabytes.
> 
> IDGI.  First we come to i915_gem_execbuffer2() from ioctl:
> 
>   exec2_list = kmalloc(sizeof(*exec2_list)*args->buffer_count, ...);
> 
> args->buffer_count is passed from userspace so it can be any value.

That I agreed with, I just disagree with how you chose to handle it.
Rather than continue on and attempt to vmalloc a large array we should
just fail the ioctl with EINVAL.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
