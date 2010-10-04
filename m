Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0JDJps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:45:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48568 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0JDJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:45:46 -0400
From: vkuzmichev@mvista.com
To: linux-arm-kernel@lists.infradead.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH 2/4] ARM: smp_twd: Fix typo in twd_timer_rate printout
Date: Mon,  4 Oct 2010 13:45:38 +0400
Message-Id: <1286185540-19569-3-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuzmichev <vkuzmichev@mvista.com>

To get hundredths of MHz the rate needs to be divided by 10'000.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 arch/arm/kernel/smp_twd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 7bc1173..931b0e3 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -114,7 +114,7 @@ static void __cpuinit twd_calibrate_rate(void)
 		twd_timer_rate = (0xFFFFFFFFU - count) * (HZ / 5);
 
 		printk("%lu.%02luMHz.\n", twd_timer_rate / 1000000,
-			(twd_timer_rate / 100000) % 100);
+			(twd_timer_rate / 10000) % 100);
 	}
 
 	load = twd_timer_rate / HZ;
-- 
1.7.2.2

