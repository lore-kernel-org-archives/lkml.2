Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935408Ab1IOXWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:22:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58219 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935397Ab1IOXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:22:17 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 05/13] staging: wlags49_h2: Remove HCF_DL_ONLY
Date: Fri, 16 Sep 2011 00:20:49 +0100
Message-Id: <1316128857-9781-6-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is supposed to profile the code so that you can build a driver
that will only update the firmware. We don't need to support this
configuration.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c    |   23 ++---------------------
 drivers/staging/wlags49_h2/hcfcfg.h |   13 -------------
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 304258e..b38fea5 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -511,7 +511,6 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  ************************** T O P   L E V E L   H C F   R O U T I N E S **************************************
  ************************************************************************************************************/
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.MODULE        int hcf_action( IFBP ifbp, hcf_16 action )
@@ -834,7 +833,6 @@ hcf_action( IFBP ifbp, hcf_16 action )
 	HCFLOGEXIT( HCF_TRACE_ACTION );
 	return rc;
 } // hcf_action
-#endif // HCF_DL_ONLY
 
 
 /************************************************************************************************************
@@ -1854,7 +1852,6 @@ hcf_dma_tx_put( IFBP ifbp, DESC_STRCT *descp, hcf_16 tx_cntl )
 
 #endif // HCF_DMA
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.MODULE        hcf_8 hcf_encap( wci_bufp type )
@@ -1914,7 +1911,6 @@ hcf_encap( wci_bufp type )
 	return rc;
 } // hcf_encap
 #endif // HCF_ENCAP
-#endif // HCF_DL_ONLY
 
 
 /************************************************************************************************************
@@ -2330,7 +2326,6 @@ hcf_put_info( IFBP ifbp, LTVP ltvp )
 } // hcf_put_info
 
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.MODULE        int hcf_rcv_msg( IFBP ifbp, DESC_STRCT *descp, unsigned int offset )
@@ -2490,10 +2485,8 @@ hcf_rcv_msg( IFBP ifbp, DESC_STRCT *descp, unsigned int offset )
 	HCFLOGEXIT( HCF_TRACE_RCV_MSG );
 	return rc;
 } // hcf_rcv_msg
-#endif // HCF_DL_ONLY
 
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.MODULE        int hcf_send_msg( IFBP ifbp, DESC_STRCT *descp, hcf_16 tx_cntl )
@@ -2804,10 +2797,8 @@ hcf_send_msg( IFBP ifbp, DESC_STRCT *descp, hcf_16 tx_cntl )
 	HCFLOGEXIT( HCF_TRACE_SEND_MSG );
 	return rc;
 } // hcf_send_msg
-#endif // HCF_DL_ONLY
 
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.MODULE        int hcf_service_nic( IFBP ifbp, wci_bufp bufp, unsigned int len )
@@ -3186,7 +3177,6 @@ hcf_service_nic( IFBP ifbp, wci_bufp bufp, unsigned int len )
 	HCFLOGEXIT( HCF_TRACE_SERVICE_NIC );
 	return rc;
 } // hcf_service_nic
-#endif // HCF_DL_ONLY
 
 
 /************************************************************************************************************
@@ -3517,7 +3507,6 @@ calibrate( IFBP ifbp )
 #endif // HCF_PROT_TIME
 
 
-#if (HCF_DL_ONLY) == 0
 #if (HCF_TYPE) & HCF_TYPE_WPA
 /************************************************************************************************************
  *
@@ -3565,7 +3554,6 @@ check_mic( IFBP ifbp )
 	return rc;
 } // check_mic
 #endif // HCF_TYPE_WPA
-#endif // HCF_DL_ONLY
 
 
 /************************************************************************************************************
@@ -3879,7 +3867,6 @@ fw_printf(IFBP ifbp, CFG_FW_PRINTF_STRCT FAR *ltvp)
 #endif // HCF_ASSERT_PRINTF
 
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.SUBMODULE     hcf_16 get_fid( IFBP ifbp )
@@ -3943,7 +3930,6 @@ get_fid( IFBP ifbp )
 	}
 	return fid;
 } // get_fid
-#endif // HCF_DL_ONLY
 
 
 /************************************************************************************************************
@@ -4232,7 +4218,7 @@ init( IFBP ifbp )
 		}
 	}
 #endif // MSF_COMPONENT_ID
-#if (HCF_DL_ONLY) == 0                                                                          /* 28 */
+
 	if ( rc == HCF_SUCCESS && ifbp->IFB_FWIdentity.comp_id >= COMP_ID_FW_STA ) {
 		PROT_CNT_INI;
 		/**************************************************************************************
@@ -4258,13 +4244,12 @@ init( IFBP ifbp )
 		}
 //#endif // ALLOC_15
 	}
-#endif // HCF_DL_ONLY
+
 	HCFASSERT( rc == HCF_SUCCESS, rc );
 	HCFLOGEXIT( HCF_TRACE_INIT );
 	return rc;
 } // init
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.SUBMODULE     void isr_info( IFBP ifbp )
@@ -4346,7 +4331,6 @@ isr_info( IFBP ifbp )
 	}
 	return;
 } // isr_info
-#endif // HCF_DL_ONLY
 
 //
 //
@@ -4384,7 +4368,6 @@ isr_info( IFBP ifbp )
 //
 //  return;
 //} // isr_info
-//#endif // HCF_DL_ONLY
 
 
 /************************************************************************************************************
@@ -4669,7 +4652,6 @@ put_info( IFBP ifbp, LTVP ltvp  )
 } // put_info
 
 
-#if (HCF_DL_ONLY) == 0
 /************************************************************************************************************
  *
  *.SUBMODULE     int put_info_mb( IFBP ifbp, CFG_MB_INFO_STRCT FAR * ltvp )
@@ -4783,7 +4765,6 @@ put_info_mb( IFBP ifbp, CFG_MB_INFO_STRCT FAR * ltvp )
 } // put_info_mb
 
 #endif // HCF_EXT_MB
-#endif // HCF_DL_ONLY
 
 
 /************************************************************************************************************
diff --git a/drivers/staging/wlags49_h2/hcfcfg.h b/drivers/staging/wlags49_h2/hcfcfg.h
index 32db381..764ad9a 100644
--- a/drivers/staging/wlags49_h2/hcfcfg.h
+++ b/drivers/staging/wlags49_h2/hcfcfg.h
@@ -479,10 +479,6 @@ typedef unsigned long			hcf_32;
 #define 		HCF_BIG_ENDIAN		0
 #endif // 		HCF_BIG_ENDIAN
 
-#if ! defined	HCF_DL_ONLY
-#define 		HCF_DL_ONLY			0
-#endif // 		HCF_DL_ONLY
-
 #if ! defined	HCF_DMA
 #define 		HCF_DMA				0
 #endif // 		HCF_DMA
@@ -540,11 +536,6 @@ typedef unsigned long			hcf_32;
 #define			HCF_BIG_ENDIAN		1		//just for convenience of generating cfg_hcf_opt
 #endif //	 	HCF_BIG_ENDIAN
 
-#if				HCF_DL_ONLY
-#undef			HCF_DL_ONLY
-#define			HCF_DL_ONLY			1		//just for convenience of generating cfg_hcf_opt
-#endif //		HCF_DL_ONLY
-
 #if				HCF_DMA
 #undef			HCF_DMA
 #define			HCF_DMA				1		//just for convenience of generating cfg_hcf_opt
@@ -752,10 +743,6 @@ err: these macros are not used consistently;
 err: invalid value for HCF_BIG_ENDIAN;
 #endif // HCF_BIG_ENDIAN
 
-#if HCF_DL_ONLY != 0 && HCF_DL_ONLY != 1
-err: invalid value for HCF_DL_ONLY;
-#endif // HCF_DL_ONLY
-
 #if HCF_DMA != 0 && HCF_DMA != 1
 err: invalid value for HCF_DMA;
 #endif // HCF_DMA
-- 
1.7.4.1

