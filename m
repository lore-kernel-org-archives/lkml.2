Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1JRUoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 16:44:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45024 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1JRUoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 16:44:14 -0400
Message-ID: <4E9DE51A.7070900@gmail.com>
Date: Tue, 18 Oct 2011 15:44:10 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] AT91: dt: at91sam9g45 family and board device tree
 files
References: <1317636056-9537-1-git-send-email-nicolas.ferre@atmel.com> <4E8C54DC.6040700@gmail.com> <4E8EF6F4.4030905@atmel.com> <4E9D4FD5.8080802@atmel.com>
In-Reply-To: <4E9D4FD5.8080802@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

On 10/18/2011 05:07 AM, Nicolas Ferre wrote:
> On 10/07/2011 02:56 PM, Nicolas Ferre :
>> On 10/05/2011 03:00 PM, Rob Herring :
>>> Nicolas,
>>>
>>> On 10/03/2011 05:00 AM, Nicolas Ferre wrote:
>>>> Create a new device tree source file for Atmel at91sam9g45 SoC family.
>>>> The Evaluation Kit at91sam9m10g45ek includes it.
>>>> This first basic support will be populated as drivers and boards will be
>>>> converted to device tree.
>>>> Contains serial, dma and interrupt controllers.
>>>>
>>>> The generic board file still takes advantage of platform data for early serial
>>>> init. As we need a storage media and the NAND flash driver is not converted to
>>>> DT yet, we keep old initialization for it.
>>>>
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> [..]
> 
>>>> diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
>>>> new file mode 100644
>>>> index 0000000..7bcb9a9
>>>> --- /dev/null
>>>> +++ b/arch/arm/mach-at91/board-dt.c
>>>> @@ -0,0 +1,122 @@
>>>> +/*
>>>> + *  Setup code for AT91SAM Evaluation Kits with Device Tree support
>>>> + *
>>>> + *  Covers: * AT91SAM9G45-EKES  board
>>>> + *          * AT91SAM9M10-EKES  board
>>>> + *          * AT91SAM9M10G45-EK board
>>>> + *
>>>> + *  Copyright (C) 2011 Atmel,
>>>> + *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> + *
>>>> + * Licensed under GPLv2 or later.
>>>> + */
>>>> +
>>>> +#include <linux/types.h>
>>>> +#include <linux/init.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/irqdomain.h>
>>>> +#include <linux/of_irq.h>
>>>> +#include <linux/of_platform.h>
>>>> +
>>>> +#include <mach/hardware.h>
>>>> +#include <mach/board.h>
>>>> +#include <mach/gpio.h>
>>>> +#include <mach/system_rev.h>
>>>> +#include <mach/at91sam9_smc.h>
>>>> +
>>>> +#include <asm/setup.h>
>>>> +#include <asm/irq.h>
>>>> +#include <asm/mach/arch.h>
>>>> +#include <asm/mach/map.h>
>>>> +#include <asm/mach/irq.h>
>>>> +
>>>> +#include "sam9_smc.h"
>>>> +#include "generic.h"
> 
> As found by Jean-Christophe, it seems that some clock lookup data are missing here. Something like:
> 
> +/*
> + * Lookup table for attaching a specific name and platform_data pointer to
> + * devices as they get created by of_platform_populate(). Ideally this table
> + * would not exist, but the current clock implementation depends on some devices
> + * having a specific name.
> + /
> +static const struct of_dev_auxdata at91_auxdata_lookup[] __initconst = {
> + / at91sam9260/ at91sam9g20 /
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffff200, "atmel_usart.0", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffb0000, "atmel_usart.1", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffb4000, "atmel_usart.2", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffb8000, "atmel_usart.3", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffd0000, "atmel_usart.4", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffd4000, "atmel_usart.5", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffd8000, "atmel_usart.6", NULL),
> + / at91sam9g45*/
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xffffee00, "atmel_usart.0", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff8c000, "atmel_usart.1", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff90000, "atmel_usart.2", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff94000, "atmel_usart.3", NULL),
> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff98000, "atmel_usart.4", NULL),
> + { /* sentinel */ }
> +};
> 
> With a change here:
>   of_platform_populate(NULL, of_default_bus_match_table, at91_auxdata_lookup, NULL);
> 
> I know that it is a temporary usage of auxdata. Does it sound the right thing to do for the moment?
> 

If clk lookups are the only thing needed, can't you jusst add the
lookups for DT?

Rob
