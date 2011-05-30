Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1E3JJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:09:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2330 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab1E3JJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:09:43 -0400
Subject: Re: [PATCH 1/1] aat2870: Adding backlight, regulator and mfd driver
From: Joe Perches <joe@perches.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1306743452-26386-2-git-send-email-jinyoungp@nvidia.com>
References: <1306743452-26386-1-git-send-email-jinyoungp@nvidia.com>
	 <1306743452-26386-2-git-send-email-jinyoungp@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 02:09:42 -0700
Message-ID: <1306746582.20175.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 17:17 +0900, Jin Park wrote:
> Adding backlight, regulator and mfd driver for AnalogicTech AAT2870.
> Signed-off-by: Jin Park <jinyoungp@nvidia.com>

Hi Jin, just trivia

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
[]
> +config MFD_AAT2870_CORE
> +	bool "Support for the AnlogicTech AAT2870"

Analogic

> +++ b/drivers/mfd/aat2870-core.c
[]
> +static struct aat2870_register aat2870_regs[AAT2870_REG_NUM] = {

Might describe this as the reg_cache as well.
readable, writable could be bool.

> +	/* readable, writeable, value */
> +	{ 0, 1, 0x00 },	/* 0x00 AAT2870_BL_CH_EN */

[]

> diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
[]
> +static int aat2870_ldo_voltages[] = {

static const int?

> +	1200000, 1300000, 1500000, 1600000,
> +	1800000, 2000000, 2200000, 2500000,
> +	2600000, 2700000, 2800000, 2900000,
> +	3000000, 3100000, 3200000, 3300000,

[]

> diff --git a/include/linux/mfd/aat2870.h b/include/linux/mfd/aat2870.h
[]
> +/* Backlight current magnitude (mA) */
> +enum aat2870_current {
> +	AAT2870_CURRENT_0_45 = 0,

Seems odd and error prone to add enum = value
every 10 places.

> +	AAT2870_CURRENT_0_90,
> +	AAT2870_CURRENT_1_80,
> +	AAT2870_CURRENT_2_70,
> +	AAT2870_CURRENT_3_60,
> +	AAT2870_CURRENT_4_50,
> +	AAT2870_CURRENT_5_40,
> +	AAT2870_CURRENT_6_30,
> +	AAT2870_CURRENT_7_20,
> +	AAT2870_CURRENT_8_10,
> +	AAT2870_CURRENT_9_00 = 10,
[]
> +struct aat2870_register {
> +	int readable;
> +	int writeable;

bool?

> +struct aat2870_data {
> +	struct device *dev;
> +	struct i2c_client *client;
> +
> +	struct mutex io_lock;
> +	struct aat2870_register *reg_cache; /* register cache */
> +	int en_pin; /* enable GPIO pin (if < 0, ignore this value) */
> +	int is_enable;

bool?


