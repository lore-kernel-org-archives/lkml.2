Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2LTTPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:15:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49058 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab2LTTOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:07 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpupowerutils: don't compare pointers with 0
Date: Thu, 20 Dec 2012 14:11:17 -0500
Message-Id: <1356030701-16284-9-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/power/cpupower/utils/helpers/bitmask.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/power/cpupower/utils/helpers/bitmask.c b/tools/power/cpupower/utils/helpers/bitmask.c
index 5c074c6..3b6e03d 100644
--- a/tools/power/cpupower/utils/helpers/bitmask.c
+++ b/tools/power/cpupower/utils/helpers/bitmask.c
@@ -25,11 +25,11 @@ struct bitmask *bitmask_alloc(unsigned int n)
 	struct bitmask *bmp;
 
 	bmp = malloc(sizeof(*bmp));
-	if (bmp == 0)
+	if (bmp == NULL)
 		return 0;
 	bmp->size = n;
 	bmp->maskp = calloc(longsperbits(n), sizeof(unsigned long));
-	if (bmp->maskp == 0) {
+	if (bmp->maskp == NULL) {
 		free(bmp);
 		return 0;
 	}
@@ -39,7 +39,7 @@ struct bitmask *bitmask_alloc(unsigned int n)
 /* Free `struct bitmask` */
 void bitmask_free(struct bitmask *bmp)
 {
-	if (bmp == 0)
+	if (bmp == NULL)
 		return;
 	free(bmp->maskp);
 	bmp->maskp = (unsigned long *)0xdeadcdef;  /* double free tripwire */
-- 
1.8.0

