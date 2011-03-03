Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab1CCUFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:05:24 -0500
Received: from server103.greatnet.de ([83.133.97.6]:55251 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798Ab1CCUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:05:20 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 7/7] x86: fix section of a disable_apic_timer
Date: Thu,  3 Mar 2011 21:05:01 +0100
Message-Id: <1299182701-8591-7-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable placed better into section .init.data,
since its only accessed by __init code.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 64efb2d..dab58b6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -163,7 +163,7 @@ early_param("nox2apic", setup_nox2apic);
 unsigned long mp_lapic_addr;
 int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
+static int disable_apic_timer __initdata = 0;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
-- 
1.7.2.3

