Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2I0OWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:22:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42516 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2I0OWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:22:16 -0400
Date: Thu, 27 Sep 2012 15:18:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH v2 1/2] usb: phy: add a new driver for usb3 phy
Message-ID: <20120927141837.GA26268@n2100.arm.linux.org.uk>
References: <1348754648-8315-1-git-send-email-kishon@ti.com> <1348754648-8315-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348754648-8315-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:34:07PM +0530, Kishon Vijay Abraham I wrote:
> +static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
> +{
> +	u32 val;
> +	unsigned long rate;
> +	struct clk *sys_clk;
> +
> +	sys_clk = clk_get(NULL, "sys_clkin");
> +	if (IS_ERR(sys_clk)) {
> +		pr_err("%s: unable to get sys_clkin\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	rate = clk_get_rate(sys_clk);
> +	rate = rate/1000000;
> +	clk_put(sys_clk);

Actually, you're supposed to hold on to the struct clk all the time your
driver is making use of that - you're not supposed to drop it.

That has several advantages: if clk_get() fails, then you're failing
earlier on (when the driver is being probed) and when some event occurs.
