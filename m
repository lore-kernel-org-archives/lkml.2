Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404Ab1IOXZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:25:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42455 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab1IOXZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:25:50 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 13/13] staging: wlags49_h2: Remove continuous tx test
Date: Fri, 16 Sep 2011 00:20:57 +0100
Message-Id: <1316128857-9781-14-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 67c138d..7dc176a 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -2596,28 +2596,6 @@ hcf_send_msg( IFBP ifbp, DESC_STRCT *descp, hcf_16 tx_cntl )
 
 	if ( descp ) ifbp->IFB_TxFID = 0;               //cancel a pre-put message
 
-#if (HCF_EXT) & HCF_EXT_TX_CONT             // Continuous transmit test
-	if ( tx_cntl == HFS_TX_CNTL_TX_CONT ) {
-		fid = get_fid(ifbp);
-		if (fid != 0 ) {
-			                        //setup BAP to begin of TxFS
-			(void)setup_bap( ifbp, fid, 0, IO_OUT );
-			                        //copy all the fragments in a transparent fashion
-			for ( p = descp; p; p = p->next_desc_addr ) {
-				/* obnoxious warning C4769: conversion of near pointer to long integer */
-				HCFASSERT( ((hcf_32)p & 3 ) == 0, (hcf_32)p );
-				put_frag( ifbp, p->buf_addr, p->BUF_CNT BE_PAR(0) );
-			}
-			rc = cmd_exe( ifbp, HCMD_THESEUS | HCMD_BUSY | HCMD_STARTPREAMBLE, fid );
-			if ( ifbp->IFB_RscInd == 0 ) {
-				ifbp->IFB_RscInd = get_fid( ifbp );
-			}
-		}
-		                                // een slecht voorbeeld doet goed volgen ;?
-		HCFLOGEXIT( HCF_TRACE_SEND_MSG );
-		return rc;
-	}
-#endif // HCF_EXT_TX_CONT
 	/* the following initialization code is redundant for a pre-put message
 	 * but moving it inside the "if fid" logic makes the merging with the
 	 * USB flow awkward
-- 
1.7.4.1

