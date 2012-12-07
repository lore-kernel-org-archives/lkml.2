Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab2LGKOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:14:43 -0500
Received: from smtp2.goneo.de ([212.90.139.82]:62476 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2LGKOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:14:41 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.897
From: Lars Poeschel <poeschel@lemonage.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH RFC] misc/at24: distinguish between eeprom and fram chips
Date: Fri, 7 Dec 2012 11:14:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
References: <201212041758.38600.poeschel@lemonage.de> <201212051043.07460.poeschel@lemonage.de> <20121205164153.GA5011@pengutronix.de>
In-Reply-To: <20121205164153.GA5011@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212071114.29034.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I wanted to use a fm24c04 i2c fram chip with linux. I grepped the
> > > > source and found nothing. I later found that my chip can be handled
> > > > by at24 eeprom driver. It creates a sysfs file called eeprom to
> > > > read from and write to the chip. Userspace has no chance to
> > > > distinguish if it is writing an eeprom or a fram chip.
> > > 
> > > Why should it?
> > 
> > Because writes are much faster and it doesn't have to take care on erase
> > cycles. It could use other write strategies on such devices and update
> > informations that have to survive power downs more often.
> 
> I agree. I think that a seperate attribute named e.g. 'page_size' would
> be more helpful than renaming the binary file to fram?

Yes, this is a much better solution! Adding a seperate sysfs file page_size 
and a file for the type of device which would read eeprom, fram, etc then.
If you also think this is the way to go, I would spent one of my next free 
timeslots to this.

> > > The method of accessing EEPROMs is used by way more chips than FRAMs.
> > > So, I'd prefer to have the text updated more generic like "EEPROMs and
> > > similar devices like RAMs, ROMs, etc...". Describing setting .flags in
> > > Kconfig is overkill.
> > 
> > A patch updating Kconfig is below.
> 
> Looks good from a glimpse, will apply it later.

Thank you!

Lars
