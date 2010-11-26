Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0KZTFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:13 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46274 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KZTFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:11 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/16] amd64_edac: Use cached extended CPU model
Date: Fri, 26 Nov 2010 20:04:09 +0100
Message-Id: <1290798263-13074-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... instead of computing it needlessly again.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b7bde66..7f3609d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1046,13 +1046,12 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 	if (err)
 		return err;
 
-	if ((boot_cpu_data.x86_model >> 4) >= K8_REV_F) {
+	if (pvt->ext_model >= K8_REV_F)
 		/* RevF (NPT) and later */
 		flag = pvt->dclr0 & F10_WIDTH_128;
-	} else {
+	else
 		/* RevE and earlier */
 		flag = pvt->dclr0 & REVE_WIDTH_128;
-	}
 
 	/* not used */
 	pvt->dclr1 = 0;
-- 
1.7.3.1.50.g1e633

