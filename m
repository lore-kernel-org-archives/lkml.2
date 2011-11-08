Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab1KHX6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:58:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42873 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1KHX6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:58:21 -0500
Message-ID: <4EB9C217.1010100@gmail.com>
Date: Wed, 09 Nov 2011 10:58:15 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Nikolaus Voss <n.voss@weinmann.de>
CC: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        nicolas.ferre@atmel.com, balbi@ti.com
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
References: <cover.1320753142.git.n.voss@weinmann.de> <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
In-Reply-To: <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/11 21:49, Nikolaus Voss wrote:

> This driver has the following properties compared to the old driver:
> 1. Support for multiple interfaces.
> 2. Interrupt driven I/O as opposed to polling/busy waiting.
> 3. Support for _one_ repeated start (Sr) condition, which is enough
>    for most real-world applications including all SMBus transfer types.
>    (The hardware does not support issuing arbitrary Sr conditions on the
>     bus.)
> 
> Tested on Atmel G45 with BQ20Z80 battery SMBus client.
> 
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>

<snip>

> +	dev->clk = clk_get(&pdev->dev, "twi_clk");
> +	if (IS_ERR(dev->clk)) {
> +		dev_err(&pdev->dev, "no clock defined\n");
> +		rc = -ENODEV;
> +		goto err_free_mem;
> +	}
> +	clk_enable(dev->clk);


There are now dummy clk_prepare/unprepare functions in
include/linux/clk.h, so you should be using them in this driver to
future proof it.

~Ryan
