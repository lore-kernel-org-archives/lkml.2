Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2KZNB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:01:59 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51945 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2KZNB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:01:58 -0500
MIME-Version: 1.0
In-Reply-To: <1353559384-26570-1-git-send-email-tushar.behera@linaro.org>
References: <1353559384-26570-1-git-send-email-tushar.behera@linaro.org>
Date: Mon, 26 Nov 2012 18:31:56 +0530
Message-ID: <CAM=Q2csrtLOCvQpkSfLfE3teCYU1GUzdVaBpuWwocLy2j-9Wuw@mail.gmail.com>
Subject: Re: [PATCH] watchdog: da9052: Fix invalid free of devm_ allocated data
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        wim@iguana.be, patches@linaro.org, Anthony.Olech@diasemi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 10:13 AM, Tushar Behera
<tushar.behera@linaro.org> wrote:
> It is not required to free devm_ allocated data. Since kref_put
> needs a valid release function, da9052_wdt_release_resources()
> is not deleted.
>
> Fixes following warning.
> drivers/watchdog/da9052_wdt.c:59:1-6: WARNING: invalid free of
> devm_ allocated data
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/watchdog/da9052_wdt.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
> index f7abbae..20071de 100644
> --- a/drivers/watchdog/da9052_wdt.c
> +++ b/drivers/watchdog/da9052_wdt.c
> @@ -53,10 +53,6 @@ static const struct {
>
>  static void da9052_wdt_release_resources(struct kref *r)
>  {
> -       struct da9052_wdt_data *driver_data =
> -               container_of(r, struct da9052_wdt_data, kref);
> -
> -       kfree(driver_data);

However now the function will be empty right?


>  }
>
>  static int da9052_wdt_set_timeout(struct watchdog_device *wdt_dev,
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
