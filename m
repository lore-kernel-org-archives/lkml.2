Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2IZKtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:49:05 -0400
Received: from [216.32.181.183] ([216.32.181.183]:6096 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab2IZKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV3-01-D51-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/19] x86, io_apic: Remove irq_remapping_enabled check in setup_timer_IRQ0_pin
Date: Wed, 26 Sep 2012 12:44:42 +0200
Message-ID: <1348656291-10375-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only called when irq-remapping is disabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/apic/io_apic.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 360f62b..d5cd6e1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1489,9 +1489,6 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
 
-	if (irq_remapping_enabled)
-		return;
-
 	memset(&entry, 0, sizeof(entry));
 
 	/*
-- 
1.7.9.5


