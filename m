Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0GCQDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:03:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab0GCQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=j8Oxtl8eg8SEfzC8wdSOTdf+7x2A42pDDAHuaPOLCp0PJjOMMJFO+wa/6XsBR1cKey
         GMuXbge/2GgGIYTAHegmZ4kzL7TXGYSPAIPzxIb7Dg9sYczq8ifBW3jybUQSVNLqDQgZ
         jWCgajaFXLhjkY8oc4d/CWmDTJEk1QJVNu/Mc=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       David Howells <dhowells@redhat.com>, linux-cris-kernel@axis.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 02/19] arch/cris/arch-v32/drivers/pci: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:03:37 +0400
Message-Id: <1278173019-11473-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/cris/arch-v32/drivers/pci/bios.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index bc0cfda..6c3c8e8 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -109,7 +109,7 @@ int pcibios_assign_resources(void)
 	int idx;
 	struct resource *r;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 		int class = dev->class >> 8;
 
 		/* Don't touch classless devices and host bridges */
-- 
1.7.0.4

