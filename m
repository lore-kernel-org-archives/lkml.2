Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2KNHvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:51:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2KNHvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:51:04 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 4/6] staging: line6: drop MIDI dumping code
Date: Wed, 14 Nov 2012 08:50:44 +0100
Message-Id: <1352879446-23195-5-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
References: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALSA amidi(1) and aseqdump(1) can be used to dump MIDI instead of
manually dumping MIDI messages in the driver.  The advantage of using
these existing tools is that can be used at run-time rather than
compile-time.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.c | 3 ---
 drivers/staging/line6/midi.c   | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index fda92d1..0bc838d 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -402,9 +402,6 @@ static void line6_data_received(struct urb *urb)
 			continue;
 
 		line6->message_length = done;
-#ifdef CONFIG_LINE6_USB_DUMP_MIDI
-		line6_write_hexdump(line6, 'r', line6->buffer_message, done);
-#endif
 		line6_midi_receive(line6, line6->buffer_message, done);
 
 		switch (line6->usbdev->descriptor.idProduct) {
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 348d425..c8e099b 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -59,9 +59,6 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 		if (done == 0)
 			break;
 
-#ifdef CONFIG_LINE6_USB_DUMP_MIDI
-		line6_write_hexdump(line6, 's', chunk, done);
-#endif
 		line6_midibuf_write(mb, chunk, done);
 		snd_rawmidi_transmit_ack(substream, done);
 	}
-- 
1.8.0

