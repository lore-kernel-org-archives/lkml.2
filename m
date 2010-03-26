Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0CZDx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:53:59 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:37485 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab0CZDx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:53:57 -0400
Date: Fri, 26 Mar 2010 09:23:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 1/2] cputimers/proc: do_task_stat()->task_times() can
 race with getrusage()
Message-ID: <20100326035344.GQ3308@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100324204550.GA31777@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100324204550.GA31777@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2010-03-24 21:45:50]:

> do_task_stat()->task_times() can race with getrusage(), they both can
> try to update task->prev_Xtime at the same time.
> 
> Remove this bit of d180c5bc "sched: Introduce task_times() to replace
> task_{u,s}time()".

One of the reasons for adding this accuracy was to avoid sampling
based noise and errors that occur with utime and stime.

As long as there is no preemption during the assignment, I think we
should be OK. 

I see two options

1. Disable preemption around assignment
2. Remove task_times() from getrusage()


-- 
	Three Cheers,
	Balbir
