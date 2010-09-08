Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0IHBo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:44:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51350 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0IHBo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dn/l7x+ZTKhePWBViQD6FkGHI36NIuqK4ADX9m75scaCBtMtN2nzw/Ji0zU3LyP0ds
         aOSjgKbpMaIPk+PDBPfDjykHA35mdyDsYKe9YqUl+3KQ0x3FDDFRrWvHq4ivSIbXbrOJ
         JlWtyOUWiFfJuU+A1VDo+BUfdiyM4iRPhagkA=
MIME-Version: 1.0
In-Reply-To: <1283873872-8633-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1283873872-8633-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 8 Sep 2010 10:44:26 +0900
Message-ID: <AANLkTimxXWjiX64wJcNui2mLrvVg9RUtN9fFVnLhZsBY@mail.gmail.com>
Subject: Re: [PATCH 2/2] spi/spi_s3c64xx: Increase dead reckoning time in wait_for_xfer()
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Jassi Brar <jassi.brar@samsung.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 12:37 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> For small transfers at high speeds the expected transfer time can easily
> be well under 1ms, causing the delay in wait_for_xfer() to be only the
> dead reckoning fudge factor of 5ms currently included. Experiments on
> some of my systems shows that this is marginal for some transfers so
> double it to 10ms.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/spi/spi_s3c64xx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> index 03b28e4..4abb441 100644
> --- a/drivers/spi/spi_s3c64xx.c
> +++ b/drivers/spi/spi_s3c64xx.c
> @@ -326,7 +326,7 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
>
>        /* millisecs to xfer 'len' bytes @ 'cur_speed' */
>        ms = xfer->len * 8 * 1000 / sdd->cur_speed;
> -       ms += 5; /* some tolerance */
> +       ms += 10; /* some tolerance */
>
>        if (dma_mode) {
>                val = msecs_to_jiffies(ms) + 10;

Acked-by: Jassi Brar <jassi.brar@samsung.com>
