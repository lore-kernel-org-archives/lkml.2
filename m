Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3AIKTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:19:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3AIKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:19:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
Date: Wed, 9 Jan 2013 10:18:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, sameo@linux.intel.com
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org> <1357725965-27342-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1357725965-27342-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091018.55058.arnd@arndb.de>
X-Provags-ID: V02:K0:jhajq32Xz6S1IpSa9Kt3H4iD1SUgSygSV0R/x+sQxz+
 pGROr9Ewwi+aOGf2LKFqNj04954EXwlInbxZbGoJdg6j08u1Ah
 LvUVhag8S2aLx0FcO1V/un/jO3qNDNmu9+yTkvbn2W5clOvZ+K
 kxDU+ZvDlzRgZf1Vqe3FiAjdv1ESkli5zlhoQOkpOLi/s/5D00
 a9z31zQvUavpMWzR/7B0NfErnQPJ3K68Bqzify0abRgdzJRdaj
 4eTPhnTGYXPtqLwG6f4rNyITKjPXR2h7s24g+9v78LmPULS8ne
 ZWkwI6ptsmaUsRID5uhkQli2UQPpXvNjGVlS5Q895B6ycIMnaI
 8m4d108iqDaPYO79gba4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Lee Jones wrote:
> diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
> index 5dea906..0f25b07 100644
> --- a/arch/arm/mach-ux500/Kconfig
> +++ b/arch/arm/mach-ux500/Kconfig
> @@ -43,6 +43,8 @@ config MACH_HREFV60
>  config MACH_SNOWBALL
>         bool "U8500 Snowball platform"
>         select MACH_MOP500
> +       select LEDS_TRIGGERS
> +       select LEDS_TRIGGER_HEARTBEAT
>         help
>           Include support for the snowball development platform.

Be careful with "select" statements like this when there are other
dependencies. I think LEDS_TRIGGERS depends on LEDS_CLASS, so this
should probably be written as

	select LEDS_TRIGGERS if LEDS_CLASS

	Arnd
