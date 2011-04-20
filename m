Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1DTJoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:44:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53994 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388Ab1DTJoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:44:37 -0400
Date: Wed, 20 Apr 2011 10:45:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Nizette <bn@niasdigital.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110420104507.69ebb8e8@lxorguk.ukuu.org.uk>
In-Reply-To: <D3BCC8A3-7570-49F2-838C-A2B1899B0519@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<D3BCC8A3-7570-49F2-838C-A2B1899B0519@niasdigital.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	gpio_get_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER);
> > 	gpio_set_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER_ELSE);
> 
> Yeah I'm all for that so long as the capability constants are defined by the gpio provider, eg <linux/gpio/mygpioexpander.h>.  There's no way gpiolib should be keeping a big ole list of every possible config option for every gpio provider.  Well, maybe gpiolib can know about the options (eg GPIO_BIAS) so long as it doesn't have to enumerate every possible value.

It needs to know about any that might become common across multiple
devices so that if multiple devices have the same feature set it works
but I agree entirely about any weird platform or device specific stuff.

Perhaps for that it just needs to define

GPIO_PRIVATE_PROP		0x8000	/* to FFFF */

and be done with it


For multiple properties that can be shared you can't really get away from
needing a common name or number space. The good thing is that gpiolib
itself doesn't really care about that. To the core gpio code it's just a
set of numbers that only drivers and users know about.

Alan
