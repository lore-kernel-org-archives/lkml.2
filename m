Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1AWNiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:38:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42549 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1AWNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:38:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kG01Kj84KlUPHQbSN+r5kPVW0liaxb9EwJVFbfe5EavTVQmHRUiQGZZ3e5GzHr1iA4
         H7MDgJDC4r8FvbOLsAxtqFtW1uiLpNpAfs6O0TzcI30bluBNRy2mZ5TE47hoK/kLrjes
         MFN8qLdabY5QHmFqie1ImN5kwDTaPzgLfpnSE=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, penberg@kernel.org, shaohui.zheng@intel.com,
        rientjes@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/16] x86: Implement the default x86_32_early_logical_apicid()
Date: Sun, 23 Jan 2011 14:37:34 +0100
Message-Id: <1295789862-25482-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295789862-25482-1-git-send-email-tj@kernel.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement x86_32_early_logical_apicid() for the default apic flat
routing.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apic/probe_32.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 40be7c3..0f9a9ab 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -77,6 +77,11 @@ void __init default_setup_apic_routing(void)
 		apic->setup_apic_routing();
 }
 
+static int default_x86_32_early_logical_apicid(int cpu)
+{
+	return 1 << cpu;
+}
+
 static void setup_apic_flat_routing(void)
 {
 #ifdef CONFIG_X86_IO_APIC
@@ -167,7 +172,7 @@ struct apic apic_default = {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
-	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
 };
 
 extern struct apic apic_numaq;
-- 
1.7.1

