Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1KARwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:52:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49215 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1KARwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <CALKntY3E_opsxYBP+3xB0GTFefo=Q2A3A0w+dbXVnqs+CX3Kqw@mail.gmail.com>
References: <CALKntY3E_opsxYBP+3xB0GTFefo=Q2A3A0w+dbXVnqs+CX3Kqw@mail.gmail.com>
Date: Tue, 1 Nov 2011 23:52:43 +0600
Message-ID: <CADZ9YHhcFs9pw09sgrraJzQ3BGs=nOaXAe_966R5ZrgF6BpWRw@mail.gmail.com>
Subject: Re: Linux scheduler Questions
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 6:24 PM, Xin Tong <xerox.time.tech@gmail.com> wrote:
> 2 questions on Linux 2.6.x scheduler.
>
> 1.  in Linux 2.6, when a process is waiting for IO. it will be placed
> on the wait queue. is the wait queue per cpu or global ? I do not see
> any field for the wait queue in the runqueue structure.

Where a particular process will wait depends on which scheduling
policy it will use. For a process which has SCHED_FIFO/SCHED_RR
policy, it will be handled by sched_rt scheduler. Where processes are
kept in priority-queue structure. Look for "struct rt_rq" structure.
If it's other than rt process, then processes are kept on red-black
tree (look at "struct cfs_rq" structure).

> 2. Linux 2.6 has the notion of scheduling domain, using an example to
> explain what I am getting at here
>
> In a HT enabled CPU, the CPU has 2 cores, each core has 2 threads.
> there will be 2 levels of domain.
> 1. Domain of lev.1 ==> 2 groups, 1 physical core per group.
> 2. Domain of lev. 0 ==> 2 groups, 1 logical core per group.
> When the load on the 2 logical cores is imbalanced, Linux will migrate
> some jobs from one to another. What if there is an imbalance of
> workload on the 2 physical cores ?
>
Will also try to migrate some jobs from busiest to less busiest core.
First, load balancer will try to find which core has less load, then
will try to find which logical CPU has less load.

Thanks,
Rakib
