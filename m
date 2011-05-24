Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1EXTpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:45:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19507 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab1EXTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:45:32 -0400
Date: Tue, 24 May 2011 12:44:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, x86@kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH/RFC] gpio: add GPIOF_ values regardless on kconfig
 settings
Message-Id: <20110524124457.c6c21bab.randy.dunlap@oracle.com>
In-Reply-To: <20110524052342.GA24918@rainbow>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	<20110523134815.fb87933a.randy.dunlap@oracle.com>
	<20110523224659.GB19533@opensource.wolfsonmicro.com>
	<20110523155343.2e68c265.randy.dunlap@oracle.com>
	<20110524000837.GA30515@opensource.wolfsonmicro.com>
	<4DDB082F.3010107@oracle.com>
	<20110524014959.GA27710@opensource.wolfsonmicro.com>
	<4DDB3AFF.9030006@oracle.com>
	<20110524052342.GA24918@rainbow>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DDC0AC8.016E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 09:23:42 +0400 Dmitry Artamonow wrote:

> On 21:58 Mon 23 May     , Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
> > is enabled by moving them to <linux/gpio.h>.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Looks good.
> 
> We probably may also want to move definition of struct gpio into
> include/linux/gpio.h to make things like this work as well:
> 
> static struct gpio some_gpios[] = {
> 	{ GPIO_BLAH, GPIOF_IN, "BLAH"},
> 	{ GPIO_BLAH2, GPIOF_OUT_INIT_LOW, "BLAH2"},
> };
> 
> static int some_init_function(void)
> {
> 	/* ... */
> 
> 	gpio_request_array(some_gpios, ARRAY_SIZE(some_gpios));
> 
> 	/* ... */
> }
> 
> These gpio_request_one() and gpio_request_array() are quite handy, so I
> suppose more and more drivers will use it as we go...

That could help this one:

linux-next-20110524/include/linux/mfd/tps65910.h:774: error: field 'gpio' has incomplete type

and then add some way to handle (e.g.):

	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
=>
linux-next-20110524/drivers/gpio/tps65910-gpio.c:25: warning: type defaults to 'int' in declaration of '__mptr'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
