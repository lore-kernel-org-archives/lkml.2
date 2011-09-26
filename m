Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1IZJjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:39:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44404 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752800Ab1IZJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:39:00 -0400
Date: Mon, 26 Sep 2011 10:38:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v2 6/7] clk: Add initial WM831x clock driver
Message-ID: <20110926093858.GD2946@opensource.wolfsonmicro.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-7-git-send-email-mturquette@ti.com>
 <20110925040836.GP24631@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110925040836.GP24631@ponder.secretlab.ca>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 10:08:36PM -0600, Grant Likely wrote:
> On Thu, Sep 22, 2011 at 03:27:01PM -0700, Mike Turquette wrote:

> > +	ret = platform_driver_register(&wm831x_clk_driver);
> > +	if (ret != 0)
> > +		pr_err("Failed to register WM831x clock driver: %d\n", ret);
> > +
> > +	return ret;

> No need for this song-and-dance.  The driver core is pretty well
> debugged.  Just use "return platform_driver_register(...);"

No, that's not helpful.  The issue isn't the device probe code itself,
the issue is things like module unload not doing what they're supposed
to do and leaving the device lying around or something - there's rather
more going on than just the plain API call.
