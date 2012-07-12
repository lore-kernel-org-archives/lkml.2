Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663Ab2GLWin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:38:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35876 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2GLWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shuah Khan <shuah.khan@hp.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 053/187] iommu/amd: Fix missing iommu_shutdown initialization in passthrough mode
Date: Thu, 12 Jul 2012 15:33:29 -0700
Message-Id: <20120712191527.261633018@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

commit f2f12b6fc032c7b1419fd6db84e2868b5f05a878 upstream.

The iommu_shutdown callback is not initialized when the AMD
IOMMU driver runs in passthrough mode. Fix that by moving
the callback initialization before the check for
passthrough mode.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1641,6 +1641,8 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_api();
 
+	x86_platform.iommu_shutdown = disable_iommus;
+
 	if (iommu_pass_through)
 		goto out;
 
@@ -1649,8 +1651,6 @@ static int __init amd_iommu_init(void)
 	else
 		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
-	x86_platform.iommu_shutdown = disable_iommus;
-
 out:
 	return ret;
 


