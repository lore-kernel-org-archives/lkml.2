Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0EWIXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:23:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:59841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab0EWIW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:22:58 -0400
Message-ID: <4BF8E5DF.6030408@kernel.org>
Date: Sun, 23 May 2010 10:22:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       stable <stable@kernel.org>
Subject: [PATCH] pci: disable MSI on VIA K8M800
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 May 2010 08:22:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSI delivery from on-board ahci controller doesn't work on K8M800.  At
this point, it's unclear whether the culprit is with the ahci
controller or the host bridge.  Given the track record and considering
the rather minimal impact of MSI, disabling it seems reasonable.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Rainer Hurtado Navarro <publio.escipion.el.africano@gmail.com>
Cc: stable@kernel.org
---
Maybe we should whitelist working ones from via rather than the other
way around.  :-(

 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 27c0e6e..18a661d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2112,6 +2112,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disabl
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3364, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8380_0, quirk_disable_all_msi);

 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
