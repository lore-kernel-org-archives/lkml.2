Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042Ab2CAT1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:27:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46848 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976Ab2CAT1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:27:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.101.6.23 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/8] ARM: tegra: work around tegra THUMB2_KERNEL bug
Date: Thu,  1 Mar 2012 14:26:47 -0500
Message-Id: <1330630010-11241-6-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330630010-11241-1-git-send-email-alan@signal11.us>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The tegra smp code cannot currently be built for t2, so
disable that combination for now, as a workaround.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a48aecc..ea1d59b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1598,6 +1598,7 @@ config HZ
 config THUMB2_KERNEL
 	bool "Compile the kernel in Thumb-2 mode (EXPERIMENTAL)"
 	depends on CPU_V7 && !CPU_V6 && !CPU_V6K && EXPERIMENTAL
+	depends on !SMP || !ARCH_TEGRA
 	select AEABI
 	select ARM_ASM_UNIFIED
 	select ARM_UNWIND
-- 
1.7.0.4

