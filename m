Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2FZUZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:25:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47245 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2FZUZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <1340445863-16111-5-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
	<1340445863-16111-5-git-send-email-amwang@redhat.com>
Date: Tue, 26 Jun 2012 22:25:14 +0200
X-Google-Sender-Auth: LfOQQWtD2vCJOLDYESUdyg98VYQ
Message-ID: <CAMuHMdXkMBSkkXosJkd47n+RznpMBhzBGyLshA+gwdmZ=4dm6A@mail.gmail.com>
Subject: Re: [PATCH 04/12] frv: remove km_type definitions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 12:04 PM, Cong Wang <amwang@redhat.com> wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  arch/frv/include/asm/kmap_types.h |   24 +-----------------------
>  1 files changed, 1 insertions(+), 23 deletions(-)
>
> diff --git a/arch/frv/include/asm/kmap_types.h b/arch/frv/include/asm/kmap_types.h
> index f8e16b2..43901f2 100644
> --- a/arch/frv/include/asm/kmap_types.h
> +++ b/arch/frv/include/asm/kmap_types.h
> @@ -2,28 +2,6 @@
>  #ifndef _ASM_KMAP_TYPES_H
>  #define _ASM_KMAP_TYPES_H
>
> -enum km_type {
> -       /* arch specific kmaps - change the numbers attached to these at your peril */
> -       __KM_CACHE,             /* cache flush page attachment point */
> -       __KM_PGD,               /* current page directory */
> -       __KM_ITLB_PTD,          /* current instruction TLB miss page table lookup */
> -       __KM_DTLB_PTD,          /* current data TLB miss page table lookup */
> -
> -       /* general kmaps */
> -        KM_BOUNCE_READ,
> -        KM_SKB_SUNRPC_DATA,
> -        KM_SKB_DATA_SOFTIRQ,
> -        KM_USER0,
> -        KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#define KM_TYPE_NR 17
>
>  #endif

"enum km_type" and "__KM_CACHE" are still used in
arch/frv/include/asm/highmem.h:

In file included from include/linux/highmem.h:34:0,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:80,
                 from init/main.c:49:
arch/frv/include/asm/highmem.h:115:136: warning: 'enum km_type'
declared inside parameter list [enabled by default]
arch/frv/include/asm/highmem.h:115:136: warning: its scope is only
this definition or declaration, which is probably not what you want
[enabled by default]
arch/frv/include/asm/highmem.h:115:144: error: parameter 2 ('type')
has incomplete type
arch/frv/include/asm/highmem.h:115:92: warning: function declaration
isn't a prototype [-Wstrict-prototypes]
arch/frv/include/asm/highmem.h: In function 'kmap_atomic_primary':
arch/frv/include/asm/highmem.h:123:144: error: '__KM_CACHE' undeclared
(first use in this function)
arch/frv/include/asm/highmem.h:123:144: note: each undeclared
identifier is reported only once for each function it appears in
In file included from include/linux/highmem.h:34:0,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:80,
                 from init/main.c:49:
arch/frv/include/asm/highmem.h: At top level:
arch/frv/include/asm/highmem.h:146:132: warning: 'enum km_type'
declared inside parameter list [enabled by default]
arch/frv/include/asm/highmem.h:146:140: error: parameter 2 ('type')
has incomplete type
arch/frv/include/asm/highmem.h:146:91: warning: function declaration
isn't a prototype [-Wstrict-prototypes]
arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_primary':
arch/frv/include/asm/highmem.h:149:84: error: '__KM_CACHE' undeclared
(first use in this function)
make[1]: *** [init/main.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/6592702/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
