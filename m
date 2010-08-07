Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0HGCRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:17:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37319 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab0HGCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:16:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/10] x86: call smp_register_lapic_address for contruct_default mptable path
Date: Fri,  6 Aug 2010 19:15:37 -0700
Message-Id: <1281147343-18389-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
References: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because it already finds smp config.

make it like other find_smp_config path

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/mpparse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 3e25213..bd63a42 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -480,7 +480,7 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	/*
 	 * local APIC has default address
 	 */
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	smp_register_lapic_address(APIC_DEFAULT_PHYS_BASE);
 
 	/*
 	 * 2 CPUs, numbered 0 & 1.
@@ -616,7 +616,7 @@ void __init default_get_smp_config(unsigned int early)
 			/*
 			 * local APIC has default address
 			 */
-			mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+			smp_register_lapic_address(APIC_DEFAULT_PHYS_BASE);
 			return;
 		}
 
-- 
1.6.4.2

