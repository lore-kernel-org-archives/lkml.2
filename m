Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab2EIJA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:00:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56494 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830Ab2EIJAZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <1336489566.14207.180.camel@gandalf.stny.rr.com>
References: <CAD+1EGN=QjPkkqNNybqRHkMs7a-qR_gWL7-dMxrcE92qrX0X2w@mail.gmail.com>
	<1336399968.14207.141.camel@gandalf.stny.rr.com>
	<CAD+1EGOKJWLLjXam2TA+iksbvwx47n6u1aHir7_SNfO9ECqRGg@mail.gmail.com>
	<1336489566.14207.180.camel@gandalf.stny.rr.com>
Date: Wed, 9 May 2012 17:00:23 +0800
Message-ID: <CAD+1EGMdcYD4B6E4RVfR4drpVjuA6zkvuAbWOV5A0vKHBiJyBw@mail.gmail.com>
Subject: Re: [RFC]Read kernel stack with trace-cmd
From: harryxiyou <harryxiyou@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        Chen Lijun <cljcore@126.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 11:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-05-08 at 22:34 +0800, harryxiyou wrote:
>
>> >
[...]
>> => i915_add_request (f850cef4)
>> => i915_gem_do_execbuffer (f8510adc)
>>             Xorg-1104  [001]  3106.003258: irq_handler_exit:
>
> Isn't this what you asked for?

Hmmm.., this is what i wanna see ;-)  Actually, i don't know how to
analyse these datas got by trace-cmd. Cloud you please give me
some descriptions for following ones?

#./trace-cmd report | less
version = 6
cpus=2
       trace-cmd-1666  [000]    66.206448: sys_exit:             NR 4 = 1
            Xorg-977   [001]    66.206449: sys_exit:             NR 265 = 0
       trace-cmd-1666  [000]    66.206450: kernel_stack:         <stack trace>
=> syscall_exit_work (c010352a)
            Xorg-977   [001]    66.206450: kernel_stack:         <stack trace>
=> syscall_exit_work (c010352a)
            Xorg-977   [001]    66.206455: sys_enter:            NR 54
(9, c00c6466, bfcfccb0, 9f42bf0, 863b7b4, bfcfccd8)
            Xorg-977   [001]    66.206455: kernel_stack:         <stack trace>
=> syscall_trace_entry (c01034ff)
       trace-cmd-1666  [000]    66.206456: mm_page_alloc:
page=0xc13c65a0 pfn=3241960864 order=0 migratetype=2
gfp_flags=GFP_HIGHUSER_MOVABLE
       trace-cmd-1666  [000]    66.206457: kernel_stack:         <stack trace>
=> do_wp_page (c01e5659)
=> handle_mm_fault (c01e641c)
=> do_page_fault (c058da8d)
=> error_code (c058b983)
            Xorg-977   [001]    66.206463: sys_exit:             NR 54 = 0
            Xorg-977   [001]    66.206463: kernel_stack:         <stack trace>
=> syscall_exit_work (c010352a)
       trace-cmd-1666  [000]    66.206467: sys_enter:            NR 4
(1, b782f000, 1d, 1d, b782f000, bf91b918)
            Xorg-977   [001]    66.206467: sys_enter:            NR 54
(9, c00c6466, bfcfcd20, 9e767a8, 863b7b4, bfcfcd48)
       trace-cmd-1666  [000]    66.206467: kernel_stack:         <stack trace>
=> syscall_trace_entry (c01034ff)
            Xorg-977   [001]    66.206467: kernel_stack:         <stack trace>
=> syscall_trace_entry (c01034ff)
            Xorg-977   [001]    66.206470: sys_exit:             NR 54 = 0
            Xorg-977   [001]    66.206470: kernel_stack:         <stack trace>
=> syscall_exit_work (c010352a)
            Xorg-977   [001]    66.206473: sys_enter:            NR 54
(9, c00c6466, bfcfcd90, 9f42620, 863b7b4, bfcfcdb8)
            Xorg-977   [001]    66.206473: kernel_stack:         <stack trace>
=> syscall_trace_entry (c01034ff)
       trace-cmd-1666  [000]    66.206475: timer_start:          timer
0xef0be8c8: func delayed_work_timer_fn, expires 53251, timeout 1
       trace-cmd-1666  [000]    66.206475: kernel_stack:         <stack trace>
=> add_timer (c015be36)
=> queue_delayed_work_on (c01642df)
=> queue_delayed_work (c0164370)
=> schedule_delayed_work (c01643a6)
=> tty_flip_buffer_push (c03ba7c3)
=> pty_write (c03bb7ca)
=> process_output_block (c03b5992)
=> n_tty_write (c03b669b)
            Xorg-977   [001]    66.206476: sys_exit:             NR 54 = 0
            Xorg-977   [001]    66.206476: kernel_stack:         <stack trace>
=> syscall_exit_work (c010352a)
            Xorg-977   [001]    66.206478: sys_enter:            NR 54
(9, c00c6466, bfcfcd90, 9f546d0, 863b7d8, bfcfcdb8)
            Xorg-977   [001]    66.206479: kernel_stack:         <stack trace>
=> syscall_trace_entry (c01034ff)
       trace-cmd-1666  [000]    66.206481: sched_wakeup:         task
trace-cmd:1666 [120] success=0 [000]
       trace-cmd-1666  [000]    66.206481: kernel_stack:         <stack trace>
[...]

>
>> irq=29 return=handled
>>             Xorg-1104  [001]  3106.003259: kernel_stack:         <stack trace>
[...]
>> => hrtimer_wakeup (c016acad)
>> => __run_hrtimer (c016b14a)^Ctrace-cmd: Received SIGINT
>>             Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
>> [...]
>>
>>
>> Note: i can't stop the cmd './trace-cmd report' after
>> './trace-cmd record -e all -O stacktrace' but enter 'CTRC+C'.
>>
>> If it is a bug here? Any comments?
>
> It should stop, but perhaps not immediately. Best to pipe it through
> less:
>
> trace-cmd report |less

Yup, it works for me, thanks ;-)

>
> I may, in the future, make trace-cmd report do its own paging, like git
> does. But for now, I just use less.
>
> The reason for the special ctrl-c is because of the python plugin. It
> has some strange side effects. One is that it overrides ctrl-c, so I add
> a handler to explicitly kill trace-cmd. But that still causes a delay
> before the kill happens.
>

Hmm.., It sounds well, thanks ;-)



-- 
Thanks
Harry Wei
