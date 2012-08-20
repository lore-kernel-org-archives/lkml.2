Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2HTL7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:59:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60960 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2HTL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:59:29 -0400
Date: Mon, 20 Aug 2012 12:59:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com,
        Patrice CHOTARD <patrice.chotard@stericsson.com>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 04/22] ASoC: Ux500: Move MSP pinctrl setup into the MSP
 driver
Message-ID: <20120820115914.GP8450@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-5-git-send-email-lee.jones@linaro.org>
 <CACRpkda_xOyu9BFGRK4xTsXOO9RCJu7BbU-kPGpttVkR6mDMZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda_xOyu9BFGRK4xTsXOO9RCJu7BbU-kPGpttVkR6mDMZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:51:02AM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > In the initial submission of the MSP driver msp1 and msp3's associated
> > pinctrl mechanism was passed back to platform code using a plat_init()
> > call-back routine, but it has no place in platform code. The MSP driver
> > should set this up for the appropriate ports. Instead we use a use_pinctrl
> > identifier which is passed from platform_data/Device Tree which indicates
> > which ports should use pinctrl.
> >
> > CC: alsa-devel@alsa-project.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This is very good because it rids platform code and makes the driver
> self-contained without strange platform data hooks.
> 
> Now details...
> 
> > +/* MSP1/3 Tx/Rx usage protection */
> > +static DEFINE_SPINLOCK(msp_rxtx_lock);
> > +
> > +/* Pin modes */
> > +struct pinctrl *pinctrl_p;
> > +struct pinctrl_state *pinctrl_def;
> > +struct pinctrl_state *pinctrl_sleep;
> > +
> > +/* Reference Count */
> > +int pinctrl_rxtx_ref;
> 
> 
> But wait. These are just local statics. Surelty you can put these into
> struct ux500_msp instead? Here it looks like these will be used for
> all ports, so MSP2 will enable the pins requested by MSP1 etc
> completely broken. So put it into the struct ux500_msp state
> container from ux500_msp_i2s.h where it belongs.
> 
> Refer to drivers/tty/serial/amba-pl011.c when in trouble. This
> one is a good pinctrl example.

How do you see the MSP1 and MSP3 usage protection working if I hide it
all away in MSP specific structs?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
