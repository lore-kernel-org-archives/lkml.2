Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1LILpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:45:40 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34437 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1LILp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:45:27 -0500
From: Michal Simek <monstr@monstr.eu>
To: robherring2@gmail.com
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        anton.vorontsov@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] microblaze: Use irq_of_parse_and_map for timer
Date: Fri,  9 Dec 2011 12:45:19 +0100
Message-Id: <1323431121-12780-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1323431121-12780-2-git-send-email-monstr@monstr.eu>
References: <1323431121-12780-1-git-send-email-monstr@monstr.eu>
 <1323431121-12780-2-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is necessary to call generic function for irq finding.
The main reason is that this generic function calls irq_create_of_mapping
which can add some shift because of NO_IRQ.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index 3ba1e1c..52e3eaf 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -263,7 +263,7 @@ void __init time_init(void)
 
 	timer_baseaddr = be32_to_cpup(of_get_property(timer, "reg", NULL));
 	timer_baseaddr = (unsigned long) ioremap(timer_baseaddr, PAGE_SIZE);
-	irq = be32_to_cpup(of_get_property(timer, "interrupts", NULL));
+	irq = irq_of_parse_and_map(timer, 0);
 	timer_num = be32_to_cpup(of_get_property(timer,
 						"xlnx,one-timer-only", NULL));
 	if (timer_num) {
-- 
1.7.5.4

