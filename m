Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab0JXBFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:05:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48211 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758989Ab0JXBFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/15] x86, apic: Set fixmap only one time
Date: Sat, 23 Oct 2010 18:02:24 -0700
Message-Id: <1287882149-29275-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if mp_lapic_addr is assigned or not.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3a4e770..2cfa622 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1682,6 +1682,9 @@ void __init init_apic_mappings(void)
 
 void __init smp_register_lapic_address(unsigned long address)
 {
+	if (mp_lapic_addr)
+		return;
+
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
-- 
1.7.1

