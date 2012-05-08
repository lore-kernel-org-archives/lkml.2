Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2EHOeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:34:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55004 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2EHOeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:34:08 -0400
MIME-Version: 1.0
In-Reply-To: <1336399968.14207.141.camel@gandalf.stny.rr.com>
References: <CAD+1EGN=QjPkkqNNybqRHkMs7a-qR_gWL7-dMxrcE92qrX0X2w@mail.gmail.com>
	<1336399968.14207.141.camel@gandalf.stny.rr.com>
Date: Tue, 8 May 2012 22:34:06 +0800
Message-ID: <CAD+1EGOKJWLLjXam2TA+iksbvwx47n6u1aHir7_SNfO9ECqRGg@mail.gmail.com>
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

On Mon, May 7, 2012 at 10:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sun, 2012-05-06 at 21:25 +0800, harryxiyou wrote:
>> Hi Steven,
>>
>> Maybe this is not the right place for asking a trace-cmd matter. If true,
>> please ignore this mail. Thanks.
>> I wanna to read stack contents with our trace-cmd. But i can only get
>> something about function information like following. I can not get kernel
>> stack infos with trace-cmd. How should i run trace-cmd for kernel stack
>> ones. Cloud anyone give me some suggestions?
>>
>> My Environments:
>> # uname -r
>> 2.6.32-21-generic
>
> Wow that's an old kernel.

Yup ;-)
>
>> # lsb_release -a
>> No LSB modules are available.
>> Distributor ID:       Ubuntu
>
> Note, I don't use Ubuntu. I use Debian or Fedora.
>
>> Description:  Ubuntu 10.04.4 LTS
>> Release:      10.04
>> Codename:     lucid
>> gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1)
>>
>> Following are my test code and logs after running trace-cmd.
>>
>> /*
>>  * linux_os/sys_call.c
>>  *
>>  * Harry Wei (C) 2012 5 6
>>  */
>> #include <syscall.h>
>> #include <unistd.h>
>> #include <stdio.h>
>> #include <sys/types.h>
>>
>> int main(int argc, char **argv) {
>>       long ID1 = 0L;
>>       long ID2 = 0L;
>>
>>       ID1 = syscall(SYS_getpid);
>>       printf("syscall(SYS_getpid) = %ld\n", ID1);
>>       ID2 = getpid();
>>       printf("getpid() = %ld\n", ID2);
>>       return 0;
>> }
>>
>> $ gcc sys_call.c
>>
>> # ./trace-cmd record -e all ../../workshop1/homeworkxy/linux_os/a.out
>
>
> Have you tried it with -O stacktrace ?
>
> trace-cmd record -e all -O stacktrace
>

After this cmd, i get following ones.

[...]
=> handle_IRQ_event (c019fc34)
=> handle_edge_irq (c01a1b84)
=> handle_irq (c01059ed)
=> do_IRQ (c058fa1c)
=> common_interrupt (c0103a30)
=> mod_timer (c015bd42)
=> i915_add_request (f850cef4)
=> i915_gem_do_execbuffer (f8510adc)
            Xorg-1104  [001]  3106.003258: irq_handler_exit:
irq=29 return=handled
            Xorg-1104  [001]  3106.003259: kernel_stack:         <stack trace>
=> handle_edge_irq (c01a1b84)
=> handle_irq (c01059ed)
=> do_IRQ (c058fa1c)
=> common_interrupt (c0103a30)
=> mod_timer (c015bd42)
=> i915_add_request (f850cef4)
=> i915_gem_do_execbuffer (f8510adc)
=> i915_gem_execbuffer (f851123b)
            Xorg-1104  [001]  3106.003272: kfree:
call_site=f8510958 ptr=0xf5ab9380
            Xorg-1104  [001]  3106.003273: kernel_stack:         <stack trace>
=> i915_gem_do_execbuffer (f8510958)
=> i915_gem_execbuffer (f851123b)
=> drm_ioctl (f81d57cd)
=> vfs_ioctl (c0216231)
=> do_vfs_ioctl (c0216519)
=> sys_ioctl (c0216817)
[...]
            Xorg-1104  [001]  3106.003348: sched_wakeup:         task
trace-cmd:3028 [120] success=1 [001]
            Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
=> wake_up_process (c0142bd4)
=> hrtimer_wakeup (c016acad)
=> __run_hrtimer (c016b14a)^Ctrace-cmd: Received SIGINT
            Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
=> wake_up_process (c0142bd4)
=> hrtimer_wakeup (c016acad)
=> __run_hrtimer (c016b14a)
=> hrtimer_interrupt (c016b4e0)
=> smp_apic_timer_interrupt (c058fae7)
=> apic_timer_interrupt (c0103df1)
=> __module_text_address (c017cdf0)
[...]
=> wake_up_process (c0142bd4)
=> hrtimer_wakeup (c016acad)
=> __run_hrtimer (c016b14a)^Ctrace-cmd: Received SIGINT
            Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
[...]


Note: i can't stop the cmd './trace-cmd report' after
'./trace-cmd record -e all -O stacktrace' but enter 'CTRC+C'.

If it is a bug here? Any comments?

-- 
Thanks
Harry Wei
