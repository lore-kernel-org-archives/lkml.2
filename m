Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab0HEUXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:23:25 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55629 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab0HEUXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:23:18 -0400
Date: Thu, 5 Aug 2010 22:23:16 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 21/42] drivers/pci: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052223010.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7fa3cbd..cc232c0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2689,7 +2689,7 @@ int pcie_get_readrq(struct pci_dev *dev)
 
 	ret = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
 	if (!ret)
-	ret = 128 << ((ctl & PCI_EXP_DEVCTL_READRQ) >> 12);
+		ret = 128 << ((ctl & PCI_EXP_DEVCTL_READRQ) >> 12);
 
 	return ret;
 }
