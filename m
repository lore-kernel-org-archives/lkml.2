Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243Ab0KQWCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:02:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759082Ab0KQWCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:02:16 -0500
Date: Wed, 17 Nov 2010 23:01:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, Andre@firstfloor.org,
        ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        pierre-marc.fournier@polymtl.ca
Subject: Re: [ANNOUNCE] New tools: lttngtrace and lttngreport
Message-ID: <20101117220152.GA2915@elte.hu>
References: <20101115134243.GA2772@Krystal>
 <20101115160745.GA7203@Krystal>
 <87y68sqiyb.fsf@basil.nowhere.org>
 <20101117173124.GB13717@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117173124.GB13717@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Well, I'm afraid the collection approach "trace" is currently taking won't allow 
> this kind of dependency wakeup chain tracking, because they focus on tracing 
> operations happening on a thread and its children, but the reality is that the 
> wakeup chains often spread outside of this scope.
>
> This is why lttngtrace gathers a system-wide trace even though we're mostly 
> intested in the wait/wakeups of a specific PID.

Mathieu, what you say is factually wrong - of course perf events allows system-wide 
tracing, it always did.

This is available in the 'trace' tool as well, try:

  $ trace record --all sleep 1          # do system-wide tracing
  
  # trace recorded [1.928 MB] - try 'trace summary' to get an overview

  $ trace summary

   .-----------------------------------.
 __)    Summary of 'sleep 1' events    (__

              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]
 _____________________________________________________________________

             swapper - 0     :         64   [  0.4% ]      0.000 ms
         ksoftirqd/0 - 3     :          6   [  0.0% ]      0.063 ms
         migration/1 - 7     :          2   [  0.0% ]      0.000 ms
         kworker/0:1 - 10    :          6   [  0.0% ]      0.139 ms
         kworker/6:1 - 53    :          3   [  0.0% ]      0.014 ms
         kworker/5:1 - 54    :          3   [  0.0% ]      0.014 ms
         kworker/4:1 - 55    :          3   [  0.0% ]      0.014 ms
         kworker/3:1 - 56    :          3   [  0.0% ]      0.015 ms
         kworker/2:1 - 57    :          3   [  0.0% ]      0.015 ms
         kworker/1:1 - 58    :          3   [  0.0% ]      0.015 ms
        kworker/15:1 - 318   :          6   [  0.0% ]      0.045 ms
        kworker/14:1 - 319   :          6   [  0.0% ]      0.033 ms
        kworker/13:1 - 320   :          6   [  0.0% ]      0.036 ms
        kworker/12:1 - 321   :          6   [  0.0% ]      0.035 ms
        kworker/11:1 - 322   :          6   [  0.0% ]      0.041 ms
        kworker/10:1 - 323   :          6   [  0.0% ]      0.037 ms
         kworker/9:1 - 324   :          6   [  0.0% ]      0.042 ms
         kworker/7:1 - 326   :          6   [  0.0% ]      0.032 ms
         kworker/8:2 - 1047  :          6   [  0.0% ]      0.039 ms
            sendmail - 2327  :         18   [  0.1% ]      0.111 ms
               trace - 32281 :      15728   [ 96.2% ]     86.478 ms
               sleep - 32282 :        460   [  2.8% ]      1.305 ms
 _____________________________________________________________________

As you can see all those kworker events - it's a system-wide trace.

This is in addition to per process and per workflow (child hierarchy) tracing - 
which we expect to be more commonly used.

Thanks,

	Ingo
