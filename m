Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1AEK4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:56:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33500 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1AEK4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:56:09 -0500
MIME-Version: 1.0
X-Originating-IP: [81.245.174.26]
In-Reply-To: <4D23610C.1060009@ti.com>
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com>
	<1294136263-24020-3-git-send-email-j-pihet@ti.com>
	<4D23610C.1060009@ti.com>
Date: Wed, 5 Jan 2011 11:56:08 +0100
Message-ID: <AANLkTimHQ0jPjotGTS+V6bhuNBh_Vv_VHGKOBy1_63TK@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: add OMAP support for the new power events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Nishanth Menon <nm@ti.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, trenn@suse.de,
        linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, rjw@sisk.pl,
        Jean Pihet <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 7:03 PM, Nishanth Menon <nm@ti.com> wrote:
> jean.pihet@newoldbits.com had written, on 01/04/2011 04:17 AM, the
> following:
> [..]
>>
>> diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
>> index 0ec8a04..0ee0b0e 100644
>> --- a/arch/arm/mach-omap2/pm34xx.c
>> +++ b/arch/arm/mach-omap2/pm34xx.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/delay.h>
>>  #include <linux/slab.h>
>>  #include <linux/console.h>
>> +#include <trace/events/power.h>
>>  #include <plat/sram.h>
>>  #include <plat/clockdomain.h>
>> @@ -506,8 +507,14 @@ static void omap3_pm_idle(void)
>>        if (omap_irq_pending() || need_resched())
>>                goto out;
>>  +      trace_power_start(POWER_CSTATE, 1, smp_processor_id());
>> +       trace_cpu_idle(1, smp_processor_id());
>> +
>>        omap_sram_idle();
>>  +      trace_power_end(smp_processor_id());
>> +       trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
>
> Dumb question: it just tells me which C state was attempted - not if
> actually succeeded in hitting it rt? Does'nt this give us a false data?
Yes this tracks the idle requests only. The actual hit state might be
different depending on various factors: HW state, enabled clocks,
power domains dependencies etc.
Debugging the actual PM hit state requires other tools, which could
use the trace API. There is definitely more to come on that topic.

>
> [..]
>>
>> diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
>> index fc62fb5..7cbb09b 100644
>> --- a/arch/arm/plat-omap/clock.c
>> +++ b/arch/arm/plat-omap/clock.c
>
> (from an offline discussion on a related topic): Would it also be nice to
> hook on mach-omap2/clock.c points as well to hook on indirect changes?
> [..]
>
> --
> Regards,
> Nishanth Menon
>
