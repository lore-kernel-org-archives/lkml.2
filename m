Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2IJOBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:01:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2IJOBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:01:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rajanikanth HV <rajanikanth.hv@linaro.org>
Subject: Re: mfd: Implement devicetree support for AB8500 Btemp
Date: Mon, 10 Sep 2012 14:01:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        linus.walleij@stericsson.com, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, Patch Tracking <patches@linaro.org>
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com>
In-Reply-To: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101401.06859.arnd@arndb.de>
X-Provags-ID: V02:K0:VvHB0ALhO10c+TJ7j1M7EhgfXJlWLtE8pPMWxHlJEUt
 HWgxGv7yBID3xbqLCc4QppYWAyTeTE3ecXHZswG+/ircXED/yf
 I4YsoDgem9sSdF/AGHXz/WaBKhrJY1Zos5uwfHp7K7pJPHR644
 BYHYVt0G0tIv1Os8l6QtNqw0aHS0SSVgBaDD9liuDa2Lr+KzHa
 FJXrNPd+x7CVdZtXvUb50hR0sRRKi8Gykm6WUy4NQwFQx+NPOs
 Qz1vwgRi7v+wrBIed8LNdM0EpiA61cMKIuKp7rob+Cpc+7trlI
 hlEHjLrvC1BE9eDvgO7YS7ixssx/8d17D85US5j9p/TbCIECfk
 RSwHkNEKIVjUDgoCIJ78=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Rajanikanth HV wrote:
> +
> +supplied-to:
> +       This is a logical binding w.r.t power supply event change
> +       across energy-management-module drivers where in the
> +       runtime battery properties are shared along with uevent
> +       notification.
> +       ref: di->btemp_psy.external_power_changed =
> +               ab8500_btemp_external_power_changed;
> +               ab8500_btemp.c
> +
> +       Need for this property:
> +               btemp, fg and charger updates power-supply properties
> +               based on the events listed above.
> +               Event handler invokes power supply change notifier
> +               which in-turn invokes registered power supply class call-back
> +               based on the 'supplied_to' string.
> +               ref:
> +               power_supply_changed_work(..) ./drivers/power/power_supply_core.c
> +
> +       example:
> +       ab8500-btemp {
> +               /* Other enery management module */
> +               supplied-to = "ab8500_chargalg", "ab8500_fg";
> +               num_supplicants = <2>;
> +       };
> +

This looks like you're doing things the opposite way from everyone else.
Normally, each device uses phandles to refer to other objects it depends
on (gpio lines, regulators, clocks, interrupts, ...), rather than listing
things that depend on it.

Can you turn this around to be more like the others?

Note also that device tree identifiers should use '-' as a word separator,
not '_', and that a binding document should specify the exact set of
possible values. If the properties contain strings, please list every
valid string.

> +               thermister-internal-to-battery = <1>;
> +               li_ion_9100_battery = <0>;

Boolean properties should be empty when enabled and not present when
disabled. In this example, one would just write

		thermister-internal-to-battery;


	Arnd
