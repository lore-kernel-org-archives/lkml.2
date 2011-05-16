Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1EPSRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:17:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53628 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1EPSRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110512151113.GE21345@caffeine.csclub.uwaterloo.ca>
References: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
 <9389EE59E16E9447AFB481039183BCF4117B10@039-SN1MPN1-005.039d.mgd.msft.net> <20110512151113.GE21345@caffeine.csclub.uwaterloo.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 May 2011 12:17:13 -0600
X-Google-Sender-Auth: IBuCJewdio90fLL3EzCRZL0DP9U
Message-ID: <BANLkTikGM=v09KE-J_KOvbSNhQx3MmR0cA@mail.gmail.com>
Subject: Re: spi_fsl_spi broken when compiled as module by b36ece832512c1a0afa54ff0a56d63492a1caf08
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Hu Mingkai-B21284 <B21284@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 9:11 AM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Thu, May 12, 2011 at 01:33:55AM +0000, Hu Mingkai-B21284 wrote:
>> Please submit a patch to modify it.
>
> OK.  Here it is.

>
> --
> Len Sorensen
>
> Add missing exports and module license to allow compiling of spi_fsl_*
> drivers as modules again.  Originally broken by refactoring of code in
> b36ece832512c1a0afa54ff0a56d63492a1caf08.
>
> diff --git a/drivers/spi/spi_fsl_lib.c b/drivers/spi/spi_fsl_lib.c
> index ff59f42..d7efaac 100644
> --- a/drivers/spi/spi_fsl_lib.c
> +++ b/drivers/spi/spi_fsl_lib.c
> @@ -48,16 +48,23 @@ u32 mpc8xxx_spi_tx_buf_##type(struct mpc8xxx_spi *mpc8xxx_spi)      \
>  }
>
>  MPC8XXX_SPI_RX_BUF(u8)
> +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u8);
>  MPC8XXX_SPI_RX_BUF(u16)
> +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u16);
>  MPC8XXX_SPI_RX_BUF(u32)
> +EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u32);
>  MPC8XXX_SPI_TX_BUF(u8)
> +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u8);
>  MPC8XXX_SPI_TX_BUF(u16)
> +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u16);
>  MPC8XXX_SPI_TX_BUF(u32)
> +EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u32);

EXPORT_SYMBOL_GPL() please.


>
>  struct mpc8xxx_spi_probe_info *to_of_pinfo(struct fsl_spi_platform_data *pdata)
>  {
>        return container_of(pdata, struct mpc8xxx_spi_probe_info, pdata);
>  }
> +EXPORT_SYMBOL(to_of_pinfo);

Hmmm,. this is not so good because it exports rather generically named
functions out to the global namespace.  These functions should be
renamed to have an mpc8xxx_spi_ prefix before exporting.

Otherwise this patch looks good.

g.

>
>  void mpc8xxx_spi_work(struct work_struct *work)
>  {
> @@ -116,6 +123,7 @@ const char *mpc8xxx_spi_strmode(unsigned int flags)
>        }
>        return "CPU";
>  }
> +EXPORT_SYMBOL(mpc8xxx_spi_strmode);
>
>  int mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
>                        unsigned int irq)
> @@ -168,6 +176,7 @@ int mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
>  err:
>        return ret;
>  }
> +EXPORT_SYMBOL(mpc8xxx_spi_probe);
>
>  int __devexit mpc8xxx_spi_remove(struct device *dev)
>  {
> @@ -188,6 +197,7 @@ int __devexit mpc8xxx_spi_remove(struct device *dev)
>
>        return 0;
>  }
> +EXPORT_SYMBOL(mpc8xxx_spi_remove);
>
>  int __devinit of_mpc8xxx_spi_probe(struct platform_device *ofdev)
>  {
> @@ -234,3 +244,8 @@ err:
>        kfree(pinfo);
>        return ret;
>  }
> +EXPORT_SYMBOL(of_mpc8xxx_spi_probe);
> +
> +MODULE_AUTHOR("Kumar Gala");
> +MODULE_DESCRIPTION("Freescale SPI/eSPI controller driver library");
> +MODULE_LICENSE("GPL");
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
