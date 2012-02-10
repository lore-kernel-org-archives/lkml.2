Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2BJAEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:04:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758722Ab2BJABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 24/31] edac_mc: Some clenups at the log message
Date: Thu,  9 Feb 2012 22:01:23 -0200
Message-Id: <1328832090-9166-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 2dca0e3..c1a34b9 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -916,7 +916,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 
 	/* Check if the event report is consistent */
 	for (i = 0; i < mci->n_layers; i++) {
-		if (pos[i] >= mci->layers[i].size) {
+		if (pos[i] >= (int)mci->layers[i].size) {
 			if (type == HW_EVENT_ERR_CORRECTED) {
 				p = "CE";
 				mci->ce_mc++;
@@ -1014,7 +1014,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		}
 	}
 	if (!enable_filter) {
-		p = "any memory";
+		strcpy(label, "any memory");
 	} else {
 		if (type == HW_EVENT_ERR_CORRECTED) {
 			if (row >= 0)
@@ -1039,12 +1039,12 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	/* Memory type dependent details about the error */
 	if (type == HW_EVENT_ERR_CORRECTED)
 		snprintf(detail, sizeof(detail),
-			"page 0x%lx offset 0x%lx grain %d syndrome 0x%lx\n",
+			"page 0x%lx offset 0x%lx grain %d syndrome 0x%lx",
 			page_frame_number, offset_in_page,
 			grain, syndrome);
 	else
 		snprintf(detail, sizeof(detail),
-			"page 0x%lx offset 0x%lx grain %d\n",
+			"page 0x%lx offset 0x%lx grain %d",
 			page_frame_number, offset_in_page, grain);
 
 #ifdef CONFIG_X86
@@ -1062,7 +1062,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		if (edac_mc_get_log_ce())
 			edac_mc_printk(mci, KERN_WARNING,
-				       "CE %s label \"%s\" (%s %s %s)\n",
+				       "CE %s on %s (%s%s %s)\n",
 				       msg, label, location,
 				       detail, other_detail);
 		edac_increment_ce_error(mci,enable_filter, pos);
@@ -1089,11 +1089,11 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	} else {
 		if (edac_mc_get_log_ue())
 			edac_mc_printk(mci, KERN_WARNING,
-				"UE %s label \"%s\" (%s %s %s)\n",
+				"UE %s on %s (%s%s %s)\n",
 				msg, label, location, detail, other_detail);
 
 		if (edac_mc_get_panic_on_ue())
-			panic("UE %s label \"%s\" (%s %s %s)\n",
+			panic("UE %s on %s (%s%s %s)\n",
 			      msg, label, location, detail, other_detail);
 
 		edac_increment_ue_error(mci,enable_filter, pos);
-- 
1.7.8

