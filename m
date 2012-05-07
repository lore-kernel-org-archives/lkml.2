Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2EGVQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:16:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62336 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab2EGVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:16:53 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v3 0/3] Add imx cpuidle
Date: Mon,  7 May 2012 16:16:44 -0500
Message-Id: <1336425407-20308-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common imx cpuidle initialization functionality and add a i.MX5 and i.MX6Q
platform cpuidle implementation.

Based on v3.4-rc6 plus recently submitted device tree late_initcall patch:
 http://www.spinics.net/lists/arm-kernel/msg171620.html

v3 changes:
 * removed file introduced in v1 no longer needed after v2 [per Shawn Guo]
 * re-ordered added #includes in alphabetical order [per Shawn Guo]
 * Remove if(!drv) check to allow handling by stack trace [per Sascha Hauer]
 * Added missing return value in error meesage [per Shawn Guo]
 * fixed (void *) casting problem pointed out Sasha Hauer.  Used a different
   type of casting to properly give warning on improper casting:
   	arm_pm_idle = (void (*)(void))imx5_idle;
   Used this casting instead of adding a dummy caller function because
   adding the dummy function appears to unnecessarily introduce the following
   additional operations:
	static void imx5_pm_idle(void)
	{
	  a0:	e1a0c00d 	mov	ip, sp
	  a4:	e92dd800 	push	{fp, ip, lr, pc}
	  a8:	e24cb004 	sub	fp, ip, #4
		imx5_idle();
	  ac:	ebffffd3 	bl	0 <imx5_idle>
	}
	  b0:	e89da800 	ldm	sp, {fp, sp, pc}

v2 changes:
 * Removed some unnecessary  spaces [per Jess Juhl]
 * Added return value for an error message [per Sascha Hauer]
 * Reworked init scheme to use device tree late_initcall [per Sascha and Shawn]
 * Moved imx6q and imx5 cpuidle functionality to existing files.

https://lkml.org/lkml/2012/5/1/363

v1 initial submission:

https://lkml.org/lkml/2012/4/16/644

Robert Lee (3):
  ARM: imx: Add common imx cpuidle init functionality.
  ARM: imx: Add imx5 cpuidle driver
  ARM: imx: Add imx6q cpuidle driver

 arch/arm/mach-imx/mach-imx6q.c           |   19 +++++++
 arch/arm/mach-imx/mm-imx5.c              |   42 ++++++++++++++--
 arch/arm/plat-mxc/Makefile               |    1 +
 arch/arm/plat-mxc/cpuidle.c              |   80 ++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/cpuidle.h |   22 ++++++++
 5 files changed, 161 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/plat-mxc/cpuidle.c
 create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h

-- 
1.7.10

