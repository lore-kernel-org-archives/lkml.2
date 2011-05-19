Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab1ESPxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:53:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39752 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab1ESPxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:53:01 -0400
Date: Thu, 19 May 2011 08:52:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging: fix mei build when PM is not enabled
Message-Id: <20110519085234.2784f588.randy.dunlap@oracle.com>
In-Reply-To: <20110519135941.2fda46ca.sfr@canb.auug.org.au>
References: <20110519135941.2fda46ca.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DD53CD4.006D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mei build when CONFIG_PM is not enabled (i.e., fix typo):

drivers/staging/mei/main.c:1159: error: 'MEI_PM_OPS' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/mei/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110519.orig/drivers/staging/mei/main.c
+++ linux-next-20110519/drivers/staging/mei/main.c
@@ -1145,7 +1145,7 @@ static int mei_pci_resume(struct device 
 static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
 #define MEI_PM_OPS	(&mei_pm_ops)
 #else
-#define MIE_PM_OPS	NULL
+#define MEI_PM_OPS	NULL
 #endif /* CONFIG_PM */
 /*
  *  PCI driver structure
