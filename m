Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2JBQhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2JBQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: [PATCH 02/17] ARM: shark: fix shark_pci_init return code
Date: Tue,  2 Oct 2012 18:36:41 +0200
Message-Id: <1349195816-2225-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rFYR1JSIs/maBQvq9oNVwgA9H9nn96i1XUTbWfAAID9
 xF06tfEusVC7uEWOPflLJh6upcxRN6gTOfQZmLGV5QZk0ysh1a
 c7/0QI+WpKIdCvlaIbpfqTcWQJPNTsJUQOOH4kpE2gQOk8f6wF
 2DiQNlQCg1r7AnBYbZguiQ9UZwMes7a4MvJlXznAwLbStI3g8u
 JYdoFENN0184f95CUbOLZ/pJg11IpoDY8lwUeiSI0RaJId8YEM
 jSvbkY4bSPlWsxaJsKXLwq1leQFPBmHFyx6DGF/cBcmStMEhrC
 zdZ0DZnxpa/v0BtRJdyzwycXUe/STDo87dlasnnF9Nbpv5xlu/
 kKEXvWjf/3FBXXpcqAfFh2YMp8Uwhi9nwHMXZKUtOzMC+BTL30
 jhJEkhF+KDjFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When run on the wrong platform, the shark_pci_init function
returns an undefined value, as reported by a gcc warning,
so let's just return -ENODEV.

Without this patch, building shark_defconfig results in:

arch/arm/mach-shark/pci.c: In function 'shark_pci_init':
arch/arm/mach-shark/pci.c:42:3: warning: 'return' with no value, in function returning non-void [-Wreturn-type]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>
---
 arch/arm/mach-shark/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shark/pci.c b/arch/arm/mach-shark/pci.c
index 9089407..2b351a3 100644
--- a/arch/arm/mach-shark/pci.c
+++ b/arch/arm/mach-shark/pci.c
@@ -38,7 +38,7 @@ static struct hw_pci shark_pci __initdata = {
 static int __init shark_pci_init(void)
 {
 	if (!machine_is_shark())
-		return;
+		return -ENODEV;
 
 	pcibios_min_io = 0x6000;
 	pcibios_min_mem = 0x50000000;
-- 
1.7.10

