Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2A3WAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:00:43 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45873 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336Ab2A3WAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Armin Schindler <mac@melware.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 01/16] eicon: fix -Warray-bounds warning
Date: Mon, 30 Jan 2012 23:00:05 +0100
Message-Id: <1327960820-11867-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960840;836e2fd0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a -Warray-bounds warning. mixer_notify_update() tries to
write to ((CAPI_MSG *) msg)->info.facility_req.structs[3] while
structs is defined as byte structs[1], define structs[1] as
structs[4].

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/isdn/hardware/eicon/capi20.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/capi20.h b/drivers/isdn/hardware/eicon/capi20.h
index 7ebcccd..f9170ad 100644
--- a/drivers/isdn/hardware/eicon/capi20.h
+++ b/drivers/isdn/hardware/eicon/capi20.h
@@ -226,7 +226,7 @@ typedef struct {
         /* FACILITY-REQUEST */
 typedef struct {
   word Selector;
-  byte structs[1];      /* Facility parameters */
+  byte structs[4];      /* Facility parameters */
 } _FAC_REQP;
         /* FACILITY-CONFIRM STRUCT FOR SUPPLEMENT. SERVICES */
 typedef struct {
-- 
1.7.7.3

