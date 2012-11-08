Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2KHKj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:39:27 -0500
Received: from szxga04-in.huawei.com ([119.145.14.67]:36313 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2KHKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:39:26 -0500
Date: Thu, 08 Nov 2012 11:39:05 +0100
From: Claudio Fontana <Claudio.Fontana@huawei.com>
Subject: [PATCH] ARM: plat-versatile: move secondary CPU startup code out of
 .init for hotplug
To: Russell King <linux@arm.linux.org.uk>
Cc: Dave Martin <dave.martin@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <509B8BC9.4070209@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010
 Thunderbird/16.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using __CPUINIT instead of __INIT puts the secondary CPU startup code
into the "right" section: it will not be freed in hotplug configurations,
allowing hot-add of cpus, while still getting freed in non-hotplug configs.

Signed-off-by: Claudio Fontana <claudio.fontana@huawei.com>
---
 arch/arm/plat-versatile/headsmp.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-versatile/headsmp.S b/arch/arm/plat-versatile/headsmp.S
index dd703ef..19fe180 100644
--- a/arch/arm/plat-versatile/headsmp.S
+++ b/arch/arm/plat-versatile/headsmp.S
@@ -11,7 +11,7 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-	__INIT
+	__CPUINIT
 
 /*
  * Realview/Versatile Express specific entry point for secondary CPUs.
-- 
1.7.12.1


