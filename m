Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab2A3XNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:13:21 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:38613 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2A3XMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:12:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAB4jJ09bdWOb/2dsb2JhbABDhQuqUYFzAQUjBAsBIyMQJQIYDgICOQMbBgESh3+nBpFdgS+JUAEFAgICCAEBBA0EBgELCQgUF4MzXhWCQoEWBJUahVaDVokm
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="945795221"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 7/8] staging: tidspbridge: clean up bridge_mmap()
Date: Tue, 31 Jan 2012 00:12:23 +0100
Message-Id: <3e41ab813d19445abed5478cbb271038bbdc70bf.1327964066.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable offset is not used but in the debug log, so I don't see reason to
calculate it here.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 97c40ff..5f810b6 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -257,7 +257,6 @@ err:
 /* This function maps kernel space memory to user space memory. */
 static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	u32 offset = vma->vm_pgoff << PAGE_SHIFT;
 	u32 status;
 
 	DBC_ASSERT(vma->vm_start < vma->vm_end);
@@ -265,8 +264,8 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_RESERVED | VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
-	dev_dbg(bridge, "%s: vm filp %p offset %x start %lx end %lx page_prot "
-		"%ulx flags %lx\n", __func__, filp, offset,
+	dev_dbg(bridge, "%s: vm filp %p start %lx end %lx page_prot %ulx "
+		"flags %lx\n", __func__, filp,
 		vma->vm_start, vma->vm_end, vma->vm_page_prot,
 		vma->vm_flags);
 
-- 
1.7.8.3

