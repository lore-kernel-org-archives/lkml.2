Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2A3XOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:14:00 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:49114 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2A3XMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:12:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAB4jJ09bdWOb/2dsb2JhbABDhQuqUYFzAQUjBAsBIyMQJQIYDgICOQMbBgESh3+nBpFdgS+JUAEFAgICCAEBBA0EBgELCQgUF4MzXhWCQoEWBJUahVaMfA
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="945795216"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 4/8] staging: tidspbridge: silence the compiler
Date: Tue, 31 Jan 2012 00:12:20 +0100
Message-Id: <d25cfe1b88f2b749cb31887d551a1c9b0fcde42e.1327964066.git.vjaquez@igalia.com>
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

Silence the warning when compiling drv_interface.c

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 4316f4e..7a6401a 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -273,8 +273,9 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	dev_dbg(bridge, "%s: vm filp %p offset %x start %lx end %lx page_prot "
-		"%lx flags %lx\n", __func__, filp, offset,
-		vma->vm_start, vma->vm_end, vma->vm_page_prot, vma->vm_flags);
+		"%ulx flags %lx\n", __func__, filp, offset,
+		vma->vm_start, vma->vm_end, vma->vm_page_prot,
+		vma->vm_flags);
 
 	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 				 vma->vm_end - vma->vm_start,
-- 
1.7.8.3

