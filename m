Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2KPMQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:16:38 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:48632 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2KPMQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:16:36 -0500
Date: Fri, 16 Nov 2012 13:16:29 +0100
From: Claudio Fontana <Claudio.Fontana@huawei.com>
Subject: [PATCH 1/1 RESEND] ARM: plat-versatile: move secondary CPU startup
 code out of .init.
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <50A62E9D.8080703@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using __CPUINIT instead of __INIT puts the secondary CPU startup code
into the "right" section: it will not be freed in hotplug configurations,
allowing hot-add of cpus, while still getting freed in non-hotplug configs.

Signed-off-by: Claudio Fontana <claudio.fontana@huawei.com>
Tested-by: Claudio Fontana <claudio.fontana@huawei.com>

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


