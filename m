Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0E1HmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:42:14 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:54151 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab0E1HmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:42:12 -0400
Subject: Re: linux-next: build failure after merge of the final tree (leds
 tree related)
From: Richard Purdie <rpurdie@rpsys.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <20100528101157.aff693f4.sfr@canb.auug.org.au>
References: <20100527151656.889b5977.sfr@canb.auug.org.au>
	 <1274960190.1931.429.camel@pasglop> <1274965644.24079.1427.camel@rex>
	 <20100528013549.9c17f6e4.sfr@canb.auug.org.au>
	 <20100528101157.aff693f4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 08:41:12 +0100
Message-ID: <1275032472.24079.1466.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 10:11 +1000, Stephen Rothwell wrote:
> On Fri, 28 May 2010 01:35:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Thu, 27 May 2010 14:07:24 +0100 Richard Purdie <rpurdie@rpsys.net> wrote:
> > >
> > > On Thu, 2010-05-27 at 21:36 +1000, Benjamin Herrenschmidt wrote:
> > > > On Thu, 2010-05-27 at 15:16 +1000, Stephen Rothwell wrote:
> > > > > 
> > > > > drivers/leds/leds-net5501.c:20:23: error: asm/geode.h: No such file or directory
> > > > > drivers/leds/leds-net5501.c: In function 'soekris_init':
> > > > > drivers/leds/leds-net5501.c:63: error: implicit declaration of function 'is_geode'
> > > > 
> > > > Looks like something is missing an ifdef CONFIG_X86 :-)
> > > 
> > > Right, that driver/board is x86 only. I've pushed a fix.
> > > 
> > > > > Caused by commit 14e40f644b020d473415342461b7c62e3bb5e312 ("leds: Add LED
> > > > > driver for the Soekris net5501 board").  Presumably only tested on x86?
> > > > > 
> > > > > drivers/leds/leds-gpio.c: In function 'of_gpio_leds_probe':
> > > > > drivers/leds/leds-gpio.c:253: error: 'struct gpio_led' has no member named 'blinking'
> > > > > 
> > > > > Caused by commit 2146325df2c2640059a9e064890c30c6e259b458 ("leds:
> > > > > leds-gpio: Change blink_set callback to be able to turn off blinking").
> > > 
> > > This error looks like its from Ben's patch, probably when openfirmware
> > > is enabled. I've queued a fix for this too:
> > > 
> > > http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/commit/?id=a4b4433c511cf4361bb0afabba69e16632002d32
> > 
> > Great, thanks.
> 
> Except, of course, Linus has merged the broken tree without the fixes :-(
> 
> Oh, well.

At least we have fixes, I've asked him to pull them.

Cheers,

Richard


