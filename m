Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165Ab2FARbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:31:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44381 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759275Ab2FARbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:31:52 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1//AogynRr/9rFdnxirPV4erm15X13J+VDQAPGzug
	LcIlBVCst0giLT
From: Marc Dietrich <marvin24@gmx.de>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: swarren@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olof@lixom.net, jak@jak-linux.org, gregkh@linuxfoundation.org,
        ac100@lists.launchpad.net, devel@driverdev.osuosl.org
Subject: Re: [PATCH 7/9] staging: nvec: add clk_prepare/clk_unprepare
Date: Fri, 01 Jun 2012 19:31:08 +0200
Message-ID: <1505860.QOgf9duN2r@ax5200p>
User-Agent: KMail/4.8.3 (Linux/3.2.0-24-generic; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1338541968-7961-8-git-send-email-pgaikwad@nvidia.com>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com> <1338541968-7961-8-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2012 14:42:46 Prashant Gaikwad wrote:
> Use clk_prepare/clk_unprepare as required by the generic clk framework.
> 
> This patch should go through Tegra tree since other patches to port Tegra
> to generic clock framework are dependent on it. Posting here to get ack from
> the maintainers.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

tested and ...

Acked-By: Marc Dietrich <marvin24@gmx.de>

> ---
>  drivers/staging/nvec/nvec.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index 3c60088..9356886 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -675,7 +675,7 @@ static void tegra_init_i2c_slave(struct nvec_chip *nvec)
> {
>  	u32 val;
> 
> -	clk_enable(nvec->i2c_clk);
> +	clk_prepare_enable(nvec->i2c_clk);
> 
>  	tegra_periph_reset_assert(nvec->i2c_clk);
>  	udelay(2);
> @@ -695,14 +695,14 @@ static void tegra_init_i2c_slave(struct nvec_chip
> *nvec)
> 
>  	enable_irq(nvec->irq);
> 
> -	clk_disable(nvec->i2c_clk);
> +	clk_disable_unprepare(nvec->i2c_clk);
>  }
> 
>  static void nvec_disable_i2c_slave(struct nvec_chip *nvec)
>  {
>  	disable_irq(nvec->irq);
>  	writel(I2C_SL_NEWSL | I2C_SL_NACK, nvec->base + I2C_SL_CNFG);
> -	clk_disable(nvec->i2c_clk);
> +	clk_disable_unprepare(nvec->i2c_clk);
>  }
> 
>  static void nvec_power_off(void)
> @@ -812,7 +812,7 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev)
> 
>  	tegra_init_i2c_slave(nvec);
> 
> -	clk_enable(i2c_clk);
> +	clk_prepare_enable(i2c_clk);
> 
> 
>  	/* enable event reporting */
