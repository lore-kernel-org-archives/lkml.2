Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1DTMWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:22:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59566 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754798Ab1DTMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:22:14 -0400
Date: Wed, 20 Apr 2011 13:22:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110420132246.53b339ae@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTimZLBG++w5b6D4EtNYPNP6H=hH+uA@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<BANLkTimZLBG++w5b6D4EtNYPNP6H=hH+uA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 14:19:04 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> 2011/4/18 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> 
> > And for a lot of this stuff that the gpio layer really doesn't want
> > internal knowledge of other chunks of the kernel have used models like
> > 'get_property/set_property' (eg battery, video4linux etc) so that the mid
> > layer can plumb in a conversation between the handle owner and the driver
> > without getting involved in the conversation.
> 
> I will implement that when I get to consolidare the
> plat-nomadik/gpio.c driver. It has custom sleep modes and
> stuff noone will be interested in duplicating.
> 
> I was thinking of something along the lines of:
> 
> int gpio_set_custom(unsigned gpio, unsigned long data);
> int gpio_get_custom(unsigned gpio, unsigned long *data);
> 
> So like an ioctl() it can pass in/out arbitrary data by
> casting to an unsigned long, handling enums, pointers
> to structs and the like.

Making the data ulong is smarter definitely, although you still need the
property number separate so everyone knows where to look for it with
shared operations (just like with ioctl)



