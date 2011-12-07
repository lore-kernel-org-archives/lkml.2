Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab1LGQXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab1LGQW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161219.288448119@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:57 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [055/104] iwlwifi: allow pci_enable_msi fail
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 8a39ef8ba0fa0410d71db8e981e887fe4fdeca88 upstream.

Continue the init process even fail to enable msi

out_iounmap is no longer used, remove it

Reported-by: werner <w.landgraf@ru.ru>
Tested-by: werner <w.landgraf@ru.ru>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -442,10 +442,9 @@ static int iwl_pci_probe(struct pci_dev
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
 	err = pci_enable_msi(pdev);
-	if (err) {
-		dev_printk(KERN_ERR, &pdev->dev, "pci_enable_msi failed");
-		goto out_iounmap;
-	}
+	if (err)
+		dev_printk(KERN_ERR, &pdev->dev,
+			"pci_enable_msi failed(0X%x)", err);
 
 	/* TODO: Move this away, not needed if not MSI */
 	/* enable rfkill interrupt: hw bug w/a */
@@ -466,7 +465,6 @@ static int iwl_pci_probe(struct pci_dev
 
 out_disable_msi:
 	pci_disable_msi(pdev);
-out_iounmap:
 	pci_iounmap(pdev, pci_bus->hw_base);
 out_pci_release_regions:
 	pci_set_drvdata(pdev, NULL);


