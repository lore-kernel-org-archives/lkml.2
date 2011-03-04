Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab1CDHk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:40:29 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41911 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1CDHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:40:27 -0500
Date: Fri, 4 Mar 2011 12:55:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is
 enabled
Message-ID: <20110304072517.GC2868@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110303113435.GA2868@balbir.in.ibm.com>
 <20110303140551.GA20677@zhy>
 <AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
 <AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yong Zhang <yong.zhang0@gmail.com> [2011-03-04 11:43:16]:

> On Thu, Mar 3, 2011 at 11:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > No, not really :) It is required, it is a backup check to see if we
> > have queued tasks, rt_time of 0 and the runqueue is not throttled, why
> > should it be dequeued?
> 
> But I can't see where that kind of rt_rq is dequeued, mind pointing it out?
>

So here is what I saw

1. sched_dequeue_stack called from the dequeue path dequeues the
queues and sets rt_nr_running to 0
2. Enqueuing fails because rt_throttled is set for the group_rq
(parent who is throttled)
3. This causes further enqueue to fail, since rt_nr_running did
not increment in step 2, eventually the timer decrements rt_time
to 0 and the task is never picked up.

-- 
	Three Cheers,
	Balbir
