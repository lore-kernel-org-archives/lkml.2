Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1BPWTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:19:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22195 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1BPWTs (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Feb 2011 17:19:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Tejun Heo <tj@kernel.org>, Ryan Wilson <hap9@epoch.ncsc.mil>,
        Jan Beulich <JBeulich@novell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] xen-pcifront: don't use flush_scheduled_work()
Date: Wed, 16 Feb 2011 17:17:18 -0500
Message-Id: <1297894638-28007-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D5C4D4F.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

flush_scheduled_work() is scheduled for deprecation.  Cancel ->op_work
directly instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ryan Wilson <hap9@epoch.ncsc.mil>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/xen-pcifront.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 6acf6ae..dd615d9 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -744,8 +744,7 @@ static void free_pdev(struct pcifront_device *pdev)
 
 	pcifront_free_roots(pdev);
 
-	/*For PCIE_AER error handling job*/
-	flush_scheduled_work();
+	cancel_work_sync(&pdev->op_work);
 
 	if (pdev->irq >= 0)
 		unbind_from_irqhandler(pdev->irq, pdev);
-- 
1.7.1

