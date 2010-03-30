Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab0C3X32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:29:28 -0400
Received: from kroah.org ([198.145.64.141]:46717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936Ab0C3XVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:47 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:46 2010
Message-Id: <20100330224845.812087756@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [131/156] e100: Fix ring parameter change handling regression.
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 211a0d941b1924e667483f822a55e2cc694cd212 ]

When the PCI pool changes were added to fix resume failures:

commit 98468efddb101f8a29af974101c17ba513b07be1
e100: Use pci pool to work around GFP_ATOMIC order 5 memory allocation failu

and

commit 70abc8cb90e679d8519721e2761d8366a18212a6
e100: Fix broken cbs accounting due to missing memset.

This introduced a problem that can happen if the TX ring size
is increased.  We need to size the PCI pool using cbs->max
instead of the default cbs->count value.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -2854,7 +2854,7 @@ static int __devinit e100_probe(struct p
 	}
 	nic->cbs_pool = pci_pool_create(netdev->name,
 			   nic->pdev,
-			   nic->params.cbs.count * sizeof(struct cb),
+			   nic->params.cbs.max * sizeof(struct cb),
 			   sizeof(u32),
 			   0);
 	DPRINTK(PROBE, INFO, "addr 0x%llx, irq %d, MAC addr %pM\n",


