Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab2CFT0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:26:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab2CFT0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:26:39 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        Matthew Garrett <mjg@redhat.com>, stable@kernel.org
Subject: [PATCH] Ignore pre-1.1 ASPM quirking when ASPM is disabled
Date: Tue,  6 Mar 2012 13:41:49 -0500
Message-Id: <1331059309-4335-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we won't touch ASPM state if ASPM is disabled, except in the case
where we find a device that appears to be too old to reliably support ASPM.
Right now we'll clear it in that case, which is almost certainly the wrong
thing to do. The easiest way around this is just to disable the blacklisting
when ASPM is disabled.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@kernel.org
---
 drivers/pci/pcie/aspm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 1cfbf22..24f049e 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -500,6 +500,9 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 	int pos;
 	u32 reg32;
 
+	if (aspm_disabled)
+		return 0;
+
 	/*
 	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot
-- 
1.7.7.6

