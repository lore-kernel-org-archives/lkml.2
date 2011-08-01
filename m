Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1HAXfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:35:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1HAXZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:54 2011
Message-Id: <20110801232054.624750376@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [40/70] ath5k: fix incorrect use of drvdata in PCI suspend/resume code
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Roskin <proski@gnu.org>

commit 37000b305bff81bb1ee2f7f37b1319b670a08f76 upstream.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/pci.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -265,7 +265,9 @@ ath5k_pci_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int ath5k_pci_suspend(struct device *dev)
 {
-	struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
 
 	ath5k_led_off(sc);
 	return 0;
@@ -274,7 +276,8 @@ static int ath5k_pci_suspend(struct devi
 static int ath5k_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ath5k_softc *sc = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
 
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to


