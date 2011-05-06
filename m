Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1EFOuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:50:32 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58321 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1EFOub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xAJ/pF7IhRr6PgIeTj3xck9WyRW9LG863ZWz7KM2W7mQTe4BV8qF9++8Wjsy3vFYVj
         J4keN6Bj19SrcKvpTWj1+ZTPbptJBccuwyhxuSb2ZjaL1UwtQPzyRoQoys9KlIt/iEbO
         eQ7JS0eUgg+4U4wInV9oW1xhPaLgcSa5mzsAo=
MIME-Version: 1.0
In-Reply-To: <201105061605.31625.arnd@arndb.de>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
Date: Fri, 6 May 2011 16:50:30 +0200
Message-ID: <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/6 Arnd Bergmann <arnd@arndb.de>:
> Hi Rafał,
>
> I haven't looked in detail, but since I'll be travelling for the next
> two weeks, here is a really quick review. Overall, the bus driver
> looks really nice, except for a few things that I guess should be
> easy to resolve.

Thanks for reviewing.


> On Thursday 05 May 2011, Rafał Miłecki wrote:
>> Cc: Greg KH <greg@kroah.com>
>> Cc: Michael Büsch <mb@bu3sch.de>
>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: George Kashperko <george@znau.edu.ua>
>> Cc: Arend van Spriel <arend@broadcom.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: Russell King <rmk@arm.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Andy Botting <andy@andybotting.com>
>> Cc: linuxdriverproject <devel@linuxdriverproject.org>
>> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> This really needs a changelog. You've probably written all of
> it before, just explain above the Cc what bcma is, where it's
> used, why you use a bus_type. This will be the place where
> people look when they want to find out what it is, so try
> to make a good description.

What do you mean by changelog? Is README unsufficient? It contains
almost everything you mentioned...


>> new file mode 100644
>> index 0000000..b52cd2b
>> --- /dev/null
>> +++ b/drivers/bcma/README
>> @@ -0,0 +1,18 @@
>> +Broadcom introduced new bus as replacement for older SSB. It is based on AMBA,
>> +however from programming point of view there is nothing AMBA specific we use.
>> +
>> +Standard AMBA drivers are platform specific, have hardcoded addresses and use
>> +AMBA standard fields like CID and PID.
>> +
>> +In case of Broadcom's cards every device consists of:
>> +1) Broadcom specific AMBA device. It is put on AMBA bus, but can not be treated
>> +   as standard AMBA device. Reading it's CID or PID can cause machine lockup.
>> +2) AMBA standard devices called ports or wrappers. They have CIDs (AMBA_CID)
>> +   and PIDs (0x103BB369), but we do not use that info for anything. One of that
>> +   devices is used for managing Broadcom specific core.
>> +
>> +Addresses of AMBA devices are not hardcoded in driver and have to be read from
>> +EPROM.
>> +
>> +In this situation we decided to introduce separated bus with devices identified
>> +by Broadcom specific fields, read from EPROM.
>
> This would be a good start for the changelog. You don't actually need the
> readme in the code directory, it's better to put the information somewhere
> in the Documentation/ directory.

I guess Documentation/ can be a good idea, but I'd like to make it
later if nobody really minds. It's no fun to post more and more
versions of patches, just to update some single description.


>> diff --git a/drivers/bcma/TODO b/drivers/bcma/TODO
>> new file mode 100644
>> index 0000000..45eadc9
>> --- /dev/null
>> +++ b/drivers/bcma/TODO
>> @@ -0,0 +1,3 @@
>> +- Interrupts
>> +- Defines for PCI core driver
>> +- Convert bcma_bus->cores into linked list
>
> The last item doesn't make sense to me. Since you are using the regular
> driver model, you can simply iterate over all child devices of any
> dev.

It's about optimization. Right now bcma_bus->cores is static array, we
probably never will use all entries.


