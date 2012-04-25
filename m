Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2DYXOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:14:02 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55202 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2DYXOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120425.190034.632638679653622318.davem@davemloft.net>
References: <20120425.161050.1011838269798884593.davem@davemloft.net>
	<CAE9FiQWYPPXA0YmgBP6SkKiEaLJJnzxMqPn2_VwOKoYSKGwULQ@mail.gmail.com>
	<20120425.190034.632638679653622318.davem@davemloft.net>
Date: Wed, 25 Apr 2012 16:14:00 -0700
X-Google-Sender-Auth: q9qyEfiq5Uxcoy2pdk03mVgAHEE
Message-ID: <CAE9FiQV1=ROUFMbtvsCr+xbrFphLspesZ0vB+UTHC-fRY7JKbQ@mail.gmail.com>
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
From: Yinghai Lu <yinghai@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 4:00 PM, David Miller <davem@davemloft.net> wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Wed, 25 Apr 2012 15:46:42 -0700
>
>> On Wed, Apr 25, 2012 at 1:10 PM, David Miller <davem@davemloft.net> wrote:
>>> @@ -298,13 +298,19 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>>>        if (WARN_ON_ONCE(slab_is_available()))
>>>                return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
>>>
>>> +again:
>>>        ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
>>>                                         goal, -1ULL);
>>>        if (ptr)
>>>                return ptr;
>>
>> If you want to be consistent to bootmem version.
>>
>> again label should be here instead.
>
> It is merely an artifact of implementation that the bootmem version
> doesn't try to respect the given node if the goal cannot be satisfied,
> and in fact I would classify that as a bug that needs to be fixed.
>
> Therefore, I believe the bootmem case is what needs to be adjusted
> instead.

Yes.

Acked-by: Yinghai Lu <yinghai@kernel.org>

Linus will pick it directly or through your sparc nobootmem conversion?

Yinghai
