Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2GDQET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:04:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57319 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2GDQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:04:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFwtwWHP8At6B8t0o6mKFKKfo6e7CEZj5Zi2AROgyMcfw@mail.gmail.com>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	<1340390729-2821-1-git-send-email-js1304@gmail.com>
	<CAOJsxLHSboF0rQdGv8bdgGtinBz5dTo+omQbUnj9on_ewzgNAQ@mail.gmail.com>
	<CAAmzW4OdDhn5C_vfMhu3ejzzcXmCCt6r0h=nXUqKJaNYZxg8Bw@mail.gmail.com>
	<CAOJsxLGBxeu2sE-wDT+YNyVipmXiPj7Gvmmdo-0zGmJObp2zxg@mail.gmail.com>
	<CAAmzW4NGinc=7qEwhAH354Q7thkYy-HzpRNfVLtfaax4CEBB=g@mail.gmail.com>
	<CAOJsxLFwtwWHP8At6B8t0o6mKFKKfo6e7CEZj5Zi2AROgyMcfw@mail.gmail.com>
Date: Thu, 5 Jul 2012 01:04:16 +0900
Message-ID: <CAAmzW4N88UW0p41W5ObRZzDHHe08jW4X+VkeDrTu3pNNzFNUFA@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] slub: prefetch next freelist pointer in __slab_alloc()
From: JoonSoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <eric.dumazet@gmail.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/5 Pekka Enberg <penberg@kernel.org>:
> On Wed, Jul 4, 2012 at 6:45 PM, JoonSoo Kim <js1304@gmail.com> wrote:
>>> Prefetching can also have negative effect on overall performance:
>>>
>>> http://lwn.net/Articles/444336/
>>
>> Thanks for good article which is very helpful to me.
>>
>>> That doesn't seem like that obvious win to me... Eric, Christoph?
>>
>> Could you tell me how I test this patch more deeply, plz?
>> I am a kernel newbie and in the process of learning.
>> I doesn't know what I can do more for this.
>> I googling previous patch related to slub, some people use netperf.
>>
>> Just do below is sufficient?
>> How is this test related to slub?
>>
>> for in in `seq 1 32`
>> do
>>  netperf -H 192.168.0.8 -v 0 -l -100000 -t TCP_RR > /dev/null &
>> done
>> wait
>
> The networking subsystem is sensitive to slab allocator performance
> which makes netperf an interesting benchmark, that's all.
>
> As for slab benchmarking, you might want to look at what Mel Gorman
> has done in the past:
>
> https://lkml.org/lkml/2009/2/16/252
>
> For something like prefetch optimization, you'd really want to see a
> noticeable win in some benchmark. The kind of improvement you're
> seeing with your patch is likely to be lost in the noise - or even
> worse, cause negative performance for real world workloads.

Okay.
Thanks for comments.
