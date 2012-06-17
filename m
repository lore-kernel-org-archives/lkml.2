Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab2FQSiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:38:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758073Ab2FQSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:37 -0400
Message-Id: <20120617175950.812174765@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ricardo Martins <rasm@fe.up.pt>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 65/69] USB: fix PS3 EHCI systems
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Martins <rasm@fe.up.pt>

commit 4f7a67e2dd49fbfba002c453bc24bf00e701cc71 upstream.

After commit aaa0ef289afe9186f81e2340114ea413eef0492a "PS3 EHCI QH
read work-around", Terratec Grabby (em28xx) stopped working with AMD
Geode LX 800 (USB controller AMD CS5536). Since this is a PS3 only
fix, the following patch adds a conditional block around it.

Signed-off-by: Ricardo Martins <rasm@fe.up.pt>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-hcd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b100f5f..800be38 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -671,7 +671,9 @@ static int ehci_init(struct usb_hcd *hcd)
 	hw = ehci->async->hw;
 	hw->hw_next = QH_NEXT(ehci, ehci->async->qh_dma);
 	hw->hw_info1 = cpu_to_hc32(ehci, QH_HEAD);
+#if defined(CONFIG_PPC_PS3)
 	hw->hw_info1 |= cpu_to_hc32(ehci, (1 << 7));	/* I = 1 */
+#endif
 	hw->hw_token = cpu_to_hc32(ehci, QTD_STS_HALT);
 	hw->hw_qtd_next = EHCI_LIST_END(ehci);
 	ehci->async->qh_state = QH_STATE_LINKED;


