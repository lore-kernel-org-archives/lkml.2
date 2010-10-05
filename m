Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0JELhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:37:46 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37404 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab0JELhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:37:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 05 Oct 2010 13:39:49 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 1/1] wait: using uninitialized member of wait queue
In-reply-to: <1286276438.24366.42.camel@ekuznets-lx-nokia>
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
        gregkh@suse.de, a.p.zijlstra@chello.nl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org
Message-id: <op.vj3pcnag7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <dfd3348b7971bee89360efb85f8d622e6574b003.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <op.vj3mn1fl7p4s8u@pikus> <1286276438.24366.42.camel@ekuznets-lx-nokia>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2010-10-05 at 12:41 +0200, ext Michał Nazarewicz wrote:
>> (Interestingly, init_wait() is used only in 3 places in the kernel and
>> none uses flags.)

On Tue, 05 Oct 2010 13:00:38 +0200, Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com> wrote:
> 'wait_queue_t' is passed to prepare_to_wait() function where 'flags' is
> used, e.g:
> File: /mm/mempool.c
> void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
> {       .....
>          .....
> 	init_wait(&wait);
> 	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> 	.....
> }

I meant that none of the callers initialized flags.  I was initially concerned
whether some caller that used init_wait() could set flags and expect that they
won't be changed by the call to init_wait() -- this turned out not to be the
case.

So essentially, I'm supporting your point.  Sorry about the confusion.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
