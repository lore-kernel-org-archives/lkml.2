Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1AXP01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:26:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44597 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1AXP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:25 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/7] x86, microcode, AMD: Remove unneeded memset call
Date: Mon, 24 Jan 2011 16:29:02 +0100
Message-Id: <1295882943-11184-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295882943-11184-1-git-send-email-bp@amd64.org>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

collect_cpu_info_amd() clears its csig arg but this is done in the
microcode_core's collect_cpu_info() by clearing the embedding struct
ucode_cpu_info. Drop it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <Andreas.Herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8b58fc1..274fa40 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -77,7 +77,6 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
 
-	memset(csig, 0, sizeof(*csig));
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
 		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
 			   "supported\n", cpu, c->x86);
-- 
1.7.4.rc2

