Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1LSK0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:26:10 -0500
Received: from zeus.madism.org ([88.190.14.41]:47545 "EHLO zeus.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab1LSK0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:26:08 -0500
Date: Mon, 19 Dec 2011 11:26:05 +0100
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: allow preempt notifiers to self-unregister.
Message-ID: <20111219102605.GA28692@madism.org>
References: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
 <4EEDADF1.3040305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EEDADF1.3040305@redhat.com>
X-Face: $(^e[V4D-[`f2EmMGz@fgWK!e.B~2g.{08lKPU(nc1J~z\4B>*JEVq:E]7G-\6$Ycr4<;Z!|VY6Grt]+RsS$IMV)f>2)M="tY:ZPcU;&%it2D81X^kNya0=L]"vZmLP+UmKhgq+u*\.dJ8G!N&=EvlD
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 11:10:09AM +0200, Avi Kivity wrote:
> On 12/16/2011 06:15 PM, Pierre Habouzit wrote:
> >   As a background, this need is because I have some kind of module
> >   code that uses this facility to evaluate how many of a group of
> >   threads are concurrently running (to regulate a pool of threads).
> >
>
> That's what's cmwq is supposed to be doing (and that too should be
> using preempt notifiers, IMO).

It doesn't (use preempt notifiers) because it calls schedule directly
and can have its own processing before and after schedule() on his own.

Indeed, my goal is to have something like kernel/workqueues.c, kind of,
but for *userland*. The goal is to support things like Apple
pthread_workqueue_* stuff[1], and similar concepts of load-regulated
userland thread pools.


 [1] http://people.freebsd.org/~sson/thrworkq/pthread_workqueue.3.txt
-- 
Intersec <http://www.intersec.com>
Pierre Habouzit <pierre.habouzit@intersec.com> | Chief Software Architect
Tél : +33 (0)1 5570 3346
Mob : +33 (0)6 1636 8131
Fax : +33 (0)1 5570 3332
37 Rue Pierre Lhomme
92400 Courbevoie
