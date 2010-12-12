Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0LLXuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:50:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36921 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab0LLXsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:45 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: sgruszka@redhat.com, davem@davemloft.net, romieu@fr.zoreil.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [216/223] r8169: (re)init phy on resume
Message-Id: <20101212234843.DB1FBB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>

commit fccec10b33503a2b1197c8e7a3abd30443bedb08 upstream.

Fix switching device to low-speed mode after resume reported in:
https://bugzilla.redhat.com/show_bug.cgi?id=502974

Reported-and-tested-by: Laurentiu Badea <bugzilla-redhat@wotevah.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/r8169.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/net/r8169.c
===================================================================
--- linux.orig/drivers/net/r8169.c
+++ linux/drivers/net/r8169.c
@@ -4893,6 +4893,9 @@ static int rtl8169_resume(struct device
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct net_device *dev = pci_get_drvdata(pdev);
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	rtl8169_init_phy(dev, tp);
 
 	if (netif_running(dev))
 		__rtl8169_resume(dev);
@@ -4933,6 +4936,8 @@ static int rtl8169_runtime_resume(struct
 	tp->saved_wolopts = 0;
 	spin_unlock_irq(&tp->lock);
 
+	rtl8169_init_phy(dev, tp);
+
 	__rtl8169_resume(dev);
 
 	return 0;
