Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0JJR3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:29:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab0JJR3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TN/rPbU24AufuXpnkIR7Sa3LXCjOGnZn9qR01jwwhUGll3BxRL19cGsZP49p5gT1x6
         Zmwlm/AJYqiWoDjids1RvzmHRChYq3TAR3mT4ZxGeKBbrC8ww3KQnyYmszUfHP7W4wZh
         RV8bmb9G+XJPsh0uhTuZvQRDNpfsS0Zu4nfMQ=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Fernando Guzman Lugo <x0095840@ti.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: fix signess error
Date: Sun, 10 Oct 2010 21:28:55 +0400
Message-Id: <1286731736-18125-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i was unsigned, so check for (i < 0) made no sense.  Made it signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested.

 drivers/staging/tidspbridge/core/dsp-mmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
index 3c978f9..983c95a 100644
--- a/drivers/staging/tidspbridge/core/dsp-mmu.c
+++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
@@ -219,7 +219,8 @@ u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
 				struct page **usr_pgs)
 {
 	int res, w;
-	unsigned pages, i;
+	unsigned pages;
+	int i;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	struct sg_table *sgt;
-- 
1.7.0.4

