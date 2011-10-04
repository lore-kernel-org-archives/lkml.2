Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1JDAGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:06:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54518 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1JDAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:06:05 -0400
Date: Tue, 4 Oct 2011 11:05:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, Marc Dietrich <marvin24@gmx.de>,
        Olof Johansson <olof@lixom.net>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111004110555.bf9d9303a401177c0f380a35@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-tegra/board-paz00.h between commit ea5abbd215b7 ("ARM:
7101/1: arm/tegra: Replace <mach/gpio.h> with <mach/gpio-tegra.h>") from
the arm tree and commit 9aaa15a739a0 ("ARM: tegra: paz00: enable rfkill
for internal wifi card") from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-paz00.h
index 42ce863,86057c3..0000000
--- a/arch/arm/mach-tegra/board-paz00.h
+++ b/arch/arm/mach-tegra/board-paz00.h
@@@ -17,12 -17,18 +17,20 @@@
  #ifndef _MACH_TEGRA_BOARD_PAZ00_H
  #define _MACH_TEGRA_BOARD_PAZ00_H
  
 +#include <mach/gpio-tegra.h>
 +
- #define TEGRA_GPIO_SD1_CD		TEGRA_GPIO_PV5
- #define TEGRA_GPIO_SD1_WP		TEGRA_GPIO_PH1
- #define TEGRA_GPIO_SD1_POWER		TEGRA_GPIO_PT3
- #define TEGRA_ULPI_RST			TEGRA_GPIO_PV0
+ /* SDCARD */
+ #define TEGRA_GPIO_SD1_CD	TEGRA_GPIO_PV5
+ #define TEGRA_GPIO_SD1_WP	TEGRA_GPIO_PH1
+ #define TEGRA_GPIO_SD1_POWER	TEGRA_GPIO_PT3
+ 
+ /* ULPI */
+ #define TEGRA_ULPI_RST		TEGRA_GPIO_PV0
+ 
+ /* WIFI */
+ #define TEGRA_WIFI_PWRN		TEGRA_GPIO_PK5
+ #define TEGRA_WIFI_RST		TEGRA_GPIO_PD1
+ #define TEGRA_WIFI_LED		TEGRA_GPIO_PD0
  
  void paz00_pinmux_init(void);
  
