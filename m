Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab2LVRve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 12:51:34 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:56741 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2LVRva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 12:51:30 -0500
MIME-Version: 1.0
In-Reply-To: <1356102595.5896.105.camel@gandalf.local.home>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	<1356028391-14427-6-git-send-email-fweisbec@gmail.com>
	<1356102595.5896.105.camel@gandalf.local.home>
Date: Sat, 22 Dec 2012 18:51:29 +0100
Message-ID: <CAFTL4hxfMgdXwFBUGPPub8Y3d531ufHdMB8j7TM+iSHrLKatFw@mail.gmail.com>
Subject: Re: [PATCH 05/24] cputime: Safely read cputime of full dynticks CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/21 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:
>
>> --- a/include/linux/init_task.h
>> +++ b/include/linux/init_task.h
>> @@ -10,6 +10,7 @@
>>  #include <linux/pid_namespace.h>
>>  #include <linux/user_namespace.h>
>>  #include <linux/securebits.h>
>> +#include <linux/seqlock.h>
>>  #include <net/net_namespace.h>
>>
>>  #ifdef CONFIG_SMP
>> @@ -141,6 +142,13 @@ extern struct task_group root_task_group;
>>  # define INIT_PERF_EVENTS(tsk)
>>  #endif
>>
>> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
>> +#define INIT_VTIME(tsk)                                              \
>> +     .vtime_seqlock = __SEQLOCK_UNLOCKED(tsk.vtime_seqlock), \
>> +     .prev_jiffies = INITIAL_JIFFIES, /* CHECKME */          \
>> +     .prev_jiffies_whence = JIFFIES_SYS,
>
> #else
> # define INIT_VTIME(tsk)
> #endif
>
> Otherwise it fails to compile when CONFIG_VIRT_CPU_ACCOUNTING_GEN is not
> set.

Fixed for the next version, thanks!
