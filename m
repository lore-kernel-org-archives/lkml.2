Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2A3RZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:25:37 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60301 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352Ab2A3RZf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:25:35 -0500
MIME-Version: 1.0
In-Reply-To: <7103a353d393f9b8366b141a608a4370e4392c7b.1327348286.git.vjaquez@igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
	<7103a353d393f9b8366b141a608a4370e4392c7b.1327348286.git.vjaquez@igalia.com>
Date: Mon, 30 Jan 2012 11:25:34 -0600
Message-ID: <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] staging: tidspbridge: Lindent to drv_interface.c
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: =?ISO-8859-1?Q?V=EDctor_Manuel_J=E1quez_Leal?= <vjaquez@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/23 Víctor Manuel Jáquez Leal <vjaquez@igalia.com>:
> No functional changes.
>
> According to Lindent, the file drv_internface.c had some lines with bad
> indentation.
>
> This commit is the output of Lindent.

Usually lindent tends to do whatever it wants, unless carefully configured...

...
> @@ -342,9 +342,10 @@ static void bridge_recover(struct work_struct *work)
>        if (atomic_read(&bridge_cref)) {
>                INIT_COMPLETION(bridge_comp);
>                while (!wait_for_completion_timeout(&bridge_comp,
> -                                               msecs_to_jiffies(REC_TIMEOUT)))
> -                       pr_info("%s:%d handle(s) still opened\n",
> -                                       __func__, atomic_read(&bridge_cref));
> +                                                   msecs_to_jiffies
> +                                                   (REC_TIMEOUT)))

Like here, it just split msecs_to_jiffies(REC_TIMEOUT) into 2 lines
making it a little harder to read.

> +                       pr_info("%s:%d handle(s) still opened\n", __func__,
> +                               atomic_read(&bridge_cref));

I remember the rule was to break lines as far to the right as
possible, no? Chapter 2 CodingStyle, same for the other similar
changes.

...
> @@ -547,10 +548,9 @@ static int __devexit omap34_xx_bridge_remove(struct platform_device *pdev)
>                pr_err("%s: Failed to retrieve the object handle\n", __func__);
>                goto func_cont;
>        }
> -

Blank line removed?

>  #ifdef CONFIG_TIDSPBRIDGE_DVFS
>        if (cpufreq_unregister_notifier(&iva_clk_notifier,
> -                                               CPUFREQ_TRANSITION_NOTIFIER))
> +                                       CPUFREQ_TRANSITION_NOTIFIER))
>                pr_err("%s: cpufreq_unregister_notifier failed for iva2_ck\n",
>                       __func__);
>  #endif /* #ifdef CONFIG_TIDSPBRIDGE_DVFS */
> --
> 1.7.8.3
>

Regards,

Omar
