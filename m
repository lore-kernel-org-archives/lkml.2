Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1DRTYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:24:13 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:48095 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab1DRTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:24:06 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 07/12] staging: xgifb: delete unused register I/O macros
Date: Mon, 18 Apr 2011 22:14:03 +0300
Message-Id: <1303154048-21989-8-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused register I/O macros.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h |   36 ------------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 46b5958..560e2de 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -216,42 +216,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 #define SR_BUFFER_SIZE            5
 #define CR_BUFFER_SIZE            5
 
-/* Useful macros */
-#define inXGIREG(base)          inb(base)
-#define outXGIREG(base,val)     outb(val,base)
-#define orXGIREG(base,val)      do { \
-                                  unsigned char __Temp = inb(base); \
-                                  outXGIREG(base, __Temp | (val)); \
-                                } while (0)
-#define andXGIREG(base,val)     do { \
-                                  unsigned char __Temp = inb(base); \
-                                  outXGIREG(base, __Temp & (val)); \
-                                } while (0)
-#define inXGIIDXREG(base,idx,var)   do { \
-                                      outb(idx,base); var=inb((base)+1); \
-                                    } while (0)
-#define outXGIIDXREG(base,idx,val)  do { \
-                                      outb(idx,base); outb((val),(base)+1); \
-                                    } while (0)
-#define orXGIIDXREG(base,idx,val)   do { \
-                                      unsigned char __Temp; \
-                                      outb(idx,base);   \
-                                      __Temp = inb((base)+1)|(val); \
-                                      outXGIIDXREG(base,idx,__Temp); \
-                                    } while (0)
-#define andXGIIDXREG(base,idx,and)  do { \
-                                      unsigned char __Temp; \
-                                      outb(idx,base);   \
-                                      __Temp = inb((base)+1)&(and); \
-                                      outXGIIDXREG(base,idx,__Temp); \
-                                    } while (0)
-#define setXGIIDXREG(base,idx,and,or)   do { \
-                                          unsigned char __Temp; \
-                                          outb(idx,base);   \
-                                          __Temp = (inb((base)+1)&(and))|(or); \
-                                          outXGIIDXREG(base,idx,__Temp); \
-                                        } while (0)
-
 /* ------------------- Global Variables ----------------------------- */
 
 /* Fbcon variables */
-- 
1.5.6.5

