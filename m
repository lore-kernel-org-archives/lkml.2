Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab2J1KM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 06:12:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44318 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2J1KM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 06:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120823141506.442637130@google.com>
References: <20120823141422.444396696@google.com>
	<20120823141506.442637130@google.com>
Date: Sun, 28 Oct 2012 15:42:26 +0530
Message-ID: <CAM4v1pOJfADYuz9=XaFMnNG-OYAJtsd93Y5YgMd6pn-9sz6Q+A@mail.gmail.com>
Subject: Re: [patch 02/16] sched: maintain per-rq runnable averages
From: Preeti Murthy <preeti.lkml@gmail.com>
To: pjt@google.com, Ben Segall <bsegall@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, Ben,

A few queries regarding this patch:

1.What exactly is the significance of introducing sched_avg structure
for a runqueue? If I have
   understood correctly, sched_avg keeps track of how long a task has
been active,
   how long has it been serviced by the processor and its lifetime.How
does this apply analogously
   to the runqueue?

2.Is this a right measure to overwrite rq->load.weight because the
rq->sched_avg does not seem to
   take care of task priorities.IOW, what is the idea behind
introducing this metric for the runqueue?
   Why cant the run queue load be updated the same way as the cfs_rq
load is updated:
    cfs_rq->runnable_load_avg and cfs_rq->blocked_load_avg.

3.What is the significance of passing rq->nr_running in
enqueue_task_fair while updating
   the run queue load? Because __update_entity_runnable_avg does not
treat this argument
   any differently if it is >1.

Thank you

Regards
Preeti U Murthy

On Thu, Aug 23, 2012 at 7:44 PM,  <pjt@google.com> wrote:
> From: Ben Segall <bsegall@google.com>
>
> Since runqueues do not have a corresponding sched_entity we instead embed a
> sched_avg structure directly.
>
> Signed-off-by: Ben Segall <bsegall@google.com>
> Reviewed-by: Paul Turner <pjt@google.com>
> ---
