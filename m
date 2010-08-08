Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0HHPDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:03:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58704 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0HHPDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:03:01 -0400
MIME-Version: 1.0
In-Reply-To: <20100808141422.GA9670@oksana.dev.rtsoft.ru>
References: <20100808141422.GA9670@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 8 Aug 2010 09:02:40 -0600
X-Google-Sender-Auth: UcdDe_VmcluC_jJE0eOtyn0Atwg
Message-ID: <AANLkTin3pWr02GytxH=c7Z=HGocc0kDJu=tfWR_7PzU3@mail.gmail.com>
Subject: Re: [PATCH] mmc_spi: Fix unterminated of_match_table
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 8, 2010 at 8:14 AM, Anton Vorontsov <avorontsov@mvista.com> wrote:
> commit 2ffe8c5f323c3b9749bf7bc2375d909d20bdbb15 ("of: refactor
> of_modalias_node() and remove explicit match table"), introduced
> an unterminated of_match_table, which may cause kernel to oops.
>
> This patch fixes the issue by adding an empty device ID.
>
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>

Thanks Anton.  Merged into my next-devicetree branch.

g.

> ---
>  drivers/mmc/host/mmc_spi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index 7b0f3ef..1145ea0 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -1536,6 +1536,7 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
>  #if defined(CONFIG_OF)
>  static struct of_device_id mmc_spi_of_match_table[] __devinitdata = {
>        { .compatible = "mmc-spi-slot", },
> +       {},
>  };
>  #endif
>
> --
> 1.7.0.5
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
