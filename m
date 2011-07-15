Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813Ab1GOFEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:04:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62389 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1GOFEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110715043922.GJ32716@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025327.GI2927@ponder.secretlab.ca> <20110715043922.GJ32716@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 14 Jul 2011 23:04:27 -0600
X-Google-Sender-Auth: ZZQnbN2BNCZRum1qqFeRDRyBsIg
Message-ID: <CACxGe6sjTTnB2_e2omp51bnc+4kshkhNRfqDPdB3fYQG=oiWmQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] regmap: Add SPI bus support
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 10:39 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 14, 2011 at 08:53:27PM -0600, Grant Likely wrote:
>> On Sat, Jul 09, 2011 at 01:50:43PM +0900, Mark Brown wrote:
>
>> >  obj-$(CONFIG_I2C) += regmap-i2c.o
>> > +obj-$(CONFIG_SPI) += regmap-spi.o
>
>> I would think this code should live with drivers/spi.c  And similar
>> for the i2c implementation.
>
> There was a bit about this in the cover mail - it's the interace
> stability issue again, the plan is to move them once we're more
> confident that the interface used will stay stable.

I've got no problem with churn in drivers/spi, and I'm fine to have
changes in drivers/spi merged via other trees if it means the code is
in the logical place.

>
>> > +{
>> > +   struct spi_device *spi = to_spi_device(dev);
>> > +   struct spi_message m;
>> > +   struct spi_transfer t[2];
>
>> > +   spi_message_init(&m);
>> > +
>> > +   memset(&t, 0, sizeof(t));
>
>> If you do:
>
>>       struct spi_transfer t[2] = { {.tx_buf = reg, .len = reg_len},
>>                                    {.tx_buf = val, .len = val_len}};
>
>> Then the memset() and t[0]/t[1] lines can all be culled.
>
> That does the init to zero?

You might want to double check, but I believe it gets implemented as a
memcpy of a static initializer.

>
>> > +   t[1].tx_buf = val;
>> > +   t[1].len = val_len;
>> > +   spi_message_add_tail(&t[0], &m);
>
>> t[0]?
>
> Yes, that's been fixed in git for a little while now.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
