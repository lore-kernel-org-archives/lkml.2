Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab0LHBEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:22 -0500
Received: from kroah.org ([198.145.64.141]:33940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab0LHBEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:15 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:49 2010
Message-Id: <20101208005749.737342948@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:01:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [283/289] r8169: (re)init phy on resume
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/r8169.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4889,6 +4889,9 @@ static int rtl8169_resume(struct device
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct net_device *dev = pci_get_drvdata(pdev);
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	rtl8169_init_phy(dev, tp);
 
 	if (netif_running(dev))
 		__rtl8169_resume(dev);
@@ -4929,6 +4932,8 @@ static int rtl8169_runtime_resume(struct
 	tp->saved_wolopts = 0;
 	spin_unlock_irq(&tp->lock);
 
+	rtl8169_init_phy(dev, tp);
+
 	__rtl8169_resume(dev);
 
 	return 0;


