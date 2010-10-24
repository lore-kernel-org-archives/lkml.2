Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab0JXM3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 08:29:15 -0400
Received: from igloo.linux.gr ([62.1.205.36]:35992 "EHLO igloo.linux.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0JXM3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 08:29:14 -0400
X-Hellug-MailScanner-From: serzan@hellug.gr
X-Hellug-MailScanner-SpamCheck: not spam, SpamAssassin (cached, score=-2.9,
	required 5, autolearn=not spam, ALL_TRUSTED -1.00, BAYES_00 -1.90)
X-Hellug-MailScanner: Found to be clean
X-Hellug-MailScanner-ID: o9OCJbX7000735
From: Serafeim Zanikolas <sez@debian.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        cpw@sgi.com, linux-kernel@vger.kernel.org
Cc: Serafeim Zanikolas <sez@debian.org>
Subject: [PATCH] arch/x86/kernel/tlb_uv.c: replace kmalloc/memset 0
Date: Sun, 24 Oct 2010 14:19:27 +0200
Message-Id: <1287922767-11718-1-git-send-email-sez@debian.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kmalloc followed by memset 0 with kzalloc, and drop the unnecessary
cast.

Signed-off-by: Serafeim Zanikolas <sez@debian.org>
---
 arch/x86/kernel/tlb_uv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 20ea20a..f5b0258 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -1520,9 +1520,7 @@ static void __init uv_init_per_cpu(int nuvhubs)
 
 	timeout_us = calculate_destination_timeout();
 
-	uvhub_descs = (struct uvhub_desc *)
-		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
-	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+	uvhub_descs = kzalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);
-- 
1.7.1

