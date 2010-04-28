Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0D1NWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab0D1NWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:22:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com>
References: <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com> <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> <u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> <20100428081545.GA19027@windriver.com> <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com> <8482.1272446987@redhat.com> 
To: Changli Gao <xiaosuo@gmail.com>
Cc: dhowells@redhat.com, Yong Zhang <yong.zhang@windriver.com>,
       Xiaotian Feng <xtfeng@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
Date: Wed, 28 Apr 2010 14:21:02 +0100
Message-ID: <12671.1272460862@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao <xiaosuo@gmail.com> wrote:

> You are right. I made the wrong assumption. But we indeed need some
> primitive to add wait_queue at the head of the wait_queue_head, and I
> know epoll needs it, at least.
> 
> fs/eventpoll.c: 1443.
>                 wait.flags |= WQ_FLAG_EXCLUSIVE;
>                 __add_wait_queue(&ep->wq, &wait);

You can add at either end of the wait queue with __add_wait_queue() and
__add_wait_queue_tail().

David
