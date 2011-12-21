Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1LUGOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:14:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64871 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUGN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:13:58 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "Minchan Kim" <minchan@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: remove #ifdef in function body
References: <1324444679-9247-1-git-send-email-minchan@kernel.org>
Date: Wed, 21 Dec 2011 07:13:49 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6tsxbmb3l0zgt@mpn-glaptop>
In-Reply-To: <1324444679-9247-1-git-send-email-minchan@kernel.org>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 06:17:59 +0100, Minchan Kim <minchan@kernel.org> wrote:
> We don't like function body which include #ifdef.
> If we can, define null function to go out compile time.
> It's trivial, no functional change.

It actually adds “flush_tlb_kenel_range()” call to the function so there
is functional change.

> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/vmalloc.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0aca3ce..e1fa5a6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -505,6 +505,7 @@ static void unmap_vmap_area(struct vmap_area *va)
>  	vunmap_page_range(va->va_start, va->va_end);
>  }
>+#ifdef CONFIG_DEBUG_PAGEALLOC
>  static void vmap_debug_free_range(unsigned long start, unsigned long end)
>  {
>  	/*
> @@ -520,11 +521,15 @@ static void vmap_debug_free_range(unsigned long start, unsigned long end)
>  	 * debugging doesn't do a broadcast TLB flush so it is a lot
>  	 * faster).
>  	 */
> -#ifdef CONFIG_DEBUG_PAGEALLOC
>  	vunmap_page_range(start, end);
>  	flush_tlb_kernel_range(start, end);
> -#endif
>  }
> +#else
> +static inline void vmap_debug_free_range(unsigned long start,
> +					unsigned long end)
> +{
> +}
> +#endif
> /*
>   * lazy_max_pages is the maximum amount of virtual address space we gather up

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
