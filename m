Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2CLRGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:06:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58229 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2CLRGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:06:37 -0400
MIME-Version: 1.0
In-Reply-To: <1331300109.1149.17.camel@fedora>
References: <20120309184041.bd10edffa51dcd43ce069487@canb.auug.org.au>
	<1331300109.1149.17.camel@fedora>
Date: Mon, 12 Mar 2012 12:06:36 -0500
Message-ID: <CAMXH7KHdfzjZCsBMkFOnwYtyaqBztMY99QcZ7VwLP0JASUiVAw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the tip tree
From: Rob Lee <rob.lee@linaro.org>
To: Steven Rostedt <srostedt@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven and Stephen,

On Fri, Mar 9, 2012 at 7:35 AM, Steven Rostedt <srostedt@redhat.com> wrote:
> On Fri, 2012-03-09 at 18:40 +1100, Stephen Rothwell wrote:
>> diff --cc drivers/cpuidle/cpuidle.c
>> index 6588f43,56de5f7..0000000
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@@ -92,15 -109,13 +109,13 @@@ int cpuidle_idle_call(void
>>                 return 0;
>>         }
>>
>> -       target_state = &drv->states[next_state];
>> -
>>  -      trace_power_start(POWER_CSTATE, next_state, dev->cpu);
>>  -      trace_cpu_idle(next_state, dev->cpu);
>>  +      trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
>>  +      trace_cpu_idle_rcuidle(next_state, dev->cpu);
>>
>> -       entered_state = target_state->enter(dev, drv, next_state);
>> +       entered_state = cpuidle_enter_ops(dev, drv, next_state);
>>
>>  -      trace_power_end(dev->cpu);
>>  -      trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
>>  +      trace_power_end_rcuidle(dev->cpu);
>>  +      trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
>>
>
> Looks good. My change was just a rename of trace_power_* and
> trace_cpu_*, and it looks like another change was the clean up of
> target_state. This is a trivial conflict, and there should be no
> surprises here.
>
> -- Steve
>

Looks good to me as well.

Who should carry this fixup?

Best Regards,
Rob

>
>
>>         if (entered_state >= 0) {
>>                 /* Update cpuidle counters */
>
