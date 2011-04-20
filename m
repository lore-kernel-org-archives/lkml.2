Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1DTOxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:53:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42746 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751875Ab1DTOxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:53:45 -0400
Date: Wed, 20 Apr 2011 15:54:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kyungmin Park <kmpark@infradead.org>, Ben Nizette <bn@niasdigital.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110420155407.1aa60f20@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTimfkpjQ9DoYKRTVwyvtPRccO+RwpA@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
	<BANLkTimfkpjQ9DoYKRTVwyvtPRccO+RwpA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 14:32:35 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> 2011/4/19 Kyungmin Park <kmpark@infradead.org>:
> 
> > One more consideration, not mentioned previous time, is that pin
> > configuration for power down mode.
> > Samsung SoCs has retention GPIO configurations at sleep (suspend)
> > mode. and restore it at resume time.
> > it's need to reduce power and proper operation after suspend.
> 
> Isn't this supposed to be handled by runtime_pm hooks inside
> your GPIO driver rather than by someone else talking to
> the GPIO driver trying to spool/unspool the state from the
> outside in some other place?
> 
> Or am I getting things backwards now...?

IMHO that rather depends upon what knows the right things to do. The
platform may know the right way to manage GPIO pins but it may also be
that only the driver knows because the correct suspended pin states
depend on the driver or on the current runtime configuration - eg if a
specific GPIO must be left enabled for wakeup to work then it depends
whether that device is active not on the platform level properties.
