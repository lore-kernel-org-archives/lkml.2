Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3AGCKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 21:10:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60153 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753311Ab3AGCKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 21:10:13 -0500
Message-ID: <1357524615.4940.19.camel@joe-AO722>
Subject: Re: [v3 PATCH 06/12] spi/atmel_spi: add dmaengine support
From: Joe Perches <joe@perches.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        richard.genoud@gmail.com, JM.Lin@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Date: Sun, 06 Jan 2013 18:10:15 -0800
In-Reply-To: <1357523413-27209-7-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
	 <1357523413-27209-7-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 09:50 +0800, Wenyou Yang wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
[]
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
[]
> +static inline bool atmel_spi_use_dma(struct atmel_spi *as,
> +				struct spi_transfer *xfer)
> +{
> +	if ((as->use_dma) && (xfer->len >= DMA_MIN_BYTES))
> +		return true;
> +	else
> +		return false;
> +}

Same unnecessary form.

	return as->use_dma && xfer->len >= DMA_MIN_BYTES;

> +static inline bool atmel_spi_use_pdc(struct atmel_spi *as)
> +{
> +	if (as->use_pdc)
> +		return true;
> +	else
> +		return false;
> +}

Does this function really need to exist at all?


