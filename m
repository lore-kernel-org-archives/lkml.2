Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab0JFSQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:16:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57934 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521Ab0JFSP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:15:59 -0400
Message-ID: <4CACBCDE.3000701@cs.helsinki.fi>
Date: Wed, 06 Oct 2010 21:15:58 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 6
References: <20101006163632.c1943a38.sfr@canb.auug.org.au> <AANLkTikxMdXrm1jRztZM1BUAoCbBtAs6A39v1cAgRnDY@mail.gmail.com> <20101006174831.02cf1691.sfr@canb.auug.org.au> <AANLkTikv4Y3gxCEFXg8SQdgmb2Gqk7OniUT7gBvLf14p@mail.gmail.com> <alpine.DEB.2.00.1010061311430.31538@router.home>
In-Reply-To: <alpine.DEB.2.00.1010061311430.31538@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.10.2010 21.12, Christoph Lameter wrote:
> On Wed, 6 Oct 2010, Zimny Lech wrote:
>
>>>> It seems that you forgot to push to repo
>>>> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary
>>>
>>> No, its just that the mirroring was slow/blocked :-(
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
> Signed-off-by: Christoph Lameter<cl@linux.com>
>
> ---
>   mm/slub.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2010-10-06 13:10:00.000000000 -0500
> +++ linux-2.6/mm/slub.c	2010-10-06 13:10:25.000000000 -0500
> @@ -3028,7 +3028,9 @@ void __init kmem_cache_init(void)
>   		sizeof(struct kmem_cache_node),
>   		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>
> +#ifdef CONFIG_MEMORY_HOTPLUG
>   	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
> +#endif
>
>   	/* Able to allocate the per node structures */
>   	slab_state = PARTIAL;

You already acked my patch to fix it:

http://lkml.org/lkml/2010/10/6/194

			Pekka
