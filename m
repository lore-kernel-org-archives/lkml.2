Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300Ab2GDLQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:16:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56771 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933611Ab2GDLPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:15:41 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336363200"; 
   d="scan'208";a="30393586"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, david.vrabel@citrix.com
Subject: [PATCH WIP 4/5] xen: allow privcmd for hvm guests
Date: Wed, 4 Jul 2012 12:15:19 +0100
Message-ID: <1341400520-31770-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian's initial XENMAPSPACE_gmfn_foreign implementation is enough to get
privcmd mmap to work for XENFEAT_auto_translated_physmap guests.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/xenfs/privcmd.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
index c200b49..5c2b9e9 100644
--- a/drivers/xen/xenfs/privcmd.c
+++ b/drivers/xen/xenfs/privcmd.c
@@ -387,13 +387,6 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	//printk(KERN_CRIT "privcmd_mmap\n");
 
-	/* Unsupported for auto-translate guests. */
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-	{
-		printk(KERN_CRIT "privcmd_mmap -- no auto translated..\n");
-		return -ENOSYS;
-	}
-
 	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
 	 * how to recreate these mappings */
 	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
-- 
1.7.2.5

