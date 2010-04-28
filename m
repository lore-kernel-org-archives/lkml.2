Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab0D1J0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:26:46 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:58134 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0D1J0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:26:44 -0400
Date: Wed, 28 Apr 2010 11:25:48 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Yong Zhang <yong.zhang@windriver.com>, Xiaotian Feng <xtfeng@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
Message-ID: <20100428092548.GA4413@cmpxchg.org>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> <u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> <20100428081545.GA19027@windriver.com> <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:23:52PM +0800, Changli Gao wrote:
> On Wed, Apr 28, 2010 at 4:15 PM, Yong Zhang <yong.zhang@windriver.com> wrote:
> >
> > What do you mean "we don't need these processes"?
> 
> If the work is less than the workers, we don't need the workers at the
> tail of the exculsive list.

Have you checked how exclusive waitqueues are even used?

> > So some processs(at the tail of exclusive list)will be treated abnormally
> > and it will sleep for a long time, is this reasonable?
> >
> 
> If there isn't enough work to be done, we'd better not disrupt them
> and  leave them sleeping forever to keep the scheduler happier. Do we
> have reason to keep fair to all the workers? Does it have benefit?

How about starving lock contenders?  See wait_on_bit_lock() and grep
for the users e.g.
