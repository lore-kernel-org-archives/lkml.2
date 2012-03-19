Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030789Ab2CSOBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:01:03 -0400
Received: from imr4.ericy.com ([198.24.6.9]:60940 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab2CSOBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:01:01 -0400
Date: Mon, 19 Mar 2012 06:56:36 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Diego Elio =?iso-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
Message-ID: <20120319135636.GA30456@ericsson.com>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
 <20120317123151.AAF9A3E0952@localhost>
 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
 <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
 <20120319005406.GA28497@ericsson.com>
 <CACRpkdbZJR7NObUQCkjCEu3KedS5bfD4TuMGakL_N7BxKNUJnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbZJR7NObUQCkjCEu3KedS5bfD4TuMGakL_N7BxKNUJnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 04:26:44AM -0400, Linus Walleij wrote:
> On Mon, Mar 19, 2012 at 1:54 AM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > On Sun, Mar 18, 2012 at 07:14:45PM -0400, Linus Walleij wrote:
> >> On Sat, Mar 17, 2012 at 7:53 PM, Diego Elio Pettenņ
> >> <flameeyes@flameeyes.eu> wrote:
> >>
> >> > Another reason to have a MFD driver would be to allow tweaking the few
> >> > more knobs that (at least IT8728F) expose, such as the ability to switch
> >> > a few pre-defined inputs and outputs to GPIO instead, and so on...
> >>
> >> Hm that sounds an awful lot like pin multiplexing. Is that the case?
> >>
> > Depending on the chip configuration, a physical pin may be a GPIO pin, or a UART pin,
> > or a fan control pin, or a FD pin, or something else. This does not apply to all pins,
> > but to many of the GPIO pins.
> 
> OK that is pinmuxing, if that is to be software-controlled the place to do
> it is in drivers/pinctrl. (Documentation/pinctrl.txt gives the backrgound.)
> 
> The rule is in that case to put the driver below drivers/pinctrl/* and also
> expose a gpiolib interface from that driver.
> 
> As we convert drivers to the new pinctrl interfaces we tend to move them
> from drivers/gpio to drivers/pinctrl. But no biggie, if pinctrl is added later,
> it can be moved by then. I'm mainly concerned with blocking any
> extra custom interfaces to the gpio drivers.
> 
Personally I would not dare touch those pins. If a pin is configured as UART pin
(or whatever), it is quite unlikely that it is exposed as GPIO pin. Worst case,
changing the configuration may result in broken hardware. Not sure what is supposed
to be gained by enabling the user to do that.

Guenter
