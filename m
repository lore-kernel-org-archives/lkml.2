Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab1J3OlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 10:41:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46260 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934036Ab1J3Ok7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 10:40:59 -0400
From: Stefan Hajnoczi <stefanha@gmail.com>
To: <grabner@icg.tugraz.at>
Cc: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 1/2] staging: line6: accept all MIDI channels by default
Date: Sun, 30 Oct 2011 14:40:40 +0000
Message-Id: <1319985641-25648-2-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319985641-25648-1-git-send-email-stefanha@gmail.com>
References: <1319985641-25648-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIDI messages can be filtered by channel so that multiple devices can
coexist on the same MIDI bus.  By default all channels should be
accepted; this is important because Line6 devices seem to have different
default channels.

Accept all MIDI messages by default to avoid confusing users when
messages are silently filtered out.  If filtering is necessary due to
multiple devices on the bus, users can set the midi_mask_transmit and
midi_mask_receive sysfs attributes.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/midi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index e554a2d..2d81d2a 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -399,8 +399,8 @@ int line6_init_midi(struct usb_line6 *line6)
 		return err;
 
 	line6midi->line6 = line6;
-	line6midi->midi_mask_transmit = 1;
-	line6midi->midi_mask_receive = 4;
+	line6midi->midi_mask_transmit = 0xffff;
+	line6midi->midi_mask_receive = 0xffff;
 	line6->line6midi = line6midi;
 
 	err = snd_device_new(line6->card, SNDRV_DEV_RAWMIDI, line6midi,
-- 
1.7.7

