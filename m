Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab2JSBYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:24:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32073 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2JSBYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:24:46 -0400
Message-ID: <5080ABD7.90006@oracle.com>
Date: Fri, 19 Oct 2012 09:24:39 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Ron Mercer <ron.mercer@qlogic.com>, Linux-Driver@qlogic.com,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Joe Jin <joe.jin@oracle.com>
CC: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg Marsden <greg.marsden@oracle.com>
Subject: [PATCH] qla3xxx: Ensure request/response queue addr writes to the
 registers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before use the request and response queue addr, make sure it has wrote
to the registers.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index df09b1c..f745ade 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2525,6 +2525,12 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
 	qdev->req_q_size =
 	    (u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));
 
+	/*
+	 * The barrier is required to ensure request and response queue
+	 * addr writes to the registers.
+	 */
+	wmb();
+
 	qdev->req_q_virt_addr =
 	    pci_alloc_consistent(qdev->pdev,
 				 (size_t) qdev->req_q_size,
-- 
1.7.11.7

