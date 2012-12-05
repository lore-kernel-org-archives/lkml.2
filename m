Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2LEDFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 22:05:05 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54592 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2LEDFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 22:05:01 -0500
MIME-Version: 1.0
In-Reply-To: <loom.20121204T170759-102@post.gmane.org>
References: <1354264973-11214-1-git-send-email-a.kesavan@samsung.com>
	<000101cdd202$dc6e8310$954b8930$%choi@samsung.com>
	<loom.20121204T170759-102@post.gmane.org>
Date: Wed, 5 Dec 2012 08:35:00 +0530
Message-ID: <CAM4voamXYaULm0WEA1EnHbAa5feOkouSvtSiuJ0u4wWrgjeQ4A@mail.gmail.com>
Subject: Re: [PATCH RFC] PM/Devfreq: Add Exynos5-bus devfreq driver for Exynos5250.
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: jhbird.choi@samsung.com, myungjoo.ham@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: kyungmin.park@samsung.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing missed out recipients

---------- Forwarded message ----------
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Date: Tue, Dec 4, 2012 at 9:48 PM
Subject: Re: [PATCH RFC] PM/Devfreq: Add Exynos5-bus devfreq driver
for Exynos5250.
To: linux-pm@vger.kernel.org


Jonghwan Choi <jhbird.choi <at> samsung.com> writes:

>
>
> Hi Abhilash Kesavan.
Hi,
>
> I compiled in 3.7-rc8
> I got a compile error & warning.
>
> Compile error.
>
> CC      drivers/devfreq/exynos5_ppmu.o
> drivers/devfreq/exynos5_ppmu.c:56:14: error: 'S5P_VA_PPMU_DDR_C' undeclared
> here (not in a function)
> drivers/devfreq/exynos5_ppmu.c:59:14: error: 'S5P_VA_PPMU_DDR_R1' undeclared
> here (not in a function)
> drivers/devfreq/exynos5_ppmu.c:62:13: error: 'S5P_VA_PPMU_DDR_L' undeclared
> here (not in a function)
> drivers/devfreq/exynos5_ppmu.c:65:13: error: 'S5P_VA_PPMU_RIGHT' undeclared
> here (not in a function)
> drivers/devfreq/exynos5_ppmu.c:68:14: error: 'S5P_VA_PPMU_CPU' undeclared
> here (not in a function)
> make[2]: *** [drivers/devfreq/exynos5_ppmu.o] Error 1
I have submitted only the driver changes. As mentioned in the commit message I
will post the arch side changes after the drivers gets a complete review.
However, if you want to test the driver I will post it tommorrow.

[...]
> drivers/devfreq/exynos5_bus.c: In function 'exynos5_busfreq_int_probe':
> drivers/devfreq/exynos5_bus.c:388:9: warning: passing argument 3 of
> 'devfreq_add_device' from incompatible pointer type [enabled by default]
> include/linux/devfreq.h:170:24: note: expected 'struct devfreq_governor
> const *' but argument is of type 'char *'
[...]
> Need change?
These changes are based on
git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git : for-rafael
devfreq_add_device prototype has recently changed and that might be the cause of
the compilation error. Can you please try on this tree.

> How to change the INT clock? I think you have to change
> arch/arm/mach-exynos/clock-exynos5250.c
> (If you want to control via clock framework.)
[...]
> exynos5_int_clk.ops = &exynos5_clk_int_ops;
This is part of the arch side patch that has not been posted.

Regards,
Abhilash

--
To unsubscribe from this list: send the line "unsubscribe linux-pm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
