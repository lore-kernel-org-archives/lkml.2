Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1DQWC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 18:02:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54154 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751425Ab1DQWCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 18:02:25 -0400
Date: Sun, 17 Apr 2011 23:03:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110417230314.23350cbd@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTimwbsmQw0Dawz_+LpVf+wU60AbB0g@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<20110417224816.38ddffee@lxorguk.ukuu.org.uk>
	<BANLkTimwbsmQw0Dawz_+LpVf+wU60AbB0g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011 23:58:16 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> 2011/4/17 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> 
> >> + * enum gpio_drive - drive modes for GPIOs (output)
> >> + * @GPIO_DRIVE_PUSH_PULL: the GPIO will be driven actively high and low, this
> >> + *   is the most typical case and is typically achieved with two active
> >> + *   transistors on the output
> >> + * @GPIO_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain (open
> >> + *   collector) which means it is usually wired with other output ports
> >> + *   which are then pulled up with an external resistor
> >> + * @GPIO_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
> >> + *   (open emitter) which is the same as open drain mutatis mutandis but
> >> + *   pulled to ground
> >
> > How about "off". As I've pointed out at various times some devices have
> > GPIO pins that may or may not be connected depending upon what other chip
> > logic is doing.
> 
> Sure, why not.
> 
> > As I've also noted with various other previous suggestions for API
> > additions you also need an "unknown" state so that a device can implement
> > the methods but indicate for some pins the value is unknown due to
> > hardware or firmware limitations.
> 
> OK do you want an unknown biasing mode too, or is "floating" enough
> of a default to cover that?

I think I'd rather also have unknown for both the drive and the biasing.
It's a way of ensuring we get some kind of complete coverage even if not
perfect.

In the Intel case we also have 'alt status' stuff where the line has been
borrowed by firmware for example so we really genuinly haven't got a clue
what the state is right now.
