Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0D1Jbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0D1Jbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:31:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com>
References: <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com> <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> <u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> <20100428081545.GA19027@windriver.com>
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
Date: Wed, 28 Apr 2010 10:29:47 +0100
Message-ID: <8482.1272446987@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao <xiaosuo@gmail.com> wrote:

> If there isn't enough work to be done, we'd better not disrupt them
> and  leave them sleeping forever to keep the scheduler happier. Do we
> have reason to keep fair to all the workers? Does it have benefit?

You've made one important assumption: the processes on the wait queue are
sleeping waiting to service things... but what if the wait queue governs
access to a resource, and all the processes on that wait queue need access to
that resource to do things?  Some of the processes waiting for it may never
get a go, and so necessary work may be left undone.

So NACK.

David
