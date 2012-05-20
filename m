Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab2EVUrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:47:46 -0400
Received: from mail.mimuw.edu.pl ([193.0.96.6]:46897 "EHLO mail.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab2EVUro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:47:44 -0400
In-Reply-To: <20120522194319.GA2691@phenom.dumpdata.com>
References: <20120522194319.GA2691@phenom.dumpdata.com>
From: Marek Marczykowski <marmarek@invisiblethingslab.com>
Date: Sun, 20 May 2012 13:45:10 +0200
Subject: [PATCH RESENT] xen: do not disable netfront in dom0
Organization: Invisible Things Lab
To: David Miller <davem@davemloft.net>
Cc: Marek Marczykowski <marmarek@invisiblethingslab.com>,
        Ian.Campbell@citrix.com, xen-devel@lists.xen.org,
        virtualization@lists.linux-foundation.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20120522204742.29E8A626@duch.mimuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netfront driver can be also useful in dom0, eg when all NICs are assigned to
some domU (aka driver domain). Then using netback in domU and netfront in dom0
is the only way to get network access in dom0.

Signed-off-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/net/xen-netfront.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 0ebbb19..2027afe 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1962,9 +1962,6 @@ static int __init netif_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	if (xen_initial_domain())
-		return 0;
-
 	if (xen_hvm_domain() && !xen_platform_pci_unplug)
 		return -ENODEV;
 
@@ -1977,9 +1974,6 @@ module_init(netif_init);
 
 static void __exit netif_exit(void)
 {
-	if (xen_initial_domain())
-		return;
-
 	xenbus_unregister_driver(&netfront_driver);
 }
 module_exit(netif_exit);
-- 
1.7.4.4

