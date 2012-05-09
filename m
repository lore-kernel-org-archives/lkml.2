Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab2EIGb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:31:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38708 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253Ab2EIFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:46 -0400
Message-Id: <20120509055030.989599116@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 010/167] [PATCH] xen/gntdev: do not set VM_PFNMAP
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit e8e937be971d706061dc56220ff3605ab77622a7 upstream.

Since we are using the m2p_override we do have struct pages
corresponding to the user vma mmap'ed by gntdev.

Removing the VM_PFNMAP flag makes get_user_pages work on that vma.
An example test case would be using a Xen userspace block backend
(QDISK) on a file on NFS using O_DIRECT.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/gntdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 99d8151..1ffd03b 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -722,7 +722,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_RESERVED|VM_DONTEXPAND;
 
 	if (use_ptemod)
-		vma->vm_flags |= VM_DONTCOPY|VM_PFNMAP;
+		vma->vm_flags |= VM_DONTCOPY;
 
 	vma->vm_private_data = map;
 
-- 
1.7.10



