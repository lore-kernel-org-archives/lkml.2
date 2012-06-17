Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab2FQS1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:27:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50367 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758522Ab2FQSW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:57 -0400
Message-Id: <20120617175945.989865239@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 33/69] [SCSI] mpt2sas: Fix unsafe using smp_processor_id() in preemptible
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>

commit a2c658505bf5c75516ee0a79287223e86a2474af upstream.

When CONFIG_DEBUG_PREEMPT is enabled, bug is observed in the smp_processor_id().
This is because smp_processor_id() is not called in preempt safe condition.

To fix this issue, use raw_smp_processor_id instead of smp_processor_id.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6102ef2..9d46fcb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1792,7 +1792,7 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[smp_processor_id()];
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
 }
 
 /**


