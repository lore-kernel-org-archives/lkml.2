Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2CSP7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:59:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51616 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab2CSP7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:59:09 -0400
Message-ID: <1332172876.22775.84.camel@saladin.home.flameeyes.eu>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Date: Mon, 19 Mar 2012 17:01:16 +0100
In-Reply-To: <20120319005406.GA28497@ericsson.com>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	 <20120317123151.AAF9A3E0952@localhost>
	 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
	 <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
	 <20120319005406.GA28497@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno dom, 18/03/2012 alle 17.54 -0700, Guenter Roeck ha scritto:
> On IT8721F (which is supposedly mostly compatible to IT8728F), only four of the 87 GPIO pins
> are GPIO-only (unless I miscounted ;). All others have at least two different functions.

On the IT8728F the 64 GPIO (11 to 87, they use an X-Y notation) are
divided in eight banks, and only the latest three banks are GPIO-only,
the others all have alternate functions.

> Not sure if it is a good idea to re-configure any of those pins. I would assume
> there is a reason if a given set of pins is configured as UART, for example.

That's true, on the other hand there are a few pins that should be
reused without other issues: for instance the LED ones. That's what I
was thinking of with an MFD SuperIO driver.

At any rate I'll look at the pinctrl subsystem since the gpio_request
function in the gpio driver is indeed changing the mapping like pinmux
should. And there I thought it would have been an easy driver to write
^^;;

-- 
Diego Elio Pettenò — Flameeyes
http://blog.flameeyes.eu/


