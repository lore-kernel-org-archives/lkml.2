Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0KKLDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:03:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:41204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab0KKLDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:03:14 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] x86: Make default_send_IPI_mask_sequence/allbutself_logical() 32bit only
Date: Thu, 11 Nov 2010 12:02:37 +0100
Message-Id: <1289473363-29440-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289473363-29440-1-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 11:02:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
This is to prepare for logical apicid handling update.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apic/ipi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 08385e0..5037736 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -56,6 +56,8 @@ void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_X86_32
+
 void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
 						 int vector)
 {
@@ -96,8 +98,6 @@ void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_X86_32
-
 /*
  * This is only used on smaller machines.
  */
-- 
1.7.1

