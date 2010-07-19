Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967052Ab0GSVoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:44:38 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53685 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966846Ab0GSVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:53 -0400
Message-Id: <20100719213851.788051764@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:22 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 04/25] GRU - mmap gru contexts using nonlinear
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_nonlinear
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add VM_NONLINEAR to the vm_flags used to map the GRU.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:39.751457793 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:40.740099769 -0500
@@ -110,7 +110,7 @@ static int gru_file_mmap(struct file *fi
 
 	vma->vm_flags |=
 	    (VM_IO | VM_DONTCOPY | VM_LOCKED | VM_DONTEXPAND | VM_PFNMAP |
-			VM_RESERVED);
+			VM_RESERVED | VM_NONLINEAR);
 	vma->vm_page_prot = PAGE_SHARED;
 	vma->vm_ops = &gru_vm_ops;
 

