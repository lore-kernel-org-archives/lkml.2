Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2ILM3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:29:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43327 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2ILM3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <1347410070.10751.28.camel@gandalf.local.home>
References: <1347134489-15380-1-git-send-email-elezegarcia@gmail.com>
	<1347410070.10751.28.camel@gandalf.local.home>
Date: Wed, 12 Sep 2012 09:29:36 -0300
Message-ID: <CALF0-+XxgMsQwwGaody0L5MTwpkDhqukbvzG2fUNsG1hEaREUw@mail.gmail.com>
Subject: Re: [PATCH v3] trace: Move trace event enable from fs_initcall to core_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        tim.bird@am.sony.com, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

On Tue, Sep 11, 2012 at 9:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
ble(void)
[...]
>> +     /*
>> +      * Early initialization already enabled ftrace event.
>> +      * Now it's only necessary to create the event directory.
>> +      */
>>       for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
>> -             __trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
>
> Here, __trace_add_event_call() did the checks and did not create a
> directory on raw_init() failure. But now there's no check, and we are
> having events being created that should not be.
>

I believe the problem is we're iterating through every event
defined in __start_ftrace_events.
We should iterate through the events added to the ftrace_events list.



>> +
>> +             ret = event_create_dir(*call, d_events,
>> +                                    &ftrace_event_id_fops,
>>                                      &ftrace_enable_fops,
>>                                      &ftrace_event_filter_fops,
>>                                      &ftrace_event_format_fops);
>
> I found this out when there was errors in trace-cmd reading format
> files. Looking into it, I found several syscalls that are not mapped to
> a syscall_nr being created.
>
> One solution would be to add another flag to the ftrace_event_call
> structure, that notes the event has failed to initialize. Or better yet,
> add a flag that just says that it was initialized. Then here we can skip
> those events that do not have that flag set.
>

Might be. But perhaps we could solve it by simply iterating through
ftrace_events list.

What do you think? Either way I can send another patch fixing it.

Regards,
Ezequiel.
