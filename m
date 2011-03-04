Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab1CDL7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:59:06 -0500
Received: from server103.greatnet.de ([83.133.97.6]:34008 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496Ab1CDL6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:58:55 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@gmail.com,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCHv2 2/7] x86: make some apic symbols init
Date: Fri,  4 Mar 2011 12:58:38 +0100
Message-Id: <1299239923-7092-2-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
References: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic_force_enable(), apic_verify() and the variable
force_enable_local_apic are only used by init code
and now get marked as such.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/kernel/apic/apic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6c464a3..b62723c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -93,7 +93,7 @@ DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
  *
  * +1=force-enable
  */
-static int force_enable_local_apic;
+static int force_enable_local_apic __initdata;
 /*
  * APIC command line parameters
  */
@@ -1560,7 +1560,7 @@ static int __init detect_init_APIC(void)
 }
 #else
 
-static int apic_verify(void)
+static int __init apic_verify(void)
 {
 	u32 features, h, l;
 
@@ -1585,7 +1585,7 @@ static int apic_verify(void)
 	return 0;
 }
 
-int apic_force_enable(unsigned long addr)
+int __init apic_force_enable(unsigned long addr)
 {
 	u32 h, l;
 
-- 
1.7.2.3

