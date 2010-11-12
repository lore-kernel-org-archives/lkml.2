Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab0KLVow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:44:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627Ab0KLViN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:13 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] drivers/mfd: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:56 -0800
Message-Id: <c6c8909d879beb258d2de7d25e82c30673f29ffe.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mfd/sm501.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index bc9275c..78638cf 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -745,11 +745,8 @@ static int sm501_register_device(struct sm501_devdata *sm,
 	int ret;
 
 	for (ptr = 0; ptr < pdev->num_resources; ptr++) {
-		printk(KERN_DEBUG "%s[%d] flags %08lx: %08llx..%08llx\n",
-		       pdev->name, ptr,
-		       pdev->resource[ptr].flags,
-		       (unsigned long long)pdev->resource[ptr].start,
-		       (unsigned long long)pdev->resource[ptr].end);
+		printk(KERN_DEBUG "%s[%d] %pR\n",
+		       pdev->name, ptr, &pdev->resource[ptr]);
 	}
 
 	ret = platform_device_register(pdev);
-- 
1.7.3.1.g432b3.dirty

