Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2DYXAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:00:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54687 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab2DYXAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:00:40 -0400
Date: Wed, 25 Apr 2012 19:00:34 -0400 (EDT)
Message-Id: <20120425.190034.632638679653622318.davem@davemloft.net>
To: yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAE9FiQWYPPXA0YmgBP6SkKiEaLJJnzxMqPn2_VwOKoYSKGwULQ@mail.gmail.com>
References: <20120425.161050.1011838269798884593.davem@davemloft.net>
	<CAE9FiQWYPPXA0YmgBP6SkKiEaLJJnzxMqPn2_VwOKoYSKGwULQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 16:00:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 25 Apr 2012 15:46:42 -0700

> On Wed, Apr 25, 2012 at 1:10 PM, David Miller <davem@davemloft.net> wrote:
>> @@ -298,13 +298,19 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>>        if (WARN_ON_ONCE(slab_is_available()))
>>                return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
>>
>> +again:
>>        ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
>>                                         goal, -1ULL);
>>        if (ptr)
>>                return ptr;
> 
> If you want to be consistent to bootmem version.
> 
> again label should be here instead.

It is merely an artifact of implementation that the bootmem version
doesn't try to respect the given node if the goal cannot be satisfied,
and in fact I would classify that as a bug that needs to be fixed.

Therefore, I believe the bootmem case is what needs to be adjusted
instead.
