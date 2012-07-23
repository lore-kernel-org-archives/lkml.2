Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2GWSic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:38:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39686 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2GWShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:37:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/5] xen/p2m: Fix the comment describing the P2M tree.
Date: Mon, 23 Jul 2012 14:28:19 -0400
Message-Id: <1343068103-13579-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
References: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It mixed up the p2m_mid_missing with p2m_missing. Also
remove some extra spaces.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 64effdc..e4adbfb 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -22,7 +22,7 @@
  *
  * P2M_PER_PAGE depends on the architecture, as a mfn is always
  * unsigned long (8 bytes on 64-bit, 4 bytes on 32), leading to
- * 512 and 1024 entries respectively. 
+ * 512 and 1024 entries respectively.
  *
  * In short, these structures contain the Machine Frame Number (MFN) of the PFN.
  *
@@ -139,11 +139,11 @@
  *      /    | ~0, ~0, ....  |
  *     |     \---------------/
  *     |
- *     p2m_missing             p2m_missing
- * /------------------\     /------------\
- * | [p2m_mid_missing]+---->| ~0, ~0, ~0 |
- * | [p2m_mid_missing]+---->| ..., ~0    |
- * \------------------/     \------------/
+ *   p2m_mid_missing           p2m_missing
+ * /-----------------\     /------------\
+ * | [p2m_missing]   +---->| ~0, ~0, ~0 |
+ * | [p2m_missing]   +---->| ..., ~0    |
+ * \-----------------/     \------------/
  *
  * where ~0 is INVALID_P2M_ENTRY. IDENTITY is (PFN | IDENTITY_BIT)
  */
@@ -423,7 +423,7 @@ static void free_p2m_page(void *p)
 	free_page((unsigned long)p);
 }
 
-/* 
+/*
  * Fully allocate the p2m structure for a given pfn.  We need to check
  * that both the top and mid levels are allocated, and make sure the
  * parallel mfn tree is kept in sync.  We may race with other cpus, so
-- 
1.7.7.6

