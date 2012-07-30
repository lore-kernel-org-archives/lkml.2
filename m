Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2G3KSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:18:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60371 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2G3KSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <1342221125.17464.8.camel@lorien2>
References: <1342221125.17464.8.camel@lorien2>
Date: Mon, 30 Jul 2012 13:18:36 +0300
X-Google-Sender-Auth: RhBBOK5n9WRbdgqDJ8pdd-KCFbs
Message-ID: <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
From: Pekka Enberg <penberg@kernel.org>
To: shuah.khan@hp.com
Cc: cl@linux.com, glommer@parallels.com, js1304@gmail.com, shuahkhan@gmail.com,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 2:12 AM, Shuah Khan <shuah.khan@hp.com> wrote:
> The label oops is used in CONFIG_DEBUG_VM ifdef block and is defined
> outside ifdef CONFIG_DEBUG_VM block. This results in the following
> build warning when built with CONFIG_DEBUG_VM disabled. Fix to move
> label oops definition to inside a CONFIG_DEBUG_VM block.
>
> mm/slab_common.c: In function ‘kmem_cache_create’:
> mm/slab_common.c:101:1: warning: label ‘oops’ defined but not used
> [-Wunused-label]
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

I merged this as an obvious and safe fix for current merge window. We
need to clean this up properly for v3.7.

> ---
>  mm/slab_common.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 12637ce..aa3ca5b 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -98,7 +98,9 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align
>
>         s = __kmem_cache_create(name, size, align, flags, ctor);
>
> +#ifdef CONFIG_DEBUG_VM
>  oops:
> +#endif
>         mutex_unlock(&slab_mutex);
>         put_online_cpus();
>
> --
> 1.7.9.5
>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
