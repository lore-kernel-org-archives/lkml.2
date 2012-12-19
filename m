Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2LSUhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:37:03 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50343 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab2LSUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:36:15 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2] spi: remove check for bits_per_word on transfer from low level driver
To: Laxman Dewangan <ldewangan@nvidia.com>,
        broonie@opensource.wolfsonmicro.com
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, baohua.song@csr.com,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jonas.gorski@gmail.com,
        linux-tegra@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1355820943-25228-1-git-send-email-ldewangan@nvidia.com>
References: <1355820943-25228-1-git-send-email-ldewangan@nvidia.com>
Date: Wed, 19 Dec 2012 16:24:33 +0000
Message-Id: <20121219162433.1E1E43E0BCF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 14:25:43 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> The spi core make sure that each transfer structure have the proper
> setting for bits_per_word before calling low level transfer APIs.
> 
> Hence it is no more require to check again in low level driver for
> this field whether this is set correct or not. Removing such code
> from low level driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
[...]
> diff --git a/drivers/spi/spi-txx9.c b/drivers/spi/spi-txx9.c
> index d5a3cbb..550b5f4 100644
> --- a/drivers/spi/spi-txx9.c
> +++ b/drivers/spi/spi-txx9.c
> @@ -189,9 +189,8 @@ static void txx9spi_work_one(struct txx9spi *c, struct spi_message *m)
>  		unsigned int len = t->len;
>  		unsigned int wsize;
>  		u32 speed_hz = t->speed_hz ? : spi->max_speed_hz;
> -		u8 bits_per_word = t->bits_per_word ? : spi->bits_per_word;
> +		u8 bits_per_word = t->bits_per_word;
>  
> -		bits_per_word = bits_per_word ? : 8;
>  		wsize = bits_per_word >> 3; /* in bytes */
>  
>  		if (prev_speed_hz != speed_hz
> @@ -316,9 +315,8 @@ static int txx9spi_transfer(struct spi_device *spi, struct spi_message *m)
>  	/* check each transfer's parameters */
>  	list_for_each_entry (t, &m->transfers, transfer_list) {
>  		u32 speed_hz = t->speed_hz ? : spi->max_speed_hz;
> -		u8 bits_per_word = t->bits_per_word ? : spi->bits_per_word;
> +		u8 bits_per_word = t->bits_per_word;
>  
> -		bits_per_word = bits_per_word ? : 8;

Have you verified here that bits_per_word can never be '0' here? What is
the path that ensures spi->bits_per_word (and hence t->bits_per_word) is
set to 8 here?

Otherwise the patch looks good. Thanks for doing this work.

g.

