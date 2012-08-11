Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2HKJkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 05:40:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55356 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2HKJj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 05:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <201208060149.37972.rjw@sisk.pl>
References: <201207291612.43138.rjw@sisk.pl>
	<201208060138.03950.rjw@sisk.pl>
	<201208060149.37972.rjw@sisk.pl>
Date: Sat, 11 Aug 2012 11:39:55 +0200
X-Google-Sender-Auth: UUmKgyHcTumiUtzUo0DzO-lIKD8
Message-ID: <CAMuHMdUFeS6HNFuKVDLrFEo0f5=jrufa4QoD+aeZJHJD1Q1xCQ@mail.gmail.com>
Subject: Re: [PATCH 14/15] sh: MTU2: Basic runtime PM support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 1:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> @@ -341,8 +346,19 @@ static int __devinit sh_mtu2_probe(struc
>         if (ret) {
>                 kfree(p);
>                 platform_set_drvdata(pdev, NULL);
> +               pm_runtime_idle(&pdev->dev);
> +               return ret;
>         }
> -       return ret;
> +       if (is_early_platform_device(pdev))
> +               return 0;
> +
> + out:
> +       if (cfg->clockevent_rating)

drivers/clocksource/sh_mtu2.c:356:6: error: 'cfg' undeclared (first
use in this function)
http://kisskb.ellerman.id.au/kisskb/buildresult/6883515/

Presumably there's a

        struct sh_timer_config *cfg = p->pdev->dev.platform_data;

missing at the top of sh_mtu2_probe()

> +               pm_runtime_irq_safe(&pdev->dev);
> +       else
> +               pm_runtime_idle(&pdev->dev);
> +
> +       return 0;
>  }
>
>  static int __devexit sh_mtu2_remove(struct platform_device *pdev)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
