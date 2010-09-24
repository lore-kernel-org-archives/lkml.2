Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0IXQim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:38:42 -0400
Received: from kroah.org ([198.145.64.141]:37426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126Ab0IXQfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.086994348@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [57/68] hostap_pci: set dev->base_addr during probe
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 0f4da2d77e1bf424ac36424081afc22cbfc3ff2b upstream.

"hostap: Protect against initialization interrupt" (which reinstated
"wireless: hostap, fix oops due to early probing interrupt")
reintroduced Bug 16111.  This is because hostap_pci wasn't setting
dev->base_addr, which is now checked in prism2_interrupt.  As a result,
initialization was failing for PCI-based hostap devices.  This corrects
that oversight.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/hostap/hostap_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/hostap/hostap_pci.c
+++ b/drivers/net/wireless/hostap/hostap_pci.c
@@ -329,6 +329,7 @@ static int prism2_pci_probe(struct pci_d
 
         dev->irq = pdev->irq;
         hw_priv->mem_start = mem;
+	dev->base_addr = (unsigned long) mem;
 
 	prism2_pci_cor_sreset(local);
 


