Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2DCLWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:22:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:48285 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab2DCLWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:22:44 -0400
X-IronPort-AV: E=Sophos;i="4.75,362,1330923600"; 
   d="scan'208";a="23813971"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] xen/gntdev: do not set VM_PFNMAP
Date: Tue, 3 Apr 2012 12:25:02 +0100
Message-ID: <1333452302-5749-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since when we are using the m2p_override it is not true anymore that the
mmap'ed area doesn't have corresponsing struct pages.

Removing the VM_PFNMAP flag makes get_user_pages work on the mmap'ed user vma.
An example test case would be using a Xen userspace block backend
(QDISK) on a file on NFS using O_DIRECT.

The patch should be backported back to 2.6.38.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/gntdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.2.5

