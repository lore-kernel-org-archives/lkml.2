Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1BSN1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 08:27:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51305 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1BSN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 08:27:03 -0500
Date: Sat, 19 Feb 2011 13:26:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com, gregkh@suse.de,
        amit.chatterjee@ti.com, hjk@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
Message-ID: <20110219132642.GD29493@n2100.arm.linux.org.uk>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com> <1298041530-26855-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298041530-26855-2-git-send-email-pratheesh@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 08:35:29PM +0530, Pratheesh Gangadhar wrote:
> +static int __devinit pruss_probe(struct platform_device *dev)
> +{
> +	int ret = -ENODEV;
> +	int count = 0;
> +	struct resource *regs_pruram, *regs_l3ram, *regs_ddr;
> +	char *string;
> +
> +	/* Power on PRU in case its not done as part of boot-loader */
> +	pruss_clk = clk_get(&dev->dev, "pruss");
> +	if (IS_ERR(pruss_clk)) {
> +		dev_err(&dev->dev, "Failed to get clock\n");
> +		ret = PTR_ERR(pruss_clk);
> +		pruss_clk = NULL;

Delete this line.

...
> +out_free:
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++)
> +		kfree(info[count]);
> +
> +	if (pruss_clk != NULL)

	if (!IS_ERR(pruss_clk))

> +		clk_put(pruss_clk);
...
> +static int __devexit pruss_remove(struct platform_device *dev)
...
> +	platform_set_drvdata(dev, NULL);
> +
> +	if (pruss_clk != NULL)

	if (!IS_ERR(pruss_clk))

> +		clk_put(pruss_clk);
