Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0GCQF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:05:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab0GCQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KeodpQ5zzZECwrVO7M9LTcWCQmKVEQBOGpOz5Sla/u3bHBH8G04PhjVXHp6JdG9bUo
         HgIWrYu5zIyHbs/wyW2x9IoriXmZwC4YS75VrHt6hRv6C9rJOsxaCi9mbTY9XWygwE1n
         EAAdlj/eibKKzpIsN5ROeDzjo5r2x/aZHNWxs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       David Teigland <teigland@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Hans J. Koch" <hjk@linutronix.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 13/19] drivers/pci/hotplug: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:24 +0400
Message-Id: <1278173065-11847-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/pci/hotplug/fakephp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 5317e4d..17d10e2 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -135,7 +135,7 @@ static int __init init_legacy(void)
 	struct pci_dev *pdev = NULL;
 
 	/* Add existing devices */
-	while ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev)))
+	for_each_pci_dev(pdev)
 		legacy_add_slot(pdev);
 
 	/* Be alerted of any new ones */
-- 
1.7.0.4

