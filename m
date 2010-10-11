Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0JKQyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:54:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0JKQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:54:37 -0400
Date: Mon, 11 Oct 2010 09:53:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: fix build when CONFIG_REGULATOR_DUMMY=n
Message-Id: <20101011095315.3a34bceb.randy.dunlap@oracle.com>
In-Reply-To: <1286814955-23415-1-git-send-email-gadiyar@ti.com>
References: <1286814955-23415-1-git-send-email-gadiyar@ti.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 22:05:55 +0530 Anand Gadiyar wrote:

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
> --

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
