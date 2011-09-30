Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1I3PFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:05:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43763 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1I3PFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110930020754.GK12606@ponder.secretlab.ca>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
	<20110930020754.GK12606@ponder.secretlab.ca>
Date: Fri, 30 Sep 2011 17:05:20 +0200
Message-ID: <CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 4:07 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

> Comments below, some a bit nitpicky, but overall I think it looks
> good.  I haven't dug into it nearly deeply enough though.  :-(

Hopefully we can patch the remaining bugs as we go along  :-)

>> +/**
>> + * Looks up a pin control device matching a certain device name or
>> + * pure device pointer.
>
> May as well actually do kerneldoc formatting here on the comment
> blocks.

OK.

>> +struct pinctrl_dev *get_pctldev_from_dev(struct device *dev,
>> +                                      const char *devname)
>
> Nit: I'm not too fond of a single function doing both name and pointer
> lookup at the same time.  Presumably the caller would have one or the
> other and know what it needs to do.  I'd prefer to see one by-name
> function and one by-reference.  I'm not going to make a big deal about
> it though.

The caller currently does not know what it has or
what to do.

This is basically an interator function that is called on
a member tuple of device and device name to check
which one you have and return a matching controller
device for the key you do have.

>> +     /* Register device with sysfs */
>> +     pctldev->dev.parent = dev;
>> +     pctldev->dev.bus = &pinctrl_bus;
>
> I don't think there is an actual need for a pinctrl bus type.  There
> aren't any drivers that are going to be bound to these things which is
> the primary functionality that a bus type provides.  Am I missing
> something?

That is not the reason it's there actually, what we have
discussed on the mailing list is getting sysfs entries for the same
reason gpiolib registers a class: handle pin control from userspace,
we can already see that coming and I already have a use case
for it. (Modem SIM connector control from userspace daemon.)

So first it was registering a class, then Greg said classes are
deprecated and we should use a bus instead. So it is
registering a bus to get sysfs so we can get userspace
controls.

>> +out_err:
>> +     put_device(&pctldev->dev);
>> +     kfree(pctldev);
>
> Once a device is initialized, it cannot be kfree()'ed directly.  The
> .release method needs to do that.

OK. And I already had a proper .release() method doing
exactly that, so deleting this.

>> +/**
>> + * pin_free() - release a single muxed in pin so something else can be muxed in
>> + *   instead
>
> Nit: the summary line in kerneldoc should fit on one line.

OK.

Went over the code and fixed a few other sites too.

>> +int __init
>> +pinmux_register_mappings(struct pinmux_map const *maps, unsigned num_maps)
>
> Nit: keep line breaks in the parameter lists.  More grep friendly.

OK fixed it.

Yours,
Linus Walleij
