Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2JQGcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:32:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31351 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2JQGcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:32:13 -0400
Message-ID: <507E50E5.5040201@oracle.com>
Date: Wed, 17 Oct 2012 14:32:05 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Ron Mercer <ron.mercer@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        linux-driver@qlogic.com
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Marsden <greg.marsden@oracle.com>
Subject: [PATCH] qla3xxx: Ensure req_q_phy_addr writes to the register
Content-Type: multipart/mixed;
 boundary="------------000705040308040202030600"
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000705040308040202030600
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Make sure req_q_phy_addr write to the register.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index df09b1c..78b4cba 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2525,6 +2525,12 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
 	qdev->req_q_size =
 	    (u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));
 
+	/*
+	 * The barrier is required to ensure that req_q_phy_addr writes to
+	 * the memory.
+	 */
+	wmb();
+
 	qdev->req_q_virt_addr =
 	    pci_alloc_consistent(qdev->pdev,
 				 (size_t) qdev->req_q_size,
-- 
1.7.11.7


--------------000705040308040202030600
Content-Type: text/plain; charset=us-ascii;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------000705040308040202030600--
