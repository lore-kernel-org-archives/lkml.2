Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab2EIIej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:34:39 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39532 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2EIIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:34:36 -0400
Message-ID: <4FAA216D.1080909@linux.vnet.ibm.com>
Date: Wed, 09 May 2012 15:49:01 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Diwakar Tundlam <dtundlam@nvidia.com>
CC: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH] sched: Make nr_uninterruptible count a signed value
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com> <1336514192.8226.52.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com> <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050821-9264-0000-0000-000001704737
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 06:46 AM, Diwakar Tundlam wrote:

>> No that's right. nr_uninterruptible counts the number of tasks in 
>> uninterruptible sleep, so deactivate_task puts a task to sleep, so we 
>> need to increment the number of sleeping tasks, activate_task wakes a 
>> task up so we need to decrement the number of sleeping tasks.
> 
> Yep, I looked at the code for task_contributes_to_load() and I understand what it is all about.
> The ++ and -- are correct, I see it now.
> 
> On the -ve values, strangely inspite of %Ld in the print statement, in my kernel, I see high unsigned values instead of -ve values for nr_uninterruptible.
> 
> But the sum is always 0, though.
> 
> Maybe it is an artifact of 32-bit machine displaying 64-bit print format.
> An (unsigned long)(-24) promoted to (signed long long) ends up as 4294967272.
> As seen in my output of sched_debug.


This may do some help.

Regards,
Michael Wang
---
 kernel/sched/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 09acaa1..ab9d53f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -270,7 +270,7 @@ static void print_cpu(struct seq_file *m, int cpu)
                   rq->load.weight);
        P(nr_switches);
        P(nr_load_updates);
-       P(nr_uninterruptible);
+       P((signed long)nr_uninterruptible);
        PN(next_balance);
        P(curr->pid);
        PN(clock);
-- 
1.7.4.1

