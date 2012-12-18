Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2LRInI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:43:08 -0500
Received: from szxga04-in.huawei.com ([119.145.14.67]:37520 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2LRInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:43:06 -0500
Date: Tue, 18 Dec 2012 09:42:49 +0100
From: Claudio Fontana <Claudio.Fontana@huawei.com>
Subject: [PATCH RESEND 4] ARM: plat-versatile: move secondary CPU startup into
 cpuinit
In-reply-to: <50B47C31.2040709@huawei.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <c.dall@virtualopensystems.com>
Message-id: <50D02C89.9030307@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
References: <50B47C31.2040709@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using __CPUINIT instead of __INIT puts the secondary CPU startup code
into the "right" section: it will not be freed in hotplug configurations,
allowing hot-add of cpus, while still getting freed in non-hotplug configs.

Tested successfully on Fast-Models and on Arndale for VCPU hotplug. 

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


