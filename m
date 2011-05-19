Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab1ESIwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:52:20 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:47992
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756833Ab1ESIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:52:19 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 19 May 2011 16:56:39 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Message-ID: <20110519085638.GA26816@S2100-06.ap.freescale.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 03:13:22PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This rewrites the U300 GPIO driver using gpiolib and the irq_chip
> abstractions, makes it runtime-configured rather than compile-time,
> and moves it to the drivers/gpio subsystem where it belongs,
> depopulating the ARM tree of one more driver.
> 
> Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
driver/gpio, and I see the possibility to go a different approach
from U300 one posted here.

The common thing between these two hardwares is there are several
gpio ports implemented in one memory region. And it seems no problem
to treat all these gpio ports as one gpio chip, and we can use
platform data to specify port number, and calculate base address of
each port with shifting start address.  But I do not think this
approach is able to scale comparing to the one that we treat each
port as an independent gpio chip.

Looking at mxc gpio driver, we will see those gpio ports lay at the
discrete memory regions.  One port one chip approach works for both
cases, since sharing one memory region is just a special case of one
port one region case.  And most importantly, it will make gpio driver
clean and easy to see the common pattern among different gpio drivers.

-- 
Regards,
Shawn

