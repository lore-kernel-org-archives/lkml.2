Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2DFNqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:46:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39295 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2DFNqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:46:53 -0400
Subject: Re: [PATCH 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <1333719431_271283@CP5-2952>
Date: Fri, 6 Apr 2012 09:46:46 -0400
Cc: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Transfer-Encoding: 7bit
Message-Id: <B6B08A4C-2FEA-4C08-AB2F-4A99FB8D3786@gmail.com>
References: <1333717099-32679-1-git-send-email-xi.wang@gmail.com> <1333719431_271283@CP5-2952>
To: Chris Wilson <chris@chris-wilson.co.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 6, 2012, at 9:36 AM, Chris Wilson wrote:

> On Fri,  6 Apr 2012 08:58:18 -0400, Xi Wang <xi.wang@gmail.com> wrote:
>> A large args->buffer_count from userspace may overflow the allocation
>> size, leading to out-of-bounds access.
>> 
>> Use kmalloc_array() to avoid that.
> 
> I can safely say that exec list larger than 4GiB is going to be an
> illegal operation and would rather the ioctl failed outright with
> EINVAL.

On 32-bit platform?

- xi
