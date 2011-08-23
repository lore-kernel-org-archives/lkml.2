Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1HWItr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:49:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34463 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1HWIto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:49:44 -0400
Message-ID: <4E5369A0.4080701@gmail.com>
Date: Tue, 23 Aug 2011 10:49:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SPI: fix build with CONFIG_SPI_FSL_ESPI=m
References: <1314086345-2818-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1314086345-2818-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 09:59 AM, Jiri Slaby wrote:
> When spi_fsl_espi is chosen to be built as a module, there is a build
> error because we test only CONFIG_SPI_FSL_ESPI in declaration of
> struct mpc8xxx_spi in drivers/spi/spi_fsl_lib.h.
> 
> We need to add a test for CONFIG_SPI_FSL_ESPI_MODULE too.
> 
> The error looks like:
> drivers/spi/spi_fsl_espi.c: In function 'fsl_espi_bufs':
> drivers/spi/spi_fsl_espi.c:232: error: 'struct mpc8xxx_spi' has no member named 'len'
> ...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/spi/spi-fsl-lib.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
> index cbe881b..97968de 100644
> --- a/drivers/spi/spi-fsl-lib.h
> +++ b/drivers/spi/spi-fsl-lib.h
> @@ -28,7 +28,7 @@ struct mpc8xxx_spi {
>  	/* rx & tx bufs from the spi_transfer */
>  	const void *tx;
>  	void *rx;
> -#ifdef CONFIG_SPI_FSL_ESPI
> +#if defined(CONFIG_SPI_FSL_ESPI) || defined(CONFIG_SPI_FSL_ESPI_MODULE)
>  	int len;
>  #endif

Oh, and there are still link errors:
ERROR: "mpc8xxx_spi_tx_buf_u32" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_rx_buf_u32" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_tx_buf_u16" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_rx_buf_u16" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_tx_buf_u8" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_rx_buf_u8" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "of_mpc8xxx_spi_probe" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_strmode" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_probe" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_remove" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "to_of_pinfo" [drivers/spi/spi_fsl_spi.ko] undefined!
ERROR: "mpc8xxx_spi_tx_buf_u32" [drivers/spi/spi_fsl_espi.ko] undefined!
ERROR: "mpc8xxx_spi_rx_buf_u32" [drivers/spi/spi_fsl_espi.ko] undefined!
ERROR: "of_mpc8xxx_spi_probe" [drivers/spi/spi_fsl_espi.ko] undefined!
ERROR: "mpc8xxx_spi_probe" [drivers/spi/spi_fsl_espi.ko] undefined!
ERROR: "mpc8xxx_spi_remove" [drivers/spi/spi_fsl_espi.ko] undefined!

The functions are not exported...

Should I export all those or deny CONFIG_SPI_FSL_ESPI=m?

thanks,
-- 
js
