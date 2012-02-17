Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2BQKhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:37:21 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:58772 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2BQKhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:37:19 -0500
X-AuditID: c1b4fb3d-b7bb7ae0000007b2-e3-4f3e2dddc219
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: <lucas.demarchi@profusion.mobi>, <borislav.petkov@amd.com>,
        <linux-edac@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <thang.b.nguyen@dektech.com.au>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
Subject: [PATCH] edac: i5100 fix erroneous define for M1Err
Date: Fri, 17 Feb 2012 11:36:54 +0100
Message-ID: <1329475014-15589-1-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to [1] the define for M1Err in the FERR_NF_MEM register is
wrong. It should be at position 1 not 0.

[1] Intel 5100 Memory Controller Hub Chipset Doc.Nr: 318378
    http://www.intel.com/content/dam/doc/datasheet/5100-
    memory-controller-hub-chipset-datasheet.pdf

Reported-by: Ba Thang Nguyen <thang.b.nguyen@dektech.com.au>
Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
---
 drivers/edac/i5100_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index bcbdeec..ab2f906 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -49,7 +49,7 @@
 #define		I5100_FERR_NF_MEM_M6ERR_MASK	(1 << 6)
 #define		I5100_FERR_NF_MEM_M5ERR_MASK	(1 << 5)
 #define		I5100_FERR_NF_MEM_M4ERR_MASK	(1 << 4)
-#define		I5100_FERR_NF_MEM_M1ERR_MASK	1
+#define		I5100_FERR_NF_MEM_M1ERR_MASK	(1 << 1)
 #define		I5100_FERR_NF_MEM_ANY_MASK	\
 			(I5100_FERR_NF_MEM_M16ERR_MASK | \
 			I5100_FERR_NF_MEM_M15ERR_MASK | \
-- 
1.7.9.1

