Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2JBQjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:39:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2JBQhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>
Subject: [PATCH 14/17] ARM: davinci: don't mark da850_register_cpufreq as __init
Date: Tue,  2 Oct 2012 18:36:53 +0200
Message-Id: <1349195816-2225-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:r48ZAw6AXZHnAsIM7obNs9NmDMZVg+ticdTdTHAkYJf
 VbDlbxPt+9WW//GRRR84+yf4i2TFtiuw4s8uTn7pz8xdt2EXom
 LbWMNpb1Kxcnwcc7R8L6NyCmFvmBQsU+lN5THBeN672xGnNvyf
 Lz+asCMYqV6sf1/Pk1DHO246TR/I3kLRjGngozfb9LeqI3NdJ1
 eFOnanConlh8eM5fU0zQ+3ptoEzQ3L6e9po0tNH/54xJyx0SRH
 YtJvEcVwWll6V/3WpyiyPDSZeKvbXZuI3y22JGb0PjhWzqGoAI
 KSYXWn1ryVqF/ECy0W6SPxaJVgDTN2Y8gTAFWTgFFBb8E6MR0s
 Cp6jXII4/5pqV2JvtHpGCIJkQUAIjSG5pcUn0EpqoLe/fscLyL
 Yc4l6plz10MBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mityomapl138_cpufreq_init and read_factory_config function in
board-mityomapl138.c are not __init functions and might be called
at a later stage, so da850_register_cpufreq must not be __init either.

Without this patch, building da8xx_omapl_defconfig results in:

WARNING: arch/arm/mach-davinci/built-in.o(.text+0x2eb4): Section mismatch in reference from the function read_factory_config() to the function .init.text:da850_register_cpufreq()
The function read_factory_config() references
the function __init da850_register_cpufreq().
This is often because read_factory_config lacks a __init
annotation or the annotation of da850_register_cpufreq is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-davinci/da850.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index b44dc84..8329e5b 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -939,7 +939,7 @@ static struct platform_device da850_cpufreq_device = {
 
 unsigned int da850_max_speed = 300000;
 
-int __init da850_register_cpufreq(char *async_clk)
+int da850_register_cpufreq(char *async_clk)
 {
 	int i;
 
-- 
1.7.10

