Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab0CZHjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 03:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab0CZHjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 03:39:44 -0400
Date: Fri, 26 Mar 2010 08:37:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 1/2] cputimers/proc: do_task_stat()->task_times()
	can race with getrusage()
Message-ID: <20100326073723.GA2596@dhcp-lab-161.englab.brq.redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326035344.GQ3308@balbir.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 09:23:44AM +0530, Balbir Singh wrote:
> * Oleg Nesterov <oleg@redhat.com> [2010-03-24 21:45:50]:
> 
> > do_task_stat()->task_times() can race with getrusage(), they both can
> > try to update task->prev_Xtime at the same time.
> > 
> > Remove this bit of d180c5bc "sched: Introduce task_times() to replace
> > task_{u,s}time()".
> 
> One of the reasons for adding this accuracy was to avoid sampling
> based noise and errors that occur with utime and stime.
> 
> As long as there is no preemption during the assignment, I think we
> should be OK. 
> 
> I see two options
> 
> 1. Disable preemption around assignment
That one sounds very good.

> 2. Remove task_times() from getrusage()
We want more accurate and what more important monotonic values
in getrusage.

Stanislaw
