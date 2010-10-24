Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0JXBEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:04:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48143 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab0JXBEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:04:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/15] x86: Call smp_register_lapic_address for contruct_default mptable path
Date: Sat, 23 Oct 2010 18:02:19 -0700
Message-Id: <1287882149-29275-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It already finds smp config, make it like other find_smp_config path

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/mpparse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a550315..7b72904 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -481,7 +481,7 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	/*
 	 * local APIC has default address
 	 */
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	smp_register_lapic_address(APIC_DEFAULT_PHYS_BASE);
 
 	/*
 	 * 2 CPUs, numbered 0 & 1.
@@ -617,7 +617,7 @@ void __init default_get_smp_config(unsigned int early)
 			/*
 			 * local APIC has default address
 			 */
-			mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+			smp_register_lapic_address(APIC_DEFAULT_PHYS_BASE);
 			return;
 		}
 
-- 
1.7.1

