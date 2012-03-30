Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936348Ab2C3Vs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:48:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62781 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936007Ab2C3VUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:33 -0400
Message-Id: <20120330194839.211667196@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yoichi Yuasa <yuasa@linux-mips.org>,
        Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 075/175] gma500: Fix mmap frambuffer
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoichi Yuasa <yuasa@linux-mips.org>

commit 1278f7de7fa5606ed513a5271f7fb63910ef1b8b upstream.

It cannot map correctly if page fault begins from a intermediate address.

[The driver prefaults the mapping, so we need to work from the correct
 base address not the faulting address otherwise the map appears offset by
 the fault offset]

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/framebuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -158,7 +158,7 @@ static int psbfb_vm_fault(struct vm_area
 	unsigned long phys_addr = (unsigned long)dev_priv->stolen_base;
 
 	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	address = (unsigned long)vmf->virtual_address;
+	address = (unsigned long)vmf->virtual_address - (vmf->pgoff << PAGE_SHIFT);
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 


