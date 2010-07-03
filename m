Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0GCQEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:04:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0GCQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pK1i/5sabPqScx6bgSS+zjYkj9truX9zDU1mLyf/Cy9tTTKPMc7YSaX/92I41vUKoc
         OZQdSRgB+61GOUEdJ6pJoKXfbdbAHhlQXSgGUtNgli/Yp9QJFGOICcewEJOkWyHhf9N5
         XXQvThvuQjjU59q1IYBmhLUuju/3ljbZjbwCM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/19] arch/x86/kernel: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:03:59 +0400
Message-Id: <1278173040-11643-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/x86/kernel/k8.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 0f7bc20..0ea4b35 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -27,11 +27,10 @@ EXPORT_SYMBOL(k8_northbridges);
 
 static struct pci_dev *next_k8_northbridge(struct pci_dev *dev)
 {
-	do {
-		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
-		if (!dev)
+	for_each_pci_dev(dev) {
+		if (pci_match_id(&k8_nb_ids[0], dev))
 			break;
-	} while (!pci_match_id(&k8_nb_ids[0], dev));
+	}
 	return dev;
 }
 
-- 
1.7.0.4

