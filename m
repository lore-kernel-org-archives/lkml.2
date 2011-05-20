Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299Ab1ETDnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:43:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65324 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab1ETDns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oEZE1ef7TaTZzAWxO3saz8QSlv8xPRKUmqRp8nvs/JbUTijjCbiF8Qfkn1Ff9intR6
         0nKZ6U5ufEntpPLSXH7nMBBSFDnw7CVG8KlIUVNVp76U4PZcPOMxSW32NnFHtZ8OvYFB
         /+wWkm/d1YLlNPPdo+1Y1yWRWVVBEDMTZ1ag4=
MIME-Version: 1.0
In-Reply-To: <20110520031818.GB27251@S2100-06.ap.freescale.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<20110519085638.GA26816@S2100-06.ap.freescale.net>
	<BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
	<20110519135631.GB26816@S2100-06.ap.freescale.net>
	<20110519191156.GE2429@pengutronix.de>
	<alpine.LFD.2.00.1105191527440.14430@xanadu.home>
	<20110520031818.GB27251@S2100-06.ap.freescale.net>
Date: Fri, 20 May 2011 12:43:46 +0900
X-Google-Sender-Auth: n29nHsrYZhDvQKPeXdXFmty_Qw8
Message-ID: <BANLkTikonewi-fxCxoxx=ARsTs-CPvfoTg@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Kyungmin Park <kmpark@infradead.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:18 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Thu, May 19, 2011 at 03:30:36PM -0400, Nicolas Pitre wrote:
>> On Thu, 19 May 2011, Sascha Hauer wrote:
>>
>> > On Thu, May 19, 2011 at 09:56:32PM +0800, Shawn Guo wrote:
>> > > On Thu, May 19, 2011 at 02:21:27PM +0200, Linus Walleij wrote:
>> > > > On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>> > > >
>> > > > > I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
>> > > > > driver/gpio, and I see the possibility to go a different approach
>> > > > > from U300 one posted here.
>> > > >
>> > > > I've tried to figure out what relation the mail has to the U300 driver
>> > > > but cannot find any, more than that it's moving a driver... Please
>> > > > start a new mail thread.
>> > > >
>> > > I will post mxs-gpio driver once I get it done.  Then please review
>> > > the code and see the difference between mxs-gpio and u300-gpio,
>> > > though these hardwares have something in common.
>> >
>> > I'm pretty sure they have something in common and even more that *all*
>> > gpio drivers have something in common. I wonder if it really makes sense
>> > to move the gpio driver to drivers/gpio without creating a common
>> > mmio_gpio_chip beforehand. This can't be very hard.
>>
>> I do think that performing the move first will make a subsequent
>> conversion easier.  And since a move is a no-op from a functional point
>> of view, it is the safest thing to do first.
>>
> That's also what I heard on UDS week.  Move stuff into driver/gpio
> first, then try to find the pattern in those drivers and come up with
> some framework.

I agree, I reviewed the mmio_gpio_chip, but it's too simple to cover
current implementation.
So first move to the drivers/gpio and make more common mmio_gpio
instead of basic.

BTW, how do you think the GPIO interrupt routine. If it uses the
drivers/gpio drivers, it also cover the gpio interrupt codes at
drivers/gpio? or separate it?

Thank you,
Kyungmin Park
