Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2K0WMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:12:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57165 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab2K0WLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:11:22 -0500
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:d18:13d2:3217:7b0e]
In-Reply-To: <1354045994-8977-1-git-send-email-dianders@chromium.org>
References: <1354045994-8977-1-git-send-email-dianders@chromium.org>
Date: Tue, 27 Nov 2012 14:11:22 -0800
Message-ID: <CAOesGMjyXZwKjycyVcEV0ty0LCM_i61QxykYPhAvXxx2rhgP+A@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Avoid early use of of_machine_is_compatible()
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 11:53 AM, Doug Anderson <dianders@chromium.org> wrote:
> The recent commit "ARM: EXYNOS: add support for EXYNOS5440 SoC" broke
> support for exynos5250 because of_machine_is_compatible() was used too
> early in the boot process.  It also probably meant that the exynos5440
> failed to use the proper iotable.  Switch to use
> of_flat_dt_is_compatible() in both of these cases.
>
> The failure I was seeing in exynos5250 because of this was:
>   Division by zero in kernel.
>   [<80015ed4>] (unwind_backtrace+0x0/0xec) from [<8045c7a4>] (dump_stack+0x20/0x24)
>   [<8045c7a4>] (dump_stack+0x20/0x24) from [<80012990>] (__div0+0x20/0x28)
>   [<80012990>] (__div0+0x20/0x28) from [<8021ab04>] (Ldiv0_64+0x8/0x18)
>   [<8021ab04>] (Ldiv0_64+0x8/0x18) from [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134)
>   [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134) from [<8006865c>] (__clocksource_register_scale+0x1c/0x54)
>   [<8006865c>] (__clocksource_register_scale+0x1c/0x54) from [<80612a18>] (exynos_timer_init+0x100/0x1e8)
>   [<80612a18>] (exynos_timer_init+0x100/0x1e8) from [<8060d184>] (time_init+0x28/0x38)
>   [<8060d184>] (time_init+0x28/0x38) from [<8060a754>] (start_kernel+0x1e0/0x3c8)
>   [<8060a754>] (start_kernel+0x1e0/0x3c8) from [<40008078>] (0x40008078)
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Thanks Doug.

Kukjin, I'll apply this directly on top of the previous branch in
arm-soc, if that's OK with you.


-Olof
