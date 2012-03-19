Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162127Ab2CSFvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:51:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25578 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162073Ab2CSFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:50:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 22/26] PCI: Update pci_resource_bar() to support addon_resource
Date: Sun, 18 Mar 2012 22:48:45 -0700
Message-Id: <1332136129-14010-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F66C907.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need to loop addon resource list to retrieve reg_addr in it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5439033..8b9acf6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3549,6 +3549,13 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 		reg = pci_iov_resource_bar(dev, resno, type);
 		if (reg)
 			return reg;
+	} else if (resno >= PCI_NUM_RESOURCES) {
+		struct resource *res = pci_dev_resource_n(dev, resno);
+
+		if (res) {
+			*type = pci_bar_unknown;
+			return to_pci_dev_addon_resource(res)->reg_addr;
+		}
 	}
 
 	dev_err(&dev->dev, "BAR %d: invalid resource\n", resno);
-- 
1.7.7

