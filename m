Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab2DXWh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:37:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768Ab2DXWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:52 -0400
Message-Id: <20120424223253.987401789@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 06/42] xen/gntdev: do not set VM_PFNMAP
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/gntdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -664,7 +664,7 @@ static int gntdev_mmap(struct file *flip
 	vma->vm_flags |= VM_RESERVED|VM_DONTEXPAND;
 
 	if (use_ptemod)
-		vma->vm_flags |= VM_DONTCOPY|VM_PFNMAP;
+		vma->vm_flags |= VM_DONTCOPY;
 
 	vma->vm_private_data = map;
 


