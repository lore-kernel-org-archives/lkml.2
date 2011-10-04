Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1JDAIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:08:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53033 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1JDAIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:08:36 -0400
Date: Tue, 4 Oct 2011 11:08:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <rmk@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111004110831.a4d6d72a9b75a38265c9d6a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-tegra/board-seaboard.h between commit ea5abbd215b7 ("ARM:
7101/1: arm/tegra: Replace <mach/gpio.h> with <mach/gpio-tegra.h>") from
the arm tree and commit a697e694aeb8 ("ARM: Tegra: Seaboard board updates
for audio") from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-seaboard.h
index 15b6c57,d06c334..0000000
--- a/arch/arm/mach-tegra/board-seaboard.h
+++ b/arch/arm/mach-tegra/board-seaboard.h
@@@ -17,8 -17,9 +17,11 @@@
  #ifndef _MACH_TEGRA_BOARD_SEABOARD_H
  #define _MACH_TEGRA_BOARD_SEABOARD_H
  
 +#include <mach/gpio-tegra.h>
 +
+ #define SEABOARD_GPIO_TPS6586X(_x_)	(TEGRA_NR_GPIOS + (_x_))
+ #define SEABOARD_GPIO_WM8903(_x_)	(SEABOARD_GPIO_TPS6586X(4) + (_x_))
+ 
  #define TEGRA_GPIO_SD2_CD		TEGRA_GPIO_PI5
  #define TEGRA_GPIO_SD2_WP		TEGRA_GPIO_PH1
  #define TEGRA_GPIO_SD2_POWER		TEGRA_GPIO_PI6
