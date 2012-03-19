Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab2CSI05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:26:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54758 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab2CSI0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120319005406.GA28497@ericsson.com>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	<20120317123151.AAF9A3E0952@localhost>
	<1332010422.22775.76.camel@saladin.home.flameeyes.eu>
	<CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
	<20120319005406.GA28497@ericsson.com>
Date: Mon, 19 Mar 2012 09:26:44 +0100
Message-ID: <CACRpkdbZJR7NObUQCkjCEu3KedS5bfD4TuMGakL_N7BxKNUJnA@mail.gmail.com>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: =?ISO-8859-1?Q?Diego_Elio_Petten=F2?= <flameeyes@flameeyes.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 1:54 AM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Sun, Mar 18, 2012 at 07:14:45PM -0400, Linus Walleij wrote:
>> On Sat, Mar 17, 2012 at 7:53 PM, Diego Elio Pettenņ
>> <flameeyes@flameeyes.eu> wrote:
>>
>> > Another reason to have a MFD driver would be to allow tweaking the few
>> > more knobs that (at least IT8728F) expose, such as the ability to switch
>> > a few pre-defined inputs and outputs to GPIO instead, and so on...
>>
>> Hm that sounds an awful lot like pin multiplexing. Is that the case?
>>
> Depending on the chip configuration, a physical pin may be a GPIO pin, or a UART pin,
> or a fan control pin, or a FD pin, or something else. This does not apply to all pins,
> but to many of the GPIO pins.

OK that is pinmuxing, if that is to be software-controlled the place to do
it is in drivers/pinctrl. (Documentation/pinctrl.txt gives the backrgound.)

The rule is in that case to put the driver below drivers/pinctrl/* and also
expose a gpiolib interface from that driver.

As we convert drivers to the new pinctrl interfaces we tend to move them
from drivers/gpio to drivers/pinctrl. But no biggie, if pinctrl is added later,
it can be moved by then. I'm mainly concerned with blocking any
extra custom interfaces to the gpio drivers.

Yours,
Linus Walleij
