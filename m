Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab0K3Vyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:54:43 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44572 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab0K3Vym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:54:42 -0500
Date: Tue, 30 Nov 2010 13:54:39 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cs5535-mfd: fix warning on x86-64 (v2)
Message-ID: <20101130135439.2e293d65@queued.net>
In-Reply-To: <20101130102257.008fb652.randy.dunlap@oracle.com>
References: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
	<20101129204410.339805ef@queued.net>
	<20101130102257.008fb652.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ARRAY_SIZE() returns size_t; use %zu instead of %d so that we don't
get warnings on x86-64.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/cs5535-mfd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index b141ca7..59ca6f1 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -103,7 +103,7 @@ static int __devinit cs5535_mfd_probe(struct pci_dev *pdev,
 		goto err_disable;
 	}
 
-	dev_info(&pdev->dev, "%d devices registered.\n",
+	dev_info(&pdev->dev, "%zu devices registered.\n",
 			ARRAY_SIZE(cs5535_mfd_cells));
 
 	return 0;
-- 
1.7.2.3

