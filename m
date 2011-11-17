Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1KRJdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:33:08 -0500
Received: from www17.your-server.de ([213.133.104.17]:34761 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1KRJdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:33:01 -0500
Message-ID: <1321571538.1624.314.camel@localhost.localdomain>
Subject: [PATCH] [media] cx25821: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 00:12:18 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/video/cx25821/cx25821-audio-upstream.c b/drivers/media/video/cx25821/cx25821-audio-upstream.c
--- a/drivers/media/video/cx25821/cx25821-audio-upstream.c 2011-11-07 19:37:49.746645818 +0100
+++ b/drivers/media/video/cx25821/cx25821-audio-upstream.c 2011-11-08 10:47:22.883308220 +0100
@@ -739,25 +739,22 @@ int cx25821_audio_upstream_init(struct c
 
 	if (dev->input_audiofilename) {
 		str_length = strlen(dev->input_audiofilename);
-		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_audiofilename = kmemdup(dev->input_audiofilename,
+					      str_length + 1, GFP_KERNEL);
 
 		if (!dev->_audiofilename)
 			goto error;
 
-		memcpy(dev->_audiofilename, dev->input_audiofilename,
-		       str_length + 1);
-
 		/* Default if filename is empty string */
 		if (strcmp(dev->input_audiofilename, "") == 0)
 			dev->_audiofilename = "/root/audioGOOD.wav";
 	} else {
 		str_length = strlen(_defaultAudioName);
-		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_audiofilename = kmemdup(_defaultAudioName,
+					      str_length + 1, GFP_KERNEL);
 
 		if (!dev->_audiofilename)
 			goto error;
-
-		memcpy(dev->_audiofilename, _defaultAudioName, str_length + 1);
 	}
 
 	retval = cx25821_sram_channel_setup_upstream_audio(dev, sram_ch,
diff -u -p a/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c
--- a/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c 2011-11-07 19:37:49.756645970 +0100
+++ b/drivers/media/video/cx25821/cx25821-video-upstream-ch2.c 2011-11-08 10:47:21.626624708 +0100
@@ -761,22 +761,18 @@ int cx25821_vidupstream_init_ch2(struct
 
 	if (dev->input_filename_ch2) {
 		str_length = strlen(dev->input_filename_ch2);
-		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename_ch2 = kmemdup(dev->input_filename_ch2,
+					     str_length + 1, GFP_KERNEL);
 
 		if (!dev->_filename_ch2)
 			goto error;
-
-		memcpy(dev->_filename_ch2, dev->input_filename_ch2,
-		       str_length + 1);
 	} else {
 		str_length = strlen(dev->_defaultname_ch2);
-		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename_ch2 = kmemdup(dev->_defaultname_ch2,
+					     str_length + 1, GFP_KERNEL);
 
 		if (!dev->_filename_ch2)
 			goto error;
-
-		memcpy(dev->_filename_ch2, dev->_defaultname_ch2,
-		       str_length + 1);
 	}
 
 	/* Default if filename is empty string */
diff -u -p a/drivers/media/video/cx25821/cx25821-video-upstream.c b/drivers/media/video/cx25821/cx25821-video-upstream.c
--- a/drivers/media/video/cx25821/cx25821-video-upstream.c 2011-11-07 19:37:49.756645970 +0100
+++ b/drivers/media/video/cx25821/cx25821-video-upstream.c 2011-11-08 10:47:22.036630204 +0100
@@ -816,20 +816,18 @@ int cx25821_vidupstream_init_ch1(struct
 
 	if (dev->input_filename) {
 		str_length = strlen(dev->input_filename);
-		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename = kmemdup(dev->input_filename, str_length + 1,
+					 GFP_KERNEL);
 
 		if (!dev->_filename)
 			goto error;
-
-		memcpy(dev->_filename, dev->input_filename, str_length + 1);
 	} else {
 		str_length = strlen(dev->_defaultname);
-		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename = kmemdup(dev->_defaultname, str_length + 1,
+					 GFP_KERNEL);
 
 		if (!dev->_filename)
 			goto error;
-
-		memcpy(dev->_filename, dev->_defaultname, str_length + 1);
 	}
 
 	/* Default if filename is empty string */


