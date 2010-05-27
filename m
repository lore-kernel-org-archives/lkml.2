Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab0E0Lhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:37:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:48703 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637Ab0E0Lh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:37:27 -0400
Subject: Re: linux-next: build failure after merge of the final tree (leds
 tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100527151656.889b5977.sfr@canb.auug.org.au>
References: <20100527151656.889b5977.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 21:36:30 +1000
Message-ID: <1274960190.1931.429.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 15:16 +1000, Stephen Rothwell wrote:
> Hi Richard,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/leds/leds-net5501.c:20:23: error: asm/geode.h: No such file or directory
> drivers/leds/leds-net5501.c: In function 'soekris_init':
> drivers/leds/leds-net5501.c:63: error: implicit declaration of function 'is_geode'

Looks like something is missing an ifdef CONFIG_X86 :-)

Cheers,
Ben.

> Caused by commit 14e40f644b020d473415342461b7c62e3bb5e312 ("leds: Add LED
> driver for the Soekris net5501 board").  Presumably only tested on x86?
> 
> drivers/leds/leds-gpio.c: In function 'of_gpio_leds_probe':
> drivers/leds/leds-gpio.c:253: error: 'struct gpio_led' has no member named 'blinking'
> 
> Caused by commit 2146325df2c2640059a9e064890c30c6e259b458 ("leds:
> leds-gpio: Change blink_set callback to be able to turn off blinking").
> 
> I have used the version of the leds tree from next-20100526 for today.


