Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2BQNA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:00:58 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46517 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2BQNA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:00:57 -0500
MIME-Version: 1.0
In-Reply-To: <1329407875.2293.239.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013826.20844.47587.stgit@kitami.mtv.corp.google.com> <1329407875.2293.239.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 05:00:26 -0800
Message-ID: <CAPM31RKvSifXDqpxNt5zi7v-s2H18hPR5P_NTV0EGHa7LKe0vQ@mail.gmail.com>
Subject: Re: [RFC PATCH 05/14] sched: account for blocked load waking back up
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 7:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>> +               if (se->avg.decay_count) {
>> +                       /*
>> +                        * In a wake-up migration we have to approximate the
>> +                        * time sleeping.
>> +                        */
>> +                       se->avg.last_runnable_update -= (-se->avg.decay_count)
>> +                                                       << 20;
>> +                       update_entity_load_avg(se, 0);
>> +               }
>
> That comment wants more why and how. I think I remember pjt telling me
> about this last week, but those are already vague memories, I'll be sure
> to be completely clueless in another week.

The full reason is short enough to practically supplant the existing
comment:  We can't synchronize clock_task between our old-cpu and our
new [don't have the locks and 32-bit says you can't have nice things],
so we can use our carried decays (which we can grab atomically for
exactly this reason) to approximate that.

I'll update appropriately.
