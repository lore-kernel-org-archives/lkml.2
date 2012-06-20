Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2FTSW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2FTSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:54 -0400
Message-Id: <20120620173024.198689081@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ricardo Martins <rasm@fe.up.pt>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 38/61] USB: fix PS3 EHCI systems
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-hcd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -671,7 +671,9 @@ static int ehci_init(struct usb_hcd *hcd
 	hw = ehci->async->hw;
 	hw->hw_next = QH_NEXT(ehci, ehci->async->qh_dma);
 	hw->hw_info1 = cpu_to_hc32(ehci, QH_HEAD);
+#if defined(CONFIG_PPC_PS3)
 	hw->hw_info1 |= cpu_to_hc32(ehci, (1 << 7));	/* I = 1 */
+#endif
 	hw->hw_token = cpu_to_hc32(ehci, QTD_STS_HALT);
 	hw->hw_qtd_next = EHCI_LIST_END(ehci);
 	ehci->async->qh_state = QH_STATE_LINKED;


