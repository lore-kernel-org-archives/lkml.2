Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2IBVeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:34:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46129 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2IBVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:07 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/7] x86, probe_roms: add missing __iomem annotation to pci_map_biosrom()
Date: Sun,  2 Sep 2012 23:31:43 +0200
Message-Id: <1346621506-30857-5-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stay in sync with the declaration and fix the corresponding sparse
warnings.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kernel/probe_roms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 0bc72e2..d5f15c3 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -150,7 +150,7 @@ static struct resource *find_oprom(struct pci_dev *pdev)
 	return oprom;
 }
 
-void *pci_map_biosrom(struct pci_dev *pdev)
+void __iomem *pci_map_biosrom(struct pci_dev *pdev)
 {
 	struct resource *oprom = find_oprom(pdev);
 
-- 
1.7.10.4

