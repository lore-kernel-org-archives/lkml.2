Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2GTQXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:23:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63754 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2GTQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:23:22 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FDA9E@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FDA9E@DQHE02.ent.ti.com>
Date: Fri, 20 Jul 2012 22:08:21 +0545
Message-ID: <CAHdPZaPBocAybfr8cnxWh4cP7pC6=1r+65Nt_+Ajxz7G9J9x1Q@mail.gmail.com>
Subject: Re: [PATCH v2] leds: add new lp8788 led driver
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think a mutex_unlock is missed out,

On Fri, Jul 20, 2012 at 2:28 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> +
> +static void lp8788_led_work(struct work_struct *work)
> +{
> +       struct lp8788_led *led = container_of(work, struct lp8788_led, work);
> +       enum lp8788_isink_number num = led->isink_num;
> +       int enable;
> +       u8 val = led->brightness;
> +
> +       mutex_lock(&led->lock);
> +
> +       switch (num) {
> +       case LP8788_ISINK_1:
> +       case LP8788_ISINK_2:
> +       case LP8788_ISINK_3:
> +               lp8788_write_byte(led->lp, lp8788_pwm_addr[num], val);
> +               break;
> +       default:
                    missed mutex_unlock
> +               return;
> +       }
> +
> +       enable = (val > 0) ? 1 : 0;
> +       if (enable != led->on)
> +               lp8788_led_enable(led, num, enable);
> +
> +       mutex_unlock(&led->lock);
> +}
> +

Thanks,
Devendra
