Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1AXOnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:43:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33136 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1AXOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=e3Z7IMAfg2lF1uuGpSZWyTNbu+ukReZSndYuMWEJsQwp9C/oI0SQwH022X2uaezf3C
         4ekoowk/gdWnECLVsyTzWH9QbLTHbLpi3A2gf4iTQETVRVq+7Pvv6qVOVSqgC2SJhrn5
         54Pe+oEaLSHbL2/vT0/mbMF7CRQCIJ1d+H0U8=
Date: Mon, 24 Jan 2011 15:43:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Ryan Wilson <hap9@epoch.ncsc.mil>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] xen-pcifront: don't use flush_scheduled_work()
Message-ID: <20110124144303.GG11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is scheduled for deprecation.  Cancel ->op_work
directly instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ryan Wilson <hap9@epoch.ncsc.mil>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/xen-pcifront.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/drivers/pci/xen-pcifront.c
===================================================================
--- work.orig/drivers/pci/xen-pcifront.c
+++ work/drivers/pci/xen-pcifront.c
@@ -733,8 +733,7 @@ static void free_pdev(struct pcifront_de
 
 	pcifront_free_roots(pdev);
 
-	/*For PCIE_AER error handling job*/
-	flush_scheduled_work();
+	cancel_work_sync(&pdev->op_work);
 
 	if (pdev->irq >= 0)
 		unbind_from_irqhandler(pdev->irq, pdev);
