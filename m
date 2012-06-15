Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2FOPLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:11:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52930 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab2FOPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:11:08 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>,
        Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH] x86/vsmp: Fix vector_allocation_domain's return value
Date: Fri, 15 Jun 2012 18:10:55 +0300
Message-Id: <1339773055-27397-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8637e38a ("x86/apic: Avoid useless scanning thru a cpumask in
assign_irq_vector()") modified vector_allocation_domain() to return a
boolean indicating if cpumask is dynamic or static. Adjust vSMP's
callback implementation accordingly.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/vsmp_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 3f0285a..fa5adb7 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -208,9 +208,10 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  * In vSMP, all cpus should be capable of handling interrupts, regardless of
  * the APIC used.
  */
-static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static bool fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_setall(retmask);
+	return false;
 }
 
 static void vsmp_apic_post_init(void)
-- 
1.7.7.6

