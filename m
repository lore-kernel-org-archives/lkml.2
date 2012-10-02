Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2JBQhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2JBQha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 01/17] ARM: shmobile: fix memory size for kota2_defconfig
Date: Tue,  2 Oct 2012 18:36:40 +0200
Message-Id: <1349195816-2225-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:FCHkoPYSKGioiHuzLEza/Lf8DvM3j96fmzTiHKMl9wd
 V/6//BVK+HD3gIi7fjNk8TF3pTn0MGOAN6imH8DpAbczOh+3rC
 lX1ohh5WDsTmoyXRYNMwafGqKGyK38SSaLB8Z0U0ALfleqCCpv
 VlmCXT0Jp7AjwmgQFCtJEdtgl2LizvHbADWRkweQ8sEh1QdT9P
 OzL5gR3k87yprd/TMqZESLizaNQdu9zcxrHXWusTPSwVH8X0mp
 j7vK4vw0nJuWikcn6CuDSdaGPzsuXLTKutkCgcYTQ2E8cWJhSa
 07TE4hiimB3NgG2QGavxELLB+DkN3uzIZjGdLHK1/AkmsiaQzA
 +Y4ZEycK9PEg+hUIGRMHUvYJ1uouzONiFj2UjnfvWeTpI8YjZ8
 c0e5BuJ3Fh5xw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_MEMORY_SIZE value is interpreted as a 32 bit integer, which
makes sense on a system without PAE. I'm assuming 0x10000000 (256 MB)
is the correct size, because that is used on most other shmobile
boards.

Without this patch, building kota2_defconfig results in:

/home/arnd/linux-arm/arch/arm/kernel/setup.c:790:2: warning: large integer implicitly truncated to unsigned type [-Woverflow]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org
Cc: Simon Horman <horms@verge.net.au>
---
 arch/arm/configs/kota2_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/kota2_defconfig b/arch/arm/configs/kota2_defconfig
index b7735d6..0ea4c90 100644
--- a/arch/arm/configs/kota2_defconfig
+++ b/arch/arm/configs/kota2_defconfig
@@ -21,7 +21,7 @@ CONFIG_ARCH_SHMOBILE=y
 CONFIG_KEYBOARD_GPIO_POLLED=y
 CONFIG_ARCH_SH73A0=y
 CONFIG_MACH_KOTA2=y
-CONFIG_MEMORY_SIZE=0x1e0000000
+CONFIG_MEMORY_SIZE=0x10000000
 # CONFIG_SH_TIMER_TMU is not set
 # CONFIG_SWP_EMULATE is not set
 CONFIG_CPU_BPREDICT_DISABLE=y
-- 
1.7.10

