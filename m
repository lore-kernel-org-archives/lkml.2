Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2BXHsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:48:20 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38179 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab2BXHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:47:31 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/11] PCI: Use class for quirk for intel e100 interrupt fixup
Date: Thu, 23 Feb 2012 23:46:57 -0800
Message-Id: <1330069619-14446-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
References: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F474092.002C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 03e455a..91733a2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1957,7 +1957,8 @@ static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 
 	iounmap(csr);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_e100_interrupt);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+			PCI_CLASS_NETWORK_ETHERNET, 8, quirk_e100_interrupt);
 
 /*
  * The 82575 and 82598 may experience data corruption issues when transitioning
-- 
1.7.7

