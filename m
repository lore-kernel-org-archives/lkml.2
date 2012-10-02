Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2JBQlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:41:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2JBQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 11/17] ARM: mv78xx0: mark mv78xx0_timer_init as __init_refok
Date: Tue,  2 Oct 2012 18:36:50 +0200
Message-Id: <1349195816-2225-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EC7p05dGVDFtyqMzNiRcLlVyC/bDD6NYiyAX6gRzDHE
 +u2fDPzP9dUO3EDtttDibAw6D7nLVr+zow/ic50OtvZmBTaWbx
 5O9YkCR/Dge3n/JFbbVN3ZsJsn8f6NV7VkFP9HNq3ZHPK6WCPO
 YJA1WJq8zw6eFgvNPtmKdP0nwxgvyb+AJNdRldyijiKNvnN+0W
 +ANLV/wb8+XPvvu0g+b00RkotUIsAEREjks28qYb48UXSXzefF
 78m7KbgPBknbpiHXuVQ1UkGOT9Tz5Xh/GL4KeXr4pu3LyvS84+
 6OaWTCFQMVbeOm7Xn9VHyXmK8swwq7YqbyeGqL89cvn9vj532v
 p1wycBPGcGZXgXhV9SHYnm97maXB4XOAYCadLdFXl+SMqEC+gZ
 +oZO8PC6PAv0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sys_timer init function is only called at __init time,
so it's safe to mark mv78xx0_timer_init as __init_refok,
which allows us to call orion_time_init without getting
a link time warning.

Without this patch, building mv78xx0_defconfig results in:

WARNING: vmlinux.o(.text+0x15470): Section mismatch in reference from the function mv78xx0_timer_init() to the function .init.text:orion_time_init()
The function mv78xx0_timer_init() references
the function __init orion_time_init().
This is often because mv78xx0_timer_init lacks a __init
annotation or the annotation of orion_time_init is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-mv78xx0/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index 3057f7d..e251ebc 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -341,7 +341,7 @@ void __init mv78xx0_init_early(void)
 	orion_time_set_base(TIMER_VIRT_BASE);
 }
 
-static void mv78xx0_timer_init(void)
+static void __init_refok mv78xx0_timer_init(void)
 {
 	orion_time_init(BRIDGE_VIRT_BASE, BRIDGE_INT_TIMER1_CLR,
 			IRQ_MV78XX0_TIMER_1, get_tclk());
-- 
1.7.10

