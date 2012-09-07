Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab2IGG7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:59:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34969 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab2IGG7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:59:16 -0400
MIME-Version: 1.0
Date: Fri, 7 Sep 2012 14:59:15 +0800
Message-ID: <CAPgLHd_XzmeXysTj5cAWXJKeqU106bmLrHadxtbeJtF6ToyQXA@mail.gmail.com>
Subject: [PATCH] staging: tidspbridge: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: omar.ramirez@ti.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/tidspbridge/core/chnl_sm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index e0c7e4c..c03b07f 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -94,7 +94,7 @@ int bridge_chnl_add_io_req(struct chnl_object *chnl_obj, void *host_buf,
 	struct dev_object *dev_obj;
 	u8 dw_state;
 	bool is_eos;
-	struct chnl_mgr *chnl_mgr_obj = pchnl->chnl_mgr_obj;
+	struct chnl_mgr *chnl_mgr_obj;
 	u8 *host_sys_buf = NULL;
 	bool sched_dpc = false;
 	u16 mb_val = 0;
@@ -153,6 +153,7 @@ func_cont:
 	 * If DPC is scheduled in process context (iosm_schedule) and any
 	 * non-mailbox interrupt occurs, that DPC will run and break CS. Hence
 	 * we disable ALL DPCs. We will try to disable ONLY IO DPC later. */
+	chnl_mgr_obj = pchnl->chnl_mgr_obj;
 	spin_lock_bh(&chnl_mgr_obj->chnl_mgr_lock);
 	omap_mbox_disable_irq(dev_ctxt->mbox, IRQ_RX);
 	if (pchnl->chnl_type == CHNL_PCPY) {

