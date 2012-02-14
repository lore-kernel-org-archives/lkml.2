Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2BNHbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:31:13 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:60144 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756010Ab2BNHbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:31:07 -0500
Date: Tue, 14 Feb 2012 09:31:01 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Yang Bai <hamo.by@gmail.com>
cc: cl@linux-foundation.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] slab: warning if total alloc size overflow
In-Reply-To: <1329204499-2671-1-git-send-email-hamo.by@gmail.com>
Message-ID: <alpine.LFD.2.02.1202140929040.2721@tux.localdomain>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Yang Bai wrote:
> Before, if the total alloc size is overflow,
> we just return NULL like alloc fail. But they
> are two different type problems. The former looks
> more like a programming problem. So add a warning
> here.
>
> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> ---
> include/linux/slab.h |    4 +++-
> 1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 573c809..5865237 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -242,8 +242,10 @@ size_t ksize(const void *);
>  */
> static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> {
> -	if (size != 0 && n > ULONG_MAX / size)
> +	if (size != 0 && n > ULONG_MAX / size) {
> +		WARN(1, "Alloc memory size (%lu * %lu) overflow.", n, size);
> 		return NULL;
> +	}
> 	return __kmalloc(n * size, flags | __GFP_ZERO);
> }

Did you check how much kernel text size increases? I'm pretty sure we'd 
need to wrap this with CONFIG_SLAB_OVERFLOW ifdef.

 			Pekka
