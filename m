Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab0GWUVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:21:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab0GWUVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:21:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI: Do not run NVidia quirks related to MSI with MSI disabled
Date: Fri, 23 Jul 2010 22:19:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007232219.55331.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is no reason to run NVidia-specific quirks related to HT MSI
mappings with MSI disabled via pci=nomsi, so make
__nv_msi_ht_cap_quirk() return immediately in that case.

This allows at least one machine to boot 100% of the time with
pci=nomsi (it still doesn't boot reliably without that).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16443 .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2390,6 +2390,9 @@ static void __devinit __nv_msi_ht_cap_qu
 	int pos;
 	int found;
 
+	if (!pci_msi_enabled())
+		return;
+
 	/* check if there is HT MSI cap or enabled on this device */
 	found = ht_check_msi_mapping(dev);
 
