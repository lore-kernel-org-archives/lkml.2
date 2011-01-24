Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1AXOcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:32:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56550 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1AXOcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nlpIilRjcSP4CB+oqWzH0Kmc4qiXuhe+cQKZ1YZq+jX3Ugd2UglVa8Es3ecFzOc30Z
         po4fOnFd2+Hdm4OPrYaTGXmYSSx6z1LNW/r9t/zeI3wZD52Gt8bgAJudtU1xT6XPd8FO
         ztpr3Dwn//AJzU0pLF+LdP66emKF4g0ezxcbM=
Date: Mon, 24 Jan 2011 15:32:25 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Subject: [PATCH] pch_gbe: don't use flush_scheduled_work()
Message-ID: <20110124143225.GF11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly cancel adapter->reset_task instead of using to-be-deprecated
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/drivers/net/pch_gbe/pch_gbe_main.c
===================================================================
--- work.orig/drivers/net/pch_gbe/pch_gbe_main.c
+++ work/drivers/net/pch_gbe/pch_gbe_main.c
@@ -2247,7 +2247,7 @@ static void pch_gbe_remove(struct pci_de
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 
-	flush_scheduled_work();
+	cancel_work_sync(&adapter->reset_task);
 	unregister_netdev(netdev);
 
 	pch_gbe_hal_phy_hw_reset(&adapter->hw);
