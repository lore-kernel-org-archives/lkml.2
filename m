Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2KQHf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 02:35:26 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55138 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752325Ab2KQHfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 02:35:25 -0500
Message-ID: <1353137716.12430.3.camel@joe-AO722>
Subject: [PATCH] sound: use bitmap_weight
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 16 Nov 2012 23:35:16 -0800
In-Reply-To: <1353134389-25583-1-git-send-email-akinobu.mita@gmail.com>
References: <1353134389-25583-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_weight to count the total number of bits set in bitmap.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/usb/endpoint.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 34de6f2..51a9aa3 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -485,15 +485,10 @@ __exit_unlock:
 static int wait_clear_urbs(struct snd_usb_endpoint *ep)
 {
 	unsigned long end_time = jiffies + msecs_to_jiffies(1000);
-	unsigned int i;
 	int alive;
 
 	do {
-		alive = 0;
-		for (i = 0; i < ep->nurbs; i++)
-			if (test_bit(i, &ep->active_mask))
-				alive++;
-
+		alive = bitmap_weight(&ep->active_mask, ep->nurbs);
 		if (!alive)
 			break;
 


