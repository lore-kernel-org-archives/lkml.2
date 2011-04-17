Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1DQPWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 11:22:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1DQPWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 11:22:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=uvSQtT/UHYSy8r2f7cYgVYU7XxGrwkTRd0j0izjqhA+KxhaaL+LxUDe0kG9exPcay
	Zv8V8lGrXOhQJ76rzjtVA==
From: Greg Thelen <gthelen@google.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] PCI: check pci_vpd_pci22_wait() return
Date: Sun, 17 Apr 2011 08:22:21 -0700
Message-Id: <1303053741-384-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_vpd_pci22_write() calls pci_vpd_pci22_wait() after writing
PCI_VPD_DATA and PCI_VPD_ADDR to wait for the VPD operation to complete.
The result pci_vpd_pci22_wait() was not checked for error.

This change checks for error.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/pci/access.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 502610b..fdaa42a 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -334,6 +334,8 @@ static ssize_t pci_vpd_pci22_write(struct pci_dev *dev, loff_t pos, size_t count
 		vpd->busy = true;
 		vpd->flag = 0;
 		ret = pci_vpd_pci22_wait(dev);
+		if (ret < 0)
+			break;
 
 		pos += sizeof(u32);
 	}
-- 
1.7.3.1

