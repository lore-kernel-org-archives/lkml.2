Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab2HHSL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:11:28 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:37074 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244Ab2HHSL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:11:26 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arm@kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH 11/11] pm/drivers: fix use of SIMPLE_DEV_PM_OPS
Organization: Texas Instruments, Inc.
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
	<1344437248-20560-12-git-send-email-arnd@arndb.de>
Date: Wed, 08 Aug 2012 11:11:25 -0700
In-Reply-To: <1344437248-20560-12-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Wed, 8 Aug 2012 16:47:28 +0200")
Message-ID: <87obmluucy.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> A few drivers use a construct like
>
>  #ifdef CONFIG_PM
>  static int foo_suspend(struct device *pdev)
>  {
>     ...
>  }
>  static int foo_resume struct device *pdev)
>  {
>     ...
>  }
>  #endif
>  static SIMPLE_DEV_PM_OPS(foo_pm, foo_suspend, foo_resume);
>
> which leaves the two functions unused if CONFIG_PM is enabled
> but CONFIG_PM_SLEEP is disabled. I found this while building
> all defconfig files on ARM. It's not clear to me if this is
> the right solution, but at least it makes the code consistent
> again.
>
> Without this patch, building omap1_defconfig results in:
>
> drivers/char/hw_random/omap-rng.c:165:12: warning: 'omap_rng_suspend' defined but not used [-Wunused-function]
> drivers/char/hw_random/omap-rng.c:171:12: warning: 'omap_rng_resume' defined but not used [-Wunused-function]
> sound/drivers/dummy.c:1068:12: warning: 'snd_dummy_suspend' defined but not used [-Wunused-function]
> sound/drivers/dummy.c:1078:12: warning: 'snd_dummy_resume' defined but not used [-Wunused-function]
>
> and building tegra_defconfig results in:
>
> drivers/i2c/busses/i2c-tegra.c:716:12: warning: 'tegra_i2c_suspend' defined but not used [-Wunused-function]
> drivers/i2c/busses/i2c-tegra.c:727:12: warning: 'tegra_i2c_resume' defined but not used [-Wunused-function]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/char/hw_random/omap-rng.c |    2 +-

For the OMAP change,

Acked-by: Kevin Hilman <khilman@ti.com>

