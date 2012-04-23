Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab2DWPpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:45:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54579 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2DWPpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120423074856.GU20478@pengutronix.de>
References: <CAMXH7KFYA24sPUcwgKfwVLNPA0jWQ-QG02y+SfPNnAqdiv0+gg@mail.gmail.com>
 <CAMXH7KGgSmvfqUTC1bufBz0QXbt01dHsPo1cbRA9jLj9mGmfjg@mail.gmail.com>
 <20120419064308.GH3852@pengutronix.de> <20120420020816.GH22219@S2101-09.ap.freescale.net>
 <CAMXH7KE2RtdNy3G61guZb2uWy3rn267Z3eEVEgN5e==tHHsiuA@mail.gmail.com>
 <20120423051813.GM26306@S2101-09.ap.freescale.net> <20120423062739.GX3852@pengutronix.de>
 <20120423065259.GR26306@S2101-09.ap.freescale.net> <20120423065623.GA3852@pengutronix.de>
 <20120423071013.GS26306@S2101-09.ap.freescale.net> <20120423074856.GU20478@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Mon, 23 Apr 2012 10:45:02 -0500
Message-ID: <CAMXH7KH1pwh7hJ=T30zxcWcx19wjXvr6Ff4OLy7fzqY5p79Fwg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org,
        patches@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Let me try last time.  What about having a late_initcall hook in
>> machine_desc?
>
> Also fine with me.
>

Shall I add Shawn's patch to my imx cpuidle patchset or should the
arch/arm/kernel/setup.c and arch.h changes be submitted separately?
If separately, Shawn, did you want to submit this patch or should I?

Thanks,
Rob

>>
>> Regards,
>> Shawn
>>
>> 8<---
>>
>> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
>> index d7692ca..0b1c94b 100644
>> --- a/arch/arm/include/asm/mach/arch.h
>> +++ b/arch/arm/include/asm/mach/arch.h
>> @@ -43,6 +43,7 @@ struct machine_desc {
>>         void                    (*init_irq)(void);
>>         struct sys_timer        *timer;         /* system tick timer    */
>>         void                    (*init_machine)(void);
>> +       void                    (*init_late)(void);
>>  #ifdef CONFIG_MULTI_IRQ_HANDLER
>>         void                    (*handle_irq)(struct pt_regs *);
>>  #endif
>> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> index ebfac78..549f036 100644
>> --- a/arch/arm/kernel/setup.c
>> +++ b/arch/arm/kernel/setup.c
>> @@ -800,6 +800,14 @@ static int __init customize_machine(void)
>>  }
>>  arch_initcall(customize_machine);
>>
>> +static int __init init_machine_late(void)
>> +{
>> +       if (machine_desc->init_late)
>> +               machine_desc->init_late();
>> +       return 0;
>> +}
>> +late_initcall(init_machine_late);
>> +
>>  #ifdef CONFIG_KEXEC
>>  static inline unsigned long long get_total_mem(void)
>>  {
>> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
>> index da6c1d9..0e3640f 100644
>> --- a/arch/arm/mach-imx/mach-imx6q.c
>> +++ b/arch/arm/mach-imx/mach-imx6q.c
>> @@ -142,6 +142,7 @@ DT_MACHINE_START(IMX6Q, "Freescale i.MX6 Quad (Device Tree)")
>>         .handle_irq     = imx6q_handle_irq,
>>         .timer          = &imx6q_timer,
>>         .init_machine   = imx6q_init_machine,
>> +       .init_late      = imx6q_init_late,
>>         .dt_compat      = imx6q_dt_compat,
>>         .restart        = imx6q_restart,
>>  MACHINE_END
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
