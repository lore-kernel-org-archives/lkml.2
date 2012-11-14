Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423125Ab2KNQsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:48:17 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58359 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423059Ab2KNQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <1352911221.18025.66.camel@gandalf.local.home>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
	<1352910413-10759-2-git-send-email-fweisbec@gmail.com>
	<1352911221.18025.66.camel@gandalf.local.home>
Date: Wed, 14 Nov 2012 17:48:12 +0100
Message-ID: <CAFTL4hz11T2oy5ohBE16snuzq1cmUn3M_6Q57qzrjH=PmiYiZw@mail.gmail.com>
Subject: Re: [PATCH 1/4] vtime: Remove the underscore prefix invasion
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/14 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2012-11-14 at 17:26 +0100, Frederic Weisbecker wrote:
>> Prepending irq-unsafe vtime APIs with underscores was actually
>> a bad idea as the result is a big mess in the API namespace that
>> is even waiting to be further extended. Also these helpers
>> are always called from irq safe callers except kvm. Just
>> provide a vtime_account_system_irqsafe() for this specific
>> case so that we can remove the underscore prefix on other
>> vtime functions.
>>
>
>
>> -void __vtime_account_system(struct task_struct *tsk)
>> +void vtime_account_system(struct task_struct *tsk)
>>  {
>>       cputime_t delta = vtime_delta(tsk);
>
> Should we add a WARN_ON(!irqs_disabled()) check here?

Why not, I'll add one in vtime_delta().
