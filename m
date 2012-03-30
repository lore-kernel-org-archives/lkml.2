Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab2C3S0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:26:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab2C3S0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:26:51 -0400
Date: Fri, 30 Mar 2012 11:26:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geon Si Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] leds: Add LED driver for lm3556 chip
Message-Id: <20120330112650.2a36d833.akpm@linux-foundation.org>
In-Reply-To: <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
References: <1333089508-8501-1-git-send-email-gshark.jeong@gmail.com>
	<1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 15:38:28 +0900
Geon Si Jeong <gshark.jeong@gmail.com> wrote:

> It is a simple driver for LM3556 Chip(Texas Instruments)
> LM3556 :
> The LM3556 is a 4 MHz fixed-frequency synchronous boost
> converter plus 1.5A constant current driver for a high-current white LED.
> Datasheet: www.national.com/ds/LM/LM3556.pdf
> 
> Tested on OMAP4430
> 
> ...
>
> +EXPORT_SYMBOL_GPL(lm3556_read_reg);
> +EXPORT_SYMBOL_GPL(lm3556_write_reg);
> +EXPORT_SYMBOL_GPL(lm3556_write_bits);

These symbols are global and exported to modules, but have no
references outside this file.  Why?

> +static int lm3556_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct lm3556_platform_data *pdata = client->dev.platform_data;
> +	struct lm3556_chip_data *chip;
> +
> +	int err = -ENODEV;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		printk(KERN_ERR"[LM3556]i2c functionality check fail.\n");
> +		return err;
> +	}
> +
> +	if (pdata == NULL) {
> +		printk(KERN_ERR"[LM3556] Needs Platform Data.\n");
> +		return err;
> +	}
> +
> +	chip = kzalloc(sizeof(struct lm3556_chip_data), GFP_KERNEL);
> +	chip->client = client;
> +	chip->pdata = pdata;

tsk.

--- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-fix
+++ a/drivers/leds/leds-lm3556.c
@@ -346,7 +346,6 @@ static int lm3556_probe(struct i2c_clien
 {
 	struct lm3556_platform_data *pdata = client->dev.platform_data;
 	struct lm3556_chip_data *chip;
-
 	int err = -ENODEV;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
@@ -360,6 +359,8 @@ static int lm3556_probe(struct i2c_clien
 	}
 
 	chip = kzalloc(sizeof(struct lm3556_chip_data), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
 	chip->client = client;
 	chip->pdata = pdata;
 

