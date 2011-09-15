Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935432Ab1IOXWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:22:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58219 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935420Ab1IOXWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:22:24 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 09/13] staging: wlags49_h2: Remove MUL/DIV_BY_2
Date: Fri, 16 Sep 2011 00:20:53 +0100
Message-Id: <1316128857-9781-10-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only used in one place, so just inline and get rid of the macro.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c    |    2 +-
 drivers/staging/wlags49_h2/hcfdef.h |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index c46ad30..0453b90 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -3766,7 +3766,7 @@ download( IFBP ifbp, CFG_PROG_STRCT FAR *ltvp )                     //Hermes-II
 #if 0   //;? as long as the next if contains a hard coded 0, might as well leave it out even more obvious
 		if ( 0 /*len is definitely not want we want;?*/ && ltvp->mode == CFG_PROG_SEEPROM_READBACK ) {
 			OPW( HREG_PARAM_1, (hcf_16)(ltvp->nic_addr >> 16) );
-			OPW( HREG_PARAM_2, MUL_BY_2(ltvp->len - 4));
+			OPW( HREG_PARAM_2, (hcf_16)((ltvp->len - 4) << 1) );
 			                        //.  .  perform Hermes prog cmd with appropriate mode bits
 			rc = cmd_exe( ifbp, HCMD_PROGRAM | ltvp->mode, (hcf_16)ltvp->nic_addr );
 			                        //.  .  set up NIC RAM addressability according Resp0-1
diff --git a/drivers/staging/wlags49_h2/hcfdef.h b/drivers/staging/wlags49_h2/hcfdef.h
index 8fb870dc..a62b53a 100644
--- a/drivers/staging/wlags49_h2/hcfdef.h
+++ b/drivers/staging/wlags49_h2/hcfdef.h
@@ -568,9 +568,6 @@ err: ;
 
 #define LOF(x)          (sizeof(x)/sizeof(hcf_16)-1)
 
-#define MUL_BY_2( x )   ( (x) << 1 )                        //used to multiply by 2
-#define DIV_BY_2( x )   ( (x) >> 1 )                        //used to divide by 2
-
 //resolve problems on for some 16 bits compilers to create 32 bit values
 #define MERGE_2( hw, lw )   ( ( ((hcf_32)(hw)) << 16 ) | ((hcf_16)(lw)) )
 
-- 
1.7.4.1

