Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1JXOmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:42:54 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:47771 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab1JXOmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:42:53 -0400
Message-ID: <4EA5795F.7090101@atmel.com>
Date: Mon, 24 Oct 2011 16:42:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] AT91: dt: at91sam9g45 family and board device tree
 files
References: <1317636056-9537-1-git-send-email-nicolas.ferre@atmel.com> <4E8C54DC.6040700@gmail.com> <4E8EF6F4.4030905@atmel.com> <4E9D4FD5.8080802@atmel.com> <20111024143451.GA8708@ponder.secretlab.ca>
In-Reply-To: <20111024143451.GA8708@ponder.secretlab.ca>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 04:34 PM, Grant Likely :
> On Tue, Oct 18, 2011 at 12:07:17PM +0200, Nicolas Ferre wrote:
>> On 10/07/2011 02:56 PM, Nicolas Ferre :
>>> On 10/05/2011 03:00 PM, Rob Herring :
>>>> Nicolas,
>>>>
>>>> On 10/03/2011 05:00 AM, Nicolas Ferre wrote:
>>>>> Create a new device tree source file for Atmel at91sam9g45 SoC family.
>>>>> The Evaluation Kit at91sam9m10g45ek includes it.
>>>>> This first basic support will be populated as drivers and boards will be
>>>>> converted to device tree.
>>>>> Contains serial, dma and interrupt controllers.
>>>>>
>>>>> The generic board file still takes advantage of platform data for early serial
>>>>> init. As we need a storage media and the NAND flash driver is not converted to
>>>>> DT yet, we keep old initialization for it.
>>>>>
>>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> [..]
>>
>>>>> diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
>>>>> new file mode 100644
>>>>> index 0000000..7bcb9a9
>>>>> --- /dev/null
>>>>> +++ b/arch/arm/mach-at91/board-dt.c
>>>>> @@ -0,0 +1,122 @@
>>>>> +/*
>>>>> + *  Setup code for AT91SAM Evaluation Kits with Device Tree support
>>>>> + *
>>>>> + *  Covers: * AT91SAM9G45-EKES  board
>>>>> + *          * AT91SAM9M10-EKES  board
>>>>> + *          * AT91SAM9M10G45-EK board
>>>>> + *
>>>>> + *  Copyright (C) 2011 Atmel,
>>>>> + *                2011 Nicolas Ferre <nicolas.ferre@atmel.com>
>>>>> + *
>>>>> + * Licensed under GPLv2 or later.
>>>>> + */
>>>>> +
>>>>> +#include <linux/types.h>
>>>>> +#include <linux/init.h>
>>>>> +#include <linux/module.h>
>>>>> +#include <linux/irqdomain.h>
>>>>> +#include <linux/of_irq.h>
>>>>> +#include <linux/of_platform.h>
>>>>> +
>>>>> +#include <mach/hardware.h>
>>>>> +#include <mach/board.h>
>>>>> +#include <mach/gpio.h>
>>>>> +#include <mach/system_rev.h>
>>>>> +#include <mach/at91sam9_smc.h>
>>>>> +
>>>>> +#include <asm/setup.h>
>>>>> +#include <asm/irq.h>
>>>>> +#include <asm/mach/arch.h>
>>>>> +#include <asm/mach/map.h>
>>>>> +#include <asm/mach/irq.h>
>>>>> +
>>>>> +#include "sam9_smc.h"
>>>>> +#include "generic.h"
>>
>> As found by Jean-Christophe, it seems that some clock lookup data are missing here. Something like:
>>
>> +/*
>> + * Lookup table for attaching a specific name and platform_data pointer to
>> + * devices as they get created by of_platform_populate(). Ideally this table
>> + * would not exist, but the current clock implementation depends on some devices
>> + * having a specific name.
>> + /
>> +static const struct of_dev_auxdata at91_auxdata_lookup[] __initconst = {
>> + / at91sam9260/ at91sam9g20 /
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffff200, "atmel_usart.0", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffb0000, "atmel_usart.1", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffb4000, "atmel_usart.2", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffb8000, "atmel_usart.3", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffd0000, "atmel_usart.4", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffd4000, "atmel_usart.5", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfffd8000, "atmel_usart.6", NULL),
>> + / at91sam9g45*/
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xffffee00, "atmel_usart.0", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff8c000, "atmel_usart.1", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff90000, "atmel_usart.2", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff94000, "atmel_usart.3", NULL),
>> + OF_DEV_AUXDATA("atmel,at91sam9260-usart", 0xfff98000, "atmel_usart.4", NULL),
>> + { /* sentinel */ }
>> +};
>>
>> With a change here:
>>   of_platform_populate(NULL, of_default_bus_match_table, at91_auxdata_lookup, NULL);
>>
>> I know that it is a temporary usage of auxdata. Does it sound the right thing to do for the moment?
> 
> yes.

Grant,

It seems that Rob has had another idea. He advices me (on a Oct. 20th
email) that I should add some clock lookup entries.
That is what I did in a couple of patches that I have just sent some
minutes ago... I tend to like the clock lookup adding more as it prevent
the adding of big amount of code into the board-dt.c file.

What is the preferred option? Are you fine with patches that I have just
sent?

Thanks,

Best regards,
-- 
Nicolas Ferre