>> +static void bcma_core_disable(struct bcma_device *core, u32 flags)
>> +{
>> +     if (bcma_aread32(core, BCMA_RESET_CTL) & BCMA_RESET_CTL_RESET)
>> +             return;
>> +
>> +     bcma_awrite32(core, BCMA_IOCTL, flags);
>> +     bcma_aread32(core, BCMA_IOCTL);
>> +     udelay(10);
>> +
>> +     bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
>> +     udelay(1);
>> +}
>> +
>> +int bcma_core_enable(struct bcma_device *core, u32 flags)
>> +{
>> +     bcma_core_disable(core, flags);
>> +
>> +     bcma_awrite32(core, BCMA_IOCTL, (BCMA_IOCTL_CLK | BCMA_IOCTL_FGC | flags));
>> +     bcma_aread32(core, BCMA_IOCTL);
>> +
>> +     bcma_awrite32(core, BCMA_RESET_CTL, 0);
>> +     udelay(1);
>> +
>> +     bcma_awrite32(core, BCMA_IOCTL, (BCMA_IOCTL_CLK | flags));
>> +     bcma_aread32(core, BCMA_IOCTL);
>> +     udelay(1);
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(bcma_core_enable);
>
> I don't know if we discussed this before. Normally, you should not need such
> udelay() calls, at least if you have the correct I/O barriers in place.

I believe we didn't.

We had to use such a delays in ssb to let devices react to the
changes. Did you maybe have a talk with hardware guys at Broadcom
about this? Are you sure this is not needed for BCMA?


>> +#include "bcma_private.h"
>> +#include <linux/bcma/bcma.h>
>> +
>> +MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
>> +MODULE_LICENSE("GPL");
>> +
>> +static int bcma_bus_match(struct device *dev, struct device_driver *drv);
>> +static int bcma_device_probe(struct device *dev);
>> +static int bcma_device_remove(struct device *dev);
>
> Try to reorder your functions so you don't need any forward declarations.

That's needed because I put bus-closely-related stuff at the
beginning. I did this for readability, I don't think it really hurts
anyone or is against coding style or sth.


>> +const char *bcma_device_name(u16 coreid)
>> +{
>> +     switch (coreid) {
>> +     case BCMA_CORE_OOB_ROUTER:
>> +             return "OOB Router";
>> +     case BCMA_CORE_INVALID:
>> +             return "Invalid";
>> +     case BCMA_CORE_CHIPCOMMON:
>> +             return "ChipCommon";
>> +     case BCMA_CORE_ILINE20:
>> +             return "ILine 20";
>
> It's better to make that a data structure than a switch() statement,
> both from readability and efficiency aspects.

Well, maybe. We call it only once, at init time. In any case we're
still waiting for Broadcom to clarify which cores are really used for
BCMA.


>> +
>> +/* 1) It is not allowed to put struct device statically in bcma_device
>> + * 2) We can not just use pointer to struct device because we use container_of
>> + * 3) We do not have pointer to struct bcma_device in struct device
>> + * Solution: use such a dummy wrapper
>> + */
>> +struct __bcma_dev_wrapper {
>> +     struct device dev;
>> +     struct bcma_device *core;
>> +};
>> +
>> +struct bcma_device {
>> +     struct bcma_bus *bus;
>> +     struct bcma_device_id id;
>> +
>> +     struct device *dev;
>> +
>> +     u8 core_index;
>> +
>> +     u32 addr;
>> +     u32 wrap;
>> +
>> +     void *drvdata;
>> +};
>
> Something went wrong here, maybe you misunderstood the API, or I
> misunderstood what you are trying to do. When you define your own bus
> type, the private device (struct bcma_device) should definitely contain
> a struct device as a member, and you allocate that structure dynamically
> when probing the bus. I don't see any reason for that wrapper.

Having "stuct device" in my "struct bcma_device" let me walk from
bcma_device to device. Not the opposite. In case of:
manuf_show
id_show
rev_show
class_show
I've to go this opposite way. I've "stuct device" but I need to get
corresponding "struct bcma_device".

-- 
Rafał
