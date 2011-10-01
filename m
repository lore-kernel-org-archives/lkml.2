Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab1JAUIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:08:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1JAUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 21/26] ARM: pxa: select POWER_SUPPLY on raumfeld
Date: Sat,  1 Oct 2011 22:03:53 +0200
Message-Id: <1317499438-14058-22-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:4gMOMJLuiBCowH7CeKCvLiE4j4naxLn5tM9pX2YD7zD
 8bpbESc8lo45gQS+HW8LQjJ6zrZehkK3cCR+DgC/fg2visPagp
 NeU/uoaAqiNhQd328/iekEf0ETWdqjJXeX6gRitaJFSh2cGSQU
 lXhof9eSHs7o7VkMcIH0w4b620TFSrgk6Ht+7toHKFfI7iS4nV
 7PtEB90+g1TiZSX9PwhdmckkvsFpjvDeBCgO4krQwWvhR0lu02
 8IiO9LkX3X3pnVSF3lSdbYpZFLs7EyyyXOWF1SLD/27caKeihy
 yr7BCTiGtLWvGhMZAXjg/DnXzZBgIDBCnQbOCsiHRu1c1yWUQL
 eZzzvqEvWluIEuLC7+wzKNEuYuqDCN/QsVTbA6dnxtUqm8k4gx
 fjFX/4CZyVcmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raumfeld platform code calls power_supply_set_battery_charged
which is part of the power supply layer, so that always has
to be enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index cd94f2f..491c522 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -453,15 +453,18 @@ config MACH_RAUMFELD_RC
 	bool "Raumfeld Controller"
 	select PXA3xx
 	select CPU_PXA300
+	select POWER_SUPPLY
 	select HAVE_PWM
 
 config MACH_RAUMFELD_CONNECTOR
 	bool "Raumfeld Connector"
+	select POWER_SUPPLY
 	select PXA3xx
 	select CPU_PXA300
 
 config MACH_RAUMFELD_SPEAKER
 	bool "Raumfeld Speaker"
+	select POWER_SUPPLY
 	select PXA3xx
 	select CPU_PXA300
 
-- 
1.7.5.4

