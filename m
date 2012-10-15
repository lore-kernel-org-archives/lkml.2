Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab2JOSxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab2JOSxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:53:11 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Markus Grabner <grabner@icg.tugraz.at>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH] staging: line6: drop unused line6_index and line6_id arrays
Date: Mon, 15 Oct 2012 20:52:27 +0200
Message-Id: <1350327147-18000-1-git-send-email-stefanha@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line6 driver does not support 'index' and 'id' module parameters so
there is no need to keep arrays for these values.  Do what other sound
drivers do and use the scalar constants instead of dummy arrays.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/staging/line6/audio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/line6/audio.c b/drivers/staging/line6/audio.c
index 8e73983..a92e21f 100644
--- a/drivers/staging/line6/audio.c
+++ b/drivers/staging/line6/audio.c
@@ -16,20 +16,16 @@
 #include "driver.h"
 #include "audio.h"
 
-static int line6_index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
-static char *line6_id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-
 /*
 	Initialize the Line6 USB audio system.
 */
 int line6_init_audio(struct usb_line6 *line6)
 {
-	static int dev;
 	struct snd_card *card;
 	int err;
 
-	err = snd_card_create(line6_index[dev], line6_id[dev], THIS_MODULE, 0,
-			      &card);
+	err = snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
+			      THIS_MODULE, 0, &card);
 	if (err < 0)
 		return err;
 
-- 
1.7.11.7

