Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1GUHVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:21:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41940 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GUHVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:21:43 -0400
Subject: [PATCH] HID: prodikeys: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Don Prince <dhprince.devel@yahoo.co.uk>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 15:21:33 +0800
Message-ID: <1311232893.10976.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following symbols are not referenced outside this file so
there's no need for it to be in the global name space.

  pcmidi_sustained_note_release
  init_sustain_timers
  stop_sustain_timers
  pcmidi_handle_report
  pcmidi_setup_extra_keys
  pcmidi_snd_initialise
  pcmidi_snd_terminate

Make them static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hid/hid-prodikeys.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index ab19f29..7563229 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -242,7 +242,7 @@ drop_note:
 	return;
 }
 
-void pcmidi_sustained_note_release(unsigned long data)
+static void pcmidi_sustained_note_release(unsigned long data)
 {
 	struct pcmidi_sustain *pms = (struct pcmidi_sustain *)data;
 
@@ -250,7 +250,7 @@ void pcmidi_sustained_note_release(unsigned long data)
 	pms->in_use = 0;
 }
 
-void init_sustain_timers(struct pcmidi_snd *pm)
+static void init_sustain_timers(struct pcmidi_snd *pm)
 {
 	struct pcmidi_sustain *pms;
 	unsigned i;
@@ -264,7 +264,7 @@ void init_sustain_timers(struct pcmidi_snd *pm)
 	}
 }
 
-void stop_sustain_timers(struct pcmidi_snd *pm)
+static void stop_sustain_timers(struct pcmidi_snd *pm)
 {
 	struct pcmidi_sustain *pms;
 	unsigned i;
@@ -499,7 +499,7 @@ static int pcmidi_handle_report4(struct pcmidi_snd *pm, u8 *data)
 	return 1;
 }
 
-int pcmidi_handle_report(
+static int pcmidi_handle_report(
 	struct pcmidi_snd *pm, unsigned report_id, u8 *data, int size)
 {
 	int ret = 0;
@@ -518,7 +518,8 @@ int pcmidi_handle_report(
 	return ret;
 }
 
-void pcmidi_setup_extra_keys(struct pcmidi_snd *pm, struct input_dev *input)
+static void pcmidi_setup_extra_keys(
+	struct pcmidi_snd *pm, struct input_dev *input)
 {
 	/* reassigned functionality for N/A keys
 		MY PICTURES =>	KEY_WORDPROCESSOR
@@ -602,7 +603,7 @@ static struct snd_rawmidi_ops pcmidi_in_ops = {
 	.trigger = pcmidi_in_trigger
 };
 
-int pcmidi_snd_initialise(struct pcmidi_snd *pm)
+static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 {
 	static int dev;
 	struct snd_card *card;
@@ -720,7 +721,7 @@ fail:
 	return err;
 }
 
-int pcmidi_snd_terminate(struct pcmidi_snd *pm)
+static int pcmidi_snd_terminate(struct pcmidi_snd *pm)
 {
 	if (pm->card) {
 		stop_sustain_timers(pm);
-- 
1.7.4.1



