Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1HJM0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:26:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41386 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1HJMZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:25:59 -0400
From: "Pedanekar, Hemant" <hemantp@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 17:55:41 +0530
Subject: RE: [PATCH] omap: timer: Set dmtimer used as clocksource in
 autoreload mode
Thread-Topic: [PATCH] omap: timer: Set dmtimer used as clocksource in
 autoreload mode
Thread-Index: AcxXU9dt+Tj7Q8i5S72NBP+LSdgeXAABJFkg
Message-ID: <2A3DCF3DA181AD40BDE86A3150B27B6B03ABBBFD56@dbde02.ent.ti.com>
References: <1312948323-22823-1-git-send-email-hemantp@ti.com>
 <20110810115122.GH1939@atomide.com>
In-Reply-To: <20110810115122.GH1939@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren wrote on Wednesday, August 10, 2011 5:21 PM:

> * Hemant Pedanekar <hemantp@ti.com> [110809 20:46]:
>> If CONFIG_OMAP_32K_TIMER is not selected and dmtimer is used as
>> clocksource, the timer stops counting once overflow occurs as it was not
>> set in autoreload mode. This results into timekeeping failure: for
>> example, 'sleep 1' at the shell after the timer counter overflow would
>> hang. 
>> 
>> This patch sets up autoreload when starting the clocksource timer which
>> fixes the above issue. 
>> 
>> Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
>> ---
>>  arch/arm/mach-omap2/timer.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
>> index e964072..796b935 100644 --- a/arch/arm/mach-omap2/timer.c
>> +++ b/arch/arm/mach-omap2/timer.c
>> @@ -293,7 +293,7 @@ static void __init
> omap2_gp_clocksource_init(int gptimer_id,
>>  	pr_info("OMAP clocksource: GPTIMER%d at %lu Hz\n",  		gptimer_id,
>> clksrc.rate); 
>> 
>> -	__omap_dm_timer_load_start(clksrc.io_base, OMAP_TIMER_CTRL_ST, 0, 1);
>> +	omap_dm_timer_set_load_start(&clksrc, 1, 0);
>>  	init_sched_clock(&cd, dmtimer_update_sched_clock, 32, clksrc.rate);
>> 
>>  	if (clocksource_register_hz(&clocksource_gpt, clksrc.rate))
> 
> You should be able to just set the autoreload mode by changing to use
> OMAP_TIMER_CTRL_POSTED | OMAP_TIMER_CTRL_AR in the
> __omap_dm_timer_load_start
> above.
> 
> This avoids calling something that might be a loadable module eventually.
> 
> Regards,
> 
> Tony

Yes, that would be better - I didn't think about loadable module option.

Thanks.
   Hemant