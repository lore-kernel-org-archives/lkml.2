Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2CEVjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:39:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34822 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2CEVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:39:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel.vetter@ffwll.ch designates 10.52.28.200 as permitted sender) smtp.mail=daniel.vetter@ffwll.ch; dkim=pass header.i=daniel.vetter@ffwll.ch
MIME-Version: 1.0
X-Originating-IP: [192.55.54.38]
In-Reply-To: <20120303002342.GI15695@valkosipuli.localdomain>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
	<1330616161-1937-4-git-send-email-daniel.vetter@ffwll.ch>
	<20120303002342.GI15695@valkosipuli.localdomain>
Date: Mon, 5 Mar 2012 22:39:05 +0100
Message-ID: <CAKMK7uGnfN9TyK-53OPTQ2r609ZNZ6jcAYVhaSe_ywAaBOPJ6Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] dma_buf: Add documentation for the new cpu access support
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 3, 2012 at 01:23, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Where it should be decided which operations are being done to the buffer
> when it is passed to user space and back to kernel space?
>
> How about spliting these operations to those done on the first time the
> buffer is passed to the user space (mapping to kernel address space, for
> example) and those required every time buffer is passed from kernel to user
> and back (cache flusing)?
>
> I'm asking since any unnecessary time-consuming operations, especially as
> heavy as mapping the buffer, should be avoidable in subsystems dealing
> with streaming video, cameras etc., i.e. non-GPU users.

I'm a bit confused about your comments because this interface
extension doesn't support userspace mmap. So userspace isn't even part
of the picture. Adding mmap support is something entirely different
imo, and I have no idea yet how we should handle cache coherency for
that.

Yours, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
