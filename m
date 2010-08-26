Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0HZNVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:21:32 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33100 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751216Ab0HZNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:24 -0400
Message-Id: <20100826132123.612760064@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:41 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 04/25] GRU - mmap gru contexts using nonlinear
References: <20100826131937.108920216@sgi.com>
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
 

