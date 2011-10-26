Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab1JZQRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:17:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47577 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961Ab1JZQRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:17:36 -0400
Date: Wed, 26 Oct 2011 19:15:07 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] intr_remapping: Fix section mismatch in ir_dev_scope_init()
Message-ID: <20111026161507.GB10103@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix

Section mismatch in reference from the function ir_dev_scope_init() to the
function .init.text:dmar_dev_scope_init()
The function ir_dev_scope_init() references the function __init dmar_dev_scope_init().


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 07c9f18..6777ca0 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -773,7 +773,7 @@ int __init parse_ioapics_under_ir(void)
 	return ir_supported;
 }
 
-int ir_dev_scope_init(void)
+int __init ir_dev_scope_init(void)
 {
 	if (!intr_remapping_enabled)
 		return 0;

