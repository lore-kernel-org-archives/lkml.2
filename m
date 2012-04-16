Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2DPUoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:44:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab2DPUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:38:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC ABI v13 03/25] i5400_edac: improve debug messages to better represent the filled memory
Date: Mon, 16 Apr 2012 17:38:27 -0300
Message-Id: <1334608729-30803-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improves the debug output message, in order to better represent the
memory controller hierarchy, when outputing the debug messages.

No functional changes when debug is disabled.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5400_edac.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 3aa2a1e..5debda9 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -963,7 +963,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 	int dimm, max_dimms;
 	char *p, *mem_buffer;
 	int space, n;
-	int channel;
+	int channel, branch;
 
 	/* ================= Generate some debug output ================= */
 	space = PAGE_SIZE;
@@ -1028,6 +1028,19 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 		space -= n;
 	}
 
+	space -= n;
+	debugf2("%s\n", mem_buffer);
+	p = mem_buffer;
+	space = PAGE_SIZE;
+
+	n = snprintf(p, space, "           ");
+	p += n;
+	for (branch = 0; branch < MAX_BRANCHES; branch++) {
+		n = snprintf(p, space, "       branch %d       | ", branch);
+		p += n;
+		space -= n;
+	}
+
 	/* output the last message and free buffer */
 	debugf2("%s\n", mem_buffer);
 	kfree(mem_buffer);
-- 
1.7.8

