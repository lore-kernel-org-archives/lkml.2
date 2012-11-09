Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2KINUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:20:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58658 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2KINUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:20:06 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Device tree updates for host1x support
Date: Fri,  9 Nov 2012 14:20:00 +0100
Message-Id: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:qNSBRnCMC5IrcMvRRyp8GHM8g/81H65vugsWjLG1+2b
 qMJ9OOx7kmHTYcnR1mbmJAGgyrhOg5gEFPDV4zc+d2iOYShEwq
 JEM3YfGK0uCrDTi/vyWqliU+T/+HvRkQekTcCAvJ8sEUkL3JLf
 HqRds4OX2IDdkra6E4gKuyMAN+hhHvqgUfq6R9PLyq5aIlsdVo
 KjKx+Q26bLR9jv+aRK7j5P/lC4hFTgZBkFzM4/k+8PyjO94Iqv
 hp5mk9z/PxjQk6J0SQln/xpD2CuTjVG9/NltmHegHPzh/qQU8w
 KiRHd5eswlI2lkJ5uDPB21Yb4x8mDbXlbbDceeqbtGvUbxjv7/
 BUEQGsP0yS1RPvZrMldeLfy0teycwU2lPRksS7WVtM/1unjx3o
 7UDBz3paMFAYuhp8aWbOPJF04wnPSRnEnv1+GFvM/LQakuC8XI
 3NtoN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches are in preparation for the Tegra DRM driver. They
add the necessary nodes to the DTSI files and setup the clocks necessary
for host1x and the display controllers to work properly. The AUXDATA
table is updated with the entries for the newly added nodes and the PLL
frequency tables are extended with some frequencies required to make a
few of the more common LVDS panel and HDMI display modes work.

By default, all output resources (RGB, HDMI, DSI and TVO) are disabled,
and individual boards need to enable those that they require.

Note that there has been talk to replace the frequency tables by an
algorithmic computation of the dividers in order to avoid endless
additions to these tables. No code has surfaced yet, but eventually this
should replace the static tables.

Thierry

Thierry Reding (2):
  ARM: tegra: Add Tegra20 host1x support
  ARM: tegra: Add Tegra30 host1x support

 arch/arm/boot/dts/tegra20.dtsi            | 87 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra30.dtsi            | 87 +++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/board-dt-tegra20.c    |  9 ++++
 arch/arm/mach-tegra/board-dt-tegra30.c    | 10 ++++
 arch/arm/mach-tegra/tegra20_clocks_data.c | 23 ++++----
 arch/arm/mach-tegra/tegra30_clocks_data.c | 11 ++--
 6 files changed, 214 insertions(+), 13 deletions(-)

-- 
1.8.0

