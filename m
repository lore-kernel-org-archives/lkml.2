Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab2I1TE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:04:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab2I1TEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        Jason Gerecke <killertofu@gmail.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [ 216/262] Input: wacom - rearrange type enum
Date: Fri, 28 Sep 2012 11:52:25 -0700
Message-Id: <20120928183023.633398304@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <pinglinux@gmail.com>

commit ea2e60244573a9204c8cee9b4fb181106784c617 upstream.

So we can simplify a few type related if statements

Also fixes https://bugzilla.kernel.org/show_bug.cgi?id=46821

Signed-off-by: Ping Cheng <pingc@wacom.com>
Acked-by: Chris Bagwell <chris@cnpbagwell.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/wacom_sys.c |   10 +++-------
 drivers/input/tablet/wacom_wac.c |    6 ++----
 drivers/input/tablet/wacom_wac.h |    6 +++---
 3 files changed, 8 insertions(+), 14 deletions(-)

--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -445,8 +445,7 @@ static int wacom_query_tablet_data(struc
 	/* ask to report Wacom data */
 	if (features->device_type == BTN_TOOL_FINGER) {
 		/* if it is an MT Tablet PC touch */
-		if (features->type == TABLETPC2FG ||
-		    features->type == MTSCREEN) {
+		if (features->type > TABLETPC) {
 			do {
 				rep_data[0] = 3;
 				rep_data[1] = 4;
@@ -465,7 +464,7 @@ static int wacom_query_tablet_data(struc
 			} while ((error < 0 || rep_data[1] != 4) &&
 				 limit++ < WAC_MSG_RETRIES);
 		}
-	} else if (features->type != TABLETPC &&
+	} else if (features->type <= BAMBOO_PT &&
 		   features->type != WIRELESS &&
 		   features->device_type == BTN_TOOL_PEN) {
 		do {
@@ -515,10 +514,7 @@ static int wacom_retrieve_hid_descriptor
 	}
 
 	/* only devices that support touch need to retrieve the info */
-	if (features->type != TABLETPC &&
-	    features->type != TABLETPC2FG &&
-	    features->type != BAMBOO_PT &&
-	    features->type != MTSCREEN) {
+	if (features->type < BAMBOO_PT) {
 		goto out;
 	}
 
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1324,10 +1324,8 @@ void wacom_setup_device_quirks(struct wa
 	}
 
 	/* these device have multiple inputs */
-	if (features->type == TABLETPC || features->type == TABLETPC2FG ||
-	    features->type == BAMBOO_PT || features->type == WIRELESS ||
-	    (features->type >= INTUOS5S && features->type <= INTUOS5L) ||
-	    features->type == MTSCREEN)
+	if (features->type >= WIRELESS ||
+	    (features->type >= INTUOS5S && features->type <= INTUOS5L))
 		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
 
 	/* quirk for bamboo touch with 2 low res touches */
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -62,8 +62,6 @@ enum {
 	PTU,
 	PL,
 	DTU,
-	BAMBOO_PT,
-	WIRELESS,
 	INTUOS,
 	INTUOS3S,
 	INTUOS3,
@@ -80,7 +78,9 @@ enum {
 	CINTIQ,
 	WACOM_BEE,
 	WACOM_MO,
-	TABLETPC,
+	WIRELESS,
+	BAMBOO_PT,
+	TABLETPC,   /* add new TPC below */
 	TABLETPC2FG,
 	MTSCREEN,
 	MAX_TYPE


