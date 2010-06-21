Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab0FUPC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:02:26 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48091 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab0FUPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:02:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] X86: intel_ips, check for kzalloc properly
Date: Mon, 21 Jun 2010 17:02:11 +0200
Message-Id: <1277132531-14242-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that there are two NULL checks missing in ips_monitor. So
check their value too and bail out appropriately if the allocation
failed.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/intel_ips.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index cdaf40e..3c7ea9a 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -931,7 +931,8 @@ static int ips_monitor(void *data)
 	mch_samples = kzalloc(sizeof(u16) * IPS_SAMPLE_COUNT, GFP_KERNEL);
 	cpu_samples = kzalloc(sizeof(u32) * IPS_SAMPLE_COUNT, GFP_KERNEL);
 	mchp_samples = kzalloc(sizeof(u32) * IPS_SAMPLE_COUNT, GFP_KERNEL);
-	if (!mcp_samples || !ctv1_samples || !ctv2_samples || !mch_samples) {
+	if (!mcp_samples || !ctv1_samples || !ctv2_samples || !mch_samples ||
+			!cpu_samples || !mchp_samples) {
 		dev_err(&ips->dev->dev,
 			"failed to allocate sample array, ips disabled\n");
 		kfree(mcp_samples);
-- 
1.7.1


