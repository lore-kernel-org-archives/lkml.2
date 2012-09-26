Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2IZRzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:55:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33668 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab2IZRzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=nnUxJ4bvro_Rc95jRk7SR_yzxwZhNXeL4w5xDzsDj3nQ@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nnUxJ4bvro_Rc95jRk7SR_yzxwZhNXeL4w5xDzsDj3nQ@mail.gmail.com>
Date: Wed, 26 Sep 2012 20:55:36 +0300
Message-ID: <CAHp75VcGQ9jCpGb2jhCEX4NsbUsR0aytwd1AMkt4GpTXYVPnwQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] dmaengine: dw_dmac: Add PCI part of the driver
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 5:33 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> Forgot earlier, please keep spear-devel in cc... They will be going to
> use dw_dmac driver :)
Oh, my bad. v3 will be Cc'ed there as well. Sorry.

> On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw_dmac_pci.c
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/dw_dmac.h>
>> +
>> +#define DRIVER(_is_private, _chan_order, _chan_pri)            \
>> +       ((kernel_ulong_t)&(struct dw_dma_platform_data) {       \
>> +               .is_private = (_is_private),                    \
>> +               .chan_allocation_order = (_chan_order),         \
>> +               .chan_priority = (_chan_pri),                   \
>
> I believe you don't need these braces around input variables on right side
> of "=". Even if there is something complex passed.
Hmm... Have no idea if anyone will use robust stuff as a parameter to
that macro. I could remove them.

>
> Did you try to align "\"? Sorry can't see it in gmail :(
I checked - I have tabular indentation, that's why you see them at
different columns. In vi they look pretty well formated.

[snip]

>> +       pd = platform_device_alloc("dw_dmac", instance);
>> +       if (!pd) {
>> +               dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
>> +               ret = -ENOMEM;
>> +               goto err0;
>> +       }
>
> Is this the correct approach? I doubt... We are creating a platform
> device from a
> pci driver... Don't know if it can lead to some issues within kernel.
>
> Lets call the specialist for his comments  :)
> @Arnd: Can you please help us here?
This approach is used among different drivers in kernel. As first
example that comes to my mind you could consider chipidea USB driver
(drivers/usb/chipidea).


-- 
With Best Regards,
Andy Shevchenko
