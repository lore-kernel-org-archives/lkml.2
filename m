Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1HAVcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:32:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1HAVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:32:04 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        James Bottomley <JBottomley@Parallels.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] char drivers: ramoops: update module parameters
Date: Mon,  1 Aug 2011 14:31:40 -0700
Message-Id: <1312234300-18302-1-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the module parameters when platform data is used.
This means that they can be read from /sys/module/ramoops/parameters in
order to parse the memory area.

Change-Id: Ic8cd3b1ff4d1bac0a761ed33c59c27daed83d6cb
Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 drivers/char/ramoops.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index fca0c51..810aff9 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -147,6 +147,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
+	/*
+	 * Update the module parameter variables as well so they are visible
+	 * through /sys/module/ramoops/parameters/
+	 */
+	mem_size = pdata->mem_size;
+	mem_address = pdata->mem_address;
+	record_size = pdata->record_size;
+	dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region failed\n");
-- 
1.7.2.3

