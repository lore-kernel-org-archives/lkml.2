Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0D1S5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:57:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39240 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab0D1S5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:57:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Apr 2010 11:57:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Changli Gao <xiaosuo@gmail.com>
cc: David Howells <dhowells@redhat.com>, Yong Zhang <yong.zhang@windriver.com>,
       Xiaotian Feng <xtfeng@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO
 queue
In-Reply-To: <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1004281155070.21219@makko.or.mcafeemobile.com>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com>  <u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com>  <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com>  <20100428081545.GA19027@windriver.com>
 <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com>  <8482.1272446987@redhat.com> <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795847441-152578037-1272481022=:21219"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795847441-152578037-1272481022=:21219
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 28 Apr 2010, Changli Gao wrote:

> On Wed, Apr 28, 2010 at 5:29 PM, David Howells <dhowells@redhat.com> wrote:
> > Changli Gao <xiaosuo@gmail.com> wrote:
> >
> >> If there isn't enough work to be done, we'd better not disrupt them
> >> and  leave them sleeping forever to keep the scheduler happier. Do we
> >> have reason to keep fair to all the workers? Does it have benefit?
> >
> > You've made one important assumption: the processes on the wait queue are
> > sleeping waiting to service things... but what if the wait queue governs
> > access to a resource, and all the processes on that wait queue need access to
> > that resource to do things?  Some of the processes waiting for it may never
> > get a go, and so necessary work may be left undone.
> >
> 
> You are right. I made the wrong assumption. But we indeed need some
> primitive to add wait_queue at the head of the wait_queue_head, and I
> know epoll needs it, at least.
> 
> fs/eventpoll.c: 1443.
>                 wait.flags |= WQ_FLAG_EXCLUSIVE;
>                 __add_wait_queue(&ep->wq, &wait);

I'm not sure one user deserves a new function, but like it has been 
noticed, the patch for that should eventually be totally isolated from 
other bits.


- Davide


--1795847441-152578037-1272481022=:21219--
