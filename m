Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab1FWDwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:52:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62511 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab1FWDwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <1308794413-11069-7-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-7-git-send-email-dirk.brandewie@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 22 Jun 2011 21:51:45 -0600
X-Google-Sender-Auth: lD9ItLT0rpi-1PNu7wiSaB5WEJE
Message-ID: <BANLkTin5CFVm6rVM_c6RRranJEor_jPF=Q@mail.gmail.com>
Subject: Re: [PATCH 06/11] spi-dw: Force error on out of range chip select.
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
> BUG_ON() if the selected chip select is out of range.
>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/spi/spi-dw.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
> index 860bc34..3fa4c13 100644
> --- a/drivers/spi/spi-dw.h
> +++ b/drivers/spi/spi-dw.h
> @@ -178,8 +178,7 @@ static inline void spi_dw_set_clk(struct spi_dw *dws, u16 div)
>
>  static inline void spi_dw_chip_sel(struct spi_dw *dws, u16 cs)
>  {
> -       if (cs > dws->num_cs)
> -               return;
> +       BUG_ON(cs >= dws->master->num_chipselect);

BUG is rather an over-reaction.  The transfer should be rejected if
the cs# is invalid, and a warning message is appropriate, but BUG() is
too extreme.

g.
