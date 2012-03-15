Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838Ab2COM2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:28:31 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58964 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761827Ab2COM22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:28:28 -0400
Date: Thu, 15 Mar 2012 21:28:16 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: alan@linux.intel.com
Cc: yuasa@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH] gma500: Fix mmap frambuffer
Message-Id: <20120315212816.475b0b18.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It cannot map correctly if page fault begins from a intermediate address.

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/gpu/drm/gma500/framebuffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index be61673..5154493 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -158,7 +158,7 @@ static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	unsigned long phys_addr = (unsigned long)dev_priv->stolen_base;
 
 	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	address = (unsigned long)vmf->virtual_address;
+	address = (unsigned long)vmf->virtual_address - (vmf->pgoff << PAGE_SHIFT);
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
-- 
1.7.0.4
