Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1AQG72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:59:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43065 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1AQG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:59:26 -0500
MIME-Version: 1.0
In-Reply-To: <1295245760-4566-1-git-send-email-thomas@wytron.com.tw>
References: <4D040D1C.2020705@home.nl> <1295245760-4566-1-git-send-email-thomas@wytron.com.tw>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 16 Jan 2011 23:59:05 -0700
X-Google-Sender-Auth: LH8y8PAaSLQewIkYmSbo2w5YUqQ
Message-ID: <AANLkTi=8+Q5dm+5Pa-cYkmaBWQ4S7jgjZOL0ovtmrdxB@mail.gmail.com>
Subject: Re: [PATCH] alter_ps2: Add devicetree support
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 11:29 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> From: Walter Goossens <waltergoossens@home.nl>
>
> Signed-off-by: Walter Goossens <waltergoossens@home.nl>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
>  drivers/input/serio/altera_ps2.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
> index 7998560..93054a1 100644
> --- a/drivers/input/serio/altera_ps2.c
> +++ b/drivers/input/serio/altera_ps2.c
> @@ -19,6 +19,9 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#ifdef CONFIG_OF
> +#include <linux/of.h>
> +#endif
>
>  #define DRV_NAME "altera_ps2"
>
> @@ -173,6 +176,16 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>        return 0;
>  }
>
> +#ifdef CONFIG_OF
> +static struct of_device_id altera_ps2_match[] = {
> +       {
> +               .compatible = "altera,altera_ps2",
> +       },

So is this an FPGA soft core PS2 device?  Is there any kind of version
attached to the soft core?  The compatible value should specify an
exact version of the implementation that this driver works with.
(Newer core versions can claim compatibility with older ones, so the
driver's compatible list doesn't need to be exhaustive).

Otherwise, this patch looks correct.

g.

> +       {},
> +}
> +MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
> +#endif /* CONFIG_OF */
> +
>  /*
>  * Our device driver structure
>  */
> @@ -182,6 +195,9 @@ static struct platform_driver altera_ps2_driver = {
>        .driver = {
>                .name   = DRV_NAME,
>                .owner  = THIS_MODULE,
> +#ifdef CONFIG_OF
> +               .of_match_table = altera_ps2_match,
> +#endif
>        },
>  };
>
> --
> 1.7.3.4
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
