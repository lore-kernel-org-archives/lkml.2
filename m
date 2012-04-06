Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2DFSRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:17:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61285 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2DFSRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:17:45 -0400
Subject: Re: [PATCH 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <1333723480_272185@CP5-2952>
Date: Fri, 6 Apr 2012 14:17:41 -0400
Cc: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Transfer-Encoding: 7bit
Message-Id: <507CC69B-BD9C-421B-9107-B3284BEB116E@gmail.com>
References: <1333717099-32679-1-git-send-email-xi.wang@gmail.com> <1333719431_271283@CP5-2952> <B6B08A4C-2FEA-4C08-AB2F-4A99FB8D3786@gmail.com> <1333720475_271533@CP5-2952> <5065822E-8C69-442E-A59C-98D6C27B289D@gmail.com> <1333723480_272185@CP5-2952>
To: Chris Wilson <chris@chris-wilson.co.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 6, 2012, at 10:44 AM, Chris Wilson wrote:

> That I agreed with, I just disagree with how you chose to handle it.
> Rather than continue on and attempt to vmalloc a large array we should
> just fail the ioctl with EINVAL.

Why an attempt to vmalloc?  The overflow check in drm_malloc_ab()
will simply return NULL and fail the ioctl with -ENOMEM.

- xi

