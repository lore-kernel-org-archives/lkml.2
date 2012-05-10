Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2EJWtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:49:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57025 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2EJWts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:49:48 -0400
MIME-Version: 1.0
In-Reply-To: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 10 May 2012 18:49:16 -0400
X-Google-Sender-Auth: HsZEVQ51Jm0TxP9dCjI3Agyz5ho
Message-ID: <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
Subject: Re: [PATCH] TWL6040: fix build error
To: Sasha Levin <levinsasha928@gmail.com>
Cc: dmitry.torokhov@gmail.com, peter.ujfalusi@ti.com,
        broonie@opensource.wolfsonicro.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Fixes build error due to missing of_property_read_u32.

Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
this missing header, it needs to have a Kconfig dependency that limits
it to just being enabled on the platforms where it physically is possible to
have the hardware.  I'm guessing limiting to ARM would be a good start?

Thanks,
Paul.
--

>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/input/misc/twl6040-vibra.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
> index bb134ce..97447ee 100644
> --- a/drivers/input/misc/twl6040-vibra.c
> +++ b/drivers/input/misc/twl6040-vibra.c
> @@ -27,6 +27,7 @@
>  */
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> +#include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/workqueue.h>
>  #include <linux/input.h>
> --
> 1.7.8.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
