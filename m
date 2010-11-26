Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab0KZTF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:58 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46369 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab0KZTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:47 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 16/16] amd64_edac: Disable DRAM ECC injection on K8
Date: Fri, 26 Nov 2010 20:04:23 +0100
Message-Id: <1290798263-13074-17-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

K8 does not allow for an atomic RMW to a cacheline as GH does so disable
the error injection interface for it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index f19c34e..3f7e886 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2466,8 +2466,9 @@ static void set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 	for (; i < ARRAY_SIZE(amd64_dbg_attrs); i++)
 		sysfs_attrs[i] = amd64_dbg_attrs[i];
 
-	for (j = 0; j < ARRAY_SIZE(amd64_inj_attrs); j++, i++)
-		sysfs_attrs[i] = amd64_inj_attrs[j];
+	if (boot_cpu_data.x86 >= 0x10)
+		for (j = 0; j < ARRAY_SIZE(amd64_inj_attrs); j++, i++)
+			sysfs_attrs[i] = amd64_inj_attrs[j];
 
 	sysfs_attrs[i] = terminator;
 
-- 
1.7.3.1.50.g1e633

