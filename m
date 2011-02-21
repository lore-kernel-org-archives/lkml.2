Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1BUEmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:42:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53082 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab1BUEmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:42:31 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298250861-27094-1-git-send-email-ccross@android.com>
References: <AANLkTim0X=gUwYJmR+EAYjGamiJb7tgiVEjwqCEF0-L0@mail.gmail.com>
	<1298250861-27094-1-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:37:29 -0800
Message-ID: <AANLkTi=ia1FGur6mrVuE2rOBGjjRYZ3A41mTq3qOowmS@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: tegra: Add i2c support
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: Ben Dooks <ben-i2c@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        swarren@nvidia.com, patches@opensource.wolfsonmicro.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a couple of minor nits. I wouldn't worry about respinning just
for these comments, but if you end up doing it for other feedback, see
below.


-Olof

On Sun, Feb 20, 2011 at 5:14 PM, Colin Cross <ccross@android.com> wrote:

> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> new file mode 100644
> index 0000000..3921f66
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -0,0 +1,700 @@
> +/*
> + * drivers/i2c/busses/i2c-tegra.c
> + *
> + * Copyright (C) 2010 Google, Inc.

2011?

[..]

> +/*
> + * i2c_writel and i2c_readl will offset the register if necessary to talk
> + * to the I2C block inside the DVC block
> + */
> +static unsigned long tegra_i2c_reg_addr(struct tegra_i2c_dev *i2c_dev,
> +       unsigned long reg)
> +{
> +       if (i2c_dev->is_dvc)
> +               reg += (reg >= I2C_TX_FIFO) ? 0x10 : 0x40;
> +       return reg;
> +}
> +
> +static void i2c_writel(struct tegra_i2c_dev *i2c_dev, u32 val,
> +       unsigned long reg)
> +{
> +       writel(val, i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
> +}
> +
> +static u32 i2c_readl(struct tegra_i2c_dev *i2c_dev, unsigned long reg)
> +{
> +       return readl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
> +}
> +
> +static void i2c_writesl(struct tegra_i2c_dev *i2c_dev, void *data,
> +       unsigned long reg, int len)
> +{
> +       writesl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg), data, len);
> +}
> +
> +static void i2c_readsl(struct tegra_i2c_dev *i2c_dev, void *data,
> +       unsigned long reg, int len)
> +{
> +       readsl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg), data, len);
> +}


All of the above pass in i2c_dev to tegra_i2c_reg_addr, might as well
do the base addition in there.

> diff --git a/include/linux/i2c-tegra.h b/include/linux/i2c-tegra.h
> new file mode 100644
> index 0000000..9c85da4
> --- /dev/null
> +++ b/include/linux/i2c-tegra.h
> @@ -0,0 +1,25 @@
> +/*
> + * drivers/i2c/busses/i2c-tegra.c
> + *
> + * Copyright (C) 2010 Google, Inc.

2011?
