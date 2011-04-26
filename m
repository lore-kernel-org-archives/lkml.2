Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1DZVdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:33:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60994 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab1DZVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MRUhEifzZbyuqpjTgb0IK7rXlm8qNGtLjCdncpl3Ev0ayFbs/soPN8Ret3tJsongFl
         POD0HWI2JRemO347z6MVjqWpKdYhJkllIXiI6JJ9F6Xlp2ywDV8UFitQf1JNgtKV75kj
         HCT36/uK6GZYEoojdrs/BEKUs9qOzTCg1ikI8=
Message-ID: <4DB73A34.3010203@gmail.com>
Date: Wed, 27 Apr 2011 01:33:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for config1/config2
References: <1303407662-15564-1-git-send-email-acme@infradead.org> <1303407662-15564-2-git-send-email-acme@infradead.org> <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu> <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu> <1303809958.20212.219.camel@twins> <alpine.DEB.2.00.1104261617320.32482@cl320.eecs.utk.edu> <4DB736CB.6040109@gmail.com> <20110426212513.GD20887@redhat.com>
In-Reply-To: <20110426212513.GD20887@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 01:25 AM, Don Zickus wrote:
> On Wed, Apr 27, 2011 at 01:19:07AM +0400, Cyrill Gorcunov wrote:
>>   Vince I've not read the whole thread so no idea what is all about, but if you
>> have some p4 machines and have some will to help -- mind to test the patch below,
>> it should fix nmi-watchdog and cycles conflict. It's utter raw RFC (and i know there
>> is a nit i should update) but still might be interesting to see the results.
>> Untested.
>> -- 
>> perf, x86: P4 PMU -- Introduce alternate events v3
> 
> Unfortunately it just panic'd for me when I ran
> 
> perf record grep -r don /
> 
> Thoughts?
> 
> Cheers,
> Don
> 
> redfish.lab.bos.redhat.com login: BUG: unable to handle kernel NULL
> pointer dereference at 0000000000000008
> IP: [<ffffffff8101ff60>] p4_pmu_schedule_events+0xb0/0x4c0
> PGD 2c603067 PUD 2d617067 PMD 0 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/system/cpu/online
> CPU 2 
> Modules linked in: autofs4 sunrpc ipv6 dm_mirror dm_region_hash dm_log
> uinput ppdev e1000 parport_pc parport sg dcdbas pcspkr snd_intel8x0
> snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm sn]
> 
> Pid: 1734, comm: grep Not tainted 2.6.39-rc3usb3-latest+ #339 Dell Inc.
> Precision WorkStation 470    /0P7996
> RIP: 0010:[<ffffffff8101ff60>]  [<ffffffff8101ff60>]
> p4_pmu_schedule_events+0xb0/0x4c0
> RSP: 0018:ffff88003fb03b18  EFLAGS: 00010016
> RAX: 000000000000003c RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88003c30de00 RSI: 0000000000000004 RDI: 000000000000000f
> RBP: ffff88003fb03bb8 R08: 0000000000000001 R09: 0000000000000001
> R10: 000000000000006d R11: ffff88003acb4ae8 R12: ffff88002d490c00
> R13: ffff88003fb03b78 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88003fb00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000008 CR3: 000000002d728000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process grep (pid: 1734, threadinfo ffff88002d648000, task
> ffff88003acb4240)
> Stack:
>  ffff880000000014 ffff88003acb4b10 b00002030803c000 0000000000000003
>  0000000200000001 ffff88003fb03bc8 0000000100000002 ffff88003fb03bcc
>  0000000181a24ee0 ffff88003fb0cd48 0000000000000008 0000000000000000
> Call Trace:
>  <IRQ> 
>  [<ffffffff8101b9e1>] ? x86_pmu_add+0xb1/0x170
>  [<ffffffff8101b8bf>] x86_pmu_commit_txn+0x5f/0xb0
>  [<ffffffff810ff0c4>] ? perf_event_update_userpage+0xa4/0xe0
>  [<ffffffff810ff020>] ? perf_output_end+0x60/0x60
>  [<ffffffff81100dca>] group_sched_in+0x8a/0x160
>  [<ffffffff8110100b>] ctx_sched_in+0x16b/0x1d0
>  [<ffffffff811017ce>] perf_event_task_tick+0x1de/0x260
>  [<ffffffff8104fc1e>] scheduler_tick+0xde/0x2b0
>  [<ffffffff81096e20>] ? tick_nohz_handler+0x100/0x100
> 

Ouch, I bet p4_config_get_bind returned NULL and here we are. Weird,
seems I've missed something. Don, I'll continue tomorrow, ok? (kinda
sleep already).

-- 
    Cyrill
