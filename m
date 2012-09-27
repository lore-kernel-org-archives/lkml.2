Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab2I0Dx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:53:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41059 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2I0Dx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <201209261941.11944.arnd@arndb.de>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nnUxJ4bvro_Rc95jRk7SR_yzxwZhNXeL4w5xDzsDj3nQ@mail.gmail.com>
	<CAHp75VcGQ9jCpGb2jhCEX4NsbUsR0aytwd1AMkt4GpTXYVPnwQ@mail.gmail.com>
	<201209261941.11944.arnd@arndb.de>
Date: Thu, 27 Sep 2012 09:23:55 +0530
X-Google-Sender-Auth: 4jyN3486QpAkSL2jMikEp0yHyL0
Message-ID: <CAOh2x=kKYsvYKqpJ6EUpv_OL5f6OsvyS0Lq9yO2uouPPSXSgvw@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] dmaengine: dw_dmac: Add PCI part of the driver
From: viresh kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 1:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 26 September 2012, Andy Shevchenko wrote:
>> >> +#define DRIVER(_is_private, _chan_order, _chan_pri)            \
>> >> +       ((kernel_ulong_t)&(struct dw_dma_platform_data) {       \
>> >> +               .is_private = (_is_private),                    \
>> >> +               .chan_allocation_order = (_chan_order),         \
>> >> +               .chan_priority = (_chan_pri),                   \
>> >
>> > I believe you don't need these braces around input variables on right side
>> > of "=". Even if there is something complex passed.
>> Hmm... Have no idea if anyone will use robust stuff as a parameter to
>> that macro. I could remove them.
>
> IMHO It's better to leave them in as general practice in case of a macro.

I agree with the general practice followed, what i was saying is: Until unless
somebody is passing arguments which contain "=" OR ","... there can't be
anything wrong as they are on Right Hand Side of an equal statement.

Those practices were more common when we do something like:
param1 * param2.. Here if param1 or 2 contains + or - or *... we will get
a different meaning with and without ()... But for the above case, that can't
be true.

> However, I would prefer not having this macro at all and just open-code
> the contents. If you use traditional struct initializers, the amount of
> code is almost exactly the same.

Even this is good too.

>> >> +       pd = platform_device_alloc("dw_dmac", instance);
>> >> +       if (!pd) {
>> >> +               dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
>> >> +               ret = -ENOMEM;
>> >> +               goto err0;
>> >> +       }
>> >
>> > Is this the correct approach? I doubt... We are creating a platform
>> > device from a
>> > pci driver... Don't know if it can lead to some issues within kernel.
>> >
>> > Lets call the specialist for his comments  :)
>> > @Arnd: Can you please help us here?
>> This approach is used among different drivers in kernel. As first
>> example that comes to my mind you could consider chipidea USB driver
>> (drivers/usb/chipidea).
>
> Yes, this is fine for a PCI device with multiple logical devices. You could
> also use the MFD framework if that results in smaller code. For a driver
> that can be either a platform device or a pci device with no other sub-devices,
> I would however recommend having a common initialization function for stuff
> that can be called from either bus_type but with no extra level of indirection.

Ahh.. something new :)
I will still ask not to put it as an MFD, as it is not a MFD device at all...
I believe there is no common initialization part here, because PCI device in any
case would be calling probe of platform device. :)

Thanks Arnd...

--
viresh
