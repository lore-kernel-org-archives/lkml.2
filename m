Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0JRM5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:57:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33941 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0JRM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iblwCNcWebkyYhO3XixdbPaJJ//YW4LDnt99R4bz27A5qNk2gmzI7Y/sBIDv8yIRTm
         uoM8kqPYXj09AgLuxWDROahB8PHYYhaZKaFfO52guLv1apPh4qIxFhg4nGWZr0xf12Oe
         dcGvHrSg0IuhzLr9PU0593k9egenufi031I6w=
Date: Mon, 18 Oct 2010 20:58:04 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
Message-ID: <20101018125803.GA2497@darkstar>
References: <20101017085416.GA1758@darkstar>
 <4CBAC342.1010609@redhat.com>
 <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
 <4CBAE8E2.1060704@redhat.com>
 <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
 <4CBBF3C8.9070104@web.de>
 <4CBC1047.6010501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBC1047.6010501@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 11:15:51AM +0200, Avi Kivity wrote:
>  On 10/18/2010 09:14 AM, Jan Kiszka wrote:
> >Am 18.10.2010 06:43, Dave Young wrote:
> >>  On Sun, Oct 17, 2010 at 8:15 PM, Avi Kivity<avi@redhat.com>  wrote:
> >>>   On 10/17/2010 12:14 PM, Dave Young wrote:
> >>>>
> >>>>  On Sun, Oct 17, 2010 at 5:34 PM, Avi Kivity<avi@redhat.com>   wrote:
> >>>>>     On 10/17/2010 10:54 AM, Dave Young wrote:
> >>>>>>
> >>>>>>   linux guest can not startup normally, qemu keep rebooting.
> >>>>>>
> >>>>>>   host&     guest both use linux-2.6.36-rc8+ kernel
> >>>>>>
> >>>>>>   Add a dump_stack in x86.c around EXIT_SHUTDOWN code, I got:
> >>>>>>   [ 3924.503041] Pid: 1685, comm: qemu-system-x86 Not tainted
> >>>>>>  2.6.36-rc8+
> >>>>>>   #62
> >>>>>>   [ 3924.503045] Call Trace:
> >>>>>>   [ 3924.503055]  [<ffffffffa0176047>] handle_triple_fault+0x11/0x26
> >>>>>>   [kvm_intel]
> >>>>>>   [ 3924.503060]  [<ffffffffa01772d2>] vmx_handle_exit+0x3df/0x474
> >>>>>>   [kvm_intel]
> >>>>>>   [ 3924.503080]  [<ffffffffa021f203>]
> >>>>>>  kvm_arch_vcpu_ioctl_run+0x95f/0xc43
> >>>>>>   [kvm]
> >>>>>>   [ 3924.503087]  [<ffffffff81503e54>] ?
> >>>>>>  __mutex_unlock_slowpath+0x11c/0x131
> >>>>>>   [ 3924.503101]  [<ffffffffa021e1f9>] ? kvm_arch_vcpu_load+0x90/0xe6
> >>>>>>  [kvm]
> >>>>>>   [ 3924.503112]  [<ffffffffa0210faf>] kvm_vcpu_ioctl+0x109/0x54a [kvm]
> >>>>>>   [ 3924.503117]  [<ffffffff810bee76>] ?
> >>>>>>   fire_user_return_notifiers+0x2c/0x36
> >>>>>>   [ 3924.503122]  [<ffffffff8106be93>] ? trace_hardirqs_on+0xd/0xf
> >>>>>>   [ 3924.503127]  [<ffffffff81002789>] ? do_notify_resume+0x717/0x73d
> >>>>>>   [ 3924.503131]  [<ffffffff8103994e>] ? finish_task_switch+0x69/0xda
> >>>>>>   [ 3924.503135]  [<ffffffff8110628c>] do_vfs_ioctl+0x4c3/0x50d
> >>>>>>   [ 3924.503139]  [<ffffffff8110632b>] sys_ioctl+0x55/0x77
> >>>>>>   [ 3924.503142]  [<ffffffff81002c02>] system_call_fastpath+0x16/0x1b
> >>>>>>
> >>>>>>   Anyone can help on this?
> >>>>>
> >>>>>   Please provide a trace (trace-cmd record -e kvm) leading to the
> >>>>>  failure.
> >>>>>
> >>>>
> >>>>  Hi, please see:
> >>>>  http://userweb.kernel.org/~davey/tmp/trace.dat
> >>>>
> >>>
> >>>  Was this done with an old version of trace-cmd?  Please use the latest git.
> >>>   Make sure you have udis86 and udis86-devel installed when you build it.
> >>
> >>  Hi, the trace-cmd was build from git version, but without udis86.
> >>
> >>  I updated trace.dat on the same url, is it a correct one?
> >>
> >
> >IIUC, plugin_kvm is only involved in reporting, not recording, so udis86
> >shouldn't matter.
> >
> >I had a look out of curiosity (just managed to make my trace tools work
> >smoothly), and the data is properly parsed by kernelshark here. There is
> >a strange NMI storm going on right before the triple fault (on some MSR
> >write) hits the fan.
> >
> 
> It's secondary_startup_64 enabling efer.sce and efer.nx.
> 
> Dave, please post your /proc/cpuinfo.  Is your host running with NX
> disabled?

I see nx bit in /proc/cpuinfo, Actually I don't know how to disable it.

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz
stepping	: 13
cpu MHz		: 800.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
bogomips	: 3991.42
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz
stepping	: 13
cpu MHz		: 2001.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi flexpriority
bogomips	: 3991.36
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:
