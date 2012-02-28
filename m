Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030207Ab2B1Sur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:50:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53933 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966018Ab2B1Suo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:50:44 -0500
From: Joe Perches <joe@perches.com>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Jiri Kosina <trivial@kernel.org>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 6/9] parisc: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:35 -0800
Message-Id: <3aaf784d1f3b62a6ede3de47db5921b037c73423.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/parisc/superio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index e3b76d4..5003458 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -348,7 +348,7 @@ int superio_fixup_irq(struct pci_dev *pcidev)
 		BUG();
 		return -1;
 	}
-	printk("superio_fixup_irq(%s) ven 0x%x dev 0x%x from %p\n",
+	printk("superio_fixup_irq(%s) ven 0x%x dev 0x%x from %pf\n",
 		pci_name(pcidev),
 		pcidev->vendor, pcidev->device,
 		__builtin_return_address(0));
-- 
1.7.8.111.gad25c.dirty

