Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935450Ab1IOX2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:28:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48627 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab1IOX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:28:46 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 06/13] staging: wlags49_h2: Simplify HCF_ENCAP usage
Date: Fri, 16 Sep 2011 00:20:50 +0100
Message-Id: <1316128857-9781-7-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulation should always be enabled. Support is either via firmware
or in the driver, so we need to keep the macro. The driver can stop
exporting hcf_encap

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c |   11 +----------
 drivers/staging/wlags49_h2/hcf.h |    3 ---
 2 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index b38fea5..e1d391a 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -133,9 +133,7 @@ static int fw_printf(IFBP ifbp, CFG_FW_PRINTF_STRCT FAR *ltvp);
 #endif // HCF_ASSERT_PRINTF
 
 HCF_STATIC int          download( IFBP ifbp, CFG_PROG_STRCT FAR *ltvp );
-#if (HCF_ENCAP) & HCF_ENC
 HCF_STATIC hcf_8        hcf_encap( wci_bufp type );
-#endif // HCF_ENCAP
 HCF_STATIC hcf_8        null_addr[4] = { 0, 0, 0, 0 };
 #if ! defined IN_PORT_WORD          //replace I/O Macros with logging facility
 extern FILE *log_file;
@@ -244,11 +242,9 @@ void OUT_PORT_STRING_8_16( hcf_io prt, hcf_8 FAR * src, int n)  {   //also handl
 IFBP BASED assert_ifbp = NULL;          //to make asserts easily work under MMD and DHF
 #endif // HCF_ASSERT
 
-#if HCF_ENCAP
 /* SNAP header to be inserted in Ethernet-II frames */
 HCF_STATIC  hcf_8 BASED snap_header[] = { 0xAA, 0xAA, 0x03, 0x00, 0x00, //5 bytes signature +
                                           0 };                          //1 byte protocol identifier
-#endif // HCF_ENCAP
 
 #if (HCF_TYPE) & HCF_TYPE_WPA
 HCF_STATIC hcf_8 BASED mic_pad[8] = { 0x5A, 0, 0, 0, 0, 0, 0, 0 };      //MIC padding of message
@@ -1890,11 +1886,7 @@ hcf_dma_tx_put( IFBP ifbp, DESC_STRCT *descp, hcf_16 tx_cntl )
  *.ENDDOC                END DOCUMENTATION
  *
  ************************************************************************************************************/
-#if HCF_ENCAP   //i.e HCF_ENC or HCF_ENC_SUP
-#if ! ( (HCF_ENCAP) & HCF_ENC_SUP )
-HCF_STATIC
-#endif // HCF_ENCAP
-hcf_8
+HCF_STATIC hcf_8
 hcf_encap( wci_bufp type )
 {
 
@@ -1910,7 +1902,6 @@ hcf_encap( wci_bufp type )
 	}
 	return rc;
 } // hcf_encap
-#endif // HCF_ENCAP
 
 
 /************************************************************************************************************
diff --git a/drivers/staging/wlags49_h2/hcf.h b/drivers/staging/wlags49_h2/hcf.h
index 2cd5739..4fd62cd 100644
--- a/drivers/staging/wlags49_h2/hcf.h
+++ b/drivers/staging/wlags49_h2/hcf.h
@@ -382,9 +382,6 @@ typedef IFB_STRCT*	IFBP;
 
 EXTERN_C int		 hcf_action			(IFBP ifbp, hcf_16 cmd );
 EXTERN_C int		 hcf_connect		(IFBP ifbp, hcf_io io_base );
-#if (HCF_ENCAP) & HCF_ENC_SUP
-EXTERN_C hcf_8 		 hcf_encap			(wci_bufp type );
-#endif // HCF_ENC_SUP
 EXTERN_C int		 hcf_get_info		(IFBP ifbp, LTVP ltvp );
 EXTERN_C int		 hcf_service_nic	(IFBP ifbp, wci_bufp bufp, unsigned int len );
 EXTERN_C int		 hcf_cntl			(IFBP ifbp, hcf_16 cmd );
-- 
1.7.4.1

