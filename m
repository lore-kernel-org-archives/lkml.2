Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab2EDTZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:25:46 -0400
Received: from d1.icnet.pl ([212.160.220.21]:54500 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759494Ab2EDTZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:25:44 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: dedekind1@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v3.4-rc3] MTD: NAND: ams-delta: Fix request_mem_region() failure
Date: Fri, 04 May 2012 21:23:07 +0200
Message-ID: <20564014.WxNq7urlj7@acer>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <20120504171125.GD5613@atomide.com>
References: <1334670557-25640-1-git-send-email-jkrzyszt@tis.icnet.pl> <1520744.9xCxNUdyzk@acer> <20120504171125.GD5613@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012 10:11:25 Tony Lindgren wrote:
> Hi,
> 
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [120430 11:15]:
> > Dnia czwartek, 26 kwietnia 2012 08:20:59 Artem Bityutskiy pisze:
> > > On Wed, 2012-04-25 at 19:01 +0200, Janusz Krzysztofik wrote:
> > > > Both drivers use separate subsets of registers that belong to 
the 
> > OMAP1 
> > > > MPU I/O device, but are used for controlling different sets of 
I/O 
> > pins. 
> > > > The NAND driver reads/writes the folowing registers:
> > > > - OMAP_MPUIO_INPUT_LATCH,
> > > > - OMAP_MPUIO_OUTPUT,
> > > > - OMAP_MPUIO_IO_CNTL,
> > > > while the keypad driver - the following:
> > > > - OMAP_MPUIO_KBR_LATCH,
> > > > - OMAP_MPUIO_KBC,
> > > > - OMAP_MPUIO_KBD_MASKIT
> > > > - OMAP_MPUIO_GPIO_DEBOUNCING.
> > > > Both subsets are non-overlapping, and we rely on the drivers 
being 
> > free 
> > > > of bugs and doing their job correctly, not stepping on each 
others' 
> > > > feet, I guess.
> > > 
> > > First of all, I think this information should be in the commit 
> > message.
> > > Also, some sort of comment in the driver code would be nice.
> > > 
> > > If locking the memory region is too coarse approach, the should 
have a
> > > small separate omap-specific MPUIO subsystem which will be used by
> > > drivers to access MPUIO?
> > > 
> > > Another question - should request_mem_region() be also removed 
from 
> > the
> > > omap-gpio driver then? I think it is more sensible to put a 
comment
> > > there that it is sharing MPIO with other drivers,  instead of 
having 
> > an
> > > illusion of exclusive memory region ownership.
> > > 
> > > But this is up to the OMAP community - I can take this patch to my
> > > l2-mtd tree if you get an ack from Tony or other OMAP guys.
> > 
> > Tony,
> > Would I get your Ack for this fix if I extend the commit message as 
Artem 
> > suggested? If not, what do you think should be a correct way to fix 
the 
> > regression?
> 
> Well how about adding some exported functions to 
drivers/gpio/gpio_omap.c
> like omap_mpuio_latch?
> 
> For the regression fix, if you guys want to do what Janusz is 
suggesting,
> then assuming the patch description also contains some decent long 
term
> plan to properly fix it:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks. Now that we know you prefer to keep the memory requested from 
inside the gpio-omap, which I was about to suggest to drop back as an 
alternative fix, I'll try to cook a new description for my patch, and 
perhaps add a comment replacing the request_mem_region function removed 
from the ams-delta NAND driver, in order to satisfy both yours and 
Artem's comments in a few days.

Regards,
Janusz
