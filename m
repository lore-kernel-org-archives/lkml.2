Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab0ILFdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:33:11 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:57873 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab0ILFdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:33:09 -0400
Message-ID: <4C8C6611.20206@orcon.net.nz>
Date: Sun, 12 Sep 2010 17:33:05 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, dengcheng.zhu@gmail.com, yanmin_zhang@linux.intel.com,
        gorcunov@gmail.com, fweisbec@gmail.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        will.deacon@arm.com, lethal@linux-sh.org, davem@davemloft.net,
        mingo@elte.hu, linux-alpha@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Rework the PMU methods
References: <new-submission>	 <tip-a4eaf7f14675cb512d69f0c928055e73d0c6d252@git.kernel.org>	 <4C8B3AD3.5050309@orcon.net.nz> <1284198035.2251.29.camel@laptop>
In-Reply-To: <1284198035.2251.29.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Sun, 12 Sep 2010 17:33:06 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Sep 12 17:33:07 2010
X-DSPAM-Confidence: 0.7618
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/10 21:40, Peter Zijlstra wrote:
> On Sat, 2010-09-11 at 20:16 +1200, Michael Cree wrote:
>> On 10/09/10 07:50, tip-bot for Peter Zijlstra wrote:
>>> Commit-ID:  a4eaf7f14675cb512d69f0c928055e73d0c6d252
>>> Gitweb:     http://git.kernel.org/tip/a4eaf7f14675cb512d69f0c928055e73d0c6d252
>>> Author:     Peter Zijlstra<a.p.zijlstra@chello.nl>
>>> AuthorDate: Wed, 16 Jun 2010 14:37:10 +0200
>>> Committer:  Ingo Molnar<mingo@elte.hu>
>>> CommitDate: Thu, 9 Sep 2010 20:46:30 +0200
>>>
>>> perf: Rework the PMU methods
>>>
>>> Replace pmu::{enable,disable,start,stop,unthrottle} with
>>> pmu::{add,del,start,stop}, all of which take a flags argument.
>>
>> Regarding the new function alpha_pmu_stop() in
>> arch/alpha/kernel/perf_event.c:
>>

> Could you provide a patch that makes ALPHA work again, or would you like
> me to take another stab at it?

Yes, done.  I also took the liberty to fix an undefined variable and 
multiple defined variable errors that were exposed by compilation.  Will 
reply to this with the patch.

I've also tested it on a UP alpha.  It worked well for a little while 
but after running 'perf top' for a number of seconds I got the following 
warning:

[  287.952977] WARNING: at arch/alpha/kernel/perf_event.c:546 
alpha_pmu_start+0xd0/0x120()
[  287.952977] Modules linked in: radeon ttm drm_kms_helper hwmon 
cfbcopyarea cfbimgblt cfbfillrect parport_pc parport nfsd exportfs nfs 
lockd sunrpc ipv6 loop snd_hda_codec_atihdmi snd_hda_intel snd_hda_codec 
snd_pcm snd_seq snd_timer snd_seq_device ftdi_sio sg usbserial sr_mod 
snd cdrom r8169 ohci1394 soundcore ohci_hcd ehci_hcd ieee1394 mii 
snd_page_alloc ata_generic pcspkr tulip evdev usbcore pata_cypress
[  287.952977] fffffc000078fb80 fffffc00007961c8 fffffc000031dbb0 
fffffc002780f400
[  287.952977]        0000000000000000 0000000000000400 00000000000ee6b3 
0000000000000000
[  287.952977]        fffffc000036cf28 fffffc002780f400 fffffc003f006240 
fffffc003f343538
[  287.952977]        fffffc000036d124 0000000000000001 fffffc003f006200 
0000000000000000
[  287.952977]        fffffc003f0062c8 0000000000000000 fffffc002780f410 
fffffc003f0062c8
[  287.952977]        fffffc000034d118 fffffc003f0062c8 fffffc0000795b28 
fffffc0000795b40
[  287.952977] Trace:
[  287.952977] [<fffffc000031dbb0>] alpha_pmu_start+0xd0/0x120
[  287.952977] [<fffffc000036cf28>] perf_ctx_adjust_freq+0x138/0x150
[  287.952977] [<fffffc000036d124>] perf_event_context_tick+0x1e4/0x210
[  287.952977] [<fffffc000034d118>] hrtimer_run_queues+0x1b8/0x2f0
[  287.952977] [<fffffc0000338a48>] run_local_timers+0x18/0x40
[  287.952977] [<fffffc0000338aac>] update_process_times+0x3c/0xb0
[  287.952977] [<fffffc000031895c>] timer_interrupt+0x9c/0x100
[  287.952977] [<fffffc0000361450>] handle_IRQ_event+0x70/0x1a0
[  287.952977] [<fffffc0000361648>] __do_IRQ+0xc8/0x160
[  287.952977] [<fffffc0000315374>] handle_irq+0x54/0xb0
[  287.952977] [<fffffc0000315b04>] do_entInt+0xc4/0x1e0
[  287.952977] [<fffffc0000310c40>] ret_from_sys_call+0x0/0x10
[  287.952977] [<fffffc00003ab414>] file_free_rcu+0x54/0x70
[  287.952977] [<fffffc00003bd0ec>] estimate_accuracy+0xdc/0x120
[  287.952977] [<fffffc0000313108>] cpu_idle+0x48/0x60
[  287.952977] [<fffffc0000367e90>] perf_event_task_sched_in+0x0/0x60
[  287.952977] [<fffffc00003130f0>] cpu_idle+0x30/0x60
[  287.952977] [<fffffc00006338d0>] rest_init+0xb0/0xd0
[  287.952977] [<fffffc000031001c>] _stext+0x1c/0x20
[  287.952977]
[  287.952977] ---[ end trace 6f10adce9e4129fa ]---

which is from the line in alpha_pmu_start() that checks that 
PERF_HES_STOPPED is set.

I see that the backtrace is from the Alpha timer_interrupt() code which 
goes something like this:

[do some stuff updating timer deltas then...]

#ifndef CONFIG_SMP
         while (nticks--)
                 update_process_times(user_mode(get_irq_regs()));
#endif

         if (test_perf_event_pending()) {
                 clear_perf_event_pending();
                 perf_event_do_pending();
         }

         return IRQ_HANDLED;
}


When I added the code for handle pending events to the timer interrupt I 
hadn't realised that update_process_times() could call back into the 
perf code.  I'm speculating here, but could it be that there is pending 
work to stop the HW counter, but the call to re-start it is beating the 
call to stop it?

Cheers
Michael.
