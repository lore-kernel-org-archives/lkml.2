Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1KJE52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:57:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935194Ab1KJDa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:16 2011
Message-Id: <20111109212716.900684968@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christian Benvenuti <benve@cisco.com>,
        Danny Guo <dannguo@cisco.com>, Vasanthy Kolluri <vkolluri@cisco.com>,
        Roopa Prabhu <roprabhu@cisco.com>, David Wang <dwang2@cisco.com>,
        "David S. Miller" <davem@davemloft.net>, Chun-Yi Lee <jlee@suse.com>
Subject: [162/262] enic: Bug Fix: Fix hardware transmit queue indexing in enic_poll_controller
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasanthy Kolluri <vkolluri@cisco.com>

commit b880a954b9e2585ce325aedd76e4741880cab180 upstream.

Signed-off-by: Christian Benvenuti <benve@cisco.com>
Signed-off-by: Danny Guo <dannguo@cisco.com>
Signed-off-by: Vasanthy Kolluri <vkolluri@cisco.com>
Signed-off-by: Roopa Prabhu <roprabhu@cisco.com>
Signed-off-by: David Wang <dwang2@cisco.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Chun-Yi Lee <jlee@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/enic/enic_main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/enic/enic_main.c
+++ b/drivers/net/enic/enic_main.c
@@ -1718,8 +1718,12 @@ static void enic_poll_controller(struct
 			enic_isr_msix_rq(enic->msix_entry[intr].vector,
 				&enic->napi[i]);
 		}
-		intr = enic_msix_wq_intr(enic, i);
-		enic_isr_msix_wq(enic->msix_entry[intr].vector, enic);
+
+		for (i = 0; i < enic->wq_count; i++) {
+			intr = enic_msix_wq_intr(enic, i);
+			enic_isr_msix_wq(enic->msix_entry[intr].vector, enic);
+		}
+
 		break;
 	case VNIC_DEV_INTR_MODE_MSI:
 		enic_isr_msi(enic->pdev->irq, enic);


