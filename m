Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2G2PwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 11:52:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56173 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2G2PwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 11:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120724125504.11014.60700.stgit@localhost.localdomain>
References: <20120724125504.11014.60700.stgit@localhost.localdomain>
Date: Sun, 29 Jul 2012 17:52:20 +0200
Message-ID: <CACRpkdYqTNVpTF+NA34kCzKfuyD0aazv82GsyKFQt=mXeUR6vg@mail.gmail.com>
Subject: Re: [PATCH] gpio-sch: Fix leak of resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 2:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>
>  drivers/gpio/gpio-sch.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> index 424dce8..8707d45 100644
> --- a/drivers/gpio/gpio-sch.c
> +++ b/drivers/gpio/gpio-sch.c
> @@ -241,7 +241,8 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)
>                         break;
>
>                 default:
> -                       return -ENODEV;
> +                       err = -ENODEV;
> +                       goto err_sch_gpio_core;
>         }
>
>         sch_gpio_core.dev = &pdev->dev;

Applied to my fixes branch, CCing the list if there are complaints.

Yours,
Linus Walleij
