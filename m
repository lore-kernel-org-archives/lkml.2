Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969Ab0KQQTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:19:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48254 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934864Ab0KQQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:19:10 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/7] sst: Firmware error codes force number values
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Nov 2010 15:59:11 +0000
Message-ID: <20101117155910.21681.74921.stgit@localhost.localdomain>
In-Reply-To: <20101117155748.21681.71501.stgit@localhost.localdomain>
References: <20101117155748.21681.71501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

To avoid mismatch in driver and firmware error codes assign specfic values
to each enum.

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst_fw_ipc.h |  110 +++++++++++++++-----------
 1 files changed, 62 insertions(+), 48 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 1a2f67f..75c1876 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -142,73 +142,87 @@ enum sst_error_codes {
 	/* Error code,response to msgId: Description */
 	/* Common error codes */
 	SST_SUCCESS = 0,	/* Success */
-	SST_ERR_INVALID_STREAM_ID, /* Invalid stream ID */
-	SST_ERR_INVALID_MSG_ID,	/* Invalid message ID */
-	SST_ERR_INVALID_STREAM_OP, /* Invalid stream operation request */
-	SST_ERR_INVALID_PARAMS,	/* Invalid params */
-	SST_ERR_INVALID_CODEC,	/* Invalid codec type */
-	SST_ERR_INVALID_MEDIA_TYPE, /* Invalid media type */
-	SST_ERR_STREAM_ERR,  /* ANY: Stream control or config or
-					processing error */
+	SST_ERR_INVALID_STREAM_ID = 1,
+	SST_ERR_INVALID_MSG_ID = 2,
+	SST_ERR_INVALID_STREAM_OP = 3,
+	SST_ERR_INVALID_PARAMS = 4,
+	SST_ERR_INVALID_CODEC = 5,
+	SST_ERR_INVALID_MEDIA_TYPE = 6,
+	SST_ERR_STREAM_ERR = 7,
 
 	/* IPC specific error codes */
-	SST_IPC_ERR_CALL_BACK_NOT_REGD, /* Call back for msg not regd */
-	SST_IPC_ERR_STREAM_NOT_ALLOCATED, /* Stream is not allocated  */
-	SST_IPC_ERR_STREAM_ALLOC_FAILED, /* ALLOC:Stream alloc failed */
-	SST_IPC_ERR_GET_STREAM_FAILED, /* ALLOC:Get stream id failed*/
-	SST_ERR_MOD_NOT_AVAIL, /* SET/GET: Mod(AEC/AGC/ALC) not available */
-	SST_ERR_MOD_DNLD_RQD, /* SET/GET: Mod(AEC/AGC/ALC) download required */
-	SST_ERR_STREAM_STOPPED,		/* ANY: Stream is in stopped state */
-	SST_ERR_STREAM_IN_USE, /* ANY: Stream is already in use */
+	SST_IPC_ERR_CALL_BACK_NOT_REGD = 8,
+	SST_IPC_ERR_STREAM_NOT_ALLOCATED = 9,
+	SST_IPC_ERR_STREAM_ALLOC_FAILED = 10,
+	SST_IPC_ERR_GET_STREAM_FAILED = 11,
+	SST_ERR_MOD_NOT_AVAIL = 12,
+	SST_ERR_MOD_DNLD_RQD = 13,
+	SST_ERR_STREAM_STOPPED = 14,
+	SST_ERR_STREAM_IN_USE = 15,
 
 	/* Capture specific error codes */
-	SST_CAP_ERR_INCMPLTE_CAPTURE_MSG,/* ANY:Incomplete message */
-	SST_CAP_ERR_CAPTURE_FAIL, /* ANY:Capture op failed */
-	SST_CAP_ERR_GET_DDR_NEW_SGLIST,
-	SST_CAP_ERR_UNDER_RUN,	/* lack of input data */
-	SST_CAP_ERR_OVERFLOW,	/* lack of output space */
+	SST_CAP_ERR_INCMPLTE_CAPTURE_MSG = 16,
+	SST_CAP_ERR_CAPTURE_FAIL = 17,
+	SST_CAP_ERR_GET_DDR_NEW_SGLIST = 18,
+	SST_CAP_ERR_UNDER_RUN = 19,
+	SST_CAP_ERR_OVERFLOW = 20,
 
 	/* Playback specific error codes*/
-	SST_PB_ERR_INCMPLTE_PLAY_MSG, /* ANY: Incomplete message */
-	SST_PB_ERR_PLAY_FAIL, /* ANY: Playback operation failed */
-	SST_PB_ERR_GET_DDR_NEW_SGLIST,
+	SST_PB_ERR_INCMPLTE_PLAY_MSG = 21,
+	SST_PB_ERR_PLAY_FAIL = 22,
+	SST_PB_ERR_GET_DDR_NEW_SGLIST = 23,
 
 	/* Codec manager specific error codes */
-	SST_LIB_ERR_LIB_DNLD_REQUIRED, /* ALLOC: Codec download required */
-	SST_LIB_ERR_LIB_NOT_SUPPORTED, /* Library is not supported */
+	SST_LIB_ERR_LIB_DNLD_REQUIRED = 24,
+	SST_LIB_ERR_LIB_NOT_SUPPORTED = 25,
 
 	/* Library manager specific error codes */
-	SST_SCC_ERR_PREP_DNLD_FAILED, /* Failed to prepare for codec download */
-	SST_SCC_ERR_LIB_DNLD_RES_FAILED, /* Lib download resume failed */
+	SST_SCC_ERR_PREP_DNLD_FAILED = 26,
+	SST_SCC_ERR_LIB_DNLD_RES_FAILED = 27,
 	/* Scheduler specific error codes */
-	SST_SCH_ERR_FAIL, /* REPORT: */
+	SST_SCH_ERR_FAIL = 28,
 
 	/* DMA specific error codes */
-	SST_DMA_ERR_NO_CHNL_AVAILABLE, /* DMA Ch not available */
-	SST_DMA_ERR_INVALID_INPUT_PARAMS, /* Invalid input params */
-	SST_DMA_ERR_CHNL_ALREADY_SUSPENDED, /* Ch is suspended */
-	SST_DMA_ERR_CHNL_ALREADY_STARTED, /* Ch already started */
-	SST_DMA_ERR_CHNL_NOT_ENABLED, /* Ch not enabled */
-	SST_DMA_ERR_TRANSFER_FAILED, /* Transfer failed */
-	SST_SSP_ERR_ALREADY_ENABLED, /* REPORT: SSP already enabled */
-	SST_SSP_ERR_ALREADY_DISABLED, /* REPORT: SSP already disabled */
-	SST_SSP_ERR_NOT_INITIALIZED,
+	SST_DMA_ERR_NO_CHNL_AVAILABLE = 29,
+	SST_DMA_ERR_INVALID_INPUT_PARAMS = 30,
+	SST_DMA_ERR_CHNL_ALREADY_SUSPENDED = 31,
+	SST_DMA_ERR_CHNL_ALREADY_STARTED = 32,
+	SST_DMA_ERR_CHNL_NOT_ENABLED = 33,
+	SST_DMA_ERR_TRANSFER_FAILED = 34,
+
+	SST_SSP_ERR_ALREADY_ENABLED = 35,
+	SST_SSP_ERR_ALREADY_DISABLED = 36,
+	SST_SSP_ERR_NOT_INITIALIZED = 37,
+	SST_SSP_ERR_SRAM_NO_DMA_DATA = 38,
 
 	/* Other error codes */
-	SST_ERR_MOD_INIT_FAIL,	/* Firmware Module init failed */
+	SST_ERR_MOD_INIT_FAIL = 39,
 
 	/* FW init error codes */
-	SST_RDR_ERR_IO_DEV_SEL_NOT_ALLOWED,
-	SST_RDR_ERR_ROUTE_ALREADY_STARTED,
-	SST_RDR_PREP_CODEC_DNLD_FAILED,
+	SST_RDR_ERR_IO_DEV_SEL_NOT_ALLOWED = 40,
+	SST_RDR_ERR_ROUTE_ALREADY_STARTED = 41,
+	SST_RDR_ERR_IO_DEV_SEL_FAILED = 42,
+	SST_RDR_PREP_CODEC_DNLD_FAILED = 43,
 
 	/* Memory debug error codes */
-	SST_ERR_DBG_MEM_READ_FAIL,
-	SST_ERR_DBG_MEM_WRITE_FAIL,
-
-	/* Decode error codes */
-	SST_ERR_DEC_NEED_INPUT_BUF,
-
+	SST_ERR_DBG_MEM_READ_FAIL = 44,
+	SST_ERR_DBG_MEM_WRITE_FAIL = 45,
+	SST_ERR_INSUFFICIENT_INPUT_SG_LIST = 46,
+	SST_ERR_INSUFFICIENT_OUTPUT_SG_LIST = 47,
+
+	SST_ERR_BUFFER_NOT_AVAILABLE = 48,
+	SST_ERR_BUFFER_NOT_ALLOCATED = 49,
+	SST_ERR_INVALID_REGION_TYPE = 50,
+	SST_ERR_NULL_PTR = 51,
+	SST_ERR_INVALID_BUFFER_SIZE = 52,
+	SST_ERR_INVALID_BUFFER_INDEX = 53,
+
+	/*IIPC specific error codes */
+	SST_IIPC_QUEUE_FULL = 54,
+	SST_IIPC_ERR_MSG_SND_FAILED = 55,
+	SST_PB_ERR_UNDERRUN_OCCURED = 56,
+	SST_RDR_INSUFFICIENT_MIXER_BUFFER = 57,
+	SST_INVALID_TIME_SLOTS = 58,
 };
 
 enum dbg_mem_data_type {

