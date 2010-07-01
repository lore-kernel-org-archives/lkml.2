Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0GASXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:32 -0400
Received: from kroah.org ([198.145.64.141]:40464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840Ab0GASXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:23 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:11 2010
Message-Id: <20100701173211.873212832@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 060/149] x86/amd-iommu: Fix suspend/resume with IOMMU
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

This is a suspend resume fix for 2.6.32-stable inclusion. The
problem with this patch is that it is not upstream because the code
changed with 2.6.33 and the function where this bug is in was
removed. So this fix does not make sense anymore for anything later than
2.6.32. The patch was tested by multiple partys and is confirmed to fix
the broken suspend/resume issue with the 2.6.32 kernel.

This patch fixes suspend/resume with AMD IOMMU enabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -544,7 +544,7 @@ static void flush_devices_by_domain(stru
 
 	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
 		if ((domain == NULL && amd_iommu_pd_table[i] == NULL) ||
-		    (amd_iommu_pd_table[i] != domain))
+		    (domain != NULL && amd_iommu_pd_table[i] != domain))
 			continue;
 
 		iommu = amd_iommu_rlookup_table[i];


