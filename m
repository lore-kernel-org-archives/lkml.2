Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1DTOy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:54:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42752 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751875Ab1DTOy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:54:28 -0400
Date: Wed, 20 Apr 2011 15:55:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ben Nizette <bn@niasdigital.com>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110420155516.57d8d850@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=M3FxU6vv_aq1rLTmXQCGps=hC=w@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<D3BCC8A3-7570-49F2-838C-A2B1899B0519@niasdigital.com>
	<BANLkTi=M3FxU6vv_aq1rLTmXQCGps=hC=w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 14:38:01 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> 2011/4/20 Ben Nizette <bn@niasdigital.com>:
> > On 19/04/2011, at 6:38 PM, Alan Cox wrote:
> >> Leaving aside the current input/output and on/off bits I would go for
> >> being able to do
> >>
> >>       gpio_get_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER);
> >>       gpio_set_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER_ELSE);
> >
> > Yeah I'm all for that so long as the capability constants are defined by the gpio
> > provider, eg <linux/gpio/mygpioexpander.h>.  There's no way gpiolib should be
> > keeping a big ole list of every possible config option for every gpio provider.
> 
> OK I buy that. I will refactor this solution to some opaque call instead
> and start from there.
> 
> > Well, maybe gpiolib can know about the options (eg GPIO_BIAS) so long
> > as it doesn't have to enumerate every possible value.
> 
> I will drop that even, one parameter is better than two if one of them
> is custom nevertheless. What difference does it make..

One parameter means its completely useless and we'll have to go change
the API.

Without the 'operation' being a parameter of its own no driver knows how
to answer the question 'is this shared operation A'

Alan
