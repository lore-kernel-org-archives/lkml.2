Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab0JFSQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:16:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51190 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521Ab0JFSQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XZ0vvyqFJtjMMxwYPLzy7lfKnRLZo/HkptBNHLl1Ye+Jw319BIF4wksYsDiWSvfNKH
         UoL++DMgbYNsV4TBH4K50uWuDe43yvhX7suam/6wP71gplhGdP+aBXs+3WtwICXfQimO
         7hRoAblV48UMZRihNDqC1eKOlTyWgPFTXaDyE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1010061311430.31538@router.home>
References: <20101006163632.c1943a38.sfr@canb.auug.org.au>
	<AANLkTikxMdXrm1jRztZM1BUAoCbBtAs6A39v1cAgRnDY@mail.gmail.com>
	<20101006174831.02cf1691.sfr@canb.auug.org.au>
	<AANLkTikv4Y3gxCEFXg8SQdgmb2Gqk7OniUT7gBvLf14p@mail.gmail.com>
	<alpine.DEB.2.00.1010061311430.31538@router.home>
Date: Wed, 6 Oct 2010 20:16:11 +0200
Message-ID: <AANLkTin8hb8JfDWkWXpnxkBZCD3nj-krpf7GSViarxqJ@mail.gmail.com>
Subject: Re: linux-next: Tree for October 6
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/6 Christoph Lameter <cl@linux.com>:
> On Wed, 6 Oct 2010, Zimny Lech wrote:
>
>> >> It seems that you forgot to push to repo
>> >> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary
>> >
>> > No, its just that the mirroring was slow/blocked :-(
>>
>> Ok, I pulled latest tree. Thanks.
>>
>> I already reported this before.
>>
>> /home/test/linux-2.6/mm/slub.c: In function 'kmem_cache_init':
>> /home/test/linux-2.6/mm/slub.c:3031:2: error: 'slab_memory_callback'
>> undeclared (first use in this function)
>> /home/test/linux-2.6/mm/slub.c:3031:2: note: each undeclared
>> identifier is reported only once for each function it appears in
>> make[2]: *** [mm/slub.o] Error 1
>> make[1]: *** [mm] Error 2
>> make: *** [sub-make] Error 2
>>
>> any thoughts?
>
>
> Subject: slub: hotplug_memory_notifier not useable for !CONFIG_MEMORY_HOTPLUG
>
> Add #ifdef to resolve the situation.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Thanks for the quick reply :)

I'll check it later or in next -next

>
> ---
>  mm/slub.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c    2010-10-06 13:10:00.000000000 -0500
> +++ linux-2.6/mm/slub.c 2010-10-06 13:10:25.000000000 -0500
> @@ -3028,7 +3028,9 @@ void __init kmem_cache_init(void)
>                sizeof(struct kmem_cache_node),
>                0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>
> +#ifdef CONFIG_MEMORY_HOTPLUG
>        hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
> +#endif
>
>        /* Able to allocate the per node structures */
>        slab_state = PARTIAL;
>



-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
