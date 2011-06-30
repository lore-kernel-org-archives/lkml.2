Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1F3IkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:40:21 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54350 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1F3IkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:40:17 -0400
X-AuditID: b753bd60-a467eba0000050a4-5b-4e0c366ec3d7
X-AuditID: b753bd60-a467eba0000050a4-5b-4e0c366ec3d7
Message-ID: <4E0C366C.8040408@hitachi.com>
Date: Thu, 30 Jun 2011 17:40:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        John Stultz <john.stultz@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [patch 1/5] i8253: Create common clockevent implementation
References: <20110609130509.346588418@linutronix.de>	<20110609130621.921710458@linutronix.de> <BANLkTinwpK=TFFexbeBeqXz-s=ouBK9gEg@mail.gmail.com>
In-Reply-To: <BANLkTinwpK=TFFexbeBeqXz-s=ouBK9gEg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/26 5:03), Stijn Devriendt wrote:
>> +/*
>> + * Initialize the conversion factor and the min/max deltas of the clock event
>> + * structure and register the clock event source with the framework.
>> + */
>> +void __init clockevent_i8253_init(bool oneshot)
>> +{
>> +       if (oneshot)
>> +               i8253_clockevent.features |= CLOCK_EVT_FEAT_ONESHOT;
>> +       /*
>> +        * Start pit with the boot cpu mask. x86 might make it global
>> +        * when it is used as broadcast device later.
>> +        */
>> +       i8253_clockevent.cpumask = cpumask_of(smp_processor_id());
>> +
>> +       clockevents_config_and_register(&i8253_clockevent, PIT_TICK_RATE,
>> +                                       0xF, 0x7FFF);
>> +}
>> +#endif
>>
> Both this function and the i8253_clockevent declaration seem to be missing
> from include/linux/i8253.h causing compile failures for at least x86.
> 
> I was just trying to compile tip of
> git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

I've met same problem on latest tip tree.

> Should be fixed by applying the following patch.

We still need to expose clocksource_i8253_init() too
for CONFIG_X86_64=n.
So, could you update your patch (and send it as a patch mail)?

Thank you,

> 
> commit 0c24072a8d580acd5b4fc57009b72b217c0f23d9
> Author: Stijn Devriendt <HIGHGuY@gmail.com>
> Date:   Sat Jun 25 22:04:53 2011 +0200
> 
>     Fix missing declarations of i8253.
> 
>     Signed-off-by: Stijn Devriendt <HIGHGuY@gmail.com>
> 
> diff --git a/include/linux/i8253.h b/include/linux/i8253.h
> index 0770fc5..e6c032f 100644
> --- a/include/linux/i8253.h
> +++ b/include/linux/i8253.h
> @@ -22,6 +22,10 @@
> 
>  extern raw_spinlock_t i8253_lock;
> 
> +extern struct clock_event_device i8253_clockevent;
> +
>  extern void setup_pit_timer(void);
> 
> +extern void clockevent_i8253_init(bool oneshot);
> +
>  #endif /* __LINUX_I8253_H */


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
