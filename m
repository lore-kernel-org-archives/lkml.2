Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0IHEzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 00:55:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33107 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0IHEzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 00:55:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cz9CmwUGnAcwwLKwoT7GIq2ZDqq0iVvNwa4AK07pnnTmdLyRkAvQet2dAZFE/36t0k
         JBK0a404Lu2Nja2oVudbMdSVCWzimqn7aURpCBTGy2lZfYdEOUO9reN3+QlB13zicnhT
         dD5b111ZwpvSB+NRNrMHsCs0FijieDeM1ksbQ=
MIME-Version: 1.0
In-Reply-To: <1283855357-15179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1283855357-15179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 8 Sep 2010 13:55:39 +0900
Message-ID: <AANLkTim=ArPyqC7K-aaer97deGeR6yU-FS1Hpm3D_1ER@mail.gmail.com>
Subject: Re: [PATCH] spi/spi_s3c64xx: Move to subsys_initcall()
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jassi Brar <jassi.brar@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 7:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Allow the use of the S3C64xx SPI controller with things like PMICs by
> moving the init up to subsys_initcall().
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>
> Incidentally I don't seem to see anything in the current SPI tree for
> -next - should the tree being used be updated or something?
>
>  drivers/spi/spi_s3c64xx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
> index f72e1c0..6e48ea9 100644
> --- a/drivers/spi/spi_s3c64xx.c
> +++ b/drivers/spi/spi_s3c64xx.c
> @@ -1181,7 +1181,7 @@ static int __init s3c64xx_spi_init(void)
>  {
>        return platform_driver_probe(&s3c64xx_spi_driver, s3c64xx_spi_probe);
>  }
> -module_init(s3c64xx_spi_init);
> +subsys_initcall(s3c64xx_spi_init);

Couldn't any user ever need to load it as a module?
If no, we might as well drop the s3c64xx_spi_exit and s3c64xx_spi_remove
as well and save space. Rather going a step further, shouldn't then all
spi drivers be that way? Two steps further, why not every 'bus-driver' ?
