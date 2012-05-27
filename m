Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2E0BPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:15:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2E0BOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:14:55 -0400
Message-Id: <20120527002510.135103480@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:21 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 15/91] RDMA/cxgb4: Use dst parameter in import_ep()
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit bd61baaf59669accae2720799394a51fecabe5d9 upstream.

Function import_ep() is incorrectly using ep->dst instead of the dst
ptr passed in.  This causes a crash when accepting new rdma connections
becase ep->dst is not initialized yet.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/cxgb4/cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1593,7 +1593,7 @@ static int import_ep(struct c4iw_ep *ep,
 					n, n->dev, 0);
 		if (!ep->l2t)
 			goto out;
-		ep->mtu = dst_mtu(ep->dst);
+		ep->mtu = dst_mtu(dst);
 		ep->tx_chan = cxgb4_port_chan(n->dev);
 		ep->smac_idx = (cxgb4_port_viid(n->dev) & 0x7F) << 1;
 		step = cdev->rdev.lldi.ntxq /


