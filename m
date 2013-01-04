Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3ADMvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:51:50 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:56027 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3ADMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:51:48 -0500
MIME-Version: 1.0
In-Reply-To: <0000013bfbe28263-98bca726-cf8f-4307-989d-472ea478e7f3-000000@email.amazonses.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	<1356799386-4212-8-git-send-email-fweisbec@gmail.com>
	<0000013bfbe28263-98bca726-cf8f-4307-989d-472ea478e7f3-000000@email.amazonses.com>
Date: Fri, 4 Jan 2013 13:51:46 +0100
Message-ID: <CAFTL4hzi-NdsQSEC5emG8ikKSMzuh3S0jfS3NupLrjjjiYR5Ag@mail.gmail.com>
Subject: Re: [PATCH 07/27] nohz: Assign timekeeping duty to a non-full-nohz CPU
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/2 Christoph Lameter <cl@linux.com>:
> On Sat, 29 Dec 2012, Frederic Weisbecker wrote:
>
>> @@ -163,6 +164,8 @@ static int __init tick_nohz_full_setup(char *str)
>>       return 1;
>>  }
>>  __setup("full_nohz=", tick_nohz_full_setup);
>> +#else
>> +#define have_full_nohz_mask (0)
>>  #endif
>>
>>  /*
>> @@ -512,6 +515,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>>               return false;
>>       }
>>
>> +     /* If there are full nohz CPUs around, we need to keep the timekeeping duty */
>> +     if (have_full_nohz_mask && tick_do_timer_cpu == cpu)
>> +             return false;
>> +
>>       return true;
>>  }
>>
>>
>
> Ok so I guess this means that if I setup all cpus as nohz then a random
> one will continue to do timekeeping?

In fact, although the code doesn't check that yet, you're supposed to
have at least one online CPU outside the full_nohz mask to handle
that.
