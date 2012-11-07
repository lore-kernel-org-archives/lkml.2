Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2KGP6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:58:25 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54917 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2KGP6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:58:23 -0500
MIME-Version: 1.0
In-Reply-To: <1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de>
References: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de>
	<1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de>
Date: Wed, 7 Nov 2012 13:58:22 -0200
Message-ID: <CAAAP30F1aGZ7-FyjV5pLq9vPLARWA_bb6cPGB9EnnQk0QKMKBg@mail.gmail.com>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>, Roland Stigge <stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 1:25 PM, Alban Bedel
<alban.bedel@avionic-design.de> wrote:
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>  drivers/pwm/pwm-lpc32xx.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> index adb87f0..0dc278d 100644
> --- a/drivers/pwm/pwm-lpc32xx.c
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>
>         c = 256 * duty_ns;
>         do_div(c, period_ns);
> -       duty_cycles = c;
> +       if (c == 0)
> +               c = 256;
> +       if (c > 255)
> +               c = 255;
> +       duty_cycles = 256 - c;
>
>         writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
>                 lpc32xx->base + (pwm->hwpwm << 2));
> --
> 1.7.0.4
>
