Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2EIN6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:58:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9393 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2EIN6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:58:43 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5UZbrx23EwAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=TDXYlva7k0UThfM0mIIA:9 a=PXpPg_67I2vQptCd58sA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336571920.14207.201.camel@gandalf.stny.rr.com>
Subject: Re: [RFC]Read kernel stack with trace-cmd
From: Steven Rostedt <rostedt@goodmis.org>
To: harryxiyou <harryxiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        Chen Lijun <cljcore@126.com>
Date: Wed, 09 May 2012 09:58:40 -0400
In-Reply-To: <CAD+1EGMdcYD4B6E4RVfR4drpVjuA6zkvuAbWOV5A0vKHBiJyBw@mail.gmail.com>
References: <CAD+1EGN=QjPkkqNNybqRHkMs7a-qR_gWL7-dMxrcE92qrX0X2w@mail.gmail.com>
	 <1336399968.14207.141.camel@gandalf.stny.rr.com>
	 <CAD+1EGOKJWLLjXam2TA+iksbvwx47n6u1aHir7_SNfO9ECqRGg@mail.gmail.com>
	 <1336489566.14207.180.camel@gandalf.stny.rr.com>
	 <CAD+1EGMdcYD4B6E4RVfR4drpVjuA6zkvuAbWOV5A0vKHBiJyBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 17:00 +0800, harryxiyou wrote:
> On Tue, May 8, 2012 at 11:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2012-05-08 at 22:34 +0800, harryxiyou wrote:
> >
> >> >
> [...]
> >> => i915_add_request (f850cef4)
> >> => i915_gem_do_execbuffer (f8510adc)
> >>             Xorg-1104  [001]  3106.003258: irq_handler_exit:
> >
> > Isn't this what you asked for?
> 
> Hmmm.., this is what i wanna see ;-)  Actually, i don't know how to
> analyse these datas got by trace-cmd. Cloud you please give me
> some descriptions for following ones?

Now -Ostacktrace will only give you the kernel stack, not the userspace.
If you are tracing system calls, then that's pretty pointless to use.

You could use -Ouserstacktrace but it will only make sense if the
userspace had framepointers configured in. Including glibc. Which is
seldom done.

> 
> #./trace-cmd report | less
> version = 6
> cpus=2
>        trace-cmd-1666  [000]    66.206448: sys_exit:             NR 4 = 1
>             Xorg-977   [001]    66.206449: sys_exit:             NR 265 = 0
>        trace-cmd-1666  [000]    66.206450: kernel_stack:         <stack trace>
> => syscall_exit_work (c010352a)
>             Xorg-977   [001]    66.206450: kernel_stack:         <stack trace>
> => syscall_exit_work (c010352a)
>             Xorg-977   [001]    66.206455: sys_enter:            NR 54
> (9, c00c6466, bfcfccb0, 9f42bf0, 863b7b4, bfcfccd8)
>             Xorg-977   [001]    66.206455: kernel_stack:         <stack trace>
> => syscall_trace_entry (c01034ff)
>        trace-cmd-1666  [000]    66.206456: mm_page_alloc:
> page=0xc13c65a0 pfn=3241960864 order=0 migratetype=2
> gfp_flags=GFP_HIGHUSER_MOVABLE
>        trace-cmd-1666  [000]    66.206457: kernel_stack:         <stack trace>
> => do_wp_page (c01e5659)
> => handle_mm_fault (c01e641c)
> => do_page_fault (c058da8d)
> => error_code (c058b983)

here...

>             Xorg-977   [001]    66.206463: sys_exit:             NR 54 = 0
>             Xorg-977   [001]    66.206463: kernel_stack:         <stack trace>
> => syscall_exit_work (c010352a)
>        trace-cmd-1666  [000]    66.206467: sys_enter:            NR 4
> (1, b782f000, 1d, 1d, b782f000, bf91b918)
>             Xorg-977   [001]    66.206467: sys_enter:            NR 54
> (9, c00c6466, bfcfcd20, 9e767a8, 863b7b4, bfcfcd48)
>        trace-cmd-1666  [000]    66.206467: kernel_stack:         <stack trace>
> => syscall_trace_entry (c01034ff)
>             Xorg-977   [001]    66.206467: kernel_stack:         <stack trace>
> => syscall_trace_entry (c01034ff)
>             Xorg-977   [001]    66.206470: sys_exit:             NR 54 = 0
>             Xorg-977   [001]    66.206470: kernel_stack:         <stack trace>
> => syscall_exit_work (c010352a)
>             Xorg-977   [001]    66.206473: sys_enter:            NR 54
> (9, c00c6466, bfcfcd90, 9f42620, 863b7b4, bfcfcdb8)
>             Xorg-977   [001]    66.206473: kernel_stack:         <stack trace>
> => syscall_trace_entry (c01034ff)
>        trace-cmd-1666  [000]    66.206475: timer_start:          timer
> 0xef0be8c8: func delayed_work_timer_fn, expires 53251, timeout 1
>        trace-cmd-1666  [000]    66.206475: kernel_stack:         <stack trace>
> => add_timer (c015be36)
> => queue_delayed_work_on (c01642df)
> => queue_delayed_work (c0164370)
> => schedule_delayed_work (c01643a6)
> => tty_flip_buffer_push (c03ba7c3)
> => pty_write (c03bb7ca)
> => process_output_block (c03b5992)
> => n_tty_write (c03b669b)


and here, are the only "interesting" traces. And they are not that
interesting. It shows the function graph down to the tracepoint.

I really can't tell you how to analyze these, because I have no idea
what you are trying to do.

-- Steve

>             Xorg-977   [001]    66.206476: sys_exit:             NR 54 = 0
>             Xorg-977   [001]    66.206476: kernel_stack:         <stack trace>
> => syscall_exit_work (c010352a)
>             Xorg-977   [001]    66.206478: sys_enter:            NR 54
> (9, c00c6466, bfcfcd90, 9f546d0, 863b7d8, bfcfcdb8)
>             Xorg-977   [001]    66.206479: kernel_stack:         <stack trace>
> => syscall_trace_entry (c01034ff)
>        trace-cmd-1666  [000]    66.206481: sched_wakeup:         task
> trace-cmd:1666 [120] success=0 [000]
>        trace-cmd-1666  [000]    66.206481: kernel_stack:         <stack trace>
> [...]
> 
> >
> >> irq=29 return=handled
> >>             Xorg-1104  [001]  3106.003259: kernel_stack:         <stack trace>
> [...]
> >> => hrtimer_wakeup (c016acad)
> >> => __run_hrtimer (c016b14a)^Ctrace-cmd: Received SIGINT
> >>             Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
> >> [...]
> >>
> >>
> >> Note: i can't stop the cmd './trace-cmd report' after
> >> './trace-cmd record -e all -O stacktrace' but enter 'CTRC+C'.
> >>
> >> If it is a bug here? Any comments?
> >
> > It should stop, but perhaps not immediately. Best to pipe it through
> > less:
> >
> > trace-cmd report |less
> 
> Yup, it works for me, thanks ;-)
> 
> >
> > I may, in the future, make trace-cmd report do its own paging, like git
> > does. But for now, I just use less.
> >
> > The reason for the special ctrl-c is because of the python plugin. It
> > has some strange side effects. One is that it overrides ctrl-c, so I add
> > a handler to explicitly kill trace-cmd. But that still causes a delay
> > before the kill happens.
> >
> 
> Hmm.., It sounds well, thanks ;-)
> 
> 
> 


