Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2BRWLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 17:11:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33098 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2BRWK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 17:10:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.236.153.36 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
From: Jorgyano Vieira <jorgyano@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        nsankar@broadcom.com, jarod@wilsonet.com,
        Jorgyano Vieira <jorgyano@gmail.com>
Subject: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro with pr_err
Date: Sat, 18 Feb 2012 20:10:20 -0200
Message-Id: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the usage of BCMLOG_ERR with pr_err and remove the macro definition.
Also added pr_fmt to identify the driver error messages.

Signed-ff-by: Jorgyano Vieira <jorgyano@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_cmds.c |   68 ++++++++--------
 drivers/staging/crystalhd/crystalhd_hw.c   |  119 ++++++++++++++--------------
 drivers/staging/crystalhd/crystalhd_lnx.c  |   96 +++++++++++-----------
 drivers/staging/crystalhd/crystalhd_lnx.h  |    4 +-
 drivers/staging/crystalhd/crystalhd_misc.c |   70 ++++++++--------
 drivers/staging/crystalhd/crystalhd_misc.h |   10 +--
 6 files changed, 181 insertions(+), 186 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index 3735ed3..46fac01 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -75,12 +75,12 @@ static enum BC_STATUS bc_cproc_notify_mode(struct crystalhd_cmd *ctx,
 	int rc = 0, i = 0;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if (ctx->user[idata->u_id].mode != DTS_MODE_INV) {
-		BCMLOG_ERR("Close the handle first..\n");
+		pr_err("Close the handle first..\n");
 		return BC_STS_ERR_USAGE;
 	}
 	if (idata->udata.u.NotifyMode.Mode == DTS_MONITOR_MODE) {
@@ -88,14 +88,14 @@ static enum BC_STATUS bc_cproc_notify_mode(struct crystalhd_cmd *ctx,
 		return BC_STS_SUCCESS;
 	}
 	if (ctx->state != BC_LINK_INVALID) {
-		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
+		pr_err("%s: Link invalid state %d\n", __func__, ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 	/* Check for duplicate playback sessions..*/
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
 		if (ctx->user[i].mode == DTS_DIAG_MODE ||
 		    ctx->user[i].mode == DTS_PLAYBACK_MODE) {
-			BCMLOG_ERR("multiple playback sessions are not "
+			pr_err("multiple playback sessions are not "
 				   "supported..\n");
 			return BC_STS_ERR_USAGE;
 		}
@@ -116,7 +116,7 @@ static enum BC_STATUS bc_cproc_get_version(struct crystalhd_cmd *ctx,
 {
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 	idata->udata.u.VerInfo.DriverMajor = crystalhd_kmod_major;
@@ -130,7 +130,7 @@ static enum BC_STATUS bc_cproc_get_hwtype(struct crystalhd_cmd *ctx,
 					struct crystalhd_ioctl_data *idata)
 {
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -198,7 +198,7 @@ static enum BC_STATUS bc_cproc_mem_rd(struct crystalhd_cmd *ctx,
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
-		BCMLOG_ERR("insufficient buffer\n");
+		pr_err("%s: insufficient buffer\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 	sts = crystalhd_mem_rd(ctx->adp, idata->udata.u.devMem.StartOff,
@@ -217,7 +217,7 @@ static enum BC_STATUS bc_cproc_mem_wr(struct crystalhd_cmd *ctx,
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
-		BCMLOG_ERR("insufficient buffer\n");
+		pr_err("%s: insufficient buffer\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -250,7 +250,7 @@ static enum BC_STATUS bc_cproc_cfg_rd(struct crystalhd_cmd *ctx,
 	for (ix = 0; ix < cnt; ix++) {
 		sts = crystalhd_pci_cfg_rd(ctx->adp, off, len, &temp[ix]);
 		if (sts != BC_STS_SUCCESS) {
-			BCMLOG_ERR("config read : %d\n", sts);
+			pr_err("config read : %d\n", sts);
 			return sts;
 		}
 		off += len;
@@ -282,7 +282,7 @@ static enum BC_STATUS bc_cproc_cfg_wr(struct crystalhd_cmd *ctx,
 	for (ix = 0; ix < cnt; ix++) {
 		sts = crystalhd_pci_cfg_wr(ctx->adp, off, len, temp[ix]);
 		if (sts != BC_STS_SUCCESS) {
-			BCMLOG_ERR("config write : %d\n", sts);
+			pr_err("config write : %d\n", sts);
 			return sts;
 		}
 		off += len;
@@ -297,12 +297,12 @@ static enum BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if (ctx->state != BC_LINK_INVALID) {
-		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
+		pr_err("%s: Link invalid state %d\n", __func__, ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 
@@ -310,7 +310,7 @@ static enum BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 				  idata->add_cdata_sz);
 
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("Firmware Download Failure!! - %d\n", sts);
+		pr_err("Firmware Download Failure!! - %d\n", sts);
 	} else
 		ctx->state |= BC_LINK_INIT;
 
@@ -337,7 +337,7 @@ static enum BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx,
 	uint32_t *cmd;
 
 	if (!(ctx->state & BC_LINK_INIT)) {
-		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
+		pr_err("%s: Link invalid state %d\n", __func__, ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 
@@ -377,7 +377,7 @@ static void bc_proc_in_completion(struct crystalhd_dio_req *dio_hnd,
 				  wait_queue_head_t *event, enum BC_STATUS sts)
 {
 	if (!dio_hnd || !event) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return;
 	}
 	if (sts == BC_STS_IO_USER_ABORT)
@@ -418,7 +418,7 @@ static enum BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 	int rc = 0;
 
 	if (!ctx || !idata || !dio) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -477,14 +477,14 @@ static enum BC_STATUS bc_cproc_check_inbuffs(bool pin, void *ubuff, uint32_t ub_
 					uint32_t uv_off, bool en_422)
 {
 	if (!ubuff || !ub_sz) {
-		BCMLOG_ERR("%s->Invalid Arg %p %x\n",
+		pr_err("%s->Invalid Arg %p %x\n",
 			((pin) ? "TX" : "RX"), ubuff, ub_sz);
 		return BC_STS_INV_ARG;
 	}
 
 	/* Check for alignment */
 	if (((uintptr_t)ubuff) & 0x03) {
-		BCMLOG_ERR("%s-->Un-aligned address not implemented yet.. %p\n",
+		pr_err("%s-->Un-aligned address not implemented yet.. %p\n",
 				((pin) ? "TX" : "RX"), ubuff);
 		return BC_STS_NOT_IMPL;
 	}
@@ -492,12 +492,12 @@ static enum BC_STATUS bc_cproc_check_inbuffs(bool pin, void *ubuff, uint32_t ub_
 		return BC_STS_SUCCESS;
 
 	if (!en_422 && !uv_off) {
-		BCMLOG_ERR("Need UV offset for 420 mode.\n");
+		pr_err("Need UV offset for 420 mode.\n");
 		return BC_STS_INV_ARG;
 	}
 
 	if (en_422 && uv_off) {
-		BCMLOG_ERR("UV offset in 422 mode ??\n");
+		pr_err("UV offset in 422 mode ??\n");
 		return BC_STS_INV_ARG;
 	}
 
@@ -513,7 +513,7 @@ static enum BC_STATUS bc_cproc_proc_input(struct crystalhd_cmd *ctx,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -526,7 +526,7 @@ static enum BC_STATUS bc_cproc_proc_input(struct crystalhd_cmd *ctx,
 
 	sts = crystalhd_map_dio(ctx->adp, ubuff, ub_sz, 0, 0, 1, &dio_hnd);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("dio map - %d\n", sts);
+		pr_err("%s: dio map - %d\n", __func__, sts);
 		return sts;
 	}
 
@@ -550,7 +550,7 @@ static enum BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -566,7 +566,7 @@ static enum BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	sts = crystalhd_map_dio(ctx->adp, ubuff, ub_sz, uv_off,
 			      en_422, 0, &dio_hnd);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("dio map - %d\n", sts);
+		pr_err("%s: dio map - %d\n", __func__, sts);
 		return sts;
 	}
 
@@ -606,7 +606,7 @@ static enum BC_STATUS bc_cproc_fetch_frame(struct crystalhd_cmd *ctx,
 	struct BC_DEC_OUT_BUFF *frame;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -658,7 +658,7 @@ static enum BC_STATUS bc_cproc_flush_cap_buffs(struct crystalhd_cmd *ctx,
 	uint32_t count;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -691,7 +691,7 @@ static enum BC_STATUS bc_cproc_get_stats(struct crystalhd_cmd *ctx,
 	struct crystalhd_hw_stats	hw_stats;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -732,7 +732,7 @@ static enum BC_STATUS bc_cproc_chg_clk(struct crystalhd_cmd *ctx,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -805,7 +805,7 @@ enum BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Parameters\n");
+		pr_err("%s: Invalid Parameters\n", __func__);
 		return BC_STS_ERROR;
 	}
 
@@ -885,7 +885,7 @@ enum BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
 	struct crystalhd_user *uc;
 
 	if (!ctx || !user_ctx) {
-		BCMLOG_ERR("Invalid arg..\n");
+		pr_err("%s: Invalid arg..\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -958,7 +958,7 @@ enum BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 	int i = 0;
 
 	if (!ctx || !adp) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -1016,12 +1016,12 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cm
 	unsigned int i, tbl_sz;
 
 	if (!ctx) {
-		BCMLOG_ERR("Invalid arg.. Cmd[%d]\n", cmd);
+		pr_err("Invalid arg.. Cmd[%d]\n", cmd);
 		return NULL;
 	}
 
 	if ((cmd != BCM_IOC_GET_DRV_STAT) && (ctx->state & BC_LINK_SUSPEND)) {
-		BCMLOG_ERR("Invalid State [suspend Set].. Cmd[%d]\n", cmd);
+		pr_err("Invalid State [suspend Set].. Cmd[%d]\n", cmd);
 		return NULL;
 	}
 
@@ -1054,7 +1054,7 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cm
 bool crystalhd_cmd_interrupt(struct crystalhd_cmd *ctx)
 {
 	if (!ctx) {
-		BCMLOG_ERR("Invalid arg..\n");
+		pr_err("%s: Invalid arg..\n", __func__);
 		return 0;
 	}
 
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 2d02ed2..af7a740 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -22,10 +22,11 @@
  * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
  **********************************************************************/
 
+#include "crystalhd_hw.h"
+
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include "crystalhd_hw.h"
 
 /* Functions internal to this file */
 
@@ -289,7 +290,7 @@ static bool crystalhd_start_device(struct crystalhd_adp *adp)
 	crystalhd_reg_wr(adp, PCIE_DLL_DATA_LINK_CONTROL, reg_pwrmgmt);
 
 	if (!crystalhd_bring_out_of_rst(adp)) {
-		BCMLOG_ERR("Failed To Bring Link Out Of Reset\n");
+		pr_err("Failed To Bring Link Out Of Reset\n");
 		return false;
 	}
 
@@ -334,7 +335,7 @@ static bool crystalhd_stop_device(struct crystalhd_adp *adp)
 	crystalhd_clear_interrupts(adp);
 
 	if (!crystalhd_put_in_reset(adp))
-		BCMLOG_ERR("Failed to Put Link To Reset State\n");
+		pr_err("Failed to Put Link To Reset State\n");
 
 	reg = crystalhd_reg_rd(adp, PCIE_DLL_DATA_LINK_CONTROL);
 	reg |= ASPM_L1_ENABLE;
@@ -409,14 +410,14 @@ static void crystalhd_rx_pkt_rel_call_back(void *context, void *data)
 	struct crystalhd_rx_dma_pkt *pkt = (struct crystalhd_rx_dma_pkt *)data;
 
 	if (!pkt || !hw) {
-		BCMLOG_ERR("Invalid arg - %p %p\n", hw, pkt);
+		pr_err("%s: Invalid arg - %p %p\n", __func__, hw, pkt);
 		return;
 	}
 
 	if (pkt->dio_req)
 		crystalhd_unmap_dio(hw->adp, pkt->dio_req);
 	else
-		BCMLOG_ERR("Missing dio_req: 0x%x\n", pkt->pkt_tag);
+		pr_err("Missing dio_req: 0x%x\n", pkt->pkt_tag);
 
 	crystalhd_hw_free_rx_pkt(hw, pkt);
 }
@@ -458,7 +459,7 @@ static enum BC_STATUS crystalhd_hw_create_ioqs(struct crystalhd_hw   *hw)
 	enum BC_STATUS   sts = BC_STS_SUCCESS;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -529,7 +530,7 @@ static enum BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw,
 	struct tx_dma_pkt *tx_req;
 
 	if (!hw || !list_id) {
-		BCMLOG_ERR("Invalid Arg..\n");
+		pr_err("%s: Invalid Arg..\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -538,7 +539,7 @@ static enum BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw,
 	tx_req = (struct tx_dma_pkt *)crystalhd_dioq_find_and_fetch(hw->tx_actq, list_id);
 	if (!tx_req) {
 		if (cs != BC_STS_IO_USER_ABORT)
-			BCMLOG_ERR("Find and Fetch Did not find req\n");
+			pr_err("Find and Fetch Did not find req\n");
 		return BC_STS_NO_DATA;
 	}
 
@@ -570,7 +571,7 @@ static bool crystalhd_tx_list0_handler(struct crystalhd_hw *hw, uint32_t err_sts
 	if (!(err_sts & err_mask))
 		return false;
 
-	BCMLOG_ERR("Error on Tx-L0 %x\n", err_sts);
+	pr_err("Error on Tx-L0 %x\n", err_sts);
 
 	tmp = err_mask;
 
@@ -602,7 +603,7 @@ static bool crystalhd_tx_list1_handler(struct crystalhd_hw *hw, uint32_t err_sts
 	if (!(err_sts & err_mask))
 		return false;
 
-	BCMLOG_ERR("Error on Tx-L1 %x\n", err_sts);
+	pr_err("Error on Tx-L1 %x\n", err_sts);
 
 	tmp = err_mask;
 
@@ -694,7 +695,7 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 
 	if (!ioreq || !desc || !desc_paddr_base || !xfr_sz ||
 	    (!sg_cnt && !ioreq->uinfo.dir_tx)) {
-		BCMLOG_ERR("Invalid Args\n");
+		pr_err("%s: Invalid Args\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -706,7 +707,7 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 		/* Get SGLE length */
 		len = crystalhd_get_sgle_len(ioreq, sg_ix);
 		if (len % 4) {
-			BCMLOG_ERR(" len in sg %d %d %d\n", len, sg_ix, sg_cnt);
+			pr_err(" len in sg %d %d %d\n", len, sg_ix, sg_cnt);
 			return BC_STS_NOT_IMPL;
 		}
 		/* Setup DMA desc with Phy addr & Length at current index. */
@@ -730,7 +731,7 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 
 		/* Debug.. */
 		if ((!len) || (len > crystalhd_get_sgle_len(ioreq, sg_ix))) {
-			BCMLOG_ERR("inv-len(%x) Ix(%d) count:%x xfr_sz:%x sg_cnt:%d\n",
+			pr_err("inv-len(%x) Ix(%d) count:%x xfr_sz:%x sg_cnt:%d\n",
 				   len, ix, count, xfr_sz, sg_cnt);
 			return BC_STS_ERROR;
 		}
@@ -766,7 +767,7 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 	crystalhd_hw_dump_desc(desc, last_desc_ix, 1);
 
 	if (count != xfr_sz) {
-		BCMLOG_ERR("interal error sz curr:%x exp:%x\n", count, xfr_sz);
+		pr_err("interal error sz curr:%x exp:%x\n", count, xfr_sz);
 		return BC_STS_ERROR;
 	}
 
@@ -785,18 +786,18 @@ static enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(struct crystalhd_dio_req *i
 
 	/* Check params.. */
 	if (!ioreq || !pdesc_mem || !uv_desc_index) {
-		BCMLOG_ERR("Invalid Args\n");
+		pr_err("%s: Invalid Args\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if (!pdesc_mem->sz || !pdesc_mem->pdma_desc_start ||
 	    !ioreq->sg || (!ioreq->sg_cnt && !ioreq->uinfo.dir_tx)) {
-		BCMLOG_ERR("Invalid Args\n");
+		pr_err("%s: Invalid Args\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if ((ioreq->uinfo.dir_tx) && (ioreq->uinfo.uv_offset)) {
-		BCMLOG_ERR("UV offset for TX??\n");
+		pr_err("UV offset for TX??\n");
 		return BC_STS_INV_ARG;
 
 	}
@@ -901,7 +902,7 @@ static enum BC_STATUS crystalhd_stop_tx_dma_engine(struct crystalhd_hw *hw)
 	}
 
 	if (!cnt) {
-		BCMLOG_ERR("Failed to stop TX DMA.. l1 %d, l2 %d\n", l1, l2);
+		pr_err("Failed to stop TX DMA.. l1 %d, l2 %d\n", l1, l2);
 		crystalhd_enable_interrupts(hw->adp);
 		return BC_STS_ERROR;
 	}
@@ -942,7 +943,7 @@ static uint32_t crystalhd_get_pib_avail_cnt(struct crystalhd_hw *hw)
 			  (r_offset + MIN_PIB_Q_DEPTH);
 
 	if (pib_cnt > MAX_PIB_Q_DEPTH) {
-		BCMLOG_ERR("Invalid PIB Count (%u)\n", pib_cnt);
+		pr_err("Invalid PIB Count (%u)\n", pib_cnt);
 		return 0;
 	}
 
@@ -1023,7 +1024,7 @@ static bool crystalhd_rel_addr_to_pib_Q(struct crystalhd_hw *hw, uint32_t addr_t
 static void cpy_pib_to_app(struct c011_pib *src_pib, struct BC_PIC_INFO_BLOCK *dst_pib)
 {
 	if (!src_pib || !dst_pib) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return;
 	}
 
@@ -1175,12 +1176,12 @@ static enum BC_STATUS crystalhd_hw_prog_rxdma(struct crystalhd_hw *hw, struct cr
 	unsigned long flags;
 
 	if (!hw || !rx_pkt) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if (hw->rx_list_post_index >= DMA_ENGINE_CNT) {
-		BCMLOG_ERR("List Out Of bounds %x\n", hw->rx_list_post_index);
+		pr_err("List Out Of bounds %x\n", hw->rx_list_post_index);
 		return BC_STS_INV_ARG;
 	}
 
@@ -1294,14 +1295,14 @@ static enum BC_STATUS crystalhd_rx_pkt_done(struct crystalhd_hw *hw, uint32_t li
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!hw || list_index >= DMA_ENGINE_CNT) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	rx_pkt = crystalhd_dioq_find_and_fetch(hw->rx_actq,
 					     hw->rx_pkt_tag_seed + list_index);
 	if (!rx_pkt) {
-		BCMLOG_ERR("Act-Q:PostIx:%x L0Sts:%x L1Sts:%x current L:%x tag:%x comp:%x\n",
+		pr_err("Act-Q:PostIx:%x L0Sts:%x L1Sts:%x current L:%x tag:%x comp:%x\n",
 			   hw->rx_list_post_index, hw->rx_list_sts[0],
 			   hw->rx_list_sts[1], list_index,
 			   hw->rx_pkt_tag_seed + list_index, comp_sts);
@@ -1471,7 +1472,7 @@ static void crystalhd_rx_isr(struct crystalhd_hw *hw, uint32_t intr_sts)
 	bool ret = 0;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return;
 	}
 
@@ -1550,7 +1551,7 @@ static enum BC_STATUS crystalhd_fw_cmd_post_proc(struct crystalhd_hw *hw,
 		break;
 	case eCMD_C011_INIT:
 		if (!(crystalhd_load_firmware_config(hw->adp))) {
-			BCMLOG_ERR("Invalid Params.\n");
+			pr_err("%s: Invalid Params.\n", __func__);
 			sts = BC_STS_FW_AUTH_FAILED;
 		}
 		break;
@@ -1629,13 +1630,13 @@ enum BC_STATUS crystalhd_download_fw(struct crystalhd_adp *adp, void *buffer, ui
 
 
 	if (!adp || !buffer || !sz) {
-		BCMLOG_ERR("Invalid Params.\n");
+		pr_err("%s: Invalid Params.\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	reg_data = crystalhd_reg_rd(adp, OTP_CMD);
 	if (!(reg_data & 0x02)) {
-		BCMLOG_ERR("Invalid hw config.. otp not programmed\n");
+		pr_err("Invalid hw config.. otp not programmed\n");
 		return BC_STS_ERROR;
 	}
 
@@ -1652,7 +1653,7 @@ enum BC_STATUS crystalhd_download_fw(struct crystalhd_adp *adp, void *buffer, ui
 		reg_data = crystalhd_reg_rd(adp, DCI_STATUS);
 		reg_data &= BC_BIT(4);
 		if (--cnt == 0) {
-			BCMLOG_ERR("Firmware Download RDY Timeout.\n");
+			pr_err("Firmware Download RDY Timeout.\n");
 			return BC_STS_TIMEOUT;
 		}
 	}
@@ -1704,7 +1705,7 @@ enum BC_STATUS crystalhd_download_fw(struct crystalhd_adp *adp, void *buffer, ui
 		crystalhd_reg_wr(adp, DCI_CMD, reg_data);
 
 	} else {
-		BCMLOG_ERR("F/w Signature mismatch\n");
+		pr_err("F/w Signature mismatch\n");
 		return BC_STS_FW_AUTH_FAILED;
 	}
 
@@ -1724,7 +1725,7 @@ enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
 	crystalhd_create_event(&fw_cmd_event);
 
 	if (!hw || !fw_cmd) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -1732,7 +1733,7 @@ enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
 	res_buff = fw_cmd->rsp;
 
 	if (!cmd_buff || !res_buff) {
-		BCMLOG_ERR("Invalid Parameters for F/W Command\n");
+		pr_err("Invalid Parameters for F/W Command\n");
 		return BC_STS_INV_ARG;
 	}
 
@@ -1756,18 +1757,18 @@ enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
 	if (!rc) {
 		sts = BC_STS_SUCCESS;
 	} else if (rc == -EBUSY) {
-		BCMLOG_ERR("Firmware command T/O\n");
+		pr_err("Firmware command T/O\n");
 		sts = BC_STS_TIMEOUT;
 	} else if (rc == -EINTR) {
 		BCMLOG(BCMLOG_DBG, "FwCmd Wait Signal int.\n");
 		sts = BC_STS_IO_USER_ABORT;
 	} else {
-		BCMLOG_ERR("FwCmd IO Error.\n");
+		pr_err("FwCmd IO Error.\n");
 		sts = BC_STS_IO_ERROR;
 	}
 
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("FwCmd Failed.\n");
+		pr_err("FwCmd Failed.\n");
 		hw->pwr_lock--;
 		return sts;
 	}
@@ -1781,13 +1782,13 @@ enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
 	hw->pwr_lock--;
 
 	if (res_buff[2] != C011_RET_SUCCESS) {
-		BCMLOG_ERR("res_buff[2] != C011_RET_SUCCESS\n");
+		pr_err("res_buff[2] != C011_RET_SUCCESS\n");
 		return BC_STS_FW_CMD_ERR;
 	}
 
 	sts = crystalhd_fw_cmd_post_proc(hw, fw_cmd);
 	if (sts != BC_STS_SUCCESS)
-		BCMLOG_ERR("crystalhd_fw_cmd_post_proc Failed.\n");
+		pr_err("crystalhd_fw_cmd_post_proc Failed.\n");
 
 	return sts;
 }
@@ -1854,7 +1855,7 @@ bool crystalhd_hw_interrupt(struct crystalhd_adp *adp, struct crystalhd_hw *hw)
 enum BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 {
 	if (!hw || !adp) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -1886,7 +1887,7 @@ enum BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *
 enum BC_STATUS crystalhd_hw_close(struct crystalhd_hw *hw)
 {
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -1910,13 +1911,13 @@ enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
 	struct crystalhd_rx_dma_pkt *rpkt;
 
 	if (!hw || !hw->adp) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	sts = crystalhd_hw_create_ioqs(hw);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("Failed to create IOQs..\n");
+		pr_err("Failed to create IOQs..\n");
 		return sts;
 	}
 
@@ -1927,7 +1928,7 @@ enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
 		if (mem) {
 			memset(mem, 0, mem_len);
 		} else {
-			BCMLOG_ERR("Insufficient Memory For TX\n");
+			pr_err("Insufficient Memory For TX\n");
 			crystalhd_hw_free_dma_rings(hw);
 			return BC_STS_INSUFF_RES;
 		}
@@ -1950,7 +1951,7 @@ enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
 	for (i = 0; i < BC_RX_LIST_CNT; i++) {
 		rpkt = kzalloc(sizeof(*rpkt), GFP_KERNEL);
 		if (!rpkt) {
-			BCMLOG_ERR("Insufficient Memory For RX\n");
+			pr_err("Insufficient Memory For RX\n");
 			crystalhd_hw_free_dma_rings(hw);
 			return BC_STS_INSUFF_RES;
 		}
@@ -1959,7 +1960,7 @@ enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
 		if (mem) {
 			memset(mem, 0, mem_len);
 		} else {
-			BCMLOG_ERR("Insufficient Memory For RX\n");
+			pr_err("Insufficient Memory For RX\n");
 			crystalhd_hw_free_dma_rings(hw);
 			kfree(rpkt);
 			return BC_STS_INSUFF_RES;
@@ -1980,7 +1981,7 @@ enum BC_STATUS crystalhd_hw_free_dma_rings(struct crystalhd_hw *hw)
 	struct crystalhd_rx_dma_pkt *rpkt = NULL;
 
 	if (!hw || !hw->adp) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -2027,7 +2028,7 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw, struct crystalhd_di
 	bool rc;
 
 	if (!hw || !ioreq || !call_back || !cb_event || !list_id) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -2048,7 +2049,7 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw, struct crystalhd_di
 	/* Get a list from TxFreeQ */
 	tx_dma_packet = (struct tx_dma_pkt *)crystalhd_dioq_fetch(hw->tx_freeq);
 	if (!tx_dma_packet) {
-		BCMLOG_ERR("No empty elements..\n");
+		pr_err("%s: No empty elements..\n", __func__);
 		return BC_STS_ERR_USAGE;
 	}
 
@@ -2059,7 +2060,7 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw, struct crystalhd_di
 		add_sts = crystalhd_dioq_add(hw->tx_freeq, tx_dma_packet,
 					   false, 0);
 		if (add_sts != BC_STS_SUCCESS)
-			BCMLOG_ERR("double fault..\n");
+			pr_err("%s: double fault..\n", __func__);
 
 		return sts;
 	}
@@ -2122,7 +2123,7 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw, struct crystalhd_di
 enum BC_STATUS crystalhd_hw_cancel_tx(struct crystalhd_hw *hw, uint32_t list_id)
 {
 	if (!hw || !list_id) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -2140,13 +2141,13 @@ enum BC_STATUS crystalhd_hw_add_cap_buffer(struct crystalhd_hw *hw,
 	enum BC_STATUS sts;
 
 	if (!hw || !ioreq) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	rpkt = crystalhd_hw_alloc_rx_pkt(hw);
 	if (!rpkt) {
-		BCMLOG_ERR("Insufficient resources\n");
+		pr_err("Insufficient resources\n");
 		return BC_STS_INSUFF_RES;
 	}
 
@@ -2182,7 +2183,7 @@ enum BC_STATUS crystalhd_hw_get_cap_buffer(struct crystalhd_hw *hw,
 
 
 	if (!hw || !ioreq || !pib) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -2215,7 +2216,7 @@ enum BC_STATUS crystalhd_hw_start_capture(struct crystalhd_hw *hw)
 	uint32_t i;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -2238,7 +2239,7 @@ enum BC_STATUS crystalhd_hw_stop_capture(struct crystalhd_hw *hw)
 	void *temp = NULL;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -2286,18 +2287,18 @@ enum BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw)
 	enum BC_STATUS sts;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	sts = crystalhd_put_ddr2sleep(hw);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("Failed to Put DDR To Sleep!!\n");
+		pr_err("Failed to Put DDR To Sleep!!\n");
 		return BC_STS_ERROR;
 	}
 
 	if (!crystalhd_stop_device(hw->adp)) {
-		BCMLOG_ERR("Failed to Stop Device!!\n");
+		pr_err("Failed to Stop Device!!\n");
 		return BC_STS_ERROR;
 	}
 
@@ -2307,7 +2308,7 @@ enum BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw)
 void crystalhd_hw_stats(struct crystalhd_hw *hw, struct crystalhd_hw_stats *stats)
 {
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return;
 	}
 
@@ -2328,7 +2329,7 @@ enum BC_STATUS crystalhd_hw_set_core_clock(struct crystalhd_hw *hw)
 	uint32_t vco_mg, refresh_reg;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		pr_err("%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 9dca92c..314531e 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -15,11 +15,11 @@
   along with this driver.  If not, see <http://www.gnu.org/licenses/>.
 ***************************************************************************/
 
+#include "crystalhd_lnx.h"
+
 #include <linux/mutex.h>
 #include <linux/slab.h>
 
-#include "crystalhd_lnx.h"
-
 static DEFINE_MUTEX(chd_dec_mutex);
 static struct class *crystalhd_class;
 
@@ -40,7 +40,7 @@ static int chd_dec_enable_int(struct crystalhd_adp *adp)
 	int rc = 0;
 
 	if (!adp || !adp->pdev) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -52,7 +52,7 @@ static int chd_dec_enable_int(struct crystalhd_adp *adp)
 	rc = request_irq(adp->pdev->irq, chd_dec_isr, IRQF_SHARED,
 			 adp->name, (void *)adp);
 	if (rc) {
-		BCMLOG_ERR("Interrupt request failed..\n");
+		pr_err("Interrupt request failed..\n");
 		pci_disable_msi(adp->pdev);
 	}
 
@@ -62,7 +62,7 @@ static int chd_dec_enable_int(struct crystalhd_adp *adp)
 static int chd_dec_disable_int(struct crystalhd_adp *adp)
 {
 	if (!adp || !adp->pdev) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -113,7 +113,7 @@ static inline int crystalhd_user_data(unsigned long ud, void *dr, int size, int
 	int rc;
 
 	if (!ud || !dr) {
-		BCMLOG_ERR("Invalid arg\n");
+		pr_err("%s: Invalid arg\n", __func__);
 		return -EINVAL;
 	}
 
@@ -123,7 +123,7 @@ static inline int crystalhd_user_data(unsigned long ud, void *dr, int size, int
 		rc = copy_from_user(dr, (void *)ud, size);
 
 	if (rc) {
-		BCMLOG_ERR("Invalid args for command\n");
+		pr_err("%s: Invalid args for command\n", __func__);
 		rc = -EFAULT;
 	}
 
@@ -137,13 +137,13 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp, struct crystalhd_ioctl
 	int rc = 0;
 
 	if (!adp || !io || !ua || !m_sz) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return -EINVAL;
 	}
 
 	io->add_cdata = vmalloc(m_sz);
 	if (!io->add_cdata) {
-		BCMLOG_ERR("kalloc fail for sz:%x\n", m_sz);
+		pr_err("%s: kalloc fail for sz:%x\n", __func__, m_sz);
 		return -ENOMEM;
 	}
 
@@ -151,7 +151,7 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp, struct crystalhd_ioctl
 	ua_off = ua + sizeof(io->udata);
 	rc = crystalhd_user_data(ua_off, io->add_cdata, io->add_cdata_sz, 0);
 	if (rc) {
-		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%x\n",
+		pr_err("failed to pull add_cdata sz:%x ua_off:%x\n",
 			   io->add_cdata_sz, (unsigned int)ua_off);
 		kfree(io->add_cdata);
 		io->add_cdata = NULL;
@@ -168,7 +168,7 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 	int rc;
 
 	if (!adp || !io || !ua) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -177,7 +177,7 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 		rc = crystalhd_user_data(ua_off, io->add_cdata,
 					io->add_cdata_sz, 1);
 		if (rc) {
-			BCMLOG_ERR("failed to push add_cdata sz:%x ua_off:%x\n",
+			pr_err("failed to push add_cdata sz:%x ua_off:%x\n",
 				   io->add_cdata_sz, (unsigned int)ua_off);
 			return -ENODATA;
 		}
@@ -199,13 +199,13 @@ static int chd_dec_proc_user_data(struct crystalhd_adp *adp,
 	uint32_t m_sz = 0;
 
 	if (!adp || !io || !ua) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return -EINVAL;
 	}
 
 	rc = crystalhd_user_data(ua, &io->udata, sizeof(io->udata), set);
 	if (rc) {
-		BCMLOG_ERR("failed to %s iodata\n", (set ? "set" : "get"));
+		pr_err("failed to %s iodata\n", (set ? "set" : "get"));
 		return rc;
 	}
 
@@ -235,7 +235,7 @@ static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
 
 	temp = chd_dec_alloc_iodata(adp, 0);
 	if (!temp) {
-		BCMLOG_ERR("Failed to get iodata..\n");
+		pr_err("%s: Failed to get iodata..\n", __func__);
 		return -EINVAL;
 	}
 
@@ -268,20 +268,20 @@ static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
 	int ret;
 
 	if (!adp || !fd) {
-		BCMLOG_ERR("Invalid adp\n");
+		pr_err("%s: Invalid adp\n", __func__);
 		return -EINVAL;
 	}
 
 	uc = fd->private_data;
 	if (!uc) {
-		BCMLOG_ERR("Failed to get uc\n");
+		pr_err("%s: Failed to get uc\n", __func__);
 		return -ENODATA;
 	}
 
 	mutex_lock(&chd_dec_mutex);
 	cproc = crystalhd_get_cmd_proc(&adp->cmds, cmd, uc);
 	if (!cproc) {
-		BCMLOG_ERR("Unhandled command: %d\n", cmd);
+		pr_err("%s: Unhandled command: %d\n", __func__, cmd);
 		mutex_unlock(&chd_dec_mutex);
 		return -EINVAL;
 	}
@@ -299,7 +299,7 @@ static int chd_dec_open(struct inode *in, struct file *fd)
 	struct crystalhd_user *uc = NULL;
 
 	if (!adp) {
-		BCMLOG_ERR("Invalid adp\n");
+		pr_err("%s: Invalid adp\n", __func__);
 		return -EINVAL;
 	}
 
@@ -310,7 +310,7 @@ static int chd_dec_open(struct inode *in, struct file *fd)
 
 	sts = crystalhd_user_open(&adp->cmds, &uc);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd_user_open - %d\n", sts);
+		pr_err("%s: cmd_user_open - %d\n", __func__, sts);
 		rc = -EBUSY;
 	}
 
@@ -327,13 +327,13 @@ static int chd_dec_close(struct inode *in, struct file *fd)
 	struct crystalhd_user *uc;
 
 	if (!adp) {
-		BCMLOG_ERR("Invalid adp\n");
+		pr_err("%s: Invalid adp\n", __func__);
 		return -EINVAL;
 	}
 
 	uc = fd->private_data;
 	if (!uc) {
-		BCMLOG_ERR("Failed to get uc\n");
+		pr_err("%s: Failed to get uc\n", __func__);
 		return -ENODATA;
 	}
 
@@ -364,7 +364,7 @@ static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
 	adp->chd_dec_major = register_chrdev(0, CRYSTALHD_API_NAME,
 					     &chd_dec_fops);
 	if (adp->chd_dec_major < 0) {
-		BCMLOG_ERR("Failed to create config dev\n");
+		pr_err("Failed to create config dev\n");
 		rc = adp->chd_dec_major;
 		goto fail;
 	}
@@ -372,20 +372,20 @@ static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
 	/* register crystalhd class */
 	crystalhd_class = class_create(THIS_MODULE, "crystalhd");
 	if (IS_ERR(crystalhd_class)) {
-		BCMLOG_ERR("failed to create class\n");
+		pr_err("failed to create class\n");
 		goto fail;
 	}
 
 	dev = device_create(crystalhd_class, NULL, MKDEV(adp->chd_dec_major, 0),
 			    NULL, "crystalhd");
 	if (IS_ERR(dev)) {
-		BCMLOG_ERR("failed to create device\n");
+		pr_err("failed to create device\n");
 		goto device_create_fail;
 	}
 
 	rc = crystalhd_create_elem_pool(adp, BC_LINK_ELEM_POOL_SZ);
 	if (rc) {
-		BCMLOG_ERR("failed to create device\n");
+		pr_err("failed to create device\n");
 		goto elem_pool_fail;
 	}
 
@@ -393,7 +393,7 @@ static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
 	for (i = 0; i < CHD_IODATA_POOL_SZ; i++) {
 		temp = kzalloc(sizeof(struct crystalhd_ioctl_data), GFP_KERNEL);
 		if (!temp) {
-			BCMLOG_ERR("ioctl data pool kzalloc failed\n");
+			pr_err("ioctl data pool kzalloc failed\n");
 			rc = -ENOMEM;
 			goto kzalloc_fail;
 		}
@@ -451,13 +451,13 @@ static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 
 	rc = check_mem_region(bar2, mem_len);
 	if (rc) {
-		BCMLOG_ERR("No valid mem region...\n");
+		pr_err("No valid mem region...\n");
 		return -ENOMEM;
 	}
 
 	pinfo->addr = ioremap_nocache(bar2, mem_len);
 	if (!pinfo->addr) {
-		BCMLOG_ERR("Failed to remap mem region...\n");
+		pr_err("Failed to remap mem region...\n");
 		return -ENOMEM;
 	}
 
@@ -466,13 +466,13 @@ static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 
 	rc = check_mem_region(bar0, i2o_len);
 	if (rc) {
-		BCMLOG_ERR("No valid mem region...\n");
+		pr_err("No valid mem region...\n");
 		return -ENOMEM;
 	}
 
 	pinfo->i2o_addr = ioremap_nocache(bar0, i2o_len);
 	if (!pinfo->i2o_addr) {
-		BCMLOG_ERR("Failed to remap mem region...\n");
+		pr_err("Failed to remap mem region...\n");
 		return -ENOMEM;
 	}
 
@@ -481,7 +481,7 @@ static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 
 	rc = pci_request_regions(pinfo->pdev, pinfo->name);
 	if (rc < 0) {
-		BCMLOG_ERR("Region request failed: %d\n", rc);
+		pr_err("Region request failed: %d\n", rc);
 		return rc;
 	}
 
@@ -513,13 +513,13 @@ static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 
 	pinfo = pci_get_drvdata(pdev);
 	if (!pinfo) {
-		BCMLOG_ERR("could not get adp\n");
+		pr_err("%s: could not get adp\n", __func__);
 		return;
 	}
 
 	sts = crystalhd_delete_cmd_context(&pinfo->cmds);
 	if (sts != BC_STS_SUCCESS)
-		BCMLOG_ERR("cmd delete :%d\n", sts);
+		pr_err("%s: cmd delete :%d\n", __func__, sts);
 
 	chd_dec_release_chdev(pinfo);
 
@@ -546,7 +546,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 
 	pinfo = kzalloc(sizeof(struct crystalhd_adp), GFP_KERNEL);
 	if (!pinfo) {
-		BCMLOG_ERR("Failed to allocate memory\n");
+		pr_err("%s: Failed to allocate memory\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -554,7 +554,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		BCMLOG_ERR("Failed to enable PCI device\n");
+		pr_err("Failed to enable PCI device\n");
 		goto err;
 	}
 
@@ -564,7 +564,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 
 	rc = chd_pci_reserve_mem(pinfo);
 	if (rc) {
-		BCMLOG_ERR("Failed to setup memory regions.\n");
+		pr_err("Failed to setup memory regions.\n");
 		pci_disable_device(pdev);
 		rc = -ENOMEM;
 		goto err;
@@ -580,7 +580,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	chd_dec_init_chdev(pinfo);
 	rc = chd_dec_enable_int(pinfo);
 	if (rc) {
-		BCMLOG_ERR("_enable_int err:%d\n", rc);
+		pr_err("%s: _enable_int err:%d\n", __func__, rc);
 		pci_disable_device(pdev);
 		rc = -ENODEV;
 		goto err;
@@ -594,7 +594,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		pinfo->dmabits = 32;
 	} else {
-		BCMLOG_ERR("Unabled to setup DMA %d\n", rc);
+		pr_err("Unabled to setup DMA %d\n", rc);
 		pci_disable_device(pdev);
 		rc = -ENODEV;
 		goto err;
@@ -602,7 +602,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 
 	sts = crystalhd_setup_cmd_context(&pinfo->cmds, pinfo);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd setup :%d\n", sts);
+		pr_err("%s: cmd setup :%d\n", __func__, sts);
 		pci_disable_device(pdev);
 		rc = -ENODEV;
 		goto err;
@@ -630,19 +630,19 @@ int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	adp = pci_get_drvdata(pdev);
 	if (!adp) {
-		BCMLOG_ERR("could not get adp\n");
+		pr_err("%s: could not get adp\n", __func__);
 		return -ENODEV;
 	}
 
 	temp = chd_dec_alloc_iodata(adp, false);
 	if (!temp) {
-		BCMLOG_ERR("could not get ioctl data\n");
+		pr_err("could not get ioctl data\n");
 		return -ENODEV;
 	}
 
 	sts = crystalhd_suspend(&adp->cmds, temp);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("BCM70012 Suspend %d\n", sts);
+		pr_err("BCM70012 Suspend %d\n", sts);
 		return -ENODEV;
 	}
 
@@ -664,7 +664,7 @@ int chd_dec_pci_resume(struct pci_dev *pdev)
 
 	adp = pci_get_drvdata(pdev);
 	if (!adp) {
-		BCMLOG_ERR("could not get adp\n");
+		pr_err("%s: could not get adp\n", __func__);
 		return -ENODEV;
 	}
 
@@ -673,7 +673,7 @@ int chd_dec_pci_resume(struct pci_dev *pdev)
 
 	/* device's irq possibly is changed, driver should take care */
 	if (pci_enable_device(pdev)) {
-		BCMLOG_ERR("Failed to enable PCI device\n");
+		pr_err("Failed to enable PCI device\n");
 		return 1;
 	}
 
@@ -681,14 +681,14 @@ int chd_dec_pci_resume(struct pci_dev *pdev)
 
 	rc = chd_dec_enable_int(adp);
 	if (rc) {
-		BCMLOG_ERR("_enable_int err:%d\n", rc);
+		pr_err("%s: _enable_int err:%d\n", __func__, rc);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
 
 	sts = crystalhd_resume(&adp->cmds);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("BCM70012 Resume %d\n", sts);
+		pr_err("BCM70012 Resume %d\n", sts);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
@@ -750,7 +750,7 @@ static int __init chd_dec_module_init(void)
 	rc = pci_register_driver(&bc_chd_70012_driver);
 
 	if (rc < 0)
-		BCMLOG_ERR("Could not find any devices. err:%d\n", rc);
+		pr_err("Could not find any devices. err:%d\n", rc);
 
 	return rc;
 }
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index a2b5a56..6570c46 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -27,6 +27,8 @@
 #ifndef _CRYSTALHD_LNX_H_
 #define _CRYSTALHD_LNX_H_
 
+#include "crystalhd_cmds.h"
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -48,8 +50,6 @@
 #include <asm/system.h>
 #include <linux/uaccess.h>
 
-#include "crystalhd_cmds.h"
-
 #define CRYSTAL_HD_NAME		"Broadcom Crystal HD Decoder (BCM70012) Driver"
 
 
diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
index 5fa0c6e..140f6c7 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.c
+++ b/drivers/staging/crystalhd/crystalhd_misc.c
@@ -24,11 +24,11 @@
  * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
  **********************************************************************/
 
-#include <linux/slab.h>
-
 #include "crystalhd_misc.h"
 #include "crystalhd_lnx.h"
 
+#include <linux/slab.h>
+
 uint32_t g_linklog_level;
 
 static inline uint32_t crystalhd_dram_rd(struct crystalhd_adp *adp, uint32_t mem_off)
@@ -54,7 +54,7 @@ static struct crystalhd_dio_req *crystalhd_alloc_dio(struct crystalhd_adp *adp)
 	struct crystalhd_dio_req *temp = NULL;
 
 	if (!adp) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return temp;
 	}
 
@@ -143,7 +143,7 @@ static inline void crystalhd_init_sg(struct scatterlist *sg, unsigned int entrie
 uint32_t bc_dec_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
 {
 	if (!adp || (reg_off > adp->pci_mem_len)) {
-		BCMLOG_ERR("dec_rd_reg_off outof range: 0x%08x\n", reg_off);
+		pr_err("dec_rd_reg_off outof range: 0x%08x\n", reg_off);
 		return 0;
 	}
 
@@ -166,7 +166,7 @@ uint32_t bc_dec_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
 void bc_dec_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val)
 {
 	if (!adp || (reg_off > adp->pci_mem_len)) {
-		BCMLOG_ERR("dec_wr_reg_off outof range: 0x%08x\n", reg_off);
+		pr_err("dec_wr_reg_off outof range: 0x%08x\n", reg_off);
 		return;
 	}
 	writel(val, adp->addr + reg_off);
@@ -189,7 +189,7 @@ void bc_dec_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val)
 uint32_t crystalhd_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
 {
 	if (!adp || (reg_off > adp->pci_i2o_len)) {
-		BCMLOG_ERR("link_rd_reg_off outof range: 0x%08x\n", reg_off);
+		pr_err("link_rd_reg_off outof range: 0x%08x\n", reg_off);
 		return 0;
 	}
 	return readl(adp->i2o_addr + reg_off);
@@ -212,7 +212,7 @@ uint32_t crystalhd_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
 void crystalhd_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val)
 {
 	if (!adp || (reg_off > adp->pci_i2o_len)) {
-		BCMLOG_ERR("link_wr_reg_off outof range: 0x%08x\n", reg_off);
+		pr_err("link_wr_reg_off outof range: 0x%08x\n", reg_off);
 		return;
 	}
 	writel(val, adp->i2o_addr + reg_off);
@@ -237,7 +237,7 @@ enum BC_STATUS crystalhd_mem_rd(struct crystalhd_adp *adp, uint32_t start_off,
 
 	if (!adp || !rd_buff ||
 	    (bc_chk_dram_range(adp, start_off, dw_cnt) != BC_STS_SUCCESS)) {
-		BCMLOG_ERR("Invalid arg\n");
+		pr_err("%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 	for (ix = 0; ix < dw_cnt; ix++)
@@ -265,7 +265,7 @@ enum BC_STATUS crystalhd_mem_wr(struct crystalhd_adp *adp, uint32_t start_off,
 
 	if (!adp || !wr_buff ||
 	    (bc_chk_dram_range(adp, start_off, dw_cnt) != BC_STS_SUCCESS)) {
-		BCMLOG_ERR("Invalid arg\n");
+		pr_err("%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -293,7 +293,7 @@ enum BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *adp, uint32_t off,
 	int rc = 0;
 
 	if (!adp || !val) {
-		BCMLOG_ERR("Invalid arg\n");
+		pr_err("%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -310,7 +310,7 @@ enum BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *adp, uint32_t off,
 	default:
 		rc = -EINVAL;
 		sts = BC_STS_INV_ARG;
-		BCMLOG_ERR("Invalid len:%d\n", len);
+		pr_err("%s: Invalid len:%d\n", __func__, len);
 	}
 
 	if (rc && (sts == BC_STS_SUCCESS))
@@ -338,7 +338,7 @@ enum BC_STATUS crystalhd_pci_cfg_wr(struct crystalhd_adp *adp, uint32_t off,
 	int rc = 0;
 
 	if (!adp || !val) {
-		BCMLOG_ERR("Invalid arg\n");
+		pr_err("%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -355,7 +355,7 @@ enum BC_STATUS crystalhd_pci_cfg_wr(struct crystalhd_adp *adp, uint32_t off,
 	default:
 		rc = -EINVAL;
 		sts = BC_STS_INV_ARG;
-		BCMLOG_ERR("Invalid len:%d\n", len);
+		pr_err("%s: Invalid len:%d\n", __func__, len);
 	}
 
 	if (rc && (sts == BC_STS_SUCCESS))
@@ -383,7 +383,7 @@ void *bc_kern_dma_alloc(struct crystalhd_adp *adp, uint32_t sz,
 	void *temp = NULL;
 
 	if (!adp || !sz || !phy_addr) {
-		BCMLOG_ERR("Invalide Arg..\n");
+		pr_err("%s: Invalide Arg..\n", __func__);
 		return temp;
 	}
 
@@ -409,7 +409,7 @@ void bc_kern_dma_free(struct crystalhd_adp *adp, uint32_t sz, void *ka,
 		      dma_addr_t phy_addr)
 {
 	if (!adp || !ka || !sz || !phy_addr) {
-		BCMLOG_ERR("Invalide Arg..\n");
+		pr_err("%s: Invalide Arg..\n", __func__);
 		return;
 	}
 
@@ -436,7 +436,7 @@ enum BC_STATUS crystalhd_create_dioq(struct crystalhd_adp *adp,
 	struct crystalhd_dioq *dioq = NULL;
 
 	if (!adp || !dioq_hnd) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -505,13 +505,13 @@ enum BC_STATUS crystalhd_dioq_add(struct crystalhd_dioq *ioq, void *data,
 	struct crystalhd_elem *tmp;
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG) || !data) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	tmp = crystalhd_alloc_elem(ioq->adp);
 	if (!tmp) {
-		BCMLOG_ERR("No free elements.\n");
+		pr_err("%s: No free elements.\n", __func__);
 		return BC_STS_INSUFF_RES;
 	}
 
@@ -548,7 +548,7 @@ void *crystalhd_dioq_fetch(struct crystalhd_dioq *ioq)
 	void *data = NULL;
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG)) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return data;
 	}
 
@@ -586,7 +586,7 @@ void *crystalhd_dioq_find_and_fetch(struct crystalhd_dioq *ioq, uint32_t tag)
 	void *data = NULL;
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG)) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return data;
 	}
 
@@ -631,7 +631,7 @@ void *crystalhd_dioq_fetch_wait(struct crystalhd_dioq *ioq, uint32_t to_secs,
 	void *tmp = NULL;
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG) || !to_secs || !sig_pend) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		pr_err("%s: Invalid arg!!\n", __func__);
 		return tmp;
 	}
 
@@ -685,7 +685,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	int i = 0, rw = 0, res = 0, nr_pages = 0, skip_fb_sg = 0;
 
 	if (!adp || !ubuff || !ubuff_sz || !dio_hnd) {
-		BCMLOG_ERR("Invalid arg\n");
+		pr_err("%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 	/* Compute pages */
@@ -696,13 +696,13 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	nr_pages = end - start;
 
 	if (!count || ((uaddr + count) < uaddr)) {
-		BCMLOG_ERR("User addr overflow!!\n");
+		pr_err("User addr overflow!!\n");
 		return BC_STS_INV_ARG;
 	}
 
 	dio = crystalhd_alloc_dio(adp);
 	if (!dio) {
-		BCMLOG_ERR("dio pool empty..\n");
+		pr_err("dio pool empty..\n");
 		return BC_STS_INSUFF_RES;
 	}
 
@@ -715,7 +715,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	}
 
 	if (nr_pages > dio->max_pages) {
-		BCMLOG_ERR("max_pages(%d) exceeded(%d)!!\n",
+		pr_err("max_pages(%d) exceeded(%d)!!\n",
 			   dio->max_pages, nr_pages);
 		crystalhd_unmap_dio(adp, dio);
 		return BC_STS_INSUFF_RES;
@@ -733,7 +733,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 				     (void *)(uaddr + count - dio->fb_size),
 				     dio->fb_size);
 		if (res) {
-			BCMLOG_ERR("failed %d to copy %u fill bytes from %p\n",
+			pr_err("failed %d to copy %u fill bytes from %p\n",
 				   res, dio->fb_size,
 				   (void *)(uaddr + count-dio->fb_size));
 			crystalhd_unmap_dio(adp, dio);
@@ -749,7 +749,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	/* Save for release..*/
 	dio->sig = crystalhd_dio_locked;
 	if (res < nr_pages) {
-		BCMLOG_ERR("get pages failed: %d-%d\n", nr_pages, res);
+		pr_err("get pages failed: %d-%d\n", nr_pages, res);
 		dio->page_cnt = res;
 		crystalhd_unmap_dio(adp, dio);
 		return BC_STS_ERROR;
@@ -791,7 +791,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	dio->sg_cnt = pci_map_sg(adp->pdev, dio->sg,
 				 dio->page_cnt, dio->direction);
 	if (dio->sg_cnt <= 0) {
-		BCMLOG_ERR("sg map %d-%d\n", dio->sg_cnt, dio->page_cnt);
+		pr_err("sg map %d-%d\n", dio->sg_cnt, dio->page_cnt);
 		crystalhd_unmap_dio(adp, dio);
 		return BC_STS_ERROR;
 	}
@@ -826,7 +826,7 @@ enum BC_STATUS crystalhd_unmap_dio(struct crystalhd_adp *adp, struct crystalhd_d
 	int j = 0;
 
 	if (!adp || !dio) {
-		BCMLOG_ERR("Invalid arg\n");
+		pr_err("%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -867,7 +867,7 @@ int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
 	struct crystalhd_dio_req *dio;
 
 	if (!adp || !max_pages) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -875,7 +875,7 @@ int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
 	adp->fill_byte_pool = pci_pool_create("crystalhd_fbyte",
 					      adp->pdev, 8, 8, 0);
 	if (!adp->fill_byte_pool) {
-		BCMLOG_ERR("failed to create fill byte pool\n");
+		pr_err("failed to create fill byte pool\n");
 		return -ENOMEM;
 	}
 
@@ -889,7 +889,7 @@ int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
 	for (i = 0; i < BC_LINK_SG_POOL_SZ; i++) {
 		temp = kzalloc(asz, GFP_KERNEL);
 		if ((temp) == NULL) {
-			BCMLOG_ERR("Failed to alloc %d mem\n", asz);
+			pr_err("%s: Failed to alloc %d mem\n", __func__, asz);
 			return -ENOMEM;
 		}
 
@@ -902,7 +902,7 @@ int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
 		dio->fb_va = pci_pool_alloc(adp->fill_byte_pool, GFP_KERNEL,
 					    &dio->fb_pa);
 		if (!dio->fb_va) {
-			BCMLOG_ERR("fill byte alloc failed.\n");
+			pr_err("%s: fill byte alloc failed.\n", __func__);
 			return -ENOMEM;
 		}
 
@@ -927,7 +927,7 @@ void crystalhd_destroy_dio_pool(struct crystalhd_adp *adp)
 	int count = 0;
 
 	if (!adp) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		pr_err("%s: Invalid Arg!!\n", __func__);
 		return;
 	}
 
@@ -973,7 +973,7 @@ int __devinit crystalhd_create_elem_pool(struct crystalhd_adp *adp,
 	for (i = 0; i < pool_size; i++) {
 		temp = kzalloc(sizeof(*temp), GFP_KERNEL);
 		if (!temp) {
-			BCMLOG_ERR("kalloc failed\n");
+			pr_err("%s: kalloc failed\n", __func__);
 			return -ENOMEM;
 		}
 		crystalhd_free_elem(adp, temp);
diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index d2f7256..77e4cb2 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -28,6 +28,8 @@
 #ifndef _CRYSTALHD_MISC_H_
 #define _CRYSTALHD_MISC_H_
 
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -209,12 +211,4 @@ do {					\
 		printk(fmt, ##args);	\
 } while (0)
 
-
-#define BCMLOG_ERR(fmt, args...)				\
-do {								\
-	if (g_linklog_level & BCMLOG_ERROR)			\
-		printk(KERN_ERR "*ERR*:%s:%d: "fmt,		\
-				__FILE__, __LINE__, ##args);	\
-} while (0)
-
 #endif
-- 
1.7.2.5

