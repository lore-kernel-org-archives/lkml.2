Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2ELEPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 00:15:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50317 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2ELEPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 00:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXjYJFzMniWDO8wG57Zj6QxkGSRnKEue4b6MSuB0FU-W+Q@mail.gmail.com>
References: <CANQmPXjYJFzMniWDO8wG57Zj6QxkGSRnKEue4b6MSuB0FU-W+Q@mail.gmail.com>
Date: Sat, 12 May 2012 12:15:05 +0800
Message-ID: <CANQmPXiTapKRV69hNP0AttKuVVwHdCvEsiEnnp2wWQCso=++kA@mail.gmail.com>
Subject: Re: [ANNOUNCE][PATCH] Rotary Interactivity Favor Scheduler V2 Releaae
From: mou Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Juri Lelli <juri.lelli@gmail.com>, Con Kolivas <kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 1:06 AM, mou Chen <hi3766691@gmail.com> wrote:
> Hmm. The new version is released.;-)
>
> The RIFS SCHEDULER is a scheduler for a low latency desktop. It is
> implemented base on the concept of simple.It lets the interactive task
> run first than the cpu bound task.
>
> First , RIFS is based on the multiple feedback queue algorithm. That
> means it will let the high priority process run first. After the task
> has run out of timeslice or it sleeps for waiting something RIFS will
> determine whether we should increase the prio or not.For.preemption we
> just need to compare the prio to determine whether it can preempt or
> not.
>
> If a task run out of time_sluce we.will.decrease it 's prio.
> If a task run half of the time_slice and sleep we will increase it's prio
> In the other case we will save the time_slice.
> If a task that has a higher prio than his static_prio run out of
> time_slice, we will drop it's priority to the static_prio.
> If a task run out of time_slice and it's prio has become 140 already,
> we will raise it's prio to static_prio.
>
>                             Chen
Actually the scheduler use these 5 method to prevent the happen of
starveness and enhance the interactivity and responsiveness. Making
the end user feeling smooth is the goal of RIFS.

This is the benchmark given by "latt":

Parameters: min_wait=100ms, max_wait=500ms, clients=1

-=-=-=-=-=-=-=-=-=-=-=-BFS-=-=-=-=-=-=-=-=-=-=-=-
Wakeup averages
-------------------------------------
	Max		      23 usec
	Avg		       8 usec
	Stdev		       3 usec
	Stdev mean	       0 usec

Work averages
-------------------------------------
	Max		   22469 usec
	Avg		   20069 usec
	Stdev		     286 usec
	Stdev mean	      28 usec


-=-=-=-=-=-=-=-=-=-=-=-RIFS-=-=-=-=-=-=-=-=-=-=-=-
Wakeup averages
-------------------------------------
	Max		      13 usec
	Avg		       4 usec
	Stdev		       1 usec
	Stdev mean	       0 usec

Work averages
-------------------------------------
	Max		   20086 usec
	Avg		   19706 usec
	Stdev		      82 usec
	Stdev mean	       8 usec


It seems that RIFS has a even lower scheduling latency on an full idle box.
Actually the difference between RIFS and BFS also CFS will become
significant under a heavy workload for example make -j256 or even make
-j512. Firefox is still smooth even make -j512 on a 3.3.x kernel with
RIFS.
