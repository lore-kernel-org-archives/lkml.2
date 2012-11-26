Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2KZAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 19:16:59 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58490 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2KZAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 19:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121125190909.GA1866@windriver.com>
References: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
	<1353680484-7302-4-git-send-email-fweisbec@gmail.com>
	<20121125190909.GA1866@windriver.com>
Date: Mon, 26 Nov 2012 01:16:57 +0100
Message-ID: <CAFTL4hwgHBv=-it5QpsWzeo+yi7j2JO15iox3AH6eoMYLcB2Ew@mail.gmail.com>
Subject: Re: [PATCH 3/3] cputime: Consolidate cputime adjustment code
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/25 Paul Gortmaker <paul.gortmaker@windriver.com>:
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -433,6 +433,11 @@ struct cpu_itimer {
>>       u32 incr_error;
>>  };
>>
>> +struct cputime {
>> +     cputime_t utime;
>> +     cputime_t stime;
>> +};
>> +
>
> Hi Frederic,
>
> This new struct cputime is a 2/3 subset of the three variable struct
> task_cputime we see right below.  Maybe this is a stupid question, but I
> was wondering why you didn't re-use task_cputime, and ignore the
> sum_exec_runtime field -- vs. introducing this very similar struct?

Not a stupid question, I need to add a comment on that. I avoided to
reuse struct task_cputime because sum_exec_runtime is unused and 8
wasted bytes in the middle of task_struct is very undesirable. As in
signal struct.

>
> Or maybe there is another way to consolidate the structs?  With the
> two being so similar, I wonder if it will be confusing when to use which
> one of the two.

I can add a comment that tells when to use which. Other than that I'm
short on ideas to consolidate both without creating a mess with long
dereferencing expressions like tsk->cputime.utime and so.
