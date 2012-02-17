Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab2BQKxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:53:23 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53995 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2BQKxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:53:22 -0500
MIME-Version: 1.0
In-Reply-To: <87y5s2cbrh.fsf@linux.vnet.ibm.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013826.20844.94427.stgit@kitami.mtv.corp.google.com> <87y5s2cbrh.fsf@linux.vnet.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 02:52:51 -0800
Message-ID: <CAPM31RJ4BjrMfGnQuREB+MJiPeaeLR3-dRjESsDRMeD+uUGnog@mail.gmail.com>
Subject: Re: [RFC PATCH 06/14] sched: aggregate total task_group load
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 8:41 PM, Nikunj A Dadhania
<nikunj@linux.vnet.ibm.com> wrote:
> On Wed, 01 Feb 2012 17:38:26 -0800, Paul Turner <pjt@google.com> wrote:
>> +static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>> +                                              int force_update)
>> +{
>> +     struct task_group *tg = cfs_rq->tg;
>> +     s64 tg_contrib;
>> +
>> +     tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
>> +     tg_contrib -= cfs_rq->tg_load_contrib;
>> +
>> +     if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
>>
> Not obvious to me where this 8 is coming from?
>

It's arbitrary, it requires a change in load contrib by more than
1/8th -- or 12.5% -- of the contrib we're advertising globally before
we pay the cost of an update in the non-forced case.

We used the same trick in the previous shares tracking code since we
did not have a natural rate limit on the update rate.  While this is
not as much of an issue in the new code, it does not seem to be
hurting the accuracy and squashing essentially spurious updates does
not hurt.

- Paul

> Regards
> Nikunj
>
