Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2CSAzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:55:48 -0400
Received: from imr3.ericy.com ([198.24.6.13]:36567 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab2CSAzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:55:47 -0400
Date: Sun, 18 Mar 2012 17:54:06 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Diego Elio =?iso-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
Message-ID: <20120319005406.GA28497@ericsson.com>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
 <20120317123151.AAF9A3E0952@localhost>
 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
 <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 07:14:45PM -0400, Linus Walleij wrote:
> On Sat, Mar 17, 2012 at 7:53 PM, Diego Elio Pettenò
> <flameeyes@flameeyes.eu> wrote:
> 
> > Another reason to have a MFD driver would be to allow tweaking the few
> > more knobs that (at least IT8728F) expose, such as the ability to switch
> > a few pre-defined inputs and outputs to GPIO instead, and so on...
> 
> Hm that sounds an awful lot like pin multiplexing. Is that the case?
> 
Depending on the chip configuration, a physical pin may be a GPIO pin, or a UART pin,
or a fan control pin, or a FD pin, or something else. This does not apply to all pins,
but to many of the GPIO pins.

On IT8721F (which is supposedly mostly compatible to IT8728F), only four of the 87 GPIO pins
are GPIO-only (unless I miscounted ;). All others have at least two different functions.

Not sure if it is a good idea to re-configure any of those pins. I would assume
there is a reason if a given set of pins is configured as UART, for example.

Guenter
