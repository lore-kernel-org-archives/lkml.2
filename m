Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0D1OJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:09:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab0D1OI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:08:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <q2r412e6f7f1004280656t331e9120rc9eab069fb4d4de3@mail.gmail.com>
References: <q2r412e6f7f1004280656t331e9120rc9eab069fb4d4de3@mail.gmail.com> <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> <8526.1272447122@redhat.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
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
Date: Wed, 28 Apr 2010 15:06:59 +0100
Message-ID: <6096.1272463619@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao <xiaosuo@gmail.com> wrote:

> I don't know how to do that, as maybe there are non-exclusive and
> exclusive wait queues in the same wait queue head. If we want to
> enqueue exclusive wait queues at the head of exclusive queues, we have
> to know where the head is, otherwise, we have to loop to find the head
> when enqueuing.

I suspect you really want to have the semantics defined per-queue.  _Either_ a
queue is FIFO (such as processes waiting for a resource so they can do
something with it) _or_ it is LIFO (such as a pool of processes waiting to be
given work).

How often do the two actually mix?  And if they do, is that really an error?

David
