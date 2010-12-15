Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0LONkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:40:47 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47832 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0LONko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:40:44 -0500
X-IronPort-AV: E=Sophos;i="4.59,349,1288584000"; 
   d="scan'208";a="126991557"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/11] xen/gntdev: add VM_PFNMAP to vma
Date: Wed, 15 Dec 2010 13:40:38 +0000
Message-Id: <1292420446-3348-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
X-OriginalArrivalTime: 15 Dec 2010 13:40:43.0281 (UTC) FILETIME=[AB776010:01CB9C5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

These pages are from other domains, so don't have any local PFN.
VM_PFNMAP is the closest concept Linux has to this.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/gntdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 45898d4..cf61c7d 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -574,6 +574,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_flags |= VM_DONTCOPY;
 	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_flags |= VM_PFNMAP;
 
 	vma->vm_private_data = map;
 	map->vma = vma;
-- 
1.5.6.5

