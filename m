Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2HVFAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:00:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41451 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab2HVFAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0AF3@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0AF3@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 22 Aug 2012 12:59:43 +0800
X-Google-Sender-Auth: q_NgNVhaoGLVGytvD18B0ZEjc9E
Message-ID: <CAK5ve-J83jd4wGtkTdycuYpS6Yt3t8FqAQP_asQn-kXbgfP3fw@mail.gmail.com>
Subject: Re: [PATCH 3/4] leds-lp5523: change the return type of lp5523_set_mode()
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 5:03 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> The return value of this function is not handled any place, so
> make it as void type.
>
> And three if-statements are replaced with switch-statements.
>

This one looks fine with me. I will merge it after you rework on first 2 patches

Thanks,
-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index f090819..f8231f1 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -150,7 +150,7 @@ static inline struct lp5523_chip *led_to_lp5523(struct lp5523_led *led)
>                             leds[led->id]);
>  }
>
> -static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
> +static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
>  static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
>  static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern);
>
> @@ -789,26 +789,28 @@ static void lp5523_unregister_sysfs(struct i2c_client *client)
>  /*--------------------------------------------------------------*/
>  /*                     Set chip operating mode                 */
>  /*--------------------------------------------------------------*/
> -static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
> +static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
>  {
> -       int ret = 0;
> -
>         /* if in that mode already do nothing, except for run */
>         if (mode == engine->mode && mode != LP5523_CMD_RUN)
> -               return 0;
> +               return;
>
> -       if (mode == LP5523_CMD_RUN) {
> -               ret = lp5523_run_program(engine);
> -       } else if (mode == LP5523_CMD_LOAD) {
> +       switch (mode) {
> +       case LP5523_CMD_RUN:
> +               lp5523_run_program(engine);
> +               break;
> +       case LP5523_CMD_LOAD:
>                 lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
>                 lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
> -       } else if (mode == LP5523_CMD_DISABLED) {
> +               break;
> +       case LP5523_CMD_DISABLED:
>                 lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
> +               break;
> +       default:
> +               return;
>         }
>
>         engine->mode = mode;
> -
> -       return ret;
>  }
>
>  /*--------------------------------------------------------------*/
> --
> 1.7.2.5
>
>
> Best Regards,
> Milo
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
