Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab1FWDyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:54:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44344 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab1FWDyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:54:01 -0400
MIME-Version: 1.0
In-Reply-To: <1308794413-11069-8-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-8-git-send-email-dirk.brandewie@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 22 Jun 2011 21:53:40 -0600
X-Google-Sender-Auth: npK81cGuC3f-USnVfI2z8_mWG1I
Message-ID: <BANLkTin5hF7rZvC_AAUpX_-tR7TxdjEw+Q@mail.gmail.com>
Subject: Re: [PATCH 07/11] spi-dw: Set number of available chip selects correctly
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 8:00 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Only four chip selects are available directly off the pins of the
> master.
>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/spi/spi-dw-mid.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
> index 78e64d3..1d11268 100644
> --- a/drivers/spi/spi-dw-mid.c
> +++ b/drivers/spi/spi-dw-mid.c
> @@ -211,7 +211,9 @@ int spi_dw_mid_init(struct spi_dw *dws)
>        dws->max_freq = MRST_SPI_CLK_BASE / (clk_cdiv + 1);
>        iounmap(clk_reg);
>
> -       dws->num_cs = 16;
> +       dws->num_cs = 4;        /* spi_dw_chip_sel() bits 0-3 are
> +                                * valid in the slave enable register
> +                                */

I thought someone had told me that the dw spio core supported using
the 4 cs lines in a multiplex mode to create up to 15 cs lines, but I
may be misremembering.

g.
