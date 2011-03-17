Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1CQPHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:07:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62041 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1CQPHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ws57jJHgXo9p+oM8ZWpc0oXBjO6oL8ryqNwbw0PyfjdrCTOmZJOXk8IVGSp0hjocZq
         0d50y6DLJhjlAPCdw/7hTdsFBLyutAQK2nvZ8gNih6CnmaicA24F3cctG9rHUVvEDF7V
         /PIgR6oSG1Zmz6JhclR/MBpBzedOR0xXaceFA=
MIME-Version: 1.0
In-Reply-To: <1299477371.10486.2.camel@mola>
References: <1299477315.10486.1.camel@mola> <1299477371.10486.2.camel@mola>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 17 Mar 2011 23:06:51 +0800
Message-ID: <AANLkTikQiFxEhn5pMDQY6K_oB+i4r1Y64aA+98FyAxDk@mail.gmail.com>
Subject: Re: [PATCH 2/2] [ARM] am300epd: fix resource leak in
 am300_init_gpio_regs error path
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2HF7L8M010324

Applied.

On Mon, Mar 7, 2011 at 1:56 PM, Axel Lin <axel.lin@gmail.com> wrote:
> If gpio_request fails when i > 0, gpios[0] is not freed in current
> implementation.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Â arch/arm/mach-pxa/am300epd.c | Â  13 +++++++------
> Â 1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
> index 993d75e..fa8bad2 100644
> --- a/arch/arm/mach-pxa/am300epd.c
> +++ b/arch/arm/mach-pxa/am300epd.c
> @@ -125,10 +125,7 @@ static int am300_init_gpio_regs(struct broadsheetfb_par *par)
> Â  Â  Â  Â  Â  Â  Â  Â if (err) {
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â dev_err(&am300_device->dev, "failed requesting "
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â "gpio %d, err=%d\n", i, err);
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  while (i >= DB0_GPIO_PIN)
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  gpio_free(i--);
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  i = ARRAY_SIZE(gpios) - 1;
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto err_req_gpio;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto err_req_gpio2;
> Â  Â  Â  Â  Â  Â  Â  Â }
> Â  Â  Â  Â }
>
> @@ -159,9 +156,13 @@ static int am300_init_gpio_regs(struct broadsheetfb_par *par)
>
> Â  Â  Â  Â return 0;
>
> +err_req_gpio2:
> + Â  Â  Â  while (--i >= DB0_GPIO_PIN)
> + Â  Â  Â  Â  Â  Â  Â  gpio_free(i);
> + Â  Â  Â  i = ARRAY_SIZE(gpios);
> Â err_req_gpio:
> - Â  Â  Â  while (i > 0)
> - Â  Â  Â  Â  Â  Â  Â  gpio_free(gpios[i--]);
> + Â  Â  Â  while (--i >= 0)
> + Â  Â  Â  Â  Â  Â  Â  gpio_free(gpios[i]);
>
> Â  Â  Â  Â return err;
> Â }
> --
> 1.7.2
>
>
>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
