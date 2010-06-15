Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0FOPfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:35:39 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:60018 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab0FOPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:35:37 -0400
From: "Jan-Bernd Themann" <ossthema@de.ibm.com>
Organization: IBM
Subject: [PATCH 1/2] ehea: fix delayed packet processing
Date: Tue, 15 Jun 2010 17:35:16 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, tklein@linux.ibm.com,
       Andre Detsch <adetsch@br.ibm.com>, themann@de.ibm.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151735.17258.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the eHEA poll function an rmb() is required. Without that some packets
on the receive queue are not seen and thus delayed until the next interrupt
is handled for the same receive queue.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

---
Patch created against 2.6.35-rc3

 drivers/net/ehea/ehea_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index f547894..fd890fa 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -867,6 +867,7 @@ static int ehea_poll(struct napi_struct *napi, int budget)
 		ehea_reset_cq_ep(pr->send_cq);
 		ehea_reset_cq_n1(pr->recv_cq);
 		ehea_reset_cq_n1(pr->send_cq);
+		rmb();
 		cqe = ehea_poll_rq1(pr->qp, &wqe_index);
 		cqe_skb = ehea_poll_cq(pr->send_cq);
 
-- 
1.7.0
