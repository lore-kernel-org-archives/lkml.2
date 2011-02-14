Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1BNRDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:03:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41914 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751312Ab1BNRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:03:36 -0500
Date: Mon, 14 Feb 2011 17:08:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>,
        "grant.likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
In-Reply-To: <1297698493.965.5475.camel@petert>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	<1297698493.965.5475.camel@petert>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If a GPIO driver implements get_direction(), it is called in
> > gpio_request() to set the initial direction of the pin accurately.
> 
> I see Grant was just added as a GPIO maintainer, so added him on CC.
> 
> Anything gating getting these 3 patches being picked up?

We need four states for a gpio pin direction though. A pin can be

- input
- output
- unknown (hardware lacks get functionality and it has not been set by
  software yet)
- alt_func (pin is in use for some other purpose)

(and being able to set them alt_func was proposed a while ago and I think
wants revisiting judging by the number of platforms which use gpio, and
in their own arch code are privately handling alt_func stuff)

Alan
