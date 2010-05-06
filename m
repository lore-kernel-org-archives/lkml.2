Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab0EFS0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:26:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56756 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab0EFS0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JPt/qEfCnt0tc3ku9fbrxfJVm4h4J/AmIH43Q6K4o1y4SFefDlRVZJDxXgfiPX1pY+
         cwwg5EDXesDUcmPkyefT9K8IAAqHmV8iR8kJbouLs6KOwynEah1y5UJyuYLBeGoEYJHL
         YZJS4BUScGQ6n9lacpZIDXoh7Dz/NM4fYPlwg=
MIME-Version: 1.0
In-Reply-To: <1273142265-11929-1-git-send-email-os@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 6 May 2010 14:26:00 -0400
Message-ID: <n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com>
Subject: Re: [PATCH] ad7877: fix spi word size to 16 bit
To: Oskar Schirmer <os@emlix.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 06:37, Oskar Schirmer wrote:
> --- a/drivers/input/touchscreen/ad7877.c
> +++ b/drivers/input/touchscreen/ad7877.c
> @@ -669,6 +669,8 @@ static int __devinit ad7877_probe(struct spi_device *spi)
>                dev_dbg(&spi->dev, "SPI CLK %d Hz?\n",spi->max_speed_hz);
>                return -EINVAL;
>        }
> +       spi->bits_per_word = 16;
> +       spi_setup(spi);

i think it'd be a better idea to do something like:
  if (spi->bits_per_word != 16) {
    if (spi->bits_per_word) {
      dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
      return -EINVAL;
    }
    spi->bits_per_word = 16;
    spi_setup(spi);
  }
-mike
