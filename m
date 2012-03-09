Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab2CIUNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:13:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031143Ab2CITuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:13 -0500
Message-Id: <20120309190209.060597954@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@suse.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 84/95] x86/amd: iommu_set_device_table() must not be __init
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 6b7f000eb6a0b81d7a809833edb7a457eedf8512 upstream.

This function is called from enable_iommus(), which in turn is used
from amd_iommu_resume().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -268,7 +268,7 @@ static void iommu_set_exclusion_range(st
 }
 
 /* Programs the physical address of the device table into the IOMMU hardware */
-static void __init iommu_set_device_table(struct amd_iommu *iommu)
+static void iommu_set_device_table(struct amd_iommu *iommu)
 {
 	u64 entry;
 


