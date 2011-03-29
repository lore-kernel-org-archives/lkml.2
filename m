Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1C2QQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:16:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56229 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1C2QQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:16:51 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] amd64_edac: Fix potential memleak
Date: Tue, 29 Mar 2011 18:16:41 +0200
Message-Id: <1301415401-23876-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

We check the pointers together but at least one of them could be invalid
due to failed allocation. Since we cannot continue if either of the two
allocations has failed, exit early by freeing them both.

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0be30e9..31e71c4f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2679,7 +2679,7 @@ static int __init amd64_edac_init(void)
 	mcis	  = kzalloc(amd_nb_num() * sizeof(mcis[0]), GFP_KERNEL);
 	ecc_stngs = kzalloc(amd_nb_num() * sizeof(ecc_stngs[0]), GFP_KERNEL);
 	if (!(mcis && ecc_stngs))
-		goto err_ret;
+		goto err_free;
 
 	msrs = msrs_alloc();
 	if (!msrs)
-- 
1.7.4.rc2

