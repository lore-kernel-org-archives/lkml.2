Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2HJG6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:58:49 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62734 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993Ab2HJG6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:58:46 -0400
MIME-Version: 1.0
In-Reply-To: <1344437248-20560-11-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
	<1344437248-20560-11-git-send-email-arnd@arndb.de>
Date: Fri, 10 Aug 2012 12:28:44 +0530
Message-ID: <CAJuYYwR9SnEUdQ_VUjmNzZZeshHjsdVKhj1scqCMXrjtG9zo=A@mail.gmail.com>
Subject: Re: [PATCH 10/11] spi/s3c64xx: improve error handling
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2012 20:17, Arnd Bergmann <arnd@arndb.de> wrote:
> When a device tree definition os an s3c64xx SPI master is missing
> a "controller-data" subnode, the newly added s3c64xx_get_slave_ctrldata
> function might use uninitialized memory in place of that node,
> which was correctly reported by gcc.
>
> Without this patch, building s3c6400_defconfig results in:
>
> drivers/spi/spi-s3c64xx.c: In function 's3c64xx_get_slave_ctrldata.isra.25':
> drivers/spi/spi-s3c64xx.c:841:5: warning: 'data_np' may be used uninitialized in this function [-Wuninitialized]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Jaswinder Singh <jaswinder.singh@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  drivers/spi/spi-s3c64xx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index 646a765..cfa2c35 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -826,7 +826,7 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
>                                 struct spi_device *spi)
>  {
>         struct s3c64xx_spi_csinfo *cs;
> -       struct device_node *slave_np, *data_np;
> +       struct device_node *slave_np, *data_np = NULL;
>         u32 fb_delay = 0;
>
>         slave_np = spi->dev.of_node;
> --
> 1.7.10
>

Acked-by: Thomas Abraham <thomas.abraham@linaro.org>
