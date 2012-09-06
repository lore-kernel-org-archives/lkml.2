Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab2IFRgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2IFRgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:36:38 -0400
From: Matthew Garrett <mjg@redhat.com>
To: bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] x86: Fix build warning on 32-bit
Date: Thu,  6 Sep 2012 13:36:16 -0400
Message-Id: <1346952976-18554-1-git-send-email-mjg@redhat.com>
In-Reply-To: <CAErSpo4A=ZWDuiGCFr6gQnFz--3OReVt0iWmzfjmOSQO=ZHNEw@mail.gmail.com>
References: <CAErSpo4A=ZWDuiGCFr6gQnFz--3OReVt0iWmzfjmOSQO=ZHNEw@mail.gmail.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the cast so it doesn't cause issues on 32-bit systems.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/pci/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 3d2752f..1e2deac 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -631,7 +631,7 @@ int pcibios_add_device(struct pci_dev *dev)
 			    (PCI_FUNC(dev->devfn) == rom->function) &&
 			    (dev->vendor == rom->vendor) &&
 			    (dev->device == rom->devid)) {
-				dev->rom = (void *)(pa_data +
+				dev->rom = (void *)(unsigned long)(pa_data +
 				      offsetof(struct pci_setup_rom, romdata));
 				dev->romlen = rom->pcilen;
 			}
-- 
1.7.11.4

