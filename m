Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2CEVbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:31:55 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40240 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2CEVbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:31:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel.vetter@ffwll.ch designates 10.52.22.207 as permitted sender) smtp.mail=daniel.vetter@ffwll.ch; dkim=pass header.i=daniel.vetter@ffwll.ch
MIME-Version: 1.0
X-Originating-IP: [134.134.137.71]
In-Reply-To: <CAF6AEGs4QyGfZyOnewigYDMi6K=62Cmb8Ntd-zQRbasTXnjy-g@mail.gmail.com>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
	<1330616161-1937-3-git-send-email-daniel.vetter@ffwll.ch>
	<e39f63$3uf6dn@fmsmga002.fm.intel.com>
	<CAF6AEGs4QyGfZyOnewigYDMi6K=62Cmb8Ntd-zQRbasTXnjy-g@mail.gmail.com>
Date: Mon, 5 Mar 2012 22:31:52 +0100
Message-ID: <CAKMK7uEcukmyyqL6N2XMwMDjGe81NkhmuE1k0QyeJYKF0ufktg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 2/3] dma-buf: add support for kernel cpu access
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rob Clark <rob.clark@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 23:53, Rob Clark <rob.clark@linaro.org> wrote:
> nitially the expectation was that userspace would not pass a buffer
> to multiple subsystems for writing (or that if it did, it would get
> the undefined results that one could expect)..  so dealing w/
> synchronization was punted.

Imo synchronization should not be part of the dma_buf core, i.e.
userspace needs to ensure that access is synchronized.
begin/end_cpu_access are the coherency brackets (like map/unmap for
device dma). And if userspace asks for a gun and some bullets, the
kernel should just deliver. Even in drm/i915 gem land we don't (and
simply can't) make any promises about concurrent reads/writes/ioctls.

> I expect, though, that one of the next steps is some sort of
> sync-object mechanism to supplement dmabuf

Imo the only reason to add sync objects as explicit things is to make
device-to-device sync more efficient by using hw semaphores and
signalling lines. Or maybe a quick irq handler in the kernel that
kicks of the next device. I don't think we should design these to make
userspace simpler.

Cheers, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
