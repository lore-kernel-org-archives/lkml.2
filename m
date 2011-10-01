Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1JAIoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 04:44:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55661 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab1JAIoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 04:44:17 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/3] staging: wlags49_h2: Remove unused debug function
Date: Sat,  1 Oct 2011 09:43:49 +0100
Message-Id: <1317458630-16033-3-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317458630-16033-1-git-send-email-kilroyd@googlemail.com>
References: <1317458630-16033-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function no longer compiles, so we just remove it.

Reported-by: Henk de Groot <pe1dnn@amsat.org>
Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_cs.c |  114 ------------------------------------
 1 files changed, 0 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index a3a727c..3215802 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -501,117 +501,3 @@ int wl_adapter_is_open(struct net_device *dev)
 	return link->open;
 } /* wl_adapter_is_open */
 /*============================================================================*/
-
-
-#if DBG
-
-/*******************************************************************************
- *	DbgEvent()
- *******************************************************************************
- *
- *  DESCRIPTION:
- *
- *      Converts the card serivces events to text for debugging.
- *
- *  PARAMETERS:
- *
- *      mask    - a integer representing the error(s) being reported by Card
- *                Services.
- *
- *  RETURNS:
- *
- *      a pointer to a string describing the error(s)
- *
- ******************************************************************************/
-const char *DbgEvent(int mask)
-{
-	static char DbgBuffer[256];
-	char *pBuf;
-	/*--------------------------------------------------------------------*/
-
-	pBuf    = DbgBuffer;
-	*pBuf   = '\0';
-
-
-	if (mask & CS_EVENT_WRITE_PROTECT)
-		strcat(pBuf, "WRITE_PROTECT ");
-
-	if (mask & CS_EVENT_CARD_LOCK)
-		strcat(pBuf, "CARD_LOCK ");
-
-	if (mask & CS_EVENT_CARD_INSERTION)
-		strcat(pBuf, "CARD_INSERTION ");
-
-	if (mask & CS_EVENT_CARD_REMOVAL)
-		strcat(pBuf, "CARD_REMOVAL ");
-
-	if (mask & CS_EVENT_BATTERY_DEAD)
-		strcat(pBuf, "BATTERY_DEAD ");
-
-	if (mask & CS_EVENT_BATTERY_LOW)
-		strcat(pBuf, "BATTERY_LOW ");
-
-	if (mask & CS_EVENT_READY_CHANGE)
-		strcat(pBuf, "READY_CHANGE ");
-
-	if (mask & CS_EVENT_CARD_DETECT)
-		strcat(pBuf, "CARD_DETECT ");
-
-	if (mask & CS_EVENT_RESET_REQUEST)
-		strcat(pBuf, "RESET_REQUEST ");
-
-	if (mask & CS_EVENT_RESET_PHYSICAL)
-		strcat(pBuf, "RESET_PHYSICAL ");
-
-	if (mask & CS_EVENT_CARD_RESET)
-		strcat(pBuf, "CARD_RESET ");
-
-	if (mask & CS_EVENT_REGISTRATION_COMPLETE)
-		strcat(pBuf, "REGISTRATION_COMPLETE ");
-
-	/* if (mask & CS_EVENT_RESET_COMPLETE)
-		strcat(pBuf, "RESET_COMPLETE "); */
-
-	if (mask & CS_EVENT_PM_SUSPEND)
-		strcat(pBuf, "PM_SUSPEND ");
-
-	if (mask & CS_EVENT_PM_RESUME)
-		strcat(pBuf, "PM_RESUME ");
-
-	if (mask & CS_EVENT_INSERTION_REQUEST)
-		strcat(pBuf, "INSERTION_REQUEST ");
-
-	if (mask & CS_EVENT_EJECTION_REQUEST)
-		strcat(pBuf, "EJECTION_REQUEST ");
-
-	if (mask & CS_EVENT_MTD_REQUEST)
-		strcat(pBuf, "MTD_REQUEST ");
-
-	if (mask & CS_EVENT_ERASE_COMPLETE)
-		strcat(pBuf, "ERASE_COMPLETE ");
-
-	if (mask & CS_EVENT_REQUEST_ATTENTION)
-		strcat(pBuf, "REQUEST_ATTENTION ");
-
-	if (mask & CS_EVENT_CB_DETECT)
-		strcat(pBuf, "CB_DETECT ");
-
-	if (mask & CS_EVENT_3VCARD)
-		strcat(pBuf, "3VCARD ");
-
-	if (mask & CS_EVENT_XVCARD)
-		strcat(pBuf, "XVCARD ");
-
-
-	if (*pBuf) {
-		pBuf[strlen(pBuf) - 1] = '\0';
-	} else {
-		if (mask != 0x0)
-			sprintf(pBuf, "<<0x%08x>>", mask);
-	}
-
-	return pBuf;
-} /* DbgEvent */
-/*============================================================================*/
-
-#endif  /* DBG */
-- 
1.7.4.1

