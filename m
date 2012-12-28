Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2L1Om1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 09:42:27 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58230 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2L1OmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 09:42:24 -0500
MIME-Version: 1.0
In-Reply-To: <50DCD4CB.50205@oracle.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
	<1356293711-23864-2-git-send-email-sasha.levin@oracle.com>
	<alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
	<50DCCE5A.4000805@oracle.com>
	<alpine.DEB.2.00.1212271502070.23127@chino.kir.corp.google.com>
	<50DCD4CB.50205@oracle.com>
Date: Fri, 28 Dec 2012 23:42:24 +0900
Message-ID: <CAAmzW4MhCyYkdpOaHnJtoMoJeFsXQJXN=Cpo3s67=s+id-hrMg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even if
 slab is available
From: JoonSoo Kim <js1304@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sasha.

2012/12/28 Sasha Levin <sasha.levin@oracle.com>:
> On 12/27/2012 06:04 PM, David Rientjes wrote:
>> On Thu, 27 Dec 2012, Sasha Levin wrote:
>>
>>> That's exactly what happens with the patch. Note that in the current upstream
>>> version there are several slab checks scattered all over.
>>>
>>> In this case for example, I'm removing it from __alloc_bootmem_node(), but the
>>> first code line of__alloc_bootmem_node_nopanic() is:
>>>
>>>         if (WARN_ON_ONCE(slab_is_available()))
>>>                 return kzalloc(size, GFP_NOWAIT);
>>>
>>
>> You're only talking about mm/bootmem.c and not mm/nobootmem.c, and notice
>> that __alloc_bootmem_node() does not call __alloc_bootmem_node_nopanic(),
>> it calls ___alloc_bootmem_node_nopanic().
>
> Holy cow, this is an underscore hell.
>
>
> Thanks,
> Sasha
>

I have a different idea.
How about removing fallback allocation in bootmem.c completely?
I don't know why it is there exactly.
But, warning for 'slab_is_available()' is there for a long time.
So, most people who misuse fallback allocation change their code adequately.
I think that removing fallback at this time is valid. Isn't it?

Fallback allocation may cause possible bug.
If someone free a memory from fallback allocation,
it can't be handled properly.

So, IMHO, at this time, we should remove fallback allocation in
bootmem.c entirely.
Please let me know what I misunderstand.

Thanks.
