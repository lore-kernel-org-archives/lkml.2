Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2I1Nby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:31:54 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54899 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757996Ab2I1Nbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120928125929.GM31006@arwen.pp.htv.fi>
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
	<1348836795-4783-5-git-send-email-kishon@ti.com>
	<20120928125929.GM31006@arwen.pp.htv.fi>
Date: Fri, 28 Sep 2012 19:01:48 +0530
Message-ID: <CAAe_U6+invzzr12x7Shb-uBZfW1Tv3MpR3s0tE8ZUauH6wF-tQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] usb: dwc3-omap: Add an API to write to dwc mailbox
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 28, 2012 at 6:29 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Sep 28, 2012 at 06:23:13PM +0530, Kishon Vijay Abraham I wrote:
>> Add an API in the omap glue layer to write to the mailbox register which
>> can be used by comparator driver(twl). To pass the detection of the attached
>> device (signified by VBUS, ID) to the dwc3 core, dwc3 core has to write
>> to the mailbox regiter.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/usb/dwc3/dwc3-omap.c  |   59 +++++++++++++++++++++++++++++++++++++++++
>>  include/linux/usb/dwc3-omap.h |   30 +++++++++++++++++++++
>>  2 files changed, 89 insertions(+)
>>  create mode 100644 include/linux/usb/dwc3-omap.h
>>
>> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
>> index a1704c6..7ae4d73 100644
>> --- a/drivers/usb/dwc3/dwc3-omap.c
>> +++ b/drivers/usb/dwc3/dwc3-omap.c
>> @@ -43,6 +43,7 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/platform_data/dwc3-omap.h>
>> +#include <linux/usb/dwc3-omap.h>
>>  #include <linux/pm_runtime.h>
>>  #include <linux/dma-mapping.h>
>>  #include <linux/ioport.h>
>> @@ -126,6 +127,8 @@ struct dwc3_omap {
>>       u32                     dma_status:1;
>>  };
>>
>> +struct dwc3_omap             *_omap;
>> +
>>  static inline u32 dwc3_omap_readl(void __iomem *base, u32 offset)
>>  {
>>       return readl(base + offset);
>> @@ -136,6 +139,56 @@ static inline void dwc3_omap_writel(void __iomem *base, u32 offset, u32 value)
>>       writel(value, base + offset);
>>  }
>>
>> +void omap_dwc3_mailbox(enum omap_dwc3_vbus_id_status status)
>
> all other functions are "dwc3_omap_", let's keep it consistent.

Sure.

Thanks
Kishon
