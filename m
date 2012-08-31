Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2HaMEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:04:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65472 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2HaMEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:04:20 -0400
Date: Fri, 31 Aug 2012 13:04:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
Message-ID: <20120831120411.GB5962@gmail.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
 <1345734087-21803-3-git-send-email-lee.jones@linaro.org>
 <20120831112258.GA2624@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120831112258.GA2624@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there some dependency other than updating the dts files? If not, I'd
> like to pick up the patch via I2C.

There's no other dependency. Feel free to take them into your tree.

> > +static void nmk_i2c_of_probe(struct device_node *np,
> > +			struct nmk_i2c_controller *pdata)
> > +{
> > +	/* Provide the default configuration as a base. */
> > +	pdata = &u8500_i2c;
> 
> ?????? I wonder how that could work... have you tested the patch?

Wow, that's a great spot!

I have tested the patch, but I don't have any i2c devices, so can't
test full functionality. I, wrongly it seems, assumed there would be
a complaint from the I2C subsystem if any of the values seemed wrong.
What I will do before next submission is print out the entire pdata
structure to ensure it's populated in the correct way.

> > +
> > +	of_property_read_u32(np, "clock-frequency", (u32*)&pdata->clk_freq);
> 
> Might be worth changing clk_freq to u32?

Yes, makes sense. 

> > +
> > +	/* This driver only supports 'standard' and 'fast' modes of operation. */
> > +	if (pdata->clk_freq <= 100000)
> > +		pdata->sm = I2C_FREQ_MODE_STANDARD;
> 
> Is standard == 100000 Hz?

Well it depends on how you interpret the comments in:
     include/linux/platform_data/i2c-nomadik.h

enum i2c_freq_mode {
        I2C_FREQ_MODE_STANDARD,         /* up to 100 Kb/s */
        I2C_FREQ_MODE_FAST,             /* up to 400 Kb/s */
        I2C_FREQ_MODE_HIGH_SPEED,       /* up to 3.4 Mb/s */
        I2C_FREQ_MODE_FAST_PLUS,        /* up to 1 Mb/s */
};

I guess your guess would be better than mine.

> > +	else
> > +		pdata->sm = I2C_FREQ_MODE_FAST;
> 
> If those two are fixed frequencies, you should omit a warning if the
> devicetree has a different frequency set and report which one is going
> to be used actually.

Well, again by the comments above I would say that in between values
were valid, but I'm willing to bow down to your knowledge if you think
they are fixed values?

Thanks for reviewing.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
