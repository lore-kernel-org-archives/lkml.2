Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1JCQne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:43:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33712 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1JCQn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:43:29 -0400
Date: Mon, 3 Oct 2011 17:43:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rob Herring <robherring2@gmail.com>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, paul@pwsan.com,
        linaro-dev@lists.linaro.org, linus.walleij@stericsson.com,
        patches@linaro.org, eric.miao@linaro.org, magnus.damm@gmail.com,
        amit.kucheria@linaro.org, richard.zhao@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111003164309.GA19925@n2100.arm.linux.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com> <4E89C3FA.9020206@gmail.com> <20111003142524.GN3731@opensource.wolfsonmicro.com> <4E89D3C4.8090001@gmail.com> <20111003163107.GQ3731@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003163107.GQ3731@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:31:08PM +0100, Mark Brown wrote:
> I dunno, I get the impression that some of this is due to the current
> limitations of the clock API rather than due to a lack of clocks -
> perhaps that's specific to the applications I look at, though.
> applications 

The clk API per-se has nothing to do with how clocks are registered.
There are two things that are the clk API:

1. clkdev - which deals with translating devices + connection IDs to
   struct clk.  This has no ordering requirements wrt requiring
   parents to be "initialized" before their children (it has no care
   about that at all because it's not within its definition.)

   For this, registration is about connecting device + connection IDs
   to a struct clk.

2. the driver API, defining how the opaque struct clk is looked up,
   obtained and then manipulated.  This has no 'registration' stuff.

So, whether clocks are a tree or flat is unspecified.  It's unspecified
whether there's any particular order required.

In fact, with a clock tree, it's entirely possible that only the leaf
clocks will be 'registered' with clkdev.  How the rest of the clock tree
is initialized is beyond the scope of the driver clk API.
