Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2DFTky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:40:54 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:52493 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755111Ab2DFTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:40:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
To: Xi Wang <xi.wang@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <507CC69B-BD9C-421B-9107-B3284BEB116E@gmail.com>
References: <1333717099-32679-1-git-send-email-xi.wang@gmail.com> <1333719431_271283@CP5-2952> <B6B08A4C-2FEA-4C08-AB2F-4A99FB8D3786@gmail.com> <1333720475_271533@CP5-2952> <5065822E-8C69-442E-A59C-98D6C27B289D@gmail.com> <1333723480_272185@CP5-2952> <507CC69B-BD9C-421B-9107-B3284BEB116E@gmail.com>
Date: Fri, 06 Apr 2012 20:40:12 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333741246_275838@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012 14:17:41 -0400, Xi Wang <xi.wang@gmail.com> wrote:
> On Apr 6, 2012, at 10:44 AM, Chris Wilson wrote:
> 
> > That I agreed with, I just disagree with how you chose to handle it.
> > Rather than continue on and attempt to vmalloc a large array we should
> > just fail the ioctl with EINVAL.
> 
> Why an attempt to vmalloc?  The overflow check in drm_malloc_ab()
> will simply return NULL and fail the ioctl with -ENOMEM.

It's an invalid value for the ioctl and should be treated as such, not
making ENOMEM more ambiguous.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
