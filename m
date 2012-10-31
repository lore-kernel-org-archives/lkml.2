Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab2JaTl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760213Ab2JaTlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:41:14 -0400
Date: Wed, 31 Oct 2012 20:41:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] percpu_rw_semaphore: reimplement to not block the
	readers unnecessarily
Message-ID: <20121031194135.GA504@redhat.com>
References: <20121015191018.GA4816@redhat.com> <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030184800.GA16129@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30, Oleg Nesterov wrote:
>
> So. down_write/up_right does msleep() and it needs to call
> synchronize_sched() 3 times.
>
> This looks too much. It is not that I am worried about the writers,
> the problem is that the new readers are blocked completely while the
> writer sleeps in msleep/synchronize_sched.
>
> Paul, Mikulas, et al. Could you please look at the new implementation
> below? Completely untested/uncompiled, just for discussion.

I tried to test it, seems to work...

But. I guess the only valid test is: pass the review from Paul/Peter.

Todo:
	- add the lockdep annotations

	- we can speedup the down_write-right-aftet-up_write case

What do you all think?

Oleg.

