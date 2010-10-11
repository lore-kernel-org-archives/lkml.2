Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0JKVWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:22:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43537 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab0JKVWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:22:42 -0400
Subject: Re: [PATCH] regulator: fix build when CONFIG_REGULATOR_DUMMY=n
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <1286814955-23415-1-git-send-email-gadiyar@ti.com>
References: <1286814955-23415-1-git-send-email-gadiyar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 22:22:35 +0100
Message-ID: <1286832155.3283.21.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 22:05 +0530, Anand Gadiyar wrote:
> Commit f03f91826 (regulator: Add option for machine drivers
> to enable the dummy regulator) in the regulators tree
> seems to have introduced the following build break when
> CONFIG_REGULATOR_DUMMY is disabled. Fix this.
> 
>   CC      drivers/regulator/dummy.o
> drivers/regulator/dummy.c:41: error: redefinition of 'regulator_dummy_init'
> drivers/regulator/dummy.h:28: note: previous definition of 'regulator_dummy_init' was here
> make[2]: *** [drivers/regulator/dummy.o] Error 1
> make[1]: *** [drivers/regulator] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> The commit referenced above is in linux next as of 20101011
> and breaks builds of the omap2plus_defconfig at least.
> 
>  drivers/regulator/dummy.h |    4 ----
>  1 file changed, 4 deletions(-)
> 
> Index: mainline/drivers/regulator/dummy.h
> ===================================================================
> --- mainline.orig/drivers/regulator/dummy.h
> +++ mainline/drivers/regulator/dummy.h
> @@ -22,10 +22,6 @@ struct regulator_dev;
>  
>  extern struct regulator_dev *dummy_regulator_rdev;
>  
> -#ifdef CONFIG_REGULATOR_DUMMY
>  void __init regulator_dummy_init(void);
> -#else
> -static inline void regulator_dummy_init(void) { }
> -#endif
>  
>  #endif

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

