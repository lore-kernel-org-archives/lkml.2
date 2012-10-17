Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2JQQFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:05:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58152 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2JQQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <1350468877-7677-1-git-send-email-will.deacon@arm.com>
References: <1350468877-7677-1-git-send-email-will.deacon@arm.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 17 Oct 2012 12:05:00 -0400
Message-ID: <CA+1xoqcjomrD05vxdgx4FG2wR8DTmV58Xk5=BeVD3JGVfWrssA@mail.gmail.com>
Subject: Re: [PATCH] virtio: 9p: correctly pass physical address to userspace
 for high pages
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Marc Zyngier <marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 6:14 AM, Will Deacon <will.deacon@arm.com> wrote:
> When using a virtio transport, the 9p net device allocates pages to back
> the descriptors inserted into the virtqueue. These allocations may be
> performed from atomic context (under the channel lock) and can therefore
> return high mappings which aren't suitable for virt_to_phys.
>
> This patch ensures that virtual addresses for virtio queue descriptors
> are converted to physical addresses using kmap_to_page, which handles
> high memory correctly.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---

One of the things I was seeing when fuzzing within lkvm were random
crashes resulting
from "odd" addresses used by virtio-9p queue descriptions. I
attributed that to memory
corruption as a result of something else failing the fuzz tests
before, but this patch
explains what might have gone wrong.

I'll plug it in and run tests on it.


Thanks,
Sasha
