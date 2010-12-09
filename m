Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0LINQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:16:21 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:50114 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab0LINQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iLA3wLDsVbCYXCm6eacVHaiqd1Qq7L5j1zJSsui1JWMsX2C4tO75qWL+aMrPbjOc2c
         GO0X2qoNHO+igwLa5g3UrvkyqZVNW/Mna3yvoasa3FvbSibFTdsN36H5tCxpPM1vZj5k
         7pL+omE6uBLRkbzNBRIErqjEawaVNOGuuWRgc=
MIME-Version: 1.0
In-Reply-To: <1291899510-19861-1-git-send-email-aaro.koskinen@nokia.com>
References: <1291899510-19861-1-git-send-email-aaro.koskinen@nokia.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 9 Dec 2010 21:15:59 +0800
Message-ID: <AANLkTikxfS6rHrUv7YxW-_+GxPVCh9h7BAV8Cm1APgNo@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: gpio_request_one(): add missing gpio_free()
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 8:58 PM, Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
> If GPIO request succeeds, but configuration fails, it should be released.
>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/gpio/gpiolib.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 21da9c1..649550e 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1281,6 +1281,9 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
>                err = gpio_direction_output(gpio,
>                                (flags & GPIOF_INIT_HIGH) ? 1 : 0);
>
> +       if (err)
> +               gpio_free(gpio);
> +
>        return err;
>  }
>  EXPORT_SYMBOL_GPL(gpio_request_one);
> --
> 1.5.6.5
>
>
