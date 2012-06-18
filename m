Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2FRMLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:11:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55117 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2FRMLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:11:03 -0400
Message-ID: <4FDF1ACC.2040208@monstr.eu>
Date: Mon, 18 Jun 2012 14:10:52 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, John.Linn@xilinx.com, arnd@arndb.de
Subject: Re: [PATCH] arm: zynq: Support GIC OF initialization
References: <1340017873-18170-1-git-send-email-monstr@monstr.eu> <4FDF19CF.8010303@gmail.com>
In-Reply-To: <4FDF19CF.8010303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 02:06 PM, Rob Herring wrote:
> On 06/18/2012 06:11 AM, Michal Simek wrote:
>> Zynq is OF driven platfrom which requires OF initialization.
>>
>> Signed-off-by: Michal Simek<monstr@monstr.eu>
>> ---
>>   arch/arm/mach-zynq/common.c |    7 ++++++-
>>   1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
>> index 17d68d6..7941544 100644
>> --- a/arch/arm/mach-zynq/common.c
>> +++ b/arch/arm/mach-zynq/common.c
>> @@ -56,12 +56,17 @@ static void __init xilinx_init_machine(void)
>>   	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
>>   }
>>
>> +static const struct of_device_id zynq_dt_irq_match[] __initconst = {
>> +	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
>> +	{ }
>> +};
>> +
>>   /**
>>    * xilinx_irq_init() - Interrupt controller initialization for the GIC.
>>    */
>>   static void __init xilinx_irq_init(void)
>>   {
>> -	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
>
> And delete the corresponding defines?

Agree, Will create v2.

BTW: Who is responsible for zynq? I think John Linn and who is maintainer I should ask for pulling.

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
