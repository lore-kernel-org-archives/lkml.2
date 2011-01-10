Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1AJKf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:35:28 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:18418 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab1AJKfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:23 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293737"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/12] xen/gntdev: add VM_PFNMAP to vma
Date: Mon, 10 Jan 2011 10:36:32 +0000
Message-Id: <1294655801-16230-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:22.0628 (UTC) FILETIME=[15C7E440:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

These pages are from other domains, so don't have any local PFN.
VM_PFNMAP is the closest concept Linux has to this.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/gntdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index cfe0633..fa6355a 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -564,7 +564,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 
 	vma->vm_ops = &gntdev_vmops;
 
-	vma->vm_flags |= VM_RESERVED|VM_DONTCOPY|VM_DONTEXPAND;
+	vma->vm_flags |= VM_RESERVED|VM_DONTCOPY|VM_DONTEXPAND|VM_PFNMAP;
 
 	vma->vm_private_data = map;
 	map->vma = vma;
-- 
1.5.6.5

