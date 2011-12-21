Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1LUBdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:33:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45550 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057Ab1LUBd3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:33:29 -0500
Message-ID: <1324431204.2844.148.camel@deadeye>
Subject: [PATCH 3/8] drm: Do not include page offset in argument to
 virt_to_page()
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 01:33:24 +0000
In-Reply-To: <1324430940.2844.144.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By definition, the page offset will not affect the result.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_vm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 8c03eaf..98c3922 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -306,7 +306,7 @@ static int drm_do_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	offset = (unsigned long)vmf->virtual_address - vma->vm_start;	/* vm_[pg]off[set] should be 0 */
 	page_nr = offset >> PAGE_SHIFT; /* page_nr could just be vmf->pgoff */
-	page = virt_to_page((dma->pagelist[page_nr] + (offset & (~PAGE_MASK))));
+	page = virt_to_page(dma->pagelist[page_nr]);
 
 	get_page(page);
 	vmf->page = page;
-- 
1.7.7.3



