Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2GDQYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:24:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37621 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2GDQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:24:19 -0400
MIME-Version: 1.0
In-Reply-To: <1341418517.2583.2252.camel@edumazet-glaptop>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	<1340390729-2821-1-git-send-email-js1304@gmail.com>
	<CAOJsxLHSboF0rQdGv8bdgGtinBz5dTo+omQbUnj9on_ewzgNAQ@mail.gmail.com>
	<CAAmzW4OdDhn5C_vfMhu3ejzzcXmCCt6r0h=nXUqKJaNYZxg8Bw@mail.gmail.com>
	<CAOJsxLGBxeu2sE-wDT+YNyVipmXiPj7Gvmmdo-0zGmJObp2zxg@mail.gmail.com>
	<1341415579.2583.2134.camel@edumazet-glaptop>
	<CAAmzW4P8itKqMLLUqAAtT7GakKecCixd0PV8y0LgFOL+=g_tZQ@mail.gmail.com>
	<1341418517.2583.2252.camel@edumazet-glaptop>
Date: Thu, 5 Jul 2012 01:24:18 +0900
Message-ID: <CAAmzW4NmJs0nanYt+gMPuRCzTqByg6ufpQZBjQ3w80bapqLwFA@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] slub: prefetch next freelist pointer in __slab_alloc()
From: JoonSoo Kim <js1304@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/5 Eric Dumazet <eric.dumazet@gmail.com>:
> On Thu, 2012-07-05 at 00:48 +0900, JoonSoo Kim wrote:
>> 2012/7/5 Eric Dumazet <eric.dumazet@gmail.com>:
>> > Its the slow path. I am not convinced its useful on real workloads (not
>> > a benchmark)
>> >
>> > I mean, if a workload hits badly slow path, some more important work
>> > should be done to avoid this at a higher level.
>> >
>>
>> In hackbench test, fast path allocation is about to 93%.
>> Is it insufficient?
>
> 7% is insufficient I am afraid.
>
> One prefetch() in the fast path serves 93% of the allocations,
> so added icache pressure is ok.
>
> One prefetch() in slow path serves 7% of the allocations, do you see the
> difference ?
>
> Adding a prefetch() is usually a win when a benchmark uses the path one
> million times per second.
>
> But adding prefetches also increases kernel size and it hurts globally.
> (Latency of the kernel depends on its size, when cpu caches are cold)
>

Okay.
Thanks for comments which is very helpful to me.
