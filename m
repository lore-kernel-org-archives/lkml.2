Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0KJTDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:03:46 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49300 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab0KJTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:03:44 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/12] EDAC, MCE: Allow F15h bank 6 MCE injection
Date: Wed, 10 Nov 2010 20:02:20 +0100
Message-Id: <1289415741-15000-12-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1289415741-15000-1-git-send-email-bp@amd64.org>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h adds a sixth MCE bank: adjust bank number check in the injection
code.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd_inj.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 8d0688f..6db494f 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -88,10 +88,11 @@ static ssize_t edac_inject_bank_store(struct kobject *kobj,
 		return -EINVAL;
 	}
 
-	if (value > 5) {
-		printk(KERN_ERR "Non-existant MCE bank: %lu\n", value);
-		return -EINVAL;
-	}
+	if (value > 5)
+		if (boot_cpu_data.x86 != 0x15 || value > 6) {
+			printk(KERN_ERR "Non-existant MCE bank: %lu\n", value);
+			return -EINVAL;
+		}
 
 	i_mce.bank = value;
 
-- 
1.7.3.1.50.g1e633

