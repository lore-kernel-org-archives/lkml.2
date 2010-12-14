Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab0LNQKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:10:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:56687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab0LNQKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:10:03 -0500
Message-ID: <4D0796D7.3030309@kernel.org>
Date: Tue, 14 Dec 2010 17:09:59 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Chan <mchan@broadcom.com>, netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next-2.6] bnx2: remove cancel_work_sync() from remove_one
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 16:10:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael pointed out that bnx2_close() already cancels bp->reset_task
and thus it is guaranteed to be idle when bnx2_remove_one() is called.
Remove the unnecessary cancel_work_sync() in remove_one.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michael Chan <mchan@broadcom.com>
---
 drivers/net/bnx2.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 5c811f3..85fc2c8 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -8393,8 +8393,6 @@ bnx2_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnx2 *bp = netdev_priv(dev);

-	cancel_work_sync(&bp->reset_task);
-
 	unregister_netdev(dev);

 	if (bp->mips_firmware)
