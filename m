Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767811Ab2KON2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:28:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52885 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767762Ab2KON2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:28:12 -0500
Subject: Re: [PATCH v5 1/4] genalloc: add a global pool list, allow to find
 pools by phys address
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <CAP=VYLq9E_bacNQpczQVbOZzYq4eznMPdmMaVMu3oV9Z3q_9pw@mail.gmail.com>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
	 <1350570453-24546-2-git-send-email-p.zabel@pengutronix.de>
	 <CAP=VYLq9E_bacNQpczQVbOZzYq4eznMPdmMaVMu3oV9Z3q_9pw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Nov 2012 14:25:43 +0100
Message-ID: <1352985943.2399.198.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Am Freitag, den 26.10.2012, 15:46 -0400 schrieb Paul Gortmaker: 
> On Thu, Oct 18, 2012 at 10:27 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > This patch keeps all created pools in a global list and adds two
> > functions that allow to retrieve the gen_pool pointer from a known
> > physical address and from a device tree node.
> 
> So, I'm not seeing any added users of the of_get_named_gen_pool,
> or the other exported "reverse-lookup" function.  Without that, the
> anticipated use case is not clear to me.

My use case is the coda video codec driver, for a video codec IP core
that is integrated in various SoCs. It can use on-SoC SRAM as temporary
memory.

Other possible use cases are the TI Davinci sound driver.
Or the PXA frame buffer driver could allocate a frame buffer in SRAM for
low-resolution devices.

> Is there an example of some pending driver or similar, that has
> a phys addr from an unknown source and needs to know what
> pool it may or may not be in?  With the use case, someone might
> be able to suggest alternative ways to get what you want done.

drivers/media/platform/coda.c right now uses imx specific
iram_alloc/free wrappers around gen_pool_alloc/free.
I'd like to use of_get_named_gen_pool to obtain the struct gen_pool
pointer and use gen_pool_alloc/free directly, instead.

sound/soc/davinci/davinci-pcm.c right now uses davinci specific
sram_alloc/free wrappers around gen_pool_alloc/free.

drivers/dma/mmp_tdma.c and sound/soc/pxa/mmp-pcm.c already use
gen_pool_alloc/free directly, but they use a arch-mmp specific
sram_get_gpool function to obtain the struct gen_pool pointer.

> It might also be worth cross compiling this for powerpc, since the
> header files you implicitly get included varies from one arch to
> the next, and there might be some compile fails lurking there.

Thanks, I'll do that.

regards
Philipp


