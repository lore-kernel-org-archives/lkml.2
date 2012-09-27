Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2I0IIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:08:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43087 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2I0IIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120927074912.GK12592@arwen.pp.htv.fi>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<20120927074912.GK12592@arwen.pp.htv.fi>
Date: Thu, 27 Sep 2012 11:08:12 +0300
Message-ID: <CAHp75VdEyQP_kDeQgEanyfewQghvsAntLHKDNZGjte6Osc1kcw@mail.gmail.com>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:49 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Sep 27, 2012 at 10:31:59AM +0300, Andy Shevchenko wrote:
>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>
>> This is the PCI part of the DesignWare DMAC driver. The controller is usually
>> used in the Intel hardware such as Medfield.


>> --- /dev/null
>> +++ b/drivers/dma/dw_dmac_pci.c
>> @@ -0,0 +1,126 @@
>> +/*
>> + * PCI driver for the Synopsys DesignWare DMA Controller
>> + *
>> + * Copyright (C) 2012 Intel Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/dw_dmac.h>
>> +
>> +static struct dw_dma_platform_data pdata = {
>
> "pdata" looks like it wants a prefix.
Okay.

>> +     .is_private = 1,
>> +     .chan_allocation_order = CHAN_ALLOCATION_ASCENDING,
>> +     .chan_priority = CHAN_PRIORITY_ASCENDING,
>> +};
>
> This is the same for all of the PCI IDs listed below, looks like it's
> best to just add it as platform_data of the dwc_dmac device directly,
> rather than passing a pointer to this via driver->data.
It potentially could be altered. I prefer to leave it as structure in
the pci driver.

>> +     static int instance;
> this could be a IDA instead.
Will look at it, thanks.

-- 
With Best Regards,
Andy Shevchenko
