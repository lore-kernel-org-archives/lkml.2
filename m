Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2JBVOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:14:47 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34960 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2JBVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:14:45 -0400
MIME-Version: 1.0
In-Reply-To: <xm26vcf3b1fb.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <20120823141422.444396696@google.com> <20120823141507.061208672@google.com>
 <5060B82B.1050206@cs.tu-berlin.de> <xm26vcf3b1fb.fsf@sword-of-the-dawn.mtv.corp.google.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 2 Oct 2012 14:14:14 -0700
Message-ID: <CAPM31RLhp2OPhLJXTxE7PS2Gj8P-9eWPtRziJkGQav3kn=i7YQ@mail.gmail.com>
Subject: Re: [patch 11/16] sched: replace update_shares weight distribution
 with per-entity computation
To: Benjamin Segall <bsegall@google.com>
Cc: =?ISO-8859-1?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 1:39 PM, Benjamin Segall <bsegall@google.com> wrote:
> blocked_load_avg ~= \sum_child child.runnable_avg_sum/child.runnable_avg_period * child.weight
>
> The thought was: So if all the children have hit zero runnable_avg_sum
> (or in the case of a child task, will when they wake up), then
> blocked_avg sum should also hit zero at the same and we're in theory
> fine.
>
> However, child load can be significantly larger than even the maximum
> value of runnable_avg_sum (and you can get a full contribution off a new
> task with only one tick of runnable_avg_sum anyway...), so
> runnable_avg_sum can hit zero first due to rounding. We should case on
> runnable_avg_sum || blocked_load_avg.

Clipping blocked_load_avg when runnable_avg_sum goes to zero is
sufficient.  At this point we cannot contribute to our parent anyway.

>
>
> As a side note, currently decay_load uses SRR, which means none of these
> will hit zero anyway if updates occur more often than once per 32ms. I'm
> not sure how we missed /that/, but fixes incoming.

Egads, fixed.  We definitely used to have that, I think it got lost in
the "clean everything up, break it into a series, and make it pretty"
step.  Perhaps that explains why some of the numbers in the previous
table were a little different.


>
> Thanks,
> Ben
>
