Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2KJGrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 01:47:18 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43481 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2KJGrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 01:47:12 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: alsa-devel@alsa-project.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH] ALSA: line6: move staging driver to sound/usb/
Date: Sat, 10 Nov 2012 07:44:52 +0100
Message-Id: <1352529892-17610-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line6 driver supports devices from the Line6 PODxt, POD HD,
TonePort, and Variax product families.  This USB sound driver has been
in staging since 2009 and is ready for wider review and users.

These devices provide both PCM and MIDI.  Depending on the model the PCM
supports capture and playback - there may be multiple capture sources.
MIDI is used to control the device including changing effect or
amplifier model settings, dumping presets, and changing between patches.

There are userspace tools and a manual available at:

  http://www.tanzband-scream.at/line6/
  http://line6linux.sourceforge.net/

Cc: Markus Grabner <grabner@icg.tugraz.at>
Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
This patch is based on linux-next.git/master.

Markus is busy but has given me the green light to do the work needed to get
the line6 driver out of staging:

  http://permalink.gmane.org/gmane.comp.audio.line6linux.devel/49

 drivers/staging/Kconfig             |    2 -
 drivers/staging/Makefile            |    1 -
 drivers/staging/line6/Kconfig       |   85 ---
 drivers/staging/line6/Makefile      |   16 -
 drivers/staging/line6/audio.c       |   70 --
 drivers/staging/line6/audio.h       |   21 -
 drivers/staging/line6/capture.c     |  435 -----------
 drivers/staging/line6/capture.h     |   35 -
 drivers/staging/line6/control.c     |  995 --------------------------
 drivers/staging/line6/control.h     |  195 -----
 drivers/staging/line6/driver.c      | 1290 ---------------------------------
 drivers/staging/line6/driver.h      |  235 ------
 drivers/staging/line6/dumprequest.c |  135 ----
 drivers/staging/line6/dumprequest.h |   76 --
 drivers/staging/line6/midi.c        |  446 ------------
 drivers/staging/line6/midi.h        |   82 ---
 drivers/staging/line6/midibuf.c     |  264 -------
 drivers/staging/line6/midibuf.h     |   38 -
 drivers/staging/line6/pcm.c         |  570 ---------------
 drivers/staging/line6/pcm.h         |  382 ----------
 drivers/staging/line6/playback.c    |  586 ---------------
 drivers/staging/line6/playback.h    |   41 --
 drivers/staging/line6/pod.c         | 1351 -----------------------------------
 drivers/staging/line6/pod.h         |  205 ------
 drivers/staging/line6/podhd.c       |  154 ----
 drivers/staging/line6/podhd.h       |   30 -
 drivers/staging/line6/revision.h    |    4 -
 drivers/staging/line6/toneport.c    |  455 ------------
 drivers/staging/line6/toneport.h    |   52 --
 drivers/staging/line6/usbdefs.h     |  107 ---
 drivers/staging/line6/variax.c      |  719 -------------------
 drivers/staging/line6/variax.h      |  132 ----
 sound/usb/Kconfig                   |    2 +
 sound/usb/Makefile                  |    2 +-
 sound/usb/line6/Kconfig             |   85 +++
 sound/usb/line6/Makefile            |   16 +
 sound/usb/line6/audio.c             |   70 ++
 sound/usb/line6/audio.h             |   21 +
 sound/usb/line6/capture.c           |  435 +++++++++++
 sound/usb/line6/capture.h           |   35 +
 sound/usb/line6/control.c           |  995 ++++++++++++++++++++++++++
 sound/usb/line6/control.h           |  195 +++++
 sound/usb/line6/driver.c            | 1290 +++++++++++++++++++++++++++++++++
 sound/usb/line6/driver.h            |  235 ++++++
 sound/usb/line6/dumprequest.c       |  135 ++++
 sound/usb/line6/dumprequest.h       |   76 ++
 sound/usb/line6/midi.c              |  446 ++++++++++++
 sound/usb/line6/midi.h              |   82 +++
 sound/usb/line6/midibuf.c           |  264 +++++++
 sound/usb/line6/midibuf.h           |   38 +
 sound/usb/line6/pcm.c               |  570 +++++++++++++++
 sound/usb/line6/pcm.h               |  382 ++++++++++
 sound/usb/line6/playback.c          |  586 +++++++++++++++
 sound/usb/line6/playback.h          |   41 ++
 sound/usb/line6/pod.c               | 1351 +++++++++++++++++++++++++++++++++++
 sound/usb/line6/pod.h               |  205 ++++++
 sound/usb/line6/podhd.c             |  154 ++++
 sound/usb/line6/podhd.h             |   30 +
 sound/usb/line6/revision.h          |    4 +
 sound/usb/line6/toneport.c          |  455 ++++++++++++
 sound/usb/line6/toneport.h          |   52 ++
 sound/usb/line6/usbdefs.h           |  107 +++
 sound/usb/line6/variax.c            |  719 +++++++++++++++++++
 sound/usb/line6/variax.h            |  132 ++++
 64 files changed, 9209 insertions(+), 9210 deletions(-)
 delete mode 100644 drivers/staging/line6/Kconfig
 delete mode 100644 drivers/staging/line6/Makefile
 delete mode 100644 drivers/staging/line6/audio.c
 delete mode 100644 drivers/staging/line6/audio.h
 delete mode 100644 drivers/staging/line6/capture.c
 delete mode 100644 drivers/staging/line6/capture.h
 delete mode 100644 drivers/staging/line6/control.c
 delete mode 100644 drivers/staging/line6/control.h
 delete mode 100644 drivers/staging/line6/driver.c
 delete mode 100644 drivers/staging/line6/driver.h
 delete mode 100644 drivers/staging/line6/dumprequest.c
 delete mode 100644 drivers/staging/line6/dumprequest.h
 delete mode 100644 drivers/staging/line6/midi.c
 delete mode 100644 drivers/staging/line6/midi.h
 delete mode 100644 drivers/staging/line6/midibuf.c
 delete mode 100644 drivers/staging/line6/midibuf.h
 delete mode 100644 drivers/staging/line6/pcm.c
 delete mode 100644 drivers/staging/line6/pcm.h
 delete mode 100644 drivers/staging/line6/playback.c
 delete mode 100644 drivers/staging/line6/playback.h
 delete mode 100644 drivers/staging/line6/pod.c
 delete mode 100644 drivers/staging/line6/pod.h
 delete mode 100644 drivers/staging/line6/podhd.c
 delete mode 100644 drivers/staging/line6/podhd.h
 delete mode 100644 drivers/staging/line6/revision.h
 delete mode 100644 drivers/staging/line6/toneport.c
 delete mode 100644 drivers/staging/line6/toneport.h
 delete mode 100644 drivers/staging/line6/usbdefs.h
 delete mode 100644 drivers/staging/line6/variax.c
 delete mode 100644 drivers/staging/line6/variax.h
 create mode 100644 sound/usb/line6/Kconfig
 create mode 100644 sound/usb/line6/Makefile
 create mode 100644 sound/usb/line6/audio.c
 create mode 100644 sound/usb/line6/audio.h
 create mode 100644 sound/usb/line6/capture.c
 create mode 100644 sound/usb/line6/capture.h
 create mode 100644 sound/usb/line6/control.c
 create mode 100644 sound/usb/line6/control.h
 create mode 100644 sound/usb/line6/driver.c
 create mode 100644 sound/usb/line6/driver.h
 create mode 100644 sound/usb/line6/dumprequest.c
 create mode 100644 sound/usb/line6/dumprequest.h
 create mode 100644 sound/usb/line6/midi.c
 create mode 100644 sound/usb/line6/midi.h
 create mode 100644 sound/usb/line6/midibuf.c
 create mode 100644 sound/usb/line6/midibuf.h
 create mode 100644 sound/usb/line6/pcm.c
 create mode 100644 sound/usb/line6/pcm.h
 create mode 100644 sound/usb/line6/playback.c
 create mode 100644 sound/usb/line6/playback.h
 create mode 100644 sound/usb/line6/pod.c
 create mode 100644 sound/usb/line6/pod.h
 create mode 100644 sound/usb/line6/podhd.c
 create mode 100644 sound/usb/line6/podhd.h
 create mode 100644 sound/usb/line6/revision.h
 create mode 100644 sound/usb/line6/toneport.c
 create mode 100644 sound/usb/line6/toneport.h
 create mode 100644 sound/usb/line6/usbdefs.h
 create mode 100644 sound/usb/line6/variax.c
 create mode 100644 sound/usb/line6/variax.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 231a272..b1a1d79 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -58,8 +58,6 @@ source "drivers/staging/frontier/Kconfig"
 
 source "drivers/staging/phison/Kconfig"
 
-source "drivers/staging/line6/Kconfig"
-
 source "drivers/staging/octeon/Kconfig"
 
 source "drivers/staging/serqt_usb2/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 2b291c0..5e61dd3 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_R8712U)		+= rtl8712/
 obj-$(CONFIG_RTS5139)		+= rts5139/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_IDE_PHISON)	+= phison/
-obj-$(CONFIG_LINE6_USB)		+= line6/
 obj-$(CONFIG_USB_SERIAL_QUATECH2)	+= serqt_usb2/
 obj-$(CONFIG_OCTEON_ETHERNET)	+= octeon/
 obj-$(CONFIG_VT6655)		+= vt6655/
diff --git a/drivers/staging/line6/Kconfig b/drivers/staging/line6/Kconfig
deleted file mode 100644
index 43120ff..0000000
--- a/drivers/staging/line6/Kconfig
+++ /dev/null
@@ -1,85 +0,0 @@
-menuconfig LINE6_USB
-	tristate "Line6 USB support"
-	depends on USB && SND
-	select SND_RAWMIDI
-	select SND_PCM
-	help
-	  This is a driver for the guitar amp, cab, and effects modeller
-	  PODxt Pro by Line6 (and similar devices), supporting the
-	  following features:
-	    * Reading/writing individual parameters
-	    * Reading/writing complete channel, effects setup, and amp
-	      setup data
-	    * Channel switching
-	    * Virtual MIDI interface
-	    * Tuner access
-	    * Playback/capture/mixer device for any ALSA-compatible PCM
-	      audio application
-	    * Signal routing (record clean/processed guitar signal,
-	      re-amping)
-
-	  Preliminary support for the Variax Workbench and TonePort
-	  devices is included.
-
-if LINE6_USB
-
-config LINE6_USB_DEBUG
-	bool "print debug messages"
-	default n
-	help
-	  Say Y here to write debug messages to the syslog.
-
-	  If unsure, say N.
-
-config LINE6_USB_DUMP_CTRL
-	bool "dump control messages"
-	default n
-	help
-	  Say Y here to write control messages sent to and received from
-	  Line6 devices to the syslog.
-
-	  If unsure, say N.
-
-config LINE6_USB_DUMP_MIDI
-	bool "dump MIDI messages"
-	default n
-	help
-	  Say Y here to write MIDI messages sent to and received from
-	  Line6 devices to the syslog.
-
-	  If unsure, say N.
-
-config LINE6_USB_DUMP_PCM
-	bool "dump PCM data"
-	default n
-	help
-	  Say Y here to write PCM data sent to and received from Line6
-	  devices to the syslog. This will produce a huge amount of
-	  syslog data during playback and capture.
-
-	  If unsure, say N.
-
-config LINE6_USB_RAW
-	bool "raw data communication"
-	default n
-	help
-	  Say Y here to create special files which allow to send raw data
-	  to the device. This bypasses any sanity checks, so if you discover
-	  the code to erase the firmware, feel free to render your device
-	  useless, but only after reading the GPL section "NO WARRANTY".
-
-	  If unsure, say N.
-
-config LINE6_USB_IMPULSE_RESPONSE
-	bool "measure impulse response"
-	default n
-	help
-	  Say Y here to add code to measure the impulse response of a Line6
-	  device. This is more accurate than user-space methods since it
-	  bypasses any PCM data buffering (e.g., by ALSA or jack). This is
-	  useful for assessing the performance of new devices, but is not
-	  required for normal operation.
-
-	  If unsure, say N.
-
-endif # LINE6_USB
diff --git a/drivers/staging/line6/Makefile b/drivers/staging/line6/Makefile
deleted file mode 100644
index 34a2dda..0000000
--- a/drivers/staging/line6/Makefile
+++ /dev/null
@@ -1,16 +0,0 @@
-obj-$(CONFIG_LINE6_USB)		+= line6usb.o
-
-line6usb-y := 		\
-		audio.o		\
-		capture.o	\
-		control.o	\
-		driver.o	\
-		dumprequest.o	\
-		midi.o		\
-		midibuf.o	\
-		pcm.o		\
-		playback.o	\
-		pod.o		\
-		toneport.o	\
-		variax.o	\
-		podhd.o
diff --git a/drivers/staging/line6/audio.c b/drivers/staging/line6/audio.c
deleted file mode 100644
index a92e21f..0000000
--- a/drivers/staging/line6/audio.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <sound/core.h>
-#include <sound/initval.h>
-#include <linux/export.h>
-
-#include "driver.h"
-#include "audio.h"
-
-/*
-	Initialize the Line6 USB audio system.
-*/
-int line6_init_audio(struct usb_line6 *line6)
-{
-	struct snd_card *card;
-	int err;
-
-	err = snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
-			      THIS_MODULE, 0, &card);
-	if (err < 0)
-		return err;
-
-	line6->card = card;
-
-	strcpy(card->id, line6->properties->id);
-	strcpy(card->driver, DRIVER_NAME);
-	strcpy(card->shortname, line6->properties->name);
-	/* longname is 80 chars - see asound.h */
-	sprintf(card->longname, "Line6 %s at USB %s", line6->properties->name,
-		dev_name(line6->ifcdev));
-	return 0;
-}
-
-/*
-	Register the Line6 USB audio system.
-*/
-int line6_register_audio(struct usb_line6 *line6)
-{
-	int err;
-
-	err = snd_card_register(line6->card);
-	if (err < 0)
-		return err;
-
-	return 0;
-}
-
-/*
-	Cleanup the Line6 USB audio system.
-*/
-void line6_cleanup_audio(struct usb_line6 *line6)
-{
-	struct snd_card *card = line6->card;
-
-	if (card == NULL)
-		return;
-
-	snd_card_disconnect(card);
-	snd_card_free(card);
-	line6->card = NULL;
-}
diff --git a/drivers/staging/line6/audio.h b/drivers/staging/line6/audio.h
deleted file mode 100644
index 5f8a09a..0000000
--- a/drivers/staging/line6/audio.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef AUDIO_H
-#define AUDIO_H
-
-#include "driver.h"
-
-extern void line6_cleanup_audio(struct usb_line6 *);
-extern int line6_init_audio(struct usb_line6 *);
-extern int line6_register_audio(struct usb_line6 *);
-
-#endif
diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
deleted file mode 100644
index c85c5b6..0000000
--- a/drivers/staging/line6/capture.c
+++ /dev/null
@@ -1,435 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-
-#include "audio.h"
-#include "capture.h"
-#include "driver.h"
-#include "pcm.h"
-#include "pod.h"
-
-/*
-	Find a free URB and submit it.
-*/
-static int submit_audio_in_urb(struct snd_line6_pcm *line6pcm)
-{
-	int index;
-	unsigned long flags;
-	int i, urb_size;
-	int ret;
-	struct urb *urb_in;
-
-	spin_lock_irqsave(&line6pcm->lock_audio_in, flags);
-	index =
-	    find_first_zero_bit(&line6pcm->active_urb_in, LINE6_ISO_BUFFERS);
-
-	if (index < 0 || index >= LINE6_ISO_BUFFERS) {
-		spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
-		dev_err(line6pcm->line6->ifcdev, "no free URB found\n");
-		return -EINVAL;
-	}
-
-	urb_in = line6pcm->urb_audio_in[index];
-	urb_size = 0;
-
-	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fin =
-		    &urb_in->iso_frame_desc[i];
-		fin->offset = urb_size;
-		fin->length = line6pcm->max_packet_size;
-		urb_size += line6pcm->max_packet_size;
-	}
-
-	urb_in->transfer_buffer =
-	    line6pcm->buffer_in +
-	    index * LINE6_ISO_PACKETS * line6pcm->max_packet_size;
-	urb_in->transfer_buffer_length = urb_size;
-	urb_in->context = line6pcm;
-
-	ret = usb_submit_urb(urb_in, GFP_ATOMIC);
-
-	if (ret == 0)
-		set_bit(index, &line6pcm->active_urb_in);
-	else
-		dev_err(line6pcm->line6->ifcdev,
-			"URB in #%d submission failed (%d)\n", index, ret);
-
-	spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
-	return 0;
-}
-
-/*
-	Submit all currently available capture URBs.
-*/
-int line6_submit_audio_in_all_urbs(struct snd_line6_pcm *line6pcm)
-{
-	int ret, i;
-
-	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
-		ret = submit_audio_in_urb(line6pcm);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
-/*
-	Unlink all currently active capture URBs.
-*/
-void line6_unlink_audio_in_urbs(struct snd_line6_pcm *line6pcm)
-{
-	unsigned int i;
-
-	for (i = LINE6_ISO_BUFFERS; i--;) {
-		if (test_bit(i, &line6pcm->active_urb_in)) {
-			if (!test_and_set_bit(i, &line6pcm->unlink_urb_in)) {
-				struct urb *u = line6pcm->urb_audio_in[i];
-				usb_unlink_urb(u);
-			}
-		}
-	}
-}
-
-/*
-	Wait until unlinking of all currently active capture URBs has been
-	finished.
-*/
-void line6_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm)
-{
-	int timeout = HZ;
-	unsigned int i;
-	int alive;
-
-	do {
-		alive = 0;
-		for (i = LINE6_ISO_BUFFERS; i--;) {
-			if (test_bit(i, &line6pcm->active_urb_in))
-				alive++;
-		}
-		if (!alive)
-			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
-	} while (--timeout > 0);
-	if (alive)
-		snd_printk(KERN_ERR "timeout: still %d active urbs..\n", alive);
-}
-
-/*
-	Unlink all currently active capture URBs, and wait for finishing.
-*/
-void line6_unlink_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm)
-{
-	line6_unlink_audio_in_urbs(line6pcm);
-	line6_wait_clear_audio_in_urbs(line6pcm);
-}
-
-/*
-	Copy data into ALSA capture buffer.
-*/
-void line6_capture_copy(struct snd_line6_pcm *line6pcm, char *fbuf, int fsize)
-{
-	struct snd_pcm_substream *substream =
-	    get_substream(line6pcm, SNDRV_PCM_STREAM_CAPTURE);
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	const int bytes_per_frame = line6pcm->properties->bytes_per_frame;
-	int frames = fsize / bytes_per_frame;
-
-	if (runtime == NULL)
-		return;
-
-	if (line6pcm->pos_in_done + frames > runtime->buffer_size) {
-		/*
-		   The transferred area goes over buffer boundary,
-		   copy two separate chunks.
-		 */
-		int len;
-		len = runtime->buffer_size - line6pcm->pos_in_done;
-
-		if (len > 0) {
-			memcpy(runtime->dma_area +
-			       line6pcm->pos_in_done * bytes_per_frame, fbuf,
-			       len * bytes_per_frame);
-			memcpy(runtime->dma_area, fbuf + len * bytes_per_frame,
-			       (frames - len) * bytes_per_frame);
-		} else {
-			/* this is somewhat paranoid */
-			dev_err(line6pcm->line6->ifcdev,
-				"driver bug: len = %d\n", len);
-		}
-	} else {
-		/* copy single chunk */
-		memcpy(runtime->dma_area +
-		       line6pcm->pos_in_done * bytes_per_frame, fbuf, fsize);
-	}
-
-	line6pcm->pos_in_done += frames;
-	if (line6pcm->pos_in_done >= runtime->buffer_size)
-		line6pcm->pos_in_done -= runtime->buffer_size;
-}
-
-void line6_capture_check_period(struct snd_line6_pcm *line6pcm, int length)
-{
-	struct snd_pcm_substream *substream =
-	    get_substream(line6pcm, SNDRV_PCM_STREAM_CAPTURE);
-
-	line6pcm->bytes_in += length;
-	if (line6pcm->bytes_in >= line6pcm->period_in) {
-		line6pcm->bytes_in %= line6pcm->period_in;
-		snd_pcm_period_elapsed(substream);
-	}
-}
-
-void line6_free_capture_buffer(struct snd_line6_pcm *line6pcm)
-{
-	kfree(line6pcm->buffer_in);
-	line6pcm->buffer_in = NULL;
-}
-
-/*
- * Callback for completed capture URB.
- */
-static void audio_in_callback(struct urb *urb)
-{
-	int i, index, length = 0, shutdown = 0;
-	unsigned long flags;
-
-	struct snd_line6_pcm *line6pcm = (struct snd_line6_pcm *)urb->context;
-
-	line6pcm->last_frame_in = urb->start_frame;
-
-	/* find index of URB */
-	for (index = 0; index < LINE6_ISO_BUFFERS; ++index)
-		if (urb == line6pcm->urb_audio_in[index])
-			break;
-
-#ifdef CONFIG_LINE6_USB_DUMP_PCM
-	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fout =
-		    &urb->iso_frame_desc[i];
-		line6_write_hexdump(line6pcm->line6, 'C',
-				    urb->transfer_buffer + fout->offset,
-				    fout->length);
-	}
-#endif
-
-	spin_lock_irqsave(&line6pcm->lock_audio_in, flags);
-
-	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		char *fbuf;
-		int fsize;
-		struct usb_iso_packet_descriptor *fin = &urb->iso_frame_desc[i];
-
-		if (fin->status == -EXDEV) {
-			shutdown = 1;
-			break;
-		}
-
-		fbuf = urb->transfer_buffer + fin->offset;
-		fsize = fin->actual_length;
-
-		if (fsize > line6pcm->max_packet_size) {
-			dev_err(line6pcm->line6->ifcdev,
-				"driver and/or device bug: packet too large (%d > %d)\n",
-				fsize, line6pcm->max_packet_size);
-		}
-
-		length += fsize;
-
-		/* the following assumes LINE6_ISO_PACKETS == 1: */
-		line6pcm->prev_fbuf = fbuf;
-		line6pcm->prev_fsize = fsize;
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
-#endif
-			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm->flags)
-			    && (fsize > 0))
-				line6_capture_copy(line6pcm, fbuf, fsize);
-	}
-
-	clear_bit(index, &line6pcm->active_urb_in);
-
-	if (test_and_clear_bit(index, &line6pcm->unlink_urb_in))
-		shutdown = 1;
-
-	spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
-
-	if (!shutdown) {
-		submit_audio_in_urb(line6pcm);
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
-#endif
-			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm->flags))
-				line6_capture_check_period(line6pcm, length);
-	}
-}
-
-/* open capture callback */
-static int snd_line6_capture_open(struct snd_pcm_substream *substream)
-{
-	int err;
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-
-	err = snd_pcm_hw_constraint_ratdens(runtime, 0,
-					    SNDRV_PCM_HW_PARAM_RATE,
-					    (&line6pcm->
-					     properties->snd_line6_rates));
-	if (err < 0)
-		return err;
-
-	runtime->hw = line6pcm->properties->snd_line6_capture_hw;
-	return 0;
-}
-
-/* close capture callback */
-static int snd_line6_capture_close(struct snd_pcm_substream *substream)
-{
-	return 0;
-}
-
-/* hw_params capture callback */
-static int snd_line6_capture_hw_params(struct snd_pcm_substream *substream,
-				       struct snd_pcm_hw_params *hw_params)
-{
-	int ret;
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-
-	/* -- Florian Demski [FD] */
-	/* don't ask me why, but this fixes the bug on my machine */
-	if (line6pcm == NULL) {
-		if (substream->pcm == NULL)
-			return -ENOMEM;
-		if (substream->pcm->private_data == NULL)
-			return -ENOMEM;
-		substream->private_data = substream->pcm->private_data;
-		line6pcm = snd_pcm_substream_chip(substream);
-	}
-	/* -- [FD] end */
-
-	ret = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER);
-
-	if (ret < 0)
-		return ret;
-
-	ret = snd_pcm_lib_malloc_pages(substream,
-				       params_buffer_bytes(hw_params));
-	if (ret < 0) {
-		line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER);
-		return ret;
-	}
-
-	line6pcm->period_in = params_period_bytes(hw_params);
-	return 0;
-}
-
-/* hw_free capture callback */
-static int snd_line6_capture_hw_free(struct snd_pcm_substream *substream)
-{
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-	line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER);
-	return snd_pcm_lib_free_pages(substream);
-}
-
-/* trigger callback */
-int snd_line6_capture_trigger(struct snd_line6_pcm *line6pcm, int cmd)
-{
-	int err;
-
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-#ifdef CONFIG_PM
-	case SNDRV_PCM_TRIGGER_RESUME:
-#endif
-		err = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
-
-		if (err < 0)
-			return err;
-
-		break;
-
-	case SNDRV_PCM_TRIGGER_STOP:
-#ifdef CONFIG_PM
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-#endif
-		err = line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
-
-		if (err < 0)
-			return err;
-
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/* capture pointer callback */
-static snd_pcm_uframes_t
-snd_line6_capture_pointer(struct snd_pcm_substream *substream)
-{
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-	return line6pcm->pos_in_done;
-}
-
-/* capture operators */
-struct snd_pcm_ops snd_line6_capture_ops = {
-	.open = snd_line6_capture_open,
-	.close = snd_line6_capture_close,
-	.ioctl = snd_pcm_lib_ioctl,
-	.hw_params = snd_line6_capture_hw_params,
-	.hw_free = snd_line6_capture_hw_free,
-	.prepare = snd_line6_prepare,
-	.trigger = snd_line6_trigger,
-	.pointer = snd_line6_capture_pointer,
-};
-
-int line6_create_audio_in_urbs(struct snd_line6_pcm *line6pcm)
-{
-	int i;
-
-	/* create audio URBs and fill in constant values: */
-	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
-		struct urb *urb;
-
-		/* URB for audio in: */
-		urb = line6pcm->urb_audio_in[i] =
-		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
-
-		if (urb == NULL) {
-			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
-			return -ENOMEM;
-		}
-
-		urb->dev = line6pcm->line6->usbdev;
-		urb->pipe =
-		    usb_rcvisocpipe(line6pcm->line6->usbdev,
-				    line6pcm->ep_audio_read &
-				    USB_ENDPOINT_NUMBER_MASK);
-		urb->transfer_flags = URB_ISO_ASAP;
-		urb->start_frame = -1;
-		urb->number_of_packets = LINE6_ISO_PACKETS;
-		urb->interval = LINE6_ISO_INTERVAL;
-		urb->error_count = 0;
-		urb->complete = audio_in_callback;
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/line6/capture.h b/drivers/staging/line6/capture.h
deleted file mode 100644
index 4157bcb..0000000
--- a/drivers/staging/line6/capture.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef CAPTURE_H
-#define CAPTURE_H
-
-#include <sound/pcm.h>
-
-#include "driver.h"
-#include "pcm.h"
-
-extern struct snd_pcm_ops snd_line6_capture_ops;
-
-extern void line6_capture_copy(struct snd_line6_pcm *line6pcm, char *fbuf,
-			       int fsize);
-extern void line6_capture_check_period(struct snd_line6_pcm *line6pcm,
-				       int length);
-extern int line6_create_audio_in_urbs(struct snd_line6_pcm *line6pcm);
-extern void line6_free_capture_buffer(struct snd_line6_pcm *line6pcm);
-extern int line6_submit_audio_in_all_urbs(struct snd_line6_pcm *line6pcm);
-extern void line6_unlink_audio_in_urbs(struct snd_line6_pcm *line6pcm);
-extern void line6_unlink_wait_clear_audio_in_urbs(struct snd_line6_pcm
-						  *line6pcm);
-extern void line6_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm);
-extern int snd_line6_capture_trigger(struct snd_line6_pcm *line6pcm, int cmd);
-
-#endif
diff --git a/drivers/staging/line6/control.c b/drivers/staging/line6/control.c
deleted file mode 100644
index f8326f5..0000000
--- a/drivers/staging/line6/control.c
+++ /dev/null
@@ -1,995 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/usb.h>
-
-#include "control.h"
-#include "driver.h"
-#include "pod.h"
-#include "usbdefs.h"
-#include "variax.h"
-
-#define DEVICE_ATTR2(_name1, _name2, _mode, _show, _store) \
-struct device_attribute dev_attr_##_name1 = __ATTR(_name2, _mode, _show, _store)
-
-#define LINE6_PARAM_R(PREFIX, prefix, type, param) \
-static ssize_t prefix##_get_##param(struct device *dev, \
-			struct device_attribute *attr, char *buf) \
-{ \
-	return prefix##_get_param_##type(dev, buf, PREFIX##_##param); \
-}
-
-#define LINE6_PARAM_RW(PREFIX, prefix, type, param) \
-LINE6_PARAM_R(PREFIX, prefix, type, param); \
-static ssize_t prefix##_set_##param(struct device *dev, \
-		struct device_attribute *attr, const char *buf, size_t count) \
-{ \
-	return prefix##_set_param_##type(dev, buf, count, PREFIX##_##param); \
-}
-
-#define POD_PARAM_R(type, param) LINE6_PARAM_R(POD, pod, type, param)
-#define POD_PARAM_RW(type, param) LINE6_PARAM_RW(POD, pod, type, param)
-#define VARIAX_PARAM_R(type, param) LINE6_PARAM_R(VARIAX, variax, type, param)
-#define VARIAX_PARAM_RW(type, param) LINE6_PARAM_RW(VARIAX, variax, type, param)
-
-static ssize_t pod_get_param_int(struct device *dev, char *buf, int param)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
-	if (retval < 0)
-		return retval;
-	return sprintf(buf, "%d\n", pod->prog_data.control[param]);
-}
-
-static ssize_t pod_set_param_int(struct device *dev, const char *buf,
-				 size_t count, int param)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	u8 value;
-	int retval;
-
-	retval = kstrtou8(buf, 10, &value);
-	if (retval)
-		return retval;
-
-	line6_pod_transmit_parameter(pod, param, value);
-	return count;
-}
-
-static ssize_t variax_get_param_int(struct device *dev, char *buf, int param)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_variax *variax = usb_get_intfdata(interface);
-	int retval = line6_dump_wait_interruptible(&variax->dumpreq);
-	if (retval < 0)
-		return retval;
-	return sprintf(buf, "%d\n", variax->model_data.control[param]);
-}
-
-static ssize_t variax_get_param_float(struct device *dev, char *buf, int param)
-{
-	/*
-	   We do our own floating point handling here since at the time
-	   this code was written (Jan 2006) it was highly discouraged to
-	   use floating point arithmetic in the kernel. If you think that
-	   this no longer applies, feel free to replace this by generic
-	   floating point code.
-	 */
-
-	static const int BIAS = 0x7f;
-	static const int OFFSET = 0xf;
-	static const int PRECISION = 1000;
-
-	int len = 0;
-	unsigned part_int, part_frac;
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_variax *variax = usb_get_intfdata(interface);
-	const unsigned char *p = variax->model_data.control + param;
-	int retval = line6_dump_wait_interruptible(&variax->dumpreq);
-	if (retval < 0)
-		return retval;
-
-	if ((p[0] == 0) && (p[1] == 0) && (p[2] == 0))
-		part_int = part_frac = 0;
-	else {
-		int exponent = (((p[0] & 0x7f) << 1) | (p[1] >> 7)) - BIAS;
-		unsigned mantissa = (p[1] << 8) | p[2] | 0x8000;
-		exponent -= OFFSET;
-
-		if (exponent >= 0) {
-			part_int = mantissa << exponent;
-			part_frac = 0;
-		} else {
-			part_int = mantissa >> -exponent;
-			part_frac = (mantissa << (32 + exponent)) & 0xffffffff;
-		}
-
-		part_frac =
-		    (part_frac / ((1UL << 31) / (PRECISION / 2 * 10)) + 5) / 10;
-	}
-
-	len +=
-	    sprintf(buf + len, "%s%d.%03d\n", ((p[0] & 0x80) ? "-" : ""),
-		    part_int, part_frac);
-	return len;
-}
-
-POD_PARAM_RW(int, tweak);
-POD_PARAM_RW(int, wah_position);
-POD_PARAM_RW(int, compression_gain);
-POD_PARAM_RW(int, vol_pedal_position);
-POD_PARAM_RW(int, compression_threshold);
-POD_PARAM_RW(int, pan);
-POD_PARAM_RW(int, amp_model_setup);
-POD_PARAM_RW(int, amp_model);
-POD_PARAM_RW(int, drive);
-POD_PARAM_RW(int, bass);
-POD_PARAM_RW(int, mid);
-POD_PARAM_RW(int, lowmid);
-POD_PARAM_RW(int, treble);
-POD_PARAM_RW(int, highmid);
-POD_PARAM_RW(int, chan_vol);
-POD_PARAM_RW(int, reverb_mix);
-POD_PARAM_RW(int, effect_setup);
-POD_PARAM_RW(int, band_1_frequency);
-POD_PARAM_RW(int, presence);
-POD_PARAM_RW(int, treble__bass);
-POD_PARAM_RW(int, noise_gate_enable);
-POD_PARAM_RW(int, gate_threshold);
-POD_PARAM_RW(int, gate_decay_time);
-POD_PARAM_RW(int, stomp_enable);
-POD_PARAM_RW(int, comp_enable);
-POD_PARAM_RW(int, stomp_time);
-POD_PARAM_RW(int, delay_enable);
-POD_PARAM_RW(int, mod_param_1);
-POD_PARAM_RW(int, delay_param_1);
-POD_PARAM_RW(int, delay_param_1_note_value);
-POD_PARAM_RW(int, band_2_frequency__bass);
-POD_PARAM_RW(int, delay_param_2);
-POD_PARAM_RW(int, delay_volume_mix);
-POD_PARAM_RW(int, delay_param_3);
-POD_PARAM_RW(int, reverb_enable);
-POD_PARAM_RW(int, reverb_type);
-POD_PARAM_RW(int, reverb_decay);
-POD_PARAM_RW(int, reverb_tone);
-POD_PARAM_RW(int, reverb_pre_delay);
-POD_PARAM_RW(int, reverb_pre_post);
-POD_PARAM_RW(int, band_2_frequency);
-POD_PARAM_RW(int, band_3_frequency__bass);
-POD_PARAM_RW(int, wah_enable);
-POD_PARAM_RW(int, modulation_lo_cut);
-POD_PARAM_RW(int, delay_reverb_lo_cut);
-POD_PARAM_RW(int, volume_pedal_minimum);
-POD_PARAM_RW(int, eq_pre_post);
-POD_PARAM_RW(int, volume_pre_post);
-POD_PARAM_RW(int, di_model);
-POD_PARAM_RW(int, di_delay);
-POD_PARAM_RW(int, mod_enable);
-POD_PARAM_RW(int, mod_param_1_note_value);
-POD_PARAM_RW(int, mod_param_2);
-POD_PARAM_RW(int, mod_param_3);
-POD_PARAM_RW(int, mod_param_4);
-POD_PARAM_RW(int, mod_param_5);
-POD_PARAM_RW(int, mod_volume_mix);
-POD_PARAM_RW(int, mod_pre_post);
-POD_PARAM_RW(int, modulation_model);
-POD_PARAM_RW(int, band_3_frequency);
-POD_PARAM_RW(int, band_4_frequency__bass);
-POD_PARAM_RW(int, mod_param_1_double_precision);
-POD_PARAM_RW(int, delay_param_1_double_precision);
-POD_PARAM_RW(int, eq_enable);
-POD_PARAM_RW(int, tap);
-POD_PARAM_RW(int, volume_tweak_pedal_assign);
-POD_PARAM_RW(int, band_5_frequency);
-POD_PARAM_RW(int, tuner);
-POD_PARAM_RW(int, mic_selection);
-POD_PARAM_RW(int, cabinet_model);
-POD_PARAM_RW(int, stomp_model);
-POD_PARAM_RW(int, roomlevel);
-POD_PARAM_RW(int, band_4_frequency);
-POD_PARAM_RW(int, band_6_frequency);
-POD_PARAM_RW(int, stomp_param_1_note_value);
-POD_PARAM_RW(int, stomp_param_2);
-POD_PARAM_RW(int, stomp_param_3);
-POD_PARAM_RW(int, stomp_param_4);
-POD_PARAM_RW(int, stomp_param_5);
-POD_PARAM_RW(int, stomp_param_6);
-POD_PARAM_RW(int, amp_switch_select);
-POD_PARAM_RW(int, delay_param_4);
-POD_PARAM_RW(int, delay_param_5);
-POD_PARAM_RW(int, delay_pre_post);
-POD_PARAM_RW(int, delay_model);
-POD_PARAM_RW(int, delay_verb_model);
-POD_PARAM_RW(int, tempo_msb);
-POD_PARAM_RW(int, tempo_lsb);
-POD_PARAM_RW(int, wah_model);
-POD_PARAM_RW(int, bypass_volume);
-POD_PARAM_RW(int, fx_loop_on_off);
-POD_PARAM_RW(int, tweak_param_select);
-POD_PARAM_RW(int, amp1_engage);
-POD_PARAM_RW(int, band_1_gain);
-POD_PARAM_RW(int, band_2_gain__bass);
-POD_PARAM_RW(int, band_2_gain);
-POD_PARAM_RW(int, band_3_gain__bass);
-POD_PARAM_RW(int, band_3_gain);
-POD_PARAM_RW(int, band_4_gain__bass);
-POD_PARAM_RW(int, band_5_gain__bass);
-POD_PARAM_RW(int, band_4_gain);
-POD_PARAM_RW(int, band_6_gain__bass);
-VARIAX_PARAM_R(int, body);
-VARIAX_PARAM_R(int, pickup1_enable);
-VARIAX_PARAM_R(int, pickup1_type);
-VARIAX_PARAM_R(float, pickup1_position);
-VARIAX_PARAM_R(float, pickup1_angle);
-VARIAX_PARAM_R(float, pickup1_level);
-VARIAX_PARAM_R(int, pickup2_enable);
-VARIAX_PARAM_R(int, pickup2_type);
-VARIAX_PARAM_R(float, pickup2_position);
-VARIAX_PARAM_R(float, pickup2_angle);
-VARIAX_PARAM_R(float, pickup2_level);
-VARIAX_PARAM_R(int, pickup_phase);
-VARIAX_PARAM_R(float, capacitance);
-VARIAX_PARAM_R(float, tone_resistance);
-VARIAX_PARAM_R(float, volume_resistance);
-VARIAX_PARAM_R(int, taper);
-VARIAX_PARAM_R(float, tone_dump);
-VARIAX_PARAM_R(int, save_tone);
-VARIAX_PARAM_R(float, volume_dump);
-VARIAX_PARAM_R(int, tuning_enable);
-VARIAX_PARAM_R(int, tuning6);
-VARIAX_PARAM_R(int, tuning5);
-VARIAX_PARAM_R(int, tuning4);
-VARIAX_PARAM_R(int, tuning3);
-VARIAX_PARAM_R(int, tuning2);
-VARIAX_PARAM_R(int, tuning1);
-VARIAX_PARAM_R(float, detune6);
-VARIAX_PARAM_R(float, detune5);
-VARIAX_PARAM_R(float, detune4);
-VARIAX_PARAM_R(float, detune3);
-VARIAX_PARAM_R(float, detune2);
-VARIAX_PARAM_R(float, detune1);
-VARIAX_PARAM_R(float, mix6);
-VARIAX_PARAM_R(float, mix5);
-VARIAX_PARAM_R(float, mix4);
-VARIAX_PARAM_R(float, mix3);
-VARIAX_PARAM_R(float, mix2);
-VARIAX_PARAM_R(float, mix1);
-VARIAX_PARAM_R(int, pickup_wiring);
-
-static DEVICE_ATTR(tweak, S_IWUSR | S_IRUGO, pod_get_tweak, pod_set_tweak);
-static DEVICE_ATTR(wah_position, S_IWUSR | S_IRUGO, pod_get_wah_position,
-		   pod_set_wah_position);
-static DEVICE_ATTR(compression_gain, S_IWUSR | S_IRUGO,
-		   pod_get_compression_gain, pod_set_compression_gain);
-static DEVICE_ATTR(vol_pedal_position, S_IWUSR | S_IRUGO,
-		   pod_get_vol_pedal_position, pod_set_vol_pedal_position);
-static DEVICE_ATTR(compression_threshold, S_IWUSR | S_IRUGO,
-		   pod_get_compression_threshold,
-		   pod_set_compression_threshold);
-static DEVICE_ATTR(pan, S_IWUSR | S_IRUGO, pod_get_pan, pod_set_pan);
-static DEVICE_ATTR(amp_model_setup, S_IWUSR | S_IRUGO, pod_get_amp_model_setup,
-		   pod_set_amp_model_setup);
-static DEVICE_ATTR(amp_model, S_IWUSR | S_IRUGO, pod_get_amp_model,
-		   pod_set_amp_model);
-static DEVICE_ATTR(drive, S_IWUSR | S_IRUGO, pod_get_drive, pod_set_drive);
-static DEVICE_ATTR(bass, S_IWUSR | S_IRUGO, pod_get_bass, pod_set_bass);
-static DEVICE_ATTR(mid, S_IWUSR | S_IRUGO, pod_get_mid, pod_set_mid);
-static DEVICE_ATTR(lowmid, S_IWUSR | S_IRUGO, pod_get_lowmid, pod_set_lowmid);
-static DEVICE_ATTR(treble, S_IWUSR | S_IRUGO, pod_get_treble, pod_set_treble);
-static DEVICE_ATTR(highmid, S_IWUSR | S_IRUGO, pod_get_highmid,
-		   pod_set_highmid);
-static DEVICE_ATTR(chan_vol, S_IWUSR | S_IRUGO, pod_get_chan_vol,
-		   pod_set_chan_vol);
-static DEVICE_ATTR(reverb_mix, S_IWUSR | S_IRUGO, pod_get_reverb_mix,
-		   pod_set_reverb_mix);
-static DEVICE_ATTR(effect_setup, S_IWUSR | S_IRUGO, pod_get_effect_setup,
-		   pod_set_effect_setup);
-static DEVICE_ATTR(band_1_frequency, S_IWUSR | S_IRUGO,
-		   pod_get_band_1_frequency, pod_set_band_1_frequency);
-static DEVICE_ATTR(presence, S_IWUSR | S_IRUGO, pod_get_presence,
-		   pod_set_presence);
-static DEVICE_ATTR2(treble__bass, treble, S_IWUSR | S_IRUGO,
-		    pod_get_treble__bass, pod_set_treble__bass);
-static DEVICE_ATTR(noise_gate_enable, S_IWUSR | S_IRUGO,
-		   pod_get_noise_gate_enable, pod_set_noise_gate_enable);
-static DEVICE_ATTR(gate_threshold, S_IWUSR | S_IRUGO, pod_get_gate_threshold,
-		   pod_set_gate_threshold);
-static DEVICE_ATTR(gate_decay_time, S_IWUSR | S_IRUGO, pod_get_gate_decay_time,
-		   pod_set_gate_decay_time);
-static DEVICE_ATTR(stomp_enable, S_IWUSR | S_IRUGO, pod_get_stomp_enable,
-		   pod_set_stomp_enable);
-static DEVICE_ATTR(comp_enable, S_IWUSR | S_IRUGO, pod_get_comp_enable,
-		   pod_set_comp_enable);
-static DEVICE_ATTR(stomp_time, S_IWUSR | S_IRUGO, pod_get_stomp_time,
-		   pod_set_stomp_time);
-static DEVICE_ATTR(delay_enable, S_IWUSR | S_IRUGO, pod_get_delay_enable,
-		   pod_set_delay_enable);
-static DEVICE_ATTR(mod_param_1, S_IWUSR | S_IRUGO, pod_get_mod_param_1,
-		   pod_set_mod_param_1);
-static DEVICE_ATTR(delay_param_1, S_IWUSR | S_IRUGO, pod_get_delay_param_1,
-		   pod_set_delay_param_1);
-static DEVICE_ATTR(delay_param_1_note_value, S_IWUSR | S_IRUGO,
-		   pod_get_delay_param_1_note_value,
-		   pod_set_delay_param_1_note_value);
-static DEVICE_ATTR2(band_2_frequency__bass, band_2_frequency, S_IWUSR | S_IRUGO,
-		    pod_get_band_2_frequency__bass,
-		    pod_set_band_2_frequency__bass);
-static DEVICE_ATTR(delay_param_2, S_IWUSR | S_IRUGO, pod_get_delay_param_2,
-		   pod_set_delay_param_2);
-static DEVICE_ATTR(delay_volume_mix, S_IWUSR | S_IRUGO,
-		   pod_get_delay_volume_mix, pod_set_delay_volume_mix);
-static DEVICE_ATTR(delay_param_3, S_IWUSR | S_IRUGO, pod_get_delay_param_3,
-		   pod_set_delay_param_3);
-static DEVICE_ATTR(reverb_enable, S_IWUSR | S_IRUGO, pod_get_reverb_enable,
-		   pod_set_reverb_enable);
-static DEVICE_ATTR(reverb_type, S_IWUSR | S_IRUGO, pod_get_reverb_type,
-		   pod_set_reverb_type);
-static DEVICE_ATTR(reverb_decay, S_IWUSR | S_IRUGO, pod_get_reverb_decay,
-		   pod_set_reverb_decay);
-static DEVICE_ATTR(reverb_tone, S_IWUSR | S_IRUGO, pod_get_reverb_tone,
-		   pod_set_reverb_tone);
-static DEVICE_ATTR(reverb_pre_delay, S_IWUSR | S_IRUGO,
-		   pod_get_reverb_pre_delay, pod_set_reverb_pre_delay);
-static DEVICE_ATTR(reverb_pre_post, S_IWUSR | S_IRUGO, pod_get_reverb_pre_post,
-		   pod_set_reverb_pre_post);
-static DEVICE_ATTR(band_2_frequency, S_IWUSR | S_IRUGO,
-		   pod_get_band_2_frequency, pod_set_band_2_frequency);
-static DEVICE_ATTR2(band_3_frequency__bass, band_3_frequency, S_IWUSR | S_IRUGO,
-		    pod_get_band_3_frequency__bass,
-		    pod_set_band_3_frequency__bass);
-static DEVICE_ATTR(wah_enable, S_IWUSR | S_IRUGO, pod_get_wah_enable,
-		   pod_set_wah_enable);
-static DEVICE_ATTR(modulation_lo_cut, S_IWUSR | S_IRUGO,
-		   pod_get_modulation_lo_cut, pod_set_modulation_lo_cut);
-static DEVICE_ATTR(delay_reverb_lo_cut, S_IWUSR | S_IRUGO,
-		   pod_get_delay_reverb_lo_cut, pod_set_delay_reverb_lo_cut);
-static DEVICE_ATTR(volume_pedal_minimum, S_IWUSR | S_IRUGO,
-		   pod_get_volume_pedal_minimum, pod_set_volume_pedal_minimum);
-static DEVICE_ATTR(eq_pre_post, S_IWUSR | S_IRUGO, pod_get_eq_pre_post,
-		   pod_set_eq_pre_post);
-static DEVICE_ATTR(volume_pre_post, S_IWUSR | S_IRUGO, pod_get_volume_pre_post,
-		   pod_set_volume_pre_post);
-static DEVICE_ATTR(di_model, S_IWUSR | S_IRUGO, pod_get_di_model,
-		   pod_set_di_model);
-static DEVICE_ATTR(di_delay, S_IWUSR | S_IRUGO, pod_get_di_delay,
-		   pod_set_di_delay);
-static DEVICE_ATTR(mod_enable, S_IWUSR | S_IRUGO, pod_get_mod_enable,
-		   pod_set_mod_enable);
-static DEVICE_ATTR(mod_param_1_note_value, S_IWUSR | S_IRUGO,
-		   pod_get_mod_param_1_note_value,
-		   pod_set_mod_param_1_note_value);
-static DEVICE_ATTR(mod_param_2, S_IWUSR | S_IRUGO, pod_get_mod_param_2,
-		   pod_set_mod_param_2);
-static DEVICE_ATTR(mod_param_3, S_IWUSR | S_IRUGO, pod_get_mod_param_3,
-		   pod_set_mod_param_3);
-static DEVICE_ATTR(mod_param_4, S_IWUSR | S_IRUGO, pod_get_mod_param_4,
-		   pod_set_mod_param_4);
-static DEVICE_ATTR(mod_param_5, S_IWUSR | S_IRUGO, pod_get_mod_param_5,
-		   pod_set_mod_param_5);
-static DEVICE_ATTR(mod_volume_mix, S_IWUSR | S_IRUGO, pod_get_mod_volume_mix,
-		   pod_set_mod_volume_mix);
-static DEVICE_ATTR(mod_pre_post, S_IWUSR | S_IRUGO, pod_get_mod_pre_post,
-		   pod_set_mod_pre_post);
-static DEVICE_ATTR(modulation_model, S_IWUSR | S_IRUGO,
-		   pod_get_modulation_model, pod_set_modulation_model);
-static DEVICE_ATTR(band_3_frequency, S_IWUSR | S_IRUGO,
-		   pod_get_band_3_frequency, pod_set_band_3_frequency);
-static DEVICE_ATTR2(band_4_frequency__bass, band_4_frequency, S_IWUSR | S_IRUGO,
-		    pod_get_band_4_frequency__bass,
-		    pod_set_band_4_frequency__bass);
-static DEVICE_ATTR(mod_param_1_double_precision, S_IWUSR | S_IRUGO,
-		   pod_get_mod_param_1_double_precision,
-		   pod_set_mod_param_1_double_precision);
-static DEVICE_ATTR(delay_param_1_double_precision, S_IWUSR | S_IRUGO,
-		   pod_get_delay_param_1_double_precision,
-		   pod_set_delay_param_1_double_precision);
-static DEVICE_ATTR(eq_enable, S_IWUSR | S_IRUGO, pod_get_eq_enable,
-		   pod_set_eq_enable);
-static DEVICE_ATTR(tap, S_IWUSR | S_IRUGO, pod_get_tap, pod_set_tap);
-static DEVICE_ATTR(volume_tweak_pedal_assign, S_IWUSR | S_IRUGO,
-		   pod_get_volume_tweak_pedal_assign,
-		   pod_set_volume_tweak_pedal_assign);
-static DEVICE_ATTR(band_5_frequency, S_IWUSR | S_IRUGO,
-		   pod_get_band_5_frequency, pod_set_band_5_frequency);
-static DEVICE_ATTR(tuner, S_IWUSR | S_IRUGO, pod_get_tuner, pod_set_tuner);
-static DEVICE_ATTR(mic_selection, S_IWUSR | S_IRUGO, pod_get_mic_selection,
-		   pod_set_mic_selection);
-static DEVICE_ATTR(cabinet_model, S_IWUSR | S_IRUGO, pod_get_cabinet_model,
-		   pod_set_cabinet_model);
-static DEVICE_ATTR(stomp_model, S_IWUSR | S_IRUGO, pod_get_stomp_model,
-		   pod_set_stomp_model);
-static DEVICE_ATTR(roomlevel, S_IWUSR | S_IRUGO, pod_get_roomlevel,
-		   pod_set_roomlevel);
-static DEVICE_ATTR(band_4_frequency, S_IWUSR | S_IRUGO,
-		   pod_get_band_4_frequency, pod_set_band_4_frequency);
-static DEVICE_ATTR(band_6_frequency, S_IWUSR | S_IRUGO,
-		   pod_get_band_6_frequency, pod_set_band_6_frequency);
-static DEVICE_ATTR(stomp_param_1_note_value, S_IWUSR | S_IRUGO,
-		   pod_get_stomp_param_1_note_value,
-		   pod_set_stomp_param_1_note_value);
-static DEVICE_ATTR(stomp_param_2, S_IWUSR | S_IRUGO, pod_get_stomp_param_2,
-		   pod_set_stomp_param_2);
-static DEVICE_ATTR(stomp_param_3, S_IWUSR | S_IRUGO, pod_get_stomp_param_3,
-		   pod_set_stomp_param_3);
-static DEVICE_ATTR(stomp_param_4, S_IWUSR | S_IRUGO, pod_get_stomp_param_4,
-		   pod_set_stomp_param_4);
-static DEVICE_ATTR(stomp_param_5, S_IWUSR | S_IRUGO, pod_get_stomp_param_5,
-		   pod_set_stomp_param_5);
-static DEVICE_ATTR(stomp_param_6, S_IWUSR | S_IRUGO, pod_get_stomp_param_6,
-		   pod_set_stomp_param_6);
-static DEVICE_ATTR(amp_switch_select, S_IWUSR | S_IRUGO,
-		   pod_get_amp_switch_select, pod_set_amp_switch_select);
-static DEVICE_ATTR(delay_param_4, S_IWUSR | S_IRUGO, pod_get_delay_param_4,
-		   pod_set_delay_param_4);
-static DEVICE_ATTR(delay_param_5, S_IWUSR | S_IRUGO, pod_get_delay_param_5,
-		   pod_set_delay_param_5);
-static DEVICE_ATTR(delay_pre_post, S_IWUSR | S_IRUGO, pod_get_delay_pre_post,
-		   pod_set_delay_pre_post);
-static DEVICE_ATTR(delay_model, S_IWUSR | S_IRUGO, pod_get_delay_model,
-		   pod_set_delay_model);
-static DEVICE_ATTR(delay_verb_model, S_IWUSR | S_IRUGO,
-		   pod_get_delay_verb_model, pod_set_delay_verb_model);
-static DEVICE_ATTR(tempo_msb, S_IWUSR | S_IRUGO, pod_get_tempo_msb,
-		   pod_set_tempo_msb);
-static DEVICE_ATTR(tempo_lsb, S_IWUSR | S_IRUGO, pod_get_tempo_lsb,
-		   pod_set_tempo_lsb);
-static DEVICE_ATTR(wah_model, S_IWUSR | S_IRUGO, pod_get_wah_model,
-		   pod_set_wah_model);
-static DEVICE_ATTR(bypass_volume, S_IWUSR | S_IRUGO, pod_get_bypass_volume,
-		   pod_set_bypass_volume);
-static DEVICE_ATTR(fx_loop_on_off, S_IWUSR | S_IRUGO, pod_get_fx_loop_on_off,
-		   pod_set_fx_loop_on_off);
-static DEVICE_ATTR(tweak_param_select, S_IWUSR | S_IRUGO,
-		   pod_get_tweak_param_select, pod_set_tweak_param_select);
-static DEVICE_ATTR(amp1_engage, S_IWUSR | S_IRUGO, pod_get_amp1_engage,
-		   pod_set_amp1_engage);
-static DEVICE_ATTR(band_1_gain, S_IWUSR | S_IRUGO, pod_get_band_1_gain,
-		   pod_set_band_1_gain);
-static DEVICE_ATTR2(band_2_gain__bass, band_2_gain, S_IWUSR | S_IRUGO,
-		    pod_get_band_2_gain__bass, pod_set_band_2_gain__bass);
-static DEVICE_ATTR(band_2_gain, S_IWUSR | S_IRUGO, pod_get_band_2_gain,
-		   pod_set_band_2_gain);
-static DEVICE_ATTR2(band_3_gain__bass, band_3_gain, S_IWUSR | S_IRUGO,
-		    pod_get_band_3_gain__bass, pod_set_band_3_gain__bass);
-static DEVICE_ATTR(band_3_gain, S_IWUSR | S_IRUGO, pod_get_band_3_gain,
-		   pod_set_band_3_gain);
-static DEVICE_ATTR2(band_4_gain__bass, band_4_gain, S_IWUSR | S_IRUGO,
-		    pod_get_band_4_gain__bass, pod_set_band_4_gain__bass);
-static DEVICE_ATTR2(band_5_gain__bass, band_5_gain, S_IWUSR | S_IRUGO,
-		    pod_get_band_5_gain__bass, pod_set_band_5_gain__bass);
-static DEVICE_ATTR(band_4_gain, S_IWUSR | S_IRUGO, pod_get_band_4_gain,
-		   pod_set_band_4_gain);
-static DEVICE_ATTR2(band_6_gain__bass, band_6_gain, S_IWUSR | S_IRUGO,
-		    pod_get_band_6_gain__bass, pod_set_band_6_gain__bass);
-static DEVICE_ATTR(body, S_IRUGO, variax_get_body, line6_nop_write);
-static DEVICE_ATTR(pickup1_enable, S_IRUGO, variax_get_pickup1_enable,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup1_type, S_IRUGO, variax_get_pickup1_type,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup1_position, S_IRUGO, variax_get_pickup1_position,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup1_angle, S_IRUGO, variax_get_pickup1_angle,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup1_level, S_IRUGO, variax_get_pickup1_level,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup2_enable, S_IRUGO, variax_get_pickup2_enable,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup2_type, S_IRUGO, variax_get_pickup2_type,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup2_position, S_IRUGO, variax_get_pickup2_position,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup2_angle, S_IRUGO, variax_get_pickup2_angle,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup2_level, S_IRUGO, variax_get_pickup2_level,
-		   line6_nop_write);
-static DEVICE_ATTR(pickup_phase, S_IRUGO, variax_get_pickup_phase,
-		   line6_nop_write);
-static DEVICE_ATTR(capacitance, S_IRUGO, variax_get_capacitance,
-		   line6_nop_write);
-static DEVICE_ATTR(tone_resistance, S_IRUGO, variax_get_tone_resistance,
-		   line6_nop_write);
-static DEVICE_ATTR(volume_resistance, S_IRUGO, variax_get_volume_resistance,
-		   line6_nop_write);
-static DEVICE_ATTR(taper, S_IRUGO, variax_get_taper, line6_nop_write);
-static DEVICE_ATTR(tone_dump, S_IRUGO, variax_get_tone_dump, line6_nop_write);
-static DEVICE_ATTR(save_tone, S_IRUGO, variax_get_save_tone, line6_nop_write);
-static DEVICE_ATTR(volume_dump, S_IRUGO, variax_get_volume_dump,
-		   line6_nop_write);
-static DEVICE_ATTR(tuning_enable, S_IRUGO, variax_get_tuning_enable,
-		   line6_nop_write);
-static DEVICE_ATTR(tuning6, S_IRUGO, variax_get_tuning6, line6_nop_write);
-static DEVICE_ATTR(tuning5, S_IRUGO, variax_get_tuning5, line6_nop_write);
-static DEVICE_ATTR(tuning4, S_IRUGO, variax_get_tuning4, line6_nop_write);
-static DEVICE_ATTR(tuning3, S_IRUGO, variax_get_tuning3, line6_nop_write);
-static DEVICE_ATTR(tuning2, S_IRUGO, variax_get_tuning2, line6_nop_write);
-static DEVICE_ATTR(tuning1, S_IRUGO, variax_get_tuning1, line6_nop_write);
-static DEVICE_ATTR(detune6, S_IRUGO, variax_get_detune6, line6_nop_write);
-static DEVICE_ATTR(detune5, S_IRUGO, variax_get_detune5, line6_nop_write);
-static DEVICE_ATTR(detune4, S_IRUGO, variax_get_detune4, line6_nop_write);
-static DEVICE_ATTR(detune3, S_IRUGO, variax_get_detune3, line6_nop_write);
-static DEVICE_ATTR(detune2, S_IRUGO, variax_get_detune2, line6_nop_write);
-static DEVICE_ATTR(detune1, S_IRUGO, variax_get_detune1, line6_nop_write);
-static DEVICE_ATTR(mix6, S_IRUGO, variax_get_mix6, line6_nop_write);
-static DEVICE_ATTR(mix5, S_IRUGO, variax_get_mix5, line6_nop_write);
-static DEVICE_ATTR(mix4, S_IRUGO, variax_get_mix4, line6_nop_write);
-static DEVICE_ATTR(mix3, S_IRUGO, variax_get_mix3, line6_nop_write);
-static DEVICE_ATTR(mix2, S_IRUGO, variax_get_mix2, line6_nop_write);
-static DEVICE_ATTR(mix1, S_IRUGO, variax_get_mix1, line6_nop_write);
-static DEVICE_ATTR(pickup_wiring, S_IRUGO, variax_get_pickup_wiring,
-		   line6_nop_write);
-
-int line6_pod_create_files(int firmware, int type, struct device *dev)
-{
-	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tweak));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_wah_position));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_compression_gain));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_vol_pedal_position));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_compression_threshold));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pan));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_amp_model_setup));
-	if (firmware >= 200)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_amp_model));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_drive));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_bass));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_mid));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_lowmid));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_treble));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_highmid));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_chan_vol));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_mix));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_effect_setup));
-	if (firmware >= 200)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_band_1_frequency));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_presence));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_treble__bass));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_noise_gate_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_gate_threshold));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_gate_decay_time));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_comp_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_time));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_1));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_1));
-	CHECK_RETURN(device_create_file
-		     (dev, &dev_attr_delay_param_1_note_value));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_2_frequency__bass));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_2));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_volume_mix));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_3));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_enable));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_type));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_decay));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_tone));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_reverb_pre_delay));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_reverb_pre_post));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_2_frequency));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_3_frequency__bass));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_wah_enable));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_modulation_lo_cut));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_delay_reverb_lo_cut));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_volume_pedal_minimum));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_eq_pre_post));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_volume_pre_post));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_di_model));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_di_delay));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_1_note_value));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_2));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_3));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_4));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_5));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_volume_mix));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_pre_post));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_modulation_model));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_3_frequency));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_4_frequency__bass));
-	CHECK_RETURN(device_create_file
-		     (dev, &dev_attr_mod_param_1_double_precision));
-	CHECK_RETURN(device_create_file
-		     (dev, &dev_attr_delay_param_1_double_precision));
-	if (firmware >= 200)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_eq_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tap));
-	CHECK_RETURN(device_create_file
-		     (dev, &dev_attr_volume_tweak_pedal_assign));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_5_frequency));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mic_selection));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_cabinet_model));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_model));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_roomlevel));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_4_frequency));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_6_frequency));
-	CHECK_RETURN(device_create_file
-		     (dev, &dev_attr_stomp_param_1_note_value));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_2));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_3));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_4));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_5));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_6));
-	if ((type & (LINE6_BITS_LIVE)) != 0)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_amp_switch_select));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_4));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_5));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_pre_post));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_delay_model));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		CHECK_RETURN(device_create_file
-			     (dev, &dev_attr_delay_verb_model));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tempo_msb));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tempo_lsb));
-	if (firmware >= 300)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_wah_model));
-	if (firmware >= 214)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_bypass_volume));
-	if ((type & (LINE6_BITS_PRO)) != 0)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_fx_loop_on_off));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tweak_param_select));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_amp1_engage));
-	if (firmware >= 200)
-		CHECK_RETURN(device_create_file(dev, &dev_attr_band_1_gain));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_2_gain__bass));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_2_gain));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_3_gain__bass));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_3_gain));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_4_gain__bass));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_5_gain__bass));
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_4_gain));
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			CHECK_RETURN(device_create_file
-				     (dev, &dev_attr_band_6_gain__bass));
-	return 0;
-}
-
-void line6_pod_remove_files(int firmware, int type, struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_tweak);
-	device_remove_file(dev, &dev_attr_wah_position);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_compression_gain);
-	device_remove_file(dev, &dev_attr_vol_pedal_position);
-	device_remove_file(dev, &dev_attr_compression_threshold);
-	device_remove_file(dev, &dev_attr_pan);
-	device_remove_file(dev, &dev_attr_amp_model_setup);
-	if (firmware >= 200)
-		device_remove_file(dev, &dev_attr_amp_model);
-	device_remove_file(dev, &dev_attr_drive);
-	device_remove_file(dev, &dev_attr_bass);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_mid);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_lowmid);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_treble);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_highmid);
-	device_remove_file(dev, &dev_attr_chan_vol);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_reverb_mix);
-	device_remove_file(dev, &dev_attr_effect_setup);
-	if (firmware >= 200)
-		device_remove_file(dev, &dev_attr_band_1_frequency);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_presence);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_treble__bass);
-	device_remove_file(dev, &dev_attr_noise_gate_enable);
-	device_remove_file(dev, &dev_attr_gate_threshold);
-	device_remove_file(dev, &dev_attr_gate_decay_time);
-	device_remove_file(dev, &dev_attr_stomp_enable);
-	device_remove_file(dev, &dev_attr_comp_enable);
-	device_remove_file(dev, &dev_attr_stomp_time);
-	device_remove_file(dev, &dev_attr_delay_enable);
-	device_remove_file(dev, &dev_attr_mod_param_1);
-	device_remove_file(dev, &dev_attr_delay_param_1);
-	device_remove_file(dev, &dev_attr_delay_param_1_note_value);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev,
-					   &dev_attr_band_2_frequency__bass);
-	device_remove_file(dev, &dev_attr_delay_param_2);
-	device_remove_file(dev, &dev_attr_delay_volume_mix);
-	device_remove_file(dev, &dev_attr_delay_param_3);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_reverb_enable);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_reverb_type);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_reverb_decay);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_reverb_tone);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_reverb_pre_delay);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_reverb_pre_post);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_2_frequency);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev,
-					   &dev_attr_band_3_frequency__bass);
-	device_remove_file(dev, &dev_attr_wah_enable);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_modulation_lo_cut);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_delay_reverb_lo_cut);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_volume_pedal_minimum);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_eq_pre_post);
-	device_remove_file(dev, &dev_attr_volume_pre_post);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_di_model);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_di_delay);
-	device_remove_file(dev, &dev_attr_mod_enable);
-	device_remove_file(dev, &dev_attr_mod_param_1_note_value);
-	device_remove_file(dev, &dev_attr_mod_param_2);
-	device_remove_file(dev, &dev_attr_mod_param_3);
-	device_remove_file(dev, &dev_attr_mod_param_4);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_mod_param_5);
-	device_remove_file(dev, &dev_attr_mod_volume_mix);
-	device_remove_file(dev, &dev_attr_mod_pre_post);
-	device_remove_file(dev, &dev_attr_modulation_model);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_3_frequency);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev,
-					   &dev_attr_band_4_frequency__bass);
-	device_remove_file(dev, &dev_attr_mod_param_1_double_precision);
-	device_remove_file(dev, &dev_attr_delay_param_1_double_precision);
-	if (firmware >= 200)
-		device_remove_file(dev, &dev_attr_eq_enable);
-	device_remove_file(dev, &dev_attr_tap);
-	device_remove_file(dev, &dev_attr_volume_tweak_pedal_assign);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_5_frequency);
-	device_remove_file(dev, &dev_attr_tuner);
-	device_remove_file(dev, &dev_attr_mic_selection);
-	device_remove_file(dev, &dev_attr_cabinet_model);
-	device_remove_file(dev, &dev_attr_stomp_model);
-	device_remove_file(dev, &dev_attr_roomlevel);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_4_frequency);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_6_frequency);
-	device_remove_file(dev, &dev_attr_stomp_param_1_note_value);
-	device_remove_file(dev, &dev_attr_stomp_param_2);
-	device_remove_file(dev, &dev_attr_stomp_param_3);
-	device_remove_file(dev, &dev_attr_stomp_param_4);
-	device_remove_file(dev, &dev_attr_stomp_param_5);
-	device_remove_file(dev, &dev_attr_stomp_param_6);
-	if ((type & (LINE6_BITS_LIVE)) != 0)
-		device_remove_file(dev, &dev_attr_amp_switch_select);
-	device_remove_file(dev, &dev_attr_delay_param_4);
-	device_remove_file(dev, &dev_attr_delay_param_5);
-	device_remove_file(dev, &dev_attr_delay_pre_post);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_delay_model);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		device_remove_file(dev, &dev_attr_delay_verb_model);
-	device_remove_file(dev, &dev_attr_tempo_msb);
-	device_remove_file(dev, &dev_attr_tempo_lsb);
-	if (firmware >= 300)
-		device_remove_file(dev, &dev_attr_wah_model);
-	if (firmware >= 214)
-		device_remove_file(dev, &dev_attr_bypass_volume);
-	if ((type & (LINE6_BITS_PRO)) != 0)
-		device_remove_file(dev, &dev_attr_fx_loop_on_off);
-	device_remove_file(dev, &dev_attr_tweak_param_select);
-	device_remove_file(dev, &dev_attr_amp1_engage);
-	if (firmware >= 200)
-		device_remove_file(dev, &dev_attr_band_1_gain);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_2_gain__bass);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_2_gain);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_3_gain__bass);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_3_gain);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_4_gain__bass);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_5_gain__bass);
-	if ((type & (LINE6_BITS_PODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_4_gain);
-	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
-		if (firmware >= 200)
-			device_remove_file(dev, &dev_attr_band_6_gain__bass);
-}
-
-int line6_variax_create_files(int firmware, int type, struct device *dev)
-{
-	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_body));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_type));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_position));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_angle));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_level));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_type));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_position));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_angle));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_level));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup_phase));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_capacitance));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tone_resistance));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_volume_resistance));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_taper));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tone_dump));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_save_tone));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_volume_dump));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning_enable));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning6));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning5));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning4));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning3));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning2));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning1));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_detune6));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_detune5));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_detune4));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_detune3));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_detune2));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_detune1));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mix6));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mix5));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mix4));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mix3));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mix2));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_mix1));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup_wiring));
-	return 0;
-}
-
-void line6_variax_remove_files(int firmware, int type, struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_body);
-	device_remove_file(dev, &dev_attr_pickup1_enable);
-	device_remove_file(dev, &dev_attr_pickup1_type);
-	device_remove_file(dev, &dev_attr_pickup1_position);
-	device_remove_file(dev, &dev_attr_pickup1_angle);
-	device_remove_file(dev, &dev_attr_pickup1_level);
-	device_remove_file(dev, &dev_attr_pickup2_enable);
-	device_remove_file(dev, &dev_attr_pickup2_type);
-	device_remove_file(dev, &dev_attr_pickup2_position);
-	device_remove_file(dev, &dev_attr_pickup2_angle);
-	device_remove_file(dev, &dev_attr_pickup2_level);
-	device_remove_file(dev, &dev_attr_pickup_phase);
-	device_remove_file(dev, &dev_attr_capacitance);
-	device_remove_file(dev, &dev_attr_tone_resistance);
-	device_remove_file(dev, &dev_attr_volume_resistance);
-	device_remove_file(dev, &dev_attr_taper);
-	device_remove_file(dev, &dev_attr_tone_dump);
-	device_remove_file(dev, &dev_attr_save_tone);
-	device_remove_file(dev, &dev_attr_volume_dump);
-	device_remove_file(dev, &dev_attr_tuning_enable);
-	device_remove_file(dev, &dev_attr_tuning6);
-	device_remove_file(dev, &dev_attr_tuning5);
-	device_remove_file(dev, &dev_attr_tuning4);
-	device_remove_file(dev, &dev_attr_tuning3);
-	device_remove_file(dev, &dev_attr_tuning2);
-	device_remove_file(dev, &dev_attr_tuning1);
-	device_remove_file(dev, &dev_attr_detune6);
-	device_remove_file(dev, &dev_attr_detune5);
-	device_remove_file(dev, &dev_attr_detune4);
-	device_remove_file(dev, &dev_attr_detune3);
-	device_remove_file(dev, &dev_attr_detune2);
-	device_remove_file(dev, &dev_attr_detune1);
-	device_remove_file(dev, &dev_attr_mix6);
-	device_remove_file(dev, &dev_attr_mix5);
-	device_remove_file(dev, &dev_attr_mix4);
-	device_remove_file(dev, &dev_attr_mix3);
-	device_remove_file(dev, &dev_attr_mix2);
-	device_remove_file(dev, &dev_attr_mix1);
-	device_remove_file(dev, &dev_attr_pickup_wiring);
-}
diff --git a/drivers/staging/line6/control.h b/drivers/staging/line6/control.h
deleted file mode 100644
index e4c5d2c..0000000
--- a/drivers/staging/line6/control.h
+++ /dev/null
@@ -1,195 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef LINE6_CONTROL_H
-#define LINE6_CONTROL_H
-
-/**
-   List of PODxt Pro controls.
-   See Appendix C of the "PODxt (Pro) Pilot's Handbook" by Line6.
-   Comments after the number refer to the PODxt Pro firmware version required
-   for this feature.
-
-   Please *don't* reformat this file since "control.c" is created automatically
-   from "control.h", and this process depends on the exact formatting of the
-   code and the comments below!
-*/
-
-/* *INDENT-OFF* */
-
-enum {
-	POD_tweak                          =   1,
-	POD_wah_position                   =   4,
-	POD_compression_gain               =   5,  /* device: LINE6_BITS_PODXTALL */
-	POD_vol_pedal_position             =   7,
-	POD_compression_threshold          =   9,
-	POD_pan                            =  10,
-	POD_amp_model_setup                =  11,
-	POD_amp_model                      =  12,  /* firmware: 2.0 */
-	POD_drive                          =  13,
-	POD_bass                           =  14,
-	POD_mid                            =  15,  /* device: LINE6_BITS_PODXTALL */
-	POD_lowmid                         =  15,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_treble                         =  16,  /* device: LINE6_BITS_PODXTALL */
-	POD_highmid                        =  16,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_chan_vol                       =  17,
-	POD_reverb_mix                     =  18,  /* device: LINE6_BITS_PODXTALL */
-	POD_effect_setup                   =  19,
-	POD_band_1_frequency               =  20,  /* firmware: 2.0 */
-	POD_presence                       =  21,  /* device: LINE6_BITS_PODXTALL */
-	POD_treble__bass                   =  21,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_noise_gate_enable              =  22,
-	POD_gate_threshold                 =  23,
-	POD_gate_decay_time                =  24,
-	POD_stomp_enable                   =  25,
-	POD_comp_enable                    =  26,
-	POD_stomp_time                     =  27,
-	POD_delay_enable                   =  28,
-	POD_mod_param_1                    =  29,
-	POD_delay_param_1                  =  30,
-	POD_delay_param_1_note_value       =  31,
-	POD_band_2_frequency__bass         =  32,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_delay_param_2                  =  33,
-	POD_delay_volume_mix               =  34,
-	POD_delay_param_3                  =  35,
-	POD_reverb_enable                  =  36,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_type                    =  37,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_decay                   =  38,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_tone                    =  39,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_pre_delay               =  40,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_pre_post                =  41,  /* device: LINE6_BITS_PODXTALL */
-	POD_band_2_frequency               =  42,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_3_frequency__bass         =  42,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_wah_enable                     =  43,
-	POD_modulation_lo_cut              =  44,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_delay_reverb_lo_cut            =  45,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_volume_pedal_minimum           =  46,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_eq_pre_post                    =  46,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_volume_pre_post                =  47,
-	POD_di_model                       =  48,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_di_delay                       =  49,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_mod_enable                     =  50,
-	POD_mod_param_1_note_value         =  51,
-	POD_mod_param_2                    =  52,
-	POD_mod_param_3                    =  53,
-	POD_mod_param_4                    =  54,
-	POD_mod_param_5                    =  55,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_mod_volume_mix                 =  56,
-	POD_mod_pre_post                   =  57,
-	POD_modulation_model               =  58,
-	POD_band_3_frequency               =  60,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_4_frequency__bass         =  60,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_mod_param_1_double_precision   =  61,
-	POD_delay_param_1_double_precision =  62,
-	POD_eq_enable                      =  63,  /* firmware: 2.0 */
-	POD_tap                            =  64,
-	POD_volume_tweak_pedal_assign      =  65,
-	POD_band_5_frequency               =  68,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_tuner                          =  69,
-	POD_mic_selection                  =  70,
-	POD_cabinet_model                  =  71,
-	POD_stomp_model                    =  75,
-	POD_roomlevel                      =  76,
-	POD_band_4_frequency               =  77,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_6_frequency               =  77,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_stomp_param_1_note_value       =  78,
-	POD_stomp_param_2                  =  79,
-	POD_stomp_param_3                  =  80,
-	POD_stomp_param_4                  =  81,
-	POD_stomp_param_5                  =  82,
-	POD_stomp_param_6                  =  83,
-	POD_amp_switch_select              =  84,  /* device: LINE6_BITS_LIVE */
-	POD_delay_param_4                  =  85,
-	POD_delay_param_5                  =  86,
-	POD_delay_pre_post                 =  87,
-	POD_delay_model                    =  88,  /* device: LINE6_BITS_PODXTALL */
-	POD_delay_verb_model               =  88,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_tempo_msb                      =  89,
-	POD_tempo_lsb                      =  90,
-	POD_wah_model                      =  91,  /* firmware: 3.0 */
-	POD_bypass_volume                  = 105,  /* firmware: 2.14 */
-	POD_fx_loop_on_off                 = 107,  /* device: LINE6_BITS_PRO */
-	POD_tweak_param_select             = 108,
-	POD_amp1_engage                    = 111,
-	POD_band_1_gain                    = 114,  /* firmware: 2.0 */
-	POD_band_2_gain__bass              = 115,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_2_gain                    = 116,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_3_gain__bass              = 116,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_3_gain                    = 117,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_4_gain__bass              = 117,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_5_gain__bass              = 118,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_4_gain                    = 119,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_6_gain__bass              = 119   /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-};
-
-/**
-   List of Variax workbench controls (dump).
-*/
-enum {
-	VARIAX_body                        =   3,
-	VARIAX_pickup1_enable              =   4,  /* 0: enabled, 1: disabled */
-	VARIAX_pickup1_type                =   8,
-	VARIAX_pickup1_position            =   9,  /* type: 24 bit float */
-	VARIAX_pickup1_angle               =  12,  /* type: 24 bit float */
-	VARIAX_pickup1_level               =  15,  /* type: 24 bit float */
-	VARIAX_pickup2_enable              =  18,  /* 0: enabled, 1: disabled */
-	VARIAX_pickup2_type                =  22,
-	VARIAX_pickup2_position            =  23,  /* type: 24 bit float */
-	VARIAX_pickup2_angle               =  26,  /* type: 24 bit float */
-	VARIAX_pickup2_level               =  29,  /* type: 24 bit float */
-	VARIAX_pickup_phase                =  32,  /* 0: in phase, 1: out of phase */
-	VARIAX_capacitance                 =  33,  /* type: 24 bit float */
-	VARIAX_tone_resistance             =  36,  /* type: 24 bit float */
-	VARIAX_volume_resistance           =  39,  /* type: 24 bit float */
-	VARIAX_taper                       =  42,  /* 0: Linear, 1: Audio */
-	VARIAX_tone_dump                   =  43,  /* type: 24 bit float */
-	VARIAX_save_tone                   =  46,
-	VARIAX_volume_dump                 =  47,  /* type: 24 bit float */
-	VARIAX_tuning_enable               =  50,
-	VARIAX_tuning6                     =  51,
-	VARIAX_tuning5                     =  52,
-	VARIAX_tuning4                     =  53,
-	VARIAX_tuning3                     =  54,
-	VARIAX_tuning2                     =  55,
-	VARIAX_tuning1                     =  56,
-	VARIAX_detune6                     =  57,  /* type: 24 bit float */
-	VARIAX_detune5                     =  60,  /* type: 24 bit float */
-	VARIAX_detune4                     =  63,  /* type: 24 bit float */
-	VARIAX_detune3                     =  66,  /* type: 24 bit float */
-	VARIAX_detune2                     =  69,  /* type: 24 bit float */
-	VARIAX_detune1                     =  72,  /* type: 24 bit float */
-	VARIAX_mix6                        =  75,  /* type: 24 bit float */
-	VARIAX_mix5                        =  78,  /* type: 24 bit float */
-	VARIAX_mix4                        =  81,  /* type: 24 bit float */
-	VARIAX_mix3                        =  84,  /* type: 24 bit float */
-	VARIAX_mix2                        =  87,  /* type: 24 bit float */
-	VARIAX_mix1                        =  90,  /* type: 24 bit float */
-	VARIAX_pickup_wiring               =  96   /* 0: parallel, 1: series */
-};
-
-/**
-   List of Variax workbench controls (MIDI).
-*/
-enum {
-	VARIAXMIDI_volume                  =   7,
-	VARIAXMIDI_tone                    =  79,
-};
-
-/* *INDENT-ON* */
-
-extern int line6_pod_create_files(int firmware, int type, struct device *dev);
-extern void line6_pod_remove_files(int firmware, int type, struct device *dev);
-extern int line6_variax_create_files(int firmware, int type,
-				     struct device *dev);
-extern void line6_variax_remove_files(int firmware, int type,
-				      struct device *dev);
-
-#endif
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
deleted file mode 100644
index ac11a3b..0000000
--- a/drivers/staging/line6/driver.c
+++ /dev/null
@@ -1,1290 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/usb.h>
-
-#include "audio.h"
-#include "capture.h"
-#include "control.h"
-#include "driver.h"
-#include "midi.h"
-#include "playback.h"
-#include "pod.h"
-#include "podhd.h"
-#include "revision.h"
-#include "toneport.h"
-#include "usbdefs.h"
-#include "variax.h"
-
-#define DRIVER_AUTHOR  "Markus Grabner <grabner@icg.tugraz.at>"
-#define DRIVER_DESC    "Line6 USB Driver"
-#define DRIVER_VERSION "0.9.1beta" DRIVER_REVISION
-
-/* table of devices that work with this driver */
-static const struct usb_device_id line6_id_table[] = {
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXT)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTLIVE)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTPRO)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_GUITARPORT)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_POCKETPOD)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD300)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD500)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX2)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODX3)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODX3LIVE)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXT)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTLIVE)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTPRO)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_GX)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_UX1)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_UX2)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_VARIAX)},
-	{},
-};
-
-MODULE_DEVICE_TABLE(usb, line6_id_table);
-
-/* *INDENT-OFF* */
-static struct line6_properties line6_properties_table[] = {
-	{ LINE6_BIT_BASSPODXT,     "BassPODxt",     "BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
-	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
-	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODX3,         "PODX3",         "POD X3",           LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODX3LIVE,     "PODX3Live",     "POD X3 Live",      LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODXT,         "PODxt",         "PODxt",            LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODXTLIVE,     "PODxtLive",     "PODxt Live",       LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODXTPRO,      "PODxtPro",      "PODxt Pro",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_TONEPORT_GX,   "TonePortGX",    "TonePort GX",      LINE6_BIT_PCM               },
-	{ LINE6_BIT_TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     LINE6_BIT_PCM               },
-	{ LINE6_BIT_TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     LINE6_BIT_PCM               },
-	{ LINE6_BIT_VARIAX,        "Variax",        "Variax Workbench", LINE6_BIT_CONTROL           },
-};
-/* *INDENT-ON* */
-
-/*
-	This is Line6's MIDI manufacturer ID.
-*/
-const unsigned char line6_midi_id[] = {
-	0x00, 0x01, 0x0c
-};
-
-/*
-	Code to request version of POD, Variax interface
-	(and maybe other devices).
-*/
-static const char line6_request_version[] = {
-	0xf0, 0x7e, 0x7f, 0x06, 0x01, 0xf7
-};
-
-/**
-	 Class for asynchronous messages.
-*/
-struct message {
-	struct usb_line6 *line6;
-	const char *buffer;
-	int size;
-	int done;
-};
-
-/*
-	Forward declarations.
-*/
-static void line6_data_received(struct urb *urb);
-static int line6_send_raw_message_async_part(struct message *msg,
-					     struct urb *urb);
-
-/*
-	Start to listen on endpoint.
-*/
-static int line6_start_listen(struct usb_line6 *line6)
-{
-	int err;
-	usb_fill_int_urb(line6->urb_listen, line6->usbdev,
-			 usb_rcvintpipe(line6->usbdev, line6->ep_control_read),
-			 line6->buffer_listen, LINE6_BUFSIZE_LISTEN,
-			 line6_data_received, line6, line6->interval);
-	line6->urb_listen->actual_length = 0;
-	err = usb_submit_urb(line6->urb_listen, GFP_ATOMIC);
-	return err;
-}
-
-/*
-	Stop listening on endpoint.
-*/
-static void line6_stop_listen(struct usb_line6 *line6)
-{
-	usb_kill_urb(line6->urb_listen);
-}
-
-#ifdef CONFIG_LINE6_USB_DUMP_ANY
-/*
-	Write hexdump to syslog.
-*/
-void line6_write_hexdump(struct usb_line6 *line6, char dir,
-			 const unsigned char *buffer, int size)
-{
-	static const int BYTES_PER_LINE = 8;
-	char hexdump[100];
-	char asc[BYTES_PER_LINE + 1];
-	int i, j;
-
-	for (i = 0; i < size; i += BYTES_PER_LINE) {
-		int hexdumpsize = sizeof(hexdump);
-		char *p = hexdump;
-		int n = min(size - i, BYTES_PER_LINE);
-		asc[n] = 0;
-
-		for (j = 0; j < BYTES_PER_LINE; ++j) {
-			int bytes;
-
-			if (j < n) {
-				unsigned char val = buffer[i + j];
-				bytes = snprintf(p, hexdumpsize, " %02X", val);
-				asc[j] = ((val >= 0x20)
-					  && (val < 0x7f)) ? val : '.';
-			} else
-				bytes = snprintf(p, hexdumpsize, "   ");
-
-			if (bytes > hexdumpsize)
-				break;	/* buffer overflow */
-
-			p += bytes;
-			hexdumpsize -= bytes;
-		}
-
-		dev_info(line6->ifcdev, "%c%04X:%s %s\n", dir, i, hexdump, asc);
-	}
-}
-#endif
-
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-/*
-	Dump URB data to syslog.
-*/
-static void line6_dump_urb(struct urb *urb)
-{
-	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
-
-	if (urb->status < 0)
-		return;
-
-	line6_write_hexdump(line6, 'R', (unsigned char *)urb->transfer_buffer,
-			    urb->actual_length);
-}
-#endif
-
-/*
-	Send raw message in pieces of wMaxPacketSize bytes.
-*/
-int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
-			   int size)
-{
-	int i, done = 0;
-
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', buffer, size);
-#endif
-
-	for (i = 0; i < size; i += line6->max_packet_size) {
-		int partial;
-		const char *frag_buf = buffer + i;
-		int frag_size = min(line6->max_packet_size, size - i);
-		int retval;
-
-		retval = usb_interrupt_msg(line6->usbdev,
-					   usb_sndintpipe(line6->usbdev,
-							  line6->ep_control_write),
-					   (char *)frag_buf, frag_size,
-					   &partial, LINE6_TIMEOUT * HZ);
-
-		if (retval) {
-			dev_err(line6->ifcdev,
-				"usb_interrupt_msg failed (%d)\n", retval);
-			break;
-		}
-
-		done += frag_size;
-	}
-
-	return done;
-}
-
-/*
-	Notification of completion of asynchronous request transmission.
-*/
-static void line6_async_request_sent(struct urb *urb)
-{
-	struct message *msg = (struct message *)urb->context;
-
-	if (msg->done >= msg->size) {
-		usb_free_urb(urb);
-		kfree(msg);
-	} else
-		line6_send_raw_message_async_part(msg, urb);
-}
-
-/*
-	Asynchronously send part of a raw message.
-*/
-static int line6_send_raw_message_async_part(struct message *msg,
-					     struct urb *urb)
-{
-	int retval;
-	struct usb_line6 *line6 = msg->line6;
-	int done = msg->done;
-	int bytes = min(msg->size - done, line6->max_packet_size);
-
-	usb_fill_int_urb(urb, line6->usbdev,
-			 usb_sndintpipe(line6->usbdev, line6->ep_control_write),
-			 (char *)msg->buffer + done, bytes,
-			 line6_async_request_sent, msg, line6->interval);
-
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', (char *)msg->buffer + done, bytes);
-#endif
-
-	msg->done += bytes;
-	retval = usb_submit_urb(urb, GFP_ATOMIC);
-
-	if (retval < 0) {
-		dev_err(line6->ifcdev, "%s: usb_submit_urb failed (%d)\n",
-			__func__, retval);
-		usb_free_urb(urb);
-		kfree(msg);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/*
-	Setup and start timer.
-*/
-void line6_start_timer(struct timer_list *timer, unsigned int msecs,
-		       void (*function) (unsigned long), unsigned long data)
-{
-	setup_timer(timer, function, data);
-	timer->expires = jiffies + msecs * HZ / 1000;
-	add_timer(timer);
-}
-
-/*
-	Asynchronously send raw message.
-*/
-int line6_send_raw_message_async(struct usb_line6 *line6, const char *buffer,
-				 int size)
-{
-	struct message *msg;
-	struct urb *urb;
-
-	/* create message: */
-	msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
-
-	if (msg == NULL) {
-		dev_err(line6->ifcdev, "Out of memory\n");
-		return -ENOMEM;
-	}
-
-	/* create URB: */
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
-
-	if (urb == NULL) {
-		kfree(msg);
-		dev_err(line6->ifcdev, "Out of memory\n");
-		return -ENOMEM;
-	}
-
-	/* set message data: */
-	msg->line6 = line6;
-	msg->buffer = buffer;
-	msg->size = size;
-	msg->done = 0;
-
-	/* start sending: */
-	return line6_send_raw_message_async_part(msg, urb);
-}
-
-/*
-	Send asynchronous device version request.
-*/
-int line6_version_request_async(struct usb_line6 *line6)
-{
-	char *buffer;
-	int retval;
-
-	buffer = kmalloc(sizeof(line6_request_version), GFP_ATOMIC);
-	if (buffer == NULL) {
-		dev_err(line6->ifcdev, "Out of memory");
-		return -ENOMEM;
-	}
-
-	memcpy(buffer, line6_request_version, sizeof(line6_request_version));
-
-	retval = line6_send_raw_message_async(line6, buffer,
-					      sizeof(line6_request_version));
-	kfree(buffer);
-	return retval;
-}
-
-/*
-	Send sysex message in pieces of wMaxPacketSize bytes.
-*/
-int line6_send_sysex_message(struct usb_line6 *line6, const char *buffer,
-			     int size)
-{
-	return line6_send_raw_message(line6, buffer,
-				      size + SYSEX_EXTRA_SIZE) -
-	    SYSEX_EXTRA_SIZE;
-}
-
-/*
-	Send sysex message in pieces of wMaxPacketSize bytes.
-*/
-int line6_send_sysex_message_async(struct usb_line6 *line6, const char *buffer,
-				   int size)
-{
-	return line6_send_raw_message_async(line6, buffer,
-					    size + SYSEX_EXTRA_SIZE) -
-	    SYSEX_EXTRA_SIZE;
-}
-
-/*
-	Allocate buffer for sysex message and prepare header.
-	@param code sysex message code
-	@param size number of bytes between code and sysex end
-*/
-char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1, int code2,
-			       int size)
-{
-	char *buffer = kmalloc(size + SYSEX_EXTRA_SIZE, GFP_ATOMIC);
-
-	if (!buffer) {
-		dev_err(line6->ifcdev, "out of memory\n");
-		return NULL;
-	}
-
-	buffer[0] = LINE6_SYSEX_BEGIN;
-	memcpy(buffer + 1, line6_midi_id, sizeof(line6_midi_id));
-	buffer[sizeof(line6_midi_id) + 1] = code1;
-	buffer[sizeof(line6_midi_id) + 2] = code2;
-	buffer[sizeof(line6_midi_id) + 3 + size] = LINE6_SYSEX_END;
-	return buffer;
-}
-
-/*
-	Notification of data received from the Line6 device.
-*/
-static void line6_data_received(struct urb *urb)
-{
-	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
-	struct MidiBuffer *mb = &line6->line6midi->midibuf_in;
-	int done;
-
-	if (urb->status == -ESHUTDOWN)
-		return;
-
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_dump_urb(urb);
-#endif
-
-	done =
-	    line6_midibuf_write(mb, urb->transfer_buffer, urb->actual_length);
-
-	if (done < urb->actual_length) {
-		line6_midibuf_ignore(mb, done);
-		DEBUG_MESSAGES(dev_err
-			       (line6->ifcdev,
-				"%d %d buffer overflow - message skipped\n",
-				done, urb->actual_length));
-	}
-
-	for (;;) {
-		done =
-		    line6_midibuf_read(mb, line6->buffer_message,
-				       LINE6_MESSAGE_MAXLEN);
-
-		if (done == 0)
-			break;
-
-		/* MIDI input filter */
-		if (line6_midibuf_skip_message
-		    (mb, line6->line6midi->midi_mask_receive))
-			continue;
-
-		line6->message_length = done;
-#ifdef CONFIG_LINE6_USB_DUMP_MIDI
-		line6_write_hexdump(line6, 'r', line6->buffer_message, done);
-#endif
-		line6_midi_receive(line6, line6->buffer_message, done);
-
-		switch (line6->usbdev->descriptor.idProduct) {
-		case LINE6_DEVID_BASSPODXT:
-		case LINE6_DEVID_BASSPODXTLIVE:
-		case LINE6_DEVID_BASSPODXTPRO:
-		case LINE6_DEVID_PODXT:
-		case LINE6_DEVID_PODXTPRO:
-		case LINE6_DEVID_POCKETPOD:
-			line6_pod_process_message((struct usb_line6_pod *)
-						  line6);
-			break;
-
-		case LINE6_DEVID_PODHD300:
-		case LINE6_DEVID_PODHD500:
-			break; /* let userspace handle MIDI */
-
-		case LINE6_DEVID_PODXTLIVE:
-			switch (line6->interface_number) {
-			case PODXTLIVE_INTERFACE_POD:
-				line6_pod_process_message((struct usb_line6_pod
-							   *)line6);
-				break;
-
-			case PODXTLIVE_INTERFACE_VARIAX:
-				line6_variax_process_message((struct
-							      usb_line6_variax
-							      *)line6);
-				break;
-
-			default:
-				dev_err(line6->ifcdev,
-					"PODxt Live interface %d not supported\n",
-					line6->interface_number);
-			}
-			break;
-
-		case LINE6_DEVID_VARIAX:
-			line6_variax_process_message((struct usb_line6_variax *)
-						     line6);
-			break;
-
-		default:
-			MISSING_CASE;
-		}
-	}
-
-	line6_start_listen(line6);
-}
-
-/*
-	Send channel number (i.e., switch to a different sound).
-*/
-int line6_send_program(struct usb_line6 *line6, u8 value)
-{
-	int retval;
-	unsigned char *buffer;
-	int partial;
-
-	buffer = kmalloc(2, GFP_KERNEL);
-
-	if (!buffer) {
-		dev_err(line6->ifcdev, "out of memory\n");
-		return -ENOMEM;
-	}
-
-	buffer[0] = LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST;
-	buffer[1] = value;
-
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', buffer, 2);
-#endif
-
-	retval = usb_interrupt_msg(line6->usbdev,
-				   usb_sndintpipe(line6->usbdev,
-						  line6->ep_control_write),
-				   buffer, 2, &partial, LINE6_TIMEOUT * HZ);
-
-	if (retval)
-		dev_err(line6->ifcdev, "usb_interrupt_msg failed (%d)\n",
-			retval);
-
-	kfree(buffer);
-	return retval;
-}
-
-/*
-	Transmit Line6 control parameter.
-*/
-int line6_transmit_parameter(struct usb_line6 *line6, int param, u8 value)
-{
-	int retval;
-	unsigned char *buffer;
-	int partial;
-
-	buffer = kmalloc(3, GFP_KERNEL);
-
-	if (!buffer) {
-		dev_err(line6->ifcdev, "out of memory\n");
-		return -ENOMEM;
-	}
-
-	buffer[0] = LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST;
-	buffer[1] = param;
-	buffer[2] = value;
-
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', buffer, 3);
-#endif
-
-	retval = usb_interrupt_msg(line6->usbdev,
-				   usb_sndintpipe(line6->usbdev,
-						  line6->ep_control_write),
-				   buffer, 3, &partial, LINE6_TIMEOUT * HZ);
-
-	if (retval)
-		dev_err(line6->ifcdev, "usb_interrupt_msg failed (%d)\n",
-			retval);
-
-	kfree(buffer);
-	return retval;
-}
-
-/*
-	Read data from device.
-*/
-int line6_read_data(struct usb_line6 *line6, int address, void *data,
-		    size_t datalen)
-{
-	struct usb_device *usbdev = line6->usbdev;
-	int ret;
-	unsigned char len;
-
-	/* query the serial number: */
-	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
-			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			      (datalen << 8) | 0x21, address,
-			      NULL, 0, LINE6_TIMEOUT * HZ);
-
-	if (ret < 0) {
-		dev_err(line6->ifcdev, "read request failed (error %d)\n", ret);
-		return ret;
-	}
-
-	/* Wait for data length. We'll get a couple of 0xff until length arrives. */
-	do {
-		ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
-				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
-				      USB_DIR_IN,
-				      0x0012, 0x0000, &len, 1,
-				      LINE6_TIMEOUT * HZ);
-		if (ret < 0) {
-			dev_err(line6->ifcdev,
-				"receive length failed (error %d)\n", ret);
-			return ret;
-		}
-	} while (len == 0xff);
-
-	if (len != datalen) {
-		/* should be equal or something went wrong */
-		dev_err(line6->ifcdev,
-			"length mismatch (expected %d, got %d)\n",
-			(int)datalen, (int)len);
-		return -EINVAL;
-	}
-
-	/* receive the result: */
-	ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
-			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0x0013, 0x0000, data, datalen,
-			      LINE6_TIMEOUT * HZ);
-
-	if (ret < 0) {
-		dev_err(line6->ifcdev, "read failed (error %d)\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-/*
-	Write data to device.
-*/
-int line6_write_data(struct usb_line6 *line6, int address, void *data,
-		     size_t datalen)
-{
-	struct usb_device *usbdev = line6->usbdev;
-	int ret;
-	unsigned char status;
-
-	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
-			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			      0x0022, address, data, datalen,
-			      LINE6_TIMEOUT * HZ);
-
-	if (ret < 0) {
-		dev_err(line6->ifcdev,
-			"write request failed (error %d)\n", ret);
-		return ret;
-	}
-
-	do {
-		ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0),
-				      0x67,
-				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
-				      USB_DIR_IN,
-				      0x0012, 0x0000,
-				      &status, 1, LINE6_TIMEOUT * HZ);
-
-		if (ret < 0) {
-			dev_err(line6->ifcdev,
-				"receiving status failed (error %d)\n", ret);
-			return ret;
-		}
-	} while (status == 0xff);
-
-	if (status != 0) {
-		dev_err(line6->ifcdev, "write failed (error %d)\n", ret);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/*
-	Read Line6 device serial number.
-	(POD, TonePort, GuitarPort)
-*/
-int line6_read_serial_number(struct usb_line6 *line6, int *serial_number)
-{
-	return line6_read_data(line6, 0x80d0, serial_number,
-			       sizeof(*serial_number));
-}
-
-/*
-	No operation (i.e., unsupported).
-*/
-ssize_t line6_nop_read(struct device *dev, struct device_attribute *attr,
-		       char *buf)
-{
-	return 0;
-}
-
-/*
-	No operation (i.e., unsupported).
-*/
-ssize_t line6_nop_write(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t count)
-{
-	return count;
-}
-
-/*
-	"write" request on "raw" special file.
-*/
-#ifdef CONFIG_LINE6_USB_RAW
-ssize_t line6_set_raw(struct device *dev, struct device_attribute *attr,
-		      const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	line6_send_raw_message(line6, buf, count);
-	return count;
-}
-#endif
-
-/*
-	Generic destructor.
-*/
-static void line6_destruct(struct usb_interface *interface)
-{
-	struct usb_line6 *line6;
-
-	if (interface == NULL)
-		return;
-	line6 = usb_get_intfdata(interface);
-	if (line6 == NULL)
-		return;
-
-	/* free buffer memory first: */
-	kfree(line6->buffer_message);
-	kfree(line6->buffer_listen);
-
-	/* then free URBs: */
-	usb_free_urb(line6->urb_listen);
-
-	/* make sure the device isn't destructed twice: */
-	usb_set_intfdata(interface, NULL);
-
-	/* free interface data: */
-	kfree(line6);
-}
-
-/*
-	Probe USB device.
-*/
-static int line6_probe(struct usb_interface *interface,
-		       const struct usb_device_id *id)
-{
-	int devtype;
-	struct usb_device *usbdev;
-	struct usb_line6 *line6;
-	const struct line6_properties *properties;
-	int interface_number, alternate = 0;
-	int product;
-	int size = 0;
-	int ep_read = 0, ep_write = 0;
-	int ret;
-
-	if (interface == NULL)
-		return -ENODEV;
-	usbdev = interface_to_usbdev(interface);
-	if (usbdev == NULL)
-		return -ENODEV;
-
-	/* we don't handle multiple configurations */
-	if (usbdev->descriptor.bNumConfigurations != 1) {
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	/* check vendor and product id */
-	for (devtype = ARRAY_SIZE(line6_id_table) - 1; devtype--;) {
-		u16 idVendor = le16_to_cpu(usbdev->descriptor.idVendor);
-		u16 idProduct = le16_to_cpu(usbdev->descriptor.idProduct);
-
-		if (idVendor == line6_id_table[devtype].idVendor &&
-		    idProduct == line6_id_table[devtype].idProduct)
-			break;
-	}
-
-	if (devtype < 0) {
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	/* initialize device info: */
-	properties = &line6_properties_table[devtype];
-	dev_info(&interface->dev, "Line6 %s found\n", properties->name);
-	product = le16_to_cpu(usbdev->descriptor.idProduct);
-
-	/* query interface number */
-	interface_number = interface->cur_altsetting->desc.bInterfaceNumber;
-
-	switch (product) {
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_PODXTLIVE:
-	case LINE6_DEVID_VARIAX:
-		alternate = 1;
-		break;
-
-	case LINE6_DEVID_POCKETPOD:
-		switch (interface_number) {
-		case 0:
-			return 0;	/* this interface has no endpoints */
-		case 1:
-			alternate = 0;
-			break;
-		default:
-			MISSING_CASE;
-		}
-		break;
-
-	case LINE6_DEVID_PODHD500:
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
-		switch (interface_number) {
-		case 0:
-			alternate = 1;
-			break;
-		case 1:
-			alternate = 0;
-			break;
-		default:
-			MISSING_CASE;
-		}
-		break;
-
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTPRO:
-	case LINE6_DEVID_PODHD300:
-		alternate = 5;
-		break;
-
-	case LINE6_DEVID_GUITARPORT:
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-		alternate = 2;	/* 1..4 seem to be ok */
-		break;
-
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-		switch (interface_number) {
-		case 0:
-			/* defaults to 44.1kHz, 16-bit */
-			alternate = 2;
-			break;
-		case 1:
-			/* don't know yet what this is ...
-			   alternate = 1;
-			   break;
-			 */
-			return -ENODEV;
-		default:
-			MISSING_CASE;
-		}
-		break;
-
-	default:
-		MISSING_CASE;
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	ret = usb_set_interface(usbdev, interface_number, alternate);
-	if (ret < 0) {
-		dev_err(&interface->dev, "set_interface failed\n");
-		goto err_put;
-	}
-
-	/* initialize device data based on product id: */
-	switch (product) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTPRO:
-		size = sizeof(struct usb_line6_pod);
-		ep_read = 0x84;
-		ep_write = 0x03;
-		break;
-
-	case LINE6_DEVID_PODHD300:
-		size = sizeof(struct usb_line6_podhd);
-		ep_read = 0x84;
-		ep_write = 0x03;
-		break;
-
-	case LINE6_DEVID_PODHD500:
-		size = sizeof(struct usb_line6_podhd);
-		ep_read = 0x81;
-		ep_write = 0x01;
-		break;
-
-	case LINE6_DEVID_POCKETPOD:
-		size = sizeof(struct usb_line6_pod);
-		ep_read = 0x82;
-		ep_write = 0x02;
-		break;
-
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
-		/* currently unused! */
-		size = sizeof(struct usb_line6_pod);
-		ep_read = 0x81;
-		ep_write = 0x01;
-		break;
-
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_GUITARPORT:
-		size = sizeof(struct usb_line6_toneport);
-		/* these don't have a control channel */
-		break;
-
-	case LINE6_DEVID_PODXTLIVE:
-		switch (interface_number) {
-		case PODXTLIVE_INTERFACE_POD:
-			size = sizeof(struct usb_line6_pod);
-			ep_read = 0x84;
-			ep_write = 0x03;
-			break;
-
-		case PODXTLIVE_INTERFACE_VARIAX:
-			size = sizeof(struct usb_line6_variax);
-			ep_read = 0x86;
-			ep_write = 0x05;
-			break;
-
-		default:
-			ret = -ENODEV;
-			goto err_put;
-		}
-		break;
-
-	case LINE6_DEVID_VARIAX:
-		size = sizeof(struct usb_line6_variax);
-		ep_read = 0x82;
-		ep_write = 0x01;
-		break;
-
-	default:
-		MISSING_CASE;
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	if (size == 0) {
-		dev_err(&interface->dev,
-			"driver bug: interface data size not set\n");
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	line6 = kzalloc(size, GFP_KERNEL);
-
-	if (line6 == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	/* store basic data: */
-	line6->interface_number = interface_number;
-	line6->properties = properties;
-	line6->usbdev = usbdev;
-	line6->ifcdev = &interface->dev;
-	line6->ep_control_read = ep_read;
-	line6->ep_control_write = ep_write;
-	line6->product = product;
-
-	/* get data from endpoint descriptor (see usb_maxpacket): */
-	{
-		struct usb_host_endpoint *ep;
-		unsigned epnum =
-		    usb_pipeendpoint(usb_rcvintpipe(usbdev, ep_read));
-		ep = usbdev->ep_in[epnum];
-
-		if (ep != NULL) {
-			line6->interval = ep->desc.bInterval;
-			line6->max_packet_size =
-			    le16_to_cpu(ep->desc.wMaxPacketSize);
-		} else {
-			line6->interval = LINE6_FALLBACK_INTERVAL;
-			line6->max_packet_size = LINE6_FALLBACK_MAXPACKETSIZE;
-			dev_err(line6->ifcdev,
-				"endpoint not available, using fallback values");
-		}
-	}
-
-	usb_set_intfdata(interface, line6);
-
-	if (properties->capabilities & LINE6_BIT_CONTROL) {
-		/* initialize USB buffers: */
-		line6->buffer_listen =
-		    kmalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
-
-		if (line6->buffer_listen == NULL) {
-			dev_err(&interface->dev, "Out of memory\n");
-			ret = -ENOMEM;
-			goto err_destruct;
-		}
-
-		line6->buffer_message =
-		    kmalloc(LINE6_MESSAGE_MAXLEN, GFP_KERNEL);
-
-		if (line6->buffer_message == NULL) {
-			dev_err(&interface->dev, "Out of memory\n");
-			ret = -ENOMEM;
-			goto err_destruct;
-		}
-
-		line6->urb_listen = usb_alloc_urb(0, GFP_KERNEL);
-
-		if (line6->urb_listen == NULL) {
-			dev_err(&interface->dev, "Out of memory\n");
-			line6_destruct(interface);
-			ret = -ENOMEM;
-			goto err_destruct;
-		}
-
-		ret = line6_start_listen(line6);
-		if (ret < 0) {
-			dev_err(&interface->dev, "%s: usb_submit_urb failed\n",
-				__func__);
-			goto err_destruct;
-		}
-	}
-
-	/* initialize device data based on product id: */
-	switch (product) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_POCKETPOD:
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTPRO:
-		ret = line6_pod_init(interface, (struct usb_line6_pod *)line6);
-		break;
-
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD500:
-		ret = line6_podhd_init(interface,
-				       (struct usb_line6_podhd *)line6);
-		break;
-
-	case LINE6_DEVID_PODXTLIVE:
-		switch (interface_number) {
-		case PODXTLIVE_INTERFACE_POD:
-			ret =
-			    line6_pod_init(interface,
-					   (struct usb_line6_pod *)line6);
-			break;
-
-		case PODXTLIVE_INTERFACE_VARIAX:
-			ret =
-			    line6_variax_init(interface,
-					      (struct usb_line6_variax *)line6);
-			break;
-
-		default:
-			dev_err(&interface->dev,
-				"PODxt Live interface %d not supported\n",
-				interface_number);
-			ret = -ENODEV;
-		}
-
-		break;
-
-	case LINE6_DEVID_VARIAX:
-		ret =
-		    line6_variax_init(interface,
-				      (struct usb_line6_variax *)line6);
-		break;
-
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_GUITARPORT:
-		ret =
-		    line6_toneport_init(interface,
-					(struct usb_line6_toneport *)line6);
-		break;
-
-	default:
-		MISSING_CASE;
-		ret = -ENODEV;
-	}
-
-	if (ret < 0)
-		goto err_destruct;
-
-	ret = sysfs_create_link(&interface->dev.kobj, &usbdev->dev.kobj,
-				"usb_device");
-	if (ret < 0)
-		goto err_destruct;
-
-	/* creation of additional special files should go here */
-
-	dev_info(&interface->dev, "Line6 %s now attached\n",
-		 line6->properties->name);
-
-	switch (product) {
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
-		dev_info(&interface->dev,
-			 "NOTE: the Line6 %s is detected, but not yet supported\n",
-			 line6->properties->name);
-	}
-
-	/* increment reference counters: */
-	usb_get_intf(interface);
-	usb_get_dev(usbdev);
-
-	return 0;
-
-err_destruct:
-	line6_destruct(interface);
-err_put:
-	return ret;
-}
-
-/*
-	Line6 device disconnected.
-*/
-static void line6_disconnect(struct usb_interface *interface)
-{
-	struct usb_line6 *line6;
-	struct usb_device *usbdev;
-	int interface_number;
-
-	if (interface == NULL)
-		return;
-	usbdev = interface_to_usbdev(interface);
-	if (usbdev == NULL)
-		return;
-
-	/* removal of additional special files should go here */
-
-	sysfs_remove_link(&interface->dev.kobj, "usb_device");
-
-	interface_number = interface->cur_altsetting->desc.bInterfaceNumber;
-	line6 = usb_get_intfdata(interface);
-
-	if (line6 != NULL) {
-		if (line6->urb_listen != NULL)
-			line6_stop_listen(line6);
-
-		if (usbdev != line6->usbdev)
-			dev_err(line6->ifcdev,
-				"driver bug: inconsistent usb device\n");
-
-		switch (line6->usbdev->descriptor.idProduct) {
-		case LINE6_DEVID_BASSPODXT:
-		case LINE6_DEVID_BASSPODXTLIVE:
-		case LINE6_DEVID_BASSPODXTPRO:
-		case LINE6_DEVID_POCKETPOD:
-		case LINE6_DEVID_PODX3:
-		case LINE6_DEVID_PODX3LIVE:
-		case LINE6_DEVID_PODXT:
-		case LINE6_DEVID_PODXTPRO:
-			line6_pod_disconnect(interface);
-			break;
-
-		case LINE6_DEVID_PODHD300:
-		case LINE6_DEVID_PODHD500:
-			line6_podhd_disconnect(interface);
-			break;
-
-		case LINE6_DEVID_PODXTLIVE:
-			switch (interface_number) {
-			case PODXTLIVE_INTERFACE_POD:
-				line6_pod_disconnect(interface);
-				break;
-
-			case PODXTLIVE_INTERFACE_VARIAX:
-				line6_variax_disconnect(interface);
-				break;
-			}
-
-			break;
-
-		case LINE6_DEVID_VARIAX:
-			line6_variax_disconnect(interface);
-			break;
-
-		case LINE6_DEVID_PODSTUDIO_GX:
-		case LINE6_DEVID_PODSTUDIO_UX1:
-		case LINE6_DEVID_PODSTUDIO_UX2:
-		case LINE6_DEVID_TONEPORT_GX:
-		case LINE6_DEVID_TONEPORT_UX1:
-		case LINE6_DEVID_TONEPORT_UX2:
-		case LINE6_DEVID_GUITARPORT:
-			line6_toneport_disconnect(interface);
-			break;
-
-		default:
-			MISSING_CASE;
-		}
-
-		dev_info(&interface->dev, "Line6 %s now disconnected\n",
-			 line6->properties->name);
-	}
-
-	line6_destruct(interface);
-
-	/* decrement reference counters: */
-	usb_put_intf(interface);
-	usb_put_dev(usbdev);
-}
-
-#ifdef CONFIG_PM
-
-/*
-	Suspend Line6 device.
-*/
-static int line6_suspend(struct usb_interface *interface, pm_message_t message)
-{
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	struct snd_line6_pcm *line6pcm = line6->line6pcm;
-
-	snd_power_change_state(line6->card, SNDRV_CTL_POWER_D3hot);
-
-	if (line6->properties->capabilities & LINE6_BIT_CONTROL)
-		line6_stop_listen(line6);
-
-	if (line6pcm != NULL) {
-		snd_pcm_suspend_all(line6pcm->pcm);
-		line6_pcm_disconnect(line6pcm);
-		line6pcm->flags = 0;
-	}
-
-	return 0;
-}
-
-/*
-	Resume Line6 device.
-*/
-static int line6_resume(struct usb_interface *interface)
-{
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-
-	if (line6->properties->capabilities & LINE6_BIT_CONTROL)
-		line6_start_listen(line6);
-
-	snd_power_change_state(line6->card, SNDRV_CTL_POWER_D0);
-	return 0;
-}
-
-/*
-	Resume Line6 device after reset.
-*/
-static int line6_reset_resume(struct usb_interface *interface)
-{
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-
-	switch (line6->usbdev->descriptor.idProduct) {
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_GUITARPORT:
-		line6_toneport_reset_resume((struct usb_line6_toneport *)line6);
-	}
-
-	return line6_resume(interface);
-}
-
-#endif /* CONFIG_PM */
-
-static struct usb_driver line6_driver = {
-	.name = DRIVER_NAME,
-	.probe = line6_probe,
-	.disconnect = line6_disconnect,
-#ifdef CONFIG_PM
-	.suspend = line6_suspend,
-	.resume = line6_resume,
-	.reset_resume = line6_reset_resume,
-#endif
-	.id_table = line6_id_table,
-};
-
-module_usb_driver(line6_driver);
-
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
-MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
deleted file mode 100644
index 35246cf..0000000
--- a/drivers/staging/line6/driver.h
+++ /dev/null
@@ -1,235 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef DRIVER_H
-#define DRIVER_H
-
-#include <linux/spinlock.h>
-#include <linux/usb.h>
-#include <sound/core.h>
-
-#include "midi.h"
-
-#define DRIVER_NAME "line6usb"
-
-#if defined(CONFIG_LINE6_USB_DUMP_CTRL) || defined(CONFIG_LINE6_USB_DUMP_MIDI) || defined(CONFIG_LINE6_USB_DUMP_PCM)
-#define CONFIG_LINE6_USB_DUMP_ANY
-#endif
-
-#define LINE6_TIMEOUT 1
-#define LINE6_BUFSIZE_LISTEN 32
-#define LINE6_MESSAGE_MAXLEN 256
-
-/*
-	Line6 MIDI control commands
-*/
-#define LINE6_PARAM_CHANGE   0xb0
-#define LINE6_PROGRAM_CHANGE 0xc0
-#define LINE6_SYSEX_BEGIN    0xf0
-#define LINE6_SYSEX_END      0xf7
-#define LINE6_RESET          0xff
-
-/*
-	MIDI channel for messages initiated by the host
-	(and eventually echoed back by the device)
-*/
-#define LINE6_CHANNEL_HOST   0x00
-
-/*
-	MIDI channel for messages initiated by the device
-*/
-#define LINE6_CHANNEL_DEVICE 0x02
-
-#define LINE6_CHANNEL_UNKNOWN 5	/* don't know yet what this is good for */
-
-#define LINE6_CHANNEL_MASK 0x0f
-
-#ifdef CONFIG_LINE6_USB_DEBUG
-#define DEBUG_MESSAGES(x) (x)
-#else
-#define DEBUG_MESSAGES(x)
-#endif
-
-#define MISSING_CASE	\
-	printk(KERN_ERR "line6usb driver bug: missing case in %s:%d\n", \
-		__FILE__, __LINE__)
-
-#define CHECK_RETURN(x)		\
-do {				\
-	err = x;		\
-	if (err < 0)		\
-		return err;	\
-} while (0)
-
-#define CHECK_STARTUP_PROGRESS(x, n)	\
-do {					\
-	if ((x) >= (n))			\
-		return;			\
-	x = (n);			\
-} while (0)
-
-extern const unsigned char line6_midi_id[3];
-
-static const int SYSEX_DATA_OFS = sizeof(line6_midi_id) + 3;
-static const int SYSEX_EXTRA_SIZE = sizeof(line6_midi_id) + 4;
-
-/**
-	 Common properties of Line6 devices.
-*/
-struct line6_properties {
-	/**
-		 Bit identifying this device in the line6usb driver.
-	*/
-	int device_bit;
-
-	/**
-		 Card id string (maximum 16 characters).
-		 This can be used to address the device in ALSA programs as
-		 "default:CARD=<id>"
-	*/
-	const char *id;
-
-	/**
-		 Card short name (maximum 32 characters).
-	*/
-	const char *name;
-
-	/**
-		 Bit vector defining this device's capabilities in the
-		 line6usb driver.
-	*/
-	int capabilities;
-};
-
-/**
-	 Common data shared by all Line6 devices.
-	 Corresponds to a pair of USB endpoints.
-*/
-struct usb_line6 {
-	/**
-		 USB device.
-	*/
-	struct usb_device *usbdev;
-
-	/**
-		 Product id.
-	*/
-	int product;
-
-	/**
-		 Properties.
-	*/
-	const struct line6_properties *properties;
-
-	/**
-		 Interface number.
-	*/
-	int interface_number;
-
-	/**
-		 Interval (ms).
-	*/
-	int interval;
-
-	/**
-		 Maximum size of USB packet.
-	*/
-	int max_packet_size;
-
-	/**
-		 Device representing the USB interface.
-	*/
-	struct device *ifcdev;
-
-	/**
-		 Line6 sound card data structure.
-		 Each device has at least MIDI or PCM.
-	*/
-	struct snd_card *card;
-
-	/**
-		 Line6 PCM device data structure.
-	*/
-	struct snd_line6_pcm *line6pcm;
-
-	/**
-		 Line6 MIDI device data structure.
-	*/
-	struct snd_line6_midi *line6midi;
-
-	/**
-		 USB endpoint for listening to control commands.
-	*/
-	int ep_control_read;
-
-	/**
-		 USB endpoint for writing control commands.
-	*/
-	int ep_control_write;
-
-	/**
-		 URB for listening to PODxt Pro control endpoint.
-	*/
-	struct urb *urb_listen;
-
-	/**
-		 Buffer for listening to PODxt Pro control endpoint.
-	*/
-	unsigned char *buffer_listen;
-
-	/**
-		 Buffer for message to be processed.
-	*/
-	unsigned char *buffer_message;
-
-	/**
-		 Length of message to be processed.
-	*/
-	int message_length;
-};
-
-extern char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1,
-				      int code2, int size);
-extern ssize_t line6_nop_read(struct device *dev,
-			      struct device_attribute *attr, char *buf);
-extern ssize_t line6_nop_write(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count);
-extern int line6_read_data(struct usb_line6 *line6, int address, void *data,
-			   size_t datalen);
-extern int line6_read_serial_number(struct usb_line6 *line6,
-				    int *serial_number);
-extern int line6_send_program(struct usb_line6 *line6, u8 value);
-extern int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
-				  int size);
-extern int line6_send_raw_message_async(struct usb_line6 *line6,
-					const char *buffer, int size);
-extern int line6_send_sysex_message(struct usb_line6 *line6,
-				    const char *buffer, int size);
-extern int line6_send_sysex_message_async(struct usb_line6 *line6,
-					  const char *buffer, int size);
-extern ssize_t line6_set_raw(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count);
-extern void line6_start_timer(struct timer_list *timer, unsigned int msecs,
-			      void (*function) (unsigned long),
-			      unsigned long data);
-extern int line6_transmit_parameter(struct usb_line6 *line6, int param,
-				    u8 value);
-extern int line6_version_request_async(struct usb_line6 *line6);
-extern int line6_write_data(struct usb_line6 *line6, int address, void *data,
-			    size_t datalen);
-
-#ifdef CONFIG_LINE6_USB_DUMP_ANY
-extern void line6_write_hexdump(struct usb_line6 *line6, char dir,
-				const unsigned char *buffer, int size);
-#endif
-
-#endif
diff --git a/drivers/staging/line6/dumprequest.c b/drivers/staging/line6/dumprequest.c
deleted file mode 100644
index 60c7bae..0000000
--- a/drivers/staging/line6/dumprequest.c
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-
-#include "driver.h"
-#include "dumprequest.h"
-
-/*
-	Set "dump in progress" flag.
-*/
-void line6_dump_started(struct line6_dump_request *l6dr, int dest)
-{
-	l6dr->in_progress = dest;
-}
-
-/*
-	Invalidate current channel, i.e., set "dump in progress" flag.
-	Reading from the "dump" special file blocks until dump is completed.
-*/
-void line6_invalidate_current(struct line6_dump_request *l6dr)
-{
-	line6_dump_started(l6dr, LINE6_DUMP_CURRENT);
-}
-
-/*
-	Clear "dump in progress" flag and notify waiting processes.
-*/
-void line6_dump_finished(struct line6_dump_request *l6dr)
-{
-	l6dr->in_progress = LINE6_DUMP_NONE;
-	wake_up(&l6dr->wait);
-}
-
-/*
-	Send an asynchronous channel dump request.
-*/
-int line6_dump_request_async(struct line6_dump_request *l6dr,
-			     struct usb_line6 *line6, int num, int dest)
-{
-	int ret;
-	line6_dump_started(l6dr, dest);
-	ret = line6_send_raw_message_async(line6, l6dr->reqbufs[num].buffer,
-					   l6dr->reqbufs[num].length);
-
-	if (ret < 0)
-		line6_dump_finished(l6dr);
-
-	return ret;
-}
-
-/*
-	Wait for completion (interruptible).
-*/
-int line6_dump_wait_interruptible(struct line6_dump_request *l6dr)
-{
-	return wait_event_interruptible(l6dr->wait,
-					l6dr->in_progress == LINE6_DUMP_NONE);
-}
-
-/*
-	Wait for completion.
-*/
-void line6_dump_wait(struct line6_dump_request *l6dr)
-{
-	wait_event(l6dr->wait, l6dr->in_progress == LINE6_DUMP_NONE);
-}
-
-/*
-	Wait for completion (with timeout).
-*/
-int line6_dump_wait_timeout(struct line6_dump_request *l6dr, long timeout)
-{
-	return wait_event_timeout(l6dr->wait,
-				  l6dr->in_progress == LINE6_DUMP_NONE,
-				  timeout);
-}
-
-/*
-	Initialize dump request buffer.
-*/
-int line6_dumpreq_initbuf(struct line6_dump_request *l6dr, const void *buf,
-			  size_t len, int num)
-{
-	l6dr->reqbufs[num].buffer = kmemdup(buf, len, GFP_KERNEL);
-	if (l6dr->reqbufs[num].buffer == NULL)
-		return -ENOMEM;
-	l6dr->reqbufs[num].length = len;
-	return 0;
-}
-
-/*
-	Initialize dump request data structure (including one buffer).
-*/
-int line6_dumpreq_init(struct line6_dump_request *l6dr, const void *buf,
-		       size_t len)
-{
-	int ret;
-	ret = line6_dumpreq_initbuf(l6dr, buf, len, 0);
-	if (ret < 0)
-		return ret;
-	init_waitqueue_head(&l6dr->wait);
-	return 0;
-}
-
-/*
-	Destruct dump request data structure.
-*/
-void line6_dumpreq_destructbuf(struct line6_dump_request *l6dr, int num)
-{
-	if (l6dr == NULL)
-		return;
-	if (l6dr->reqbufs[num].buffer == NULL)
-		return;
-	kfree(l6dr->reqbufs[num].buffer);
-	l6dr->reqbufs[num].buffer = NULL;
-}
-
-/*
-	Destruct dump request data structure.
-*/
-void line6_dumpreq_destruct(struct line6_dump_request *l6dr)
-{
-	if (l6dr->reqbufs[0].buffer == NULL)
-		return;
-	line6_dumpreq_destructbuf(l6dr, 0);
-}
diff --git a/drivers/staging/line6/dumprequest.h b/drivers/staging/line6/dumprequest.h
deleted file mode 100644
index c17a262..0000000
--- a/drivers/staging/line6/dumprequest.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef DUMPREQUEST_H
-#define DUMPREQUEST_H
-
-#include <linux/usb.h>
-#include <linux/wait.h>
-#include <sound/core.h>
-
-enum {
-	LINE6_DUMP_NONE,
-	LINE6_DUMP_CURRENT
-};
-
-struct line6_dump_reqbuf {
-	/**
-		 Buffer for dump requests.
-	*/
-	unsigned char *buffer;
-
-	/**
-		 Size of dump request.
-	*/
-	size_t length;
-};
-
-/**
-	 Provides the functionality to request channel/model/... dump data from a
-	 Line6 device.
-*/
-struct line6_dump_request {
-	/**
-		 Wait queue for access to program dump data.
-	*/
-	wait_queue_head_t wait;
-
-	/**
-		 Indicates an unfinished program dump request.
-		 0: no dump
-		 1: dump current settings
-		 Other device-specific values are also allowed.
-	*/
-	int in_progress;
-
-	/**
-		 Dump request buffers
-	*/
-	struct line6_dump_reqbuf reqbufs[1];
-};
-
-extern void line6_dump_finished(struct line6_dump_request *l6dr);
-extern int line6_dump_request_async(struct line6_dump_request *l6dr,
-				    struct usb_line6 *line6, int num, int dest);
-extern void line6_dump_started(struct line6_dump_request *l6dr, int dest);
-extern void line6_dumpreq_destruct(struct line6_dump_request *l6dr);
-extern void line6_dumpreq_destructbuf(struct line6_dump_request *l6dr, int num);
-extern int line6_dumpreq_init(struct line6_dump_request *l6dr, const void *buf,
-			      size_t len);
-extern int line6_dumpreq_initbuf(struct line6_dump_request *l6dr,
-				 const void *buf, size_t len, int num);
-extern void line6_invalidate_current(struct line6_dump_request *l6dr);
-extern void line6_dump_wait(struct line6_dump_request *l6dr);
-extern int line6_dump_wait_interruptible(struct line6_dump_request *l6dr);
-extern int line6_dump_wait_timeout(struct line6_dump_request *l6dr,
-				   long timeout);
-
-#endif
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
deleted file mode 100644
index 5040729..0000000
--- a/drivers/staging/line6/midi.c
+++ /dev/null
@@ -1,446 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-#include <linux/usb.h>
-#include <sound/core.h>
-#include <sound/rawmidi.h>
-
-#include "audio.h"
-#include "driver.h"
-#include "midi.h"
-#include "pod.h"
-#include "usbdefs.h"
-
-#define line6_rawmidi_substream_midi(substream) \
-	((struct snd_line6_midi *)((substream)->rmidi->private_data))
-
-static int send_midi_async(struct usb_line6 *line6, unsigned char *data,
-			   int length);
-
-/*
-	Pass data received via USB to MIDI.
-*/
-void line6_midi_receive(struct usb_line6 *line6, unsigned char *data,
-			int length)
-{
-	if (line6->line6midi->substream_receive)
-		snd_rawmidi_receive(line6->line6midi->substream_receive,
-				    data, length);
-}
-
-/*
-	Read data from MIDI buffer and transmit them via USB.
-*/
-static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
-{
-	struct usb_line6 *line6 =
-	    line6_rawmidi_substream_midi(substream)->line6;
-	struct snd_line6_midi *line6midi = line6->line6midi;
-	struct MidiBuffer *mb = &line6midi->midibuf_out;
-	unsigned long flags;
-	unsigned char chunk[line6->max_packet_size];
-	int req, done;
-
-	spin_lock_irqsave(&line6->line6midi->midi_transmit_lock, flags);
-
-	for (;;) {
-		req = min(line6_midibuf_bytes_free(mb), line6->max_packet_size);
-		done = snd_rawmidi_transmit_peek(substream, chunk, req);
-
-		if (done == 0)
-			break;
-
-#ifdef CONFIG_LINE6_USB_DUMP_MIDI
-		line6_write_hexdump(line6, 's', chunk, done);
-#endif
-		line6_midibuf_write(mb, chunk, done);
-		snd_rawmidi_transmit_ack(substream, done);
-	}
-
-	for (;;) {
-		done = line6_midibuf_read(mb, chunk, line6->max_packet_size);
-
-		if (done == 0)
-			break;
-
-		if (line6_midibuf_skip_message
-		    (mb, line6midi->midi_mask_transmit))
-			continue;
-
-		send_midi_async(line6, chunk, done);
-	}
-
-	spin_unlock_irqrestore(&line6->line6midi->midi_transmit_lock, flags);
-}
-
-/*
-	Notification of completion of MIDI transmission.
-*/
-static void midi_sent(struct urb *urb)
-{
-	unsigned long flags;
-	int status;
-	int num;
-	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
-
-	status = urb->status;
-	kfree(urb->transfer_buffer);
-	usb_free_urb(urb);
-
-	if (status == -ESHUTDOWN)
-		return;
-
-	spin_lock_irqsave(&line6->line6midi->send_urb_lock, flags);
-	num = --line6->line6midi->num_active_send_urbs;
-
-	if (num == 0) {
-		line6_midi_transmit(line6->line6midi->substream_transmit);
-		num = line6->line6midi->num_active_send_urbs;
-	}
-
-	if (num == 0)
-		wake_up(&line6->line6midi->send_wait);
-
-	spin_unlock_irqrestore(&line6->line6midi->send_urb_lock, flags);
-}
-
-/*
-	Send an asynchronous MIDI message.
-	Assumes that line6->line6midi->send_urb_lock is held
-	(i.e., this function is serialized).
-*/
-static int send_midi_async(struct usb_line6 *line6, unsigned char *data,
-			   int length)
-{
-	struct urb *urb;
-	int retval;
-	unsigned char *transfer_buffer;
-
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
-
-	if (urb == NULL) {
-		dev_err(line6->ifcdev, "Out of memory\n");
-		return -ENOMEM;
-	}
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', data, length);
-#endif
-
-	transfer_buffer = kmemdup(data, length, GFP_ATOMIC);
-
-	if (transfer_buffer == NULL) {
-		usb_free_urb(urb);
-		dev_err(line6->ifcdev, "Out of memory\n");
-		return -ENOMEM;
-	}
-
-	usb_fill_int_urb(urb, line6->usbdev,
-			 usb_sndbulkpipe(line6->usbdev,
-					 line6->ep_control_write),
-			 transfer_buffer, length, midi_sent, line6,
-			 line6->interval);
-	urb->actual_length = 0;
-	retval = usb_submit_urb(urb, GFP_ATOMIC);
-
-	if (retval < 0) {
-		dev_err(line6->ifcdev, "usb_submit_urb failed\n");
-		usb_free_urb(urb);
-		return -EINVAL;
-	}
-
-	++line6->line6midi->num_active_send_urbs;
-
-	switch (line6->usbdev->descriptor.idProduct) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTLIVE:
-	case LINE6_DEVID_PODXTPRO:
-	case LINE6_DEVID_POCKETPOD:
-		line6_pod_midi_postprocess((struct usb_line6_pod *)line6, data,
-					   length);
-		break;
-
-	case LINE6_DEVID_VARIAX:
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD500:
-		break;
-
-	default:
-		MISSING_CASE;
-	}
-
-	return 0;
-}
-
-static int line6_midi_output_open(struct snd_rawmidi_substream *substream)
-{
-	return 0;
-}
-
-static int line6_midi_output_close(struct snd_rawmidi_substream *substream)
-{
-	return 0;
-}
-
-static void line6_midi_output_trigger(struct snd_rawmidi_substream *substream,
-				      int up)
-{
-	unsigned long flags;
-	struct usb_line6 *line6 =
-	    line6_rawmidi_substream_midi(substream)->line6;
-
-	line6->line6midi->substream_transmit = substream;
-	spin_lock_irqsave(&line6->line6midi->send_urb_lock, flags);
-
-	if (line6->line6midi->num_active_send_urbs == 0)
-		line6_midi_transmit(substream);
-
-	spin_unlock_irqrestore(&line6->line6midi->send_urb_lock, flags);
-}
-
-static void line6_midi_output_drain(struct snd_rawmidi_substream *substream)
-{
-	struct usb_line6 *line6 =
-	    line6_rawmidi_substream_midi(substream)->line6;
-	struct snd_line6_midi *midi = line6->line6midi;
-	wait_event_interruptible(midi->send_wait,
-				 midi->num_active_send_urbs == 0);
-}
-
-static int line6_midi_input_open(struct snd_rawmidi_substream *substream)
-{
-	return 0;
-}
-
-static int line6_midi_input_close(struct snd_rawmidi_substream *substream)
-{
-	return 0;
-}
-
-static void line6_midi_input_trigger(struct snd_rawmidi_substream *substream,
-				     int up)
-{
-	struct usb_line6 *line6 =
-	    line6_rawmidi_substream_midi(substream)->line6;
-
-	if (up)
-		line6->line6midi->substream_receive = substream;
-	else
-		line6->line6midi->substream_receive = 0;
-}
-
-static struct snd_rawmidi_ops line6_midi_output_ops = {
-	.open = line6_midi_output_open,
-	.close = line6_midi_output_close,
-	.trigger = line6_midi_output_trigger,
-	.drain = line6_midi_output_drain,
-};
-
-static struct snd_rawmidi_ops line6_midi_input_ops = {
-	.open = line6_midi_input_open,
-	.close = line6_midi_input_close,
-	.trigger = line6_midi_input_trigger,
-};
-
-/*
-	Cleanup the Line6 MIDI device.
-*/
-static void line6_cleanup_midi(struct snd_rawmidi *rmidi)
-{
-}
-
-/* Create a MIDI device */
-static int snd_line6_new_midi(struct snd_line6_midi *line6midi)
-{
-	struct snd_rawmidi *rmidi;
-	int err;
-
-	err = snd_rawmidi_new(line6midi->line6->card, "Line6 MIDI", 0, 1, 1,
-			      &rmidi);
-	if (err < 0)
-		return err;
-
-	rmidi->private_data = line6midi;
-	rmidi->private_free = line6_cleanup_midi;
-	strcpy(rmidi->id, line6midi->line6->properties->id);
-	strcpy(rmidi->name, line6midi->line6->properties->name);
-
-	rmidi->info_flags =
-	    SNDRV_RAWMIDI_INFO_OUTPUT |
-	    SNDRV_RAWMIDI_INFO_INPUT | SNDRV_RAWMIDI_INFO_DUPLEX;
-
-	snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT,
-			    &line6_midi_output_ops);
-	snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_INPUT,
-			    &line6_midi_input_ops);
-	return 0;
-}
-
-/*
-	"read" request on "midi_mask_transmit" special file.
-*/
-static ssize_t midi_get_midi_mask_transmit(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", line6->line6midi->midi_mask_transmit);
-}
-
-/*
-	"write" request on "midi_mask" special file.
-*/
-static ssize_t midi_set_midi_mask_transmit(struct device *dev,
-					   struct device_attribute *attr,
-					   const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	unsigned short value;
-	int ret;
-
-	ret = kstrtou16(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	line6->line6midi->midi_mask_transmit = value;
-	return count;
-}
-
-/*
-	"read" request on "midi_mask_receive" special file.
-*/
-static ssize_t midi_get_midi_mask_receive(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", line6->line6midi->midi_mask_receive);
-}
-
-/*
-	"write" request on "midi_mask" special file.
-*/
-static ssize_t midi_set_midi_mask_receive(struct device *dev,
-					  struct device_attribute *attr,
-					  const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	unsigned short value;
-	int ret;
-
-	ret = kstrtou16(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	line6->line6midi->midi_mask_receive = value;
-	return count;
-}
-
-static DEVICE_ATTR(midi_mask_transmit, S_IWUSR | S_IRUGO,
-		   midi_get_midi_mask_transmit, midi_set_midi_mask_transmit);
-static DEVICE_ATTR(midi_mask_receive, S_IWUSR | S_IRUGO,
-		   midi_get_midi_mask_receive, midi_set_midi_mask_receive);
-
-/* MIDI device destructor */
-static int snd_line6_midi_free(struct snd_device *device)
-{
-	struct snd_line6_midi *line6midi = device->device_data;
-	device_remove_file(line6midi->line6->ifcdev,
-			   &dev_attr_midi_mask_transmit);
-	device_remove_file(line6midi->line6->ifcdev,
-			   &dev_attr_midi_mask_receive);
-	line6_midibuf_destroy(&line6midi->midibuf_in);
-	line6_midibuf_destroy(&line6midi->midibuf_out);
-	return 0;
-}
-
-/*
-	Initialize the Line6 MIDI subsystem.
-*/
-int line6_init_midi(struct usb_line6 *line6)
-{
-	static struct snd_device_ops midi_ops = {
-		.dev_free = snd_line6_midi_free,
-	};
-
-	int err;
-	struct snd_line6_midi *line6midi;
-
-	if (!(line6->properties->capabilities & LINE6_BIT_CONTROL)) {
-		/* skip MIDI initialization and report success */
-		return 0;
-	}
-
-	line6midi = kzalloc(sizeof(struct snd_line6_midi), GFP_KERNEL);
-
-	if (line6midi == NULL)
-		return -ENOMEM;
-
-	err = line6_midibuf_init(&line6midi->midibuf_in, MIDI_BUFFER_SIZE, 0);
-	if (err < 0) {
-		kfree(line6midi);
-		return err;
-	}
-
-	err = line6_midibuf_init(&line6midi->midibuf_out, MIDI_BUFFER_SIZE, 1);
-	if (err < 0) {
-		kfree(line6midi->midibuf_in.buf);
-		kfree(line6midi);
-		return err;
-	}
-
-	line6midi->line6 = line6;
-
-	switch (line6->product) {
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD500:
-		line6midi->midi_mask_transmit = 1;
-		line6midi->midi_mask_receive = 1;
-		break;
-
-	default:
-		line6midi->midi_mask_transmit = 1;
-		line6midi->midi_mask_receive = 4;
-	}
-
-	line6->line6midi = line6midi;
-
-	err = snd_device_new(line6->card, SNDRV_DEV_RAWMIDI, line6midi,
-			     &midi_ops);
-	if (err < 0)
-		return err;
-
-	snd_card_set_dev(line6->card, line6->ifcdev);
-
-	err = snd_line6_new_midi(line6midi);
-	if (err < 0)
-		return err;
-
-	err = device_create_file(line6->ifcdev, &dev_attr_midi_mask_transmit);
-	if (err < 0)
-		return err;
-
-	err = device_create_file(line6->ifcdev, &dev_attr_midi_mask_receive);
-	if (err < 0)
-		return err;
-
-	init_waitqueue_head(&line6midi->send_wait);
-	spin_lock_init(&line6midi->send_urb_lock);
-	spin_lock_init(&line6midi->midi_transmit_lock);
-	return 0;
-}
diff --git a/drivers/staging/line6/midi.h b/drivers/staging/line6/midi.h
deleted file mode 100644
index 4a9e9f9..0000000
--- a/drivers/staging/line6/midi.h
+++ /dev/null
@@ -1,82 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef MIDI_H
-#define MIDI_H
-
-#include <sound/rawmidi.h>
-
-#include "midibuf.h"
-
-#define MIDI_BUFFER_SIZE 1024
-
-struct snd_line6_midi {
-	/**
-		 Pointer back to the Line6 driver data structure.
-	*/
-	struct usb_line6 *line6;
-
-	/**
-		 MIDI substream for receiving (or NULL if not active).
-	*/
-	struct snd_rawmidi_substream *substream_receive;
-
-	/**
-		 MIDI substream for transmitting (or NULL if not active).
-	*/
-	struct snd_rawmidi_substream *substream_transmit;
-
-	/**
-		 Number of currently active MIDI send URBs.
-	*/
-	int num_active_send_urbs;
-
-	/**
-		 Spin lock to protect updates of send_urb.
-	*/
-	spinlock_t send_urb_lock;
-
-	/**
-		 Spin lock to protect MIDI buffer handling.
-	*/
-	spinlock_t midi_transmit_lock;
-
-	/**
-		 Wait queue for MIDI transmission.
-	*/
-	wait_queue_head_t send_wait;
-
-	/**
-		 Bit mask for output MIDI channels.
-	*/
-	unsigned short midi_mask_transmit;
-
-	/**
-		 Bit mask for input MIDI channels.
-	*/
-	unsigned short midi_mask_receive;
-
-	/**
-		 Buffer for incoming MIDI stream.
-	*/
-	struct MidiBuffer midibuf_in;
-
-	/**
-		 Buffer for outgoing MIDI stream.
-	*/
-	struct MidiBuffer midibuf_out;
-};
-
-extern int line6_init_midi(struct usb_line6 *line6);
-extern void line6_midi_receive(struct usb_line6 *line6, unsigned char *data,
-			       int length);
-
-#endif
diff --git a/drivers/staging/line6/midibuf.c b/drivers/staging/line6/midibuf.c
deleted file mode 100644
index 836e8c8..0000000
--- a/drivers/staging/line6/midibuf.c
+++ /dev/null
@@ -1,264 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-
-#include "midibuf.h"
-
-static int midibuf_message_length(unsigned char code)
-{
-	if (code < 0x80)
-		return -1;
-	else if (code < 0xf0) {
-		static const int length[] = { 3, 3, 3, 3, 2, 2, 3 };
-		return length[(code >> 4) - 8];
-	} else {
-		/*
-		   Note that according to the MIDI specification 0xf2 is
-		   the "Song Position Pointer", but this is used by Line6
-		   to send sysex messages to the host.
-		 */
-		static const int length[] = { -1, 2, -1, 2, -1, -1, 1, 1, 1, 1,
-			1, 1, 1, -1, 1, 1
-		};
-		return length[code & 0x0f];
-	}
-}
-
-static int midibuf_is_empty(struct MidiBuffer *this)
-{
-	return (this->pos_read == this->pos_write) && !this->full;
-}
-
-static int midibuf_is_full(struct MidiBuffer *this)
-{
-	return this->full;
-}
-
-void line6_midibuf_reset(struct MidiBuffer *this)
-{
-	this->pos_read = this->pos_write = this->full = 0;
-	this->command_prev = -1;
-}
-
-int line6_midibuf_init(struct MidiBuffer *this, int size, int split)
-{
-	this->buf = kmalloc(size, GFP_KERNEL);
-
-	if (this->buf == NULL)
-		return -ENOMEM;
-
-	this->size = size;
-	this->split = split;
-	line6_midibuf_reset(this);
-	return 0;
-}
-
-void line6_midibuf_status(struct MidiBuffer *this)
-{
-	pr_debug("midibuf size=%d split=%d pos_read=%d pos_write=%d "
-	       "full=%d command_prev=%02x\n", this->size, this->split,
-	       this->pos_read, this->pos_write, this->full, this->command_prev);
-}
-
-int line6_midibuf_bytes_free(struct MidiBuffer *this)
-{
-	return
-	    midibuf_is_full(this) ?
-	    0 :
-	    (this->pos_read - this->pos_write + this->size - 1) % this->size +
-	    1;
-}
-
-int line6_midibuf_bytes_used(struct MidiBuffer *this)
-{
-	return
-	    midibuf_is_empty(this) ?
-	    0 :
-	    (this->pos_write - this->pos_read + this->size - 1) % this->size +
-	    1;
-}
-
-int line6_midibuf_write(struct MidiBuffer *this, unsigned char *data,
-			int length)
-{
-	int bytes_free;
-	int length1, length2;
-	int skip_active_sense = 0;
-
-	if (midibuf_is_full(this) || (length <= 0))
-		return 0;
-
-	/* skip trailing active sense */
-	if (data[length - 1] == 0xfe) {
-		--length;
-		skip_active_sense = 1;
-	}
-
-	bytes_free = line6_midibuf_bytes_free(this);
-
-	if (length > bytes_free)
-		length = bytes_free;
-
-	if (length > 0) {
-		length1 = this->size - this->pos_write;
-
-		if (length < length1) {
-			/* no buffer wraparound */
-			memcpy(this->buf + this->pos_write, data, length);
-			this->pos_write += length;
-		} else {
-			/* buffer wraparound */
-			length2 = length - length1;
-			memcpy(this->buf + this->pos_write, data, length1);
-			memcpy(this->buf, data + length1, length2);
-			this->pos_write = length2;
-		}
-
-		if (this->pos_write == this->pos_read)
-			this->full = 1;
-	}
-
-	return length + skip_active_sense;
-}
-
-int line6_midibuf_read(struct MidiBuffer *this, unsigned char *data, int length)
-{
-	int bytes_used;
-	int length1, length2;
-	int command;
-	int midi_length;
-	int repeat = 0;
-	int i;
-
-	/* we need to be able to store at least a 3 byte MIDI message */
-	if (length < 3)
-		return -EINVAL;
-
-	if (midibuf_is_empty(this))
-		return 0;
-
-	bytes_used = line6_midibuf_bytes_used(this);
-
-	if (length > bytes_used)
-		length = bytes_used;
-
-	length1 = this->size - this->pos_read;
-
-	/* check MIDI command length */
-	command = this->buf[this->pos_read];
-
-	if (command & 0x80) {
-		midi_length = midibuf_message_length(command);
-		this->command_prev = command;
-	} else {
-		if (this->command_prev > 0) {
-			int midi_length_prev =
-			    midibuf_message_length(this->command_prev);
-
-			if (midi_length_prev > 0) {
-				midi_length = midi_length_prev - 1;
-				repeat = 1;
-			} else
-				midi_length = -1;
-		} else
-			midi_length = -1;
-	}
-
-	if (midi_length < 0) {
-		/* search for end of message */
-		if (length < length1) {
-			/* no buffer wraparound */
-			for (i = 1; i < length; ++i)
-				if (this->buf[this->pos_read + i] & 0x80)
-					break;
-
-			midi_length = i;
-		} else {
-			/* buffer wraparound */
-			length2 = length - length1;
-
-			for (i = 1; i < length1; ++i)
-				if (this->buf[this->pos_read + i] & 0x80)
-					break;
-
-			if (i < length1)
-				midi_length = i;
-			else {
-				for (i = 0; i < length2; ++i)
-					if (this->buf[i] & 0x80)
-						break;
-
-				midi_length = length1 + i;
-			}
-		}
-
-		if (midi_length == length)
-			midi_length = -1;	/* end of message not found */
-	}
-
-	if (midi_length < 0) {
-		if (!this->split)
-			return 0;	/* command is not yet complete */
-	} else {
-		if (length < midi_length)
-			return 0;	/* command is not yet complete */
-
-		length = midi_length;
-	}
-
-	if (length < length1) {
-		/* no buffer wraparound */
-		memcpy(data + repeat, this->buf + this->pos_read, length);
-		this->pos_read += length;
-	} else {
-		/* buffer wraparound */
-		length2 = length - length1;
-		memcpy(data + repeat, this->buf + this->pos_read, length1);
-		memcpy(data + repeat + length1, this->buf, length2);
-		this->pos_read = length2;
-	}
-
-	if (repeat)
-		data[0] = this->command_prev;
-
-	this->full = 0;
-	return length + repeat;
-}
-
-int line6_midibuf_ignore(struct MidiBuffer *this, int length)
-{
-	int bytes_used = line6_midibuf_bytes_used(this);
-
-	if (length > bytes_used)
-		length = bytes_used;
-
-	this->pos_read = (this->pos_read + length) % this->size;
-	this->full = 0;
-	return length;
-}
-
-int line6_midibuf_skip_message(struct MidiBuffer *this, unsigned short mask)
-{
-	int cmd = this->command_prev;
-
-	if ((cmd >= 0x80) && (cmd < 0xf0))
-		if ((mask & (1 << (cmd & 0x0f))) == 0)
-			return 1;
-
-	return 0;
-}
-
-void line6_midibuf_destroy(struct MidiBuffer *this)
-{
-	kfree(this->buf);
-	this->buf = NULL;
-}
diff --git a/drivers/staging/line6/midibuf.h b/drivers/staging/line6/midibuf.h
deleted file mode 100644
index 444cb3a..0000000
--- a/drivers/staging/line6/midibuf.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef MIDIBUF_H
-#define MIDIBUF_H
-
-struct MidiBuffer {
-	unsigned char *buf;
-	int size;
-	int split;
-	int pos_read, pos_write;
-	int full;
-	int command_prev;
-};
-
-extern int line6_midibuf_bytes_used(struct MidiBuffer *mb);
-extern int line6_midibuf_bytes_free(struct MidiBuffer *mb);
-extern void line6_midibuf_destroy(struct MidiBuffer *mb);
-extern int line6_midibuf_ignore(struct MidiBuffer *mb, int length);
-extern int line6_midibuf_init(struct MidiBuffer *mb, int size, int split);
-extern int line6_midibuf_read(struct MidiBuffer *mb, unsigned char *data,
-			      int length);
-extern void line6_midibuf_reset(struct MidiBuffer *mb);
-extern int line6_midibuf_skip_message(struct MidiBuffer *mb,
-				      unsigned short mask);
-extern void line6_midibuf_status(struct MidiBuffer *mb);
-extern int line6_midibuf_write(struct MidiBuffer *mb, unsigned char *data,
-			       int length);
-
-#endif
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
deleted file mode 100644
index 7fe44a6..0000000
--- a/drivers/staging/line6/pcm.c
+++ /dev/null
@@ -1,570 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-#include <sound/core.h>
-#include <sound/control.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-
-#include "audio.h"
-#include "capture.h"
-#include "driver.h"
-#include "playback.h"
-#include "pod.h"
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-
-static struct snd_line6_pcm *dev2pcm(struct device *dev)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	struct snd_line6_pcm *line6pcm = line6->line6pcm;
-	return line6pcm;
-}
-
-/*
-	"read" request on "impulse_volume" special file.
-*/
-static ssize_t pcm_get_impulse_volume(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%d\n", dev2pcm(dev)->impulse_volume);
-}
-
-/*
-	"write" request on "impulse_volume" special file.
-*/
-static ssize_t pcm_set_impulse_volume(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf, size_t count)
-{
-	struct snd_line6_pcm *line6pcm = dev2pcm(dev);
-	int value;
-	int rv;
-
-	rv = kstrtoint(buf, 10, &value);
-	if (rv < 0)
-		return rv;
-
-	line6pcm->impulse_volume = value;
-
-	if (value > 0)
-		line6_pcm_acquire(line6pcm, LINE6_BITS_PCM_IMPULSE);
-	else
-		line6_pcm_release(line6pcm, LINE6_BITS_PCM_IMPULSE);
-
-	return count;
-}
-
-/*
-	"read" request on "impulse_period" special file.
-*/
-static ssize_t pcm_get_impulse_period(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%d\n", dev2pcm(dev)->impulse_period);
-}
-
-/*
-	"write" request on "impulse_period" special file.
-*/
-static ssize_t pcm_set_impulse_period(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf, size_t count)
-{
-	dev2pcm(dev)->impulse_period = simple_strtoul(buf, NULL, 10);
-	return count;
-}
-
-static DEVICE_ATTR(impulse_volume, S_IWUSR | S_IRUGO, pcm_get_impulse_volume,
-		   pcm_set_impulse_volume);
-static DEVICE_ATTR(impulse_period, S_IWUSR | S_IRUGO, pcm_get_impulse_period,
-		   pcm_set_impulse_period);
-
-#endif
-
-static bool test_flags(unsigned long flags0, unsigned long flags1,
-		       unsigned long mask)
-{
-	return ((flags0 & mask) == 0) && ((flags1 & mask) != 0);
-}
-
-int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
-{
-	unsigned long flags_old =
-	    __sync_fetch_and_or(&line6pcm->flags, channels);
-	unsigned long flags_new = flags_old | channels;
-	unsigned long flags_final = flags_old;
-	int err = 0;
-
-	line6pcm->prev_fbuf = NULL;
-
-	if (test_flags(flags_old, flags_new, LINE6_BITS_CAPTURE_BUFFER)) {
-		/* We may be invoked multiple times in a row so allocate once only */
-		if (!line6pcm->buffer_in) {
-			line6pcm->buffer_in =
-				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
-					line6pcm->max_packet_size, GFP_KERNEL);
-
-			if (!line6pcm->buffer_in) {
-				dev_err(line6pcm->line6->ifcdev,
-					"cannot malloc capture buffer\n");
-				err = -ENOMEM;
-				goto pcm_acquire_error;
-			}
-
-			flags_final |= channels & LINE6_BITS_CAPTURE_BUFFER;
-		}
-	}
-
-	if (test_flags(flags_old, flags_new, LINE6_BITS_CAPTURE_STREAM)) {
-		/*
-		   Waiting for completion of active URBs in the stop handler is
-		   a bug, we therefore report an error if capturing is restarted
-		   too soon.
-		 */
-		if (line6pcm->active_urb_in | line6pcm->unlink_urb_in) {
-			dev_err(line6pcm->line6->ifcdev, "Device not yet ready\n");
-			return -EBUSY;
-		}
-
-		line6pcm->count_in = 0;
-		line6pcm->prev_fsize = 0;
-		err = line6_submit_audio_in_all_urbs(line6pcm);
-
-		if (err < 0)
-			goto pcm_acquire_error;
-
-		flags_final |= channels & LINE6_BITS_CAPTURE_STREAM;
-	}
-
-	if (test_flags(flags_old, flags_new, LINE6_BITS_PLAYBACK_BUFFER)) {
-		/* We may be invoked multiple times in a row so allocate once only */
-		if (!line6pcm->buffer_out) {
-			line6pcm->buffer_out =
-				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
-					line6pcm->max_packet_size, GFP_KERNEL);
-
-			if (!line6pcm->buffer_out) {
-				dev_err(line6pcm->line6->ifcdev,
-					"cannot malloc playback buffer\n");
-				err = -ENOMEM;
-				goto pcm_acquire_error;
-			}
-
-			flags_final |= channels & LINE6_BITS_PLAYBACK_BUFFER;
-		}
-	}
-
-	if (test_flags(flags_old, flags_new, LINE6_BITS_PLAYBACK_STREAM)) {
-		/*
-		  See comment above regarding PCM restart.
-		*/
-		if (line6pcm->active_urb_out | line6pcm->unlink_urb_out) {
-			dev_err(line6pcm->line6->ifcdev, "Device not yet ready\n");
-			return -EBUSY;
-		}
-
-		line6pcm->count_out = 0;
-		err = line6_submit_audio_out_all_urbs(line6pcm);
-
-		if (err < 0)
-			goto pcm_acquire_error;
-
-		flags_final |= channels & LINE6_BITS_PLAYBACK_STREAM;
-	}
-
-	return 0;
-
-pcm_acquire_error:
-	/*
-	   If not all requested resources/streams could be obtained, release
-	   those which were successfully obtained (if any).
-	*/
-	line6_pcm_release(line6pcm, flags_final & channels);
-	return err;
-}
-
-int line6_pcm_release(struct snd_line6_pcm *line6pcm, int channels)
-{
-	unsigned long flags_old =
-	    __sync_fetch_and_and(&line6pcm->flags, ~channels);
-	unsigned long flags_new = flags_old & ~channels;
-
-	if (test_flags(flags_new, flags_old, LINE6_BITS_CAPTURE_STREAM))
-		line6_unlink_audio_in_urbs(line6pcm);
-
-	if (test_flags(flags_new, flags_old, LINE6_BITS_CAPTURE_BUFFER)) {
-		line6_wait_clear_audio_in_urbs(line6pcm);
-		line6_free_capture_buffer(line6pcm);
-	}
-
-	if (test_flags(flags_new, flags_old, LINE6_BITS_PLAYBACK_STREAM))
-		line6_unlink_audio_out_urbs(line6pcm);
-
-	if (test_flags(flags_new, flags_old, LINE6_BITS_PLAYBACK_BUFFER)) {
-		line6_wait_clear_audio_out_urbs(line6pcm);
-		line6_free_playback_buffer(line6pcm);
-	}
-
-	return 0;
-}
-
-/* trigger callback */
-int snd_line6_trigger(struct snd_pcm_substream *substream, int cmd)
-{
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-	struct snd_pcm_substream *s;
-	int err;
-	unsigned long flags;
-
-	spin_lock_irqsave(&line6pcm->lock_trigger, flags);
-	clear_bit(LINE6_INDEX_PREPARED, &line6pcm->flags);
-
-	snd_pcm_group_for_each_entry(s, substream) {
-		switch (s->stream) {
-		case SNDRV_PCM_STREAM_PLAYBACK:
-			err = snd_line6_playback_trigger(line6pcm, cmd);
-
-			if (err < 0) {
-				spin_unlock_irqrestore(&line6pcm->lock_trigger,
-						       flags);
-				return err;
-			}
-
-			break;
-
-		case SNDRV_PCM_STREAM_CAPTURE:
-			err = snd_line6_capture_trigger(line6pcm, cmd);
-
-			if (err < 0) {
-				spin_unlock_irqrestore(&line6pcm->lock_trigger,
-						       flags);
-				return err;
-			}
-
-			break;
-
-		default:
-			dev_err(line6pcm->line6->ifcdev,
-				"Unknown stream direction %d\n", s->stream);
-		}
-	}
-
-	spin_unlock_irqrestore(&line6pcm->lock_trigger, flags);
-	return 0;
-}
-
-/* control info callback */
-static int snd_line6_control_playback_info(struct snd_kcontrol *kcontrol,
-					   struct snd_ctl_elem_info *uinfo)
-{
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
-	uinfo->count = 2;
-	uinfo->value.integer.min = 0;
-	uinfo->value.integer.max = 256;
-	return 0;
-}
-
-/* control get callback */
-static int snd_line6_control_playback_get(struct snd_kcontrol *kcontrol,
-					  struct snd_ctl_elem_value *ucontrol)
-{
-	int i;
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-
-	for (i = 2; i--;)
-		ucontrol->value.integer.value[i] = line6pcm->volume_playback[i];
-
-	return 0;
-}
-
-/* control put callback */
-static int snd_line6_control_playback_put(struct snd_kcontrol *kcontrol,
-					  struct snd_ctl_elem_value *ucontrol)
-{
-	int i, changed = 0;
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-
-	for (i = 2; i--;)
-		if (line6pcm->volume_playback[i] !=
-		    ucontrol->value.integer.value[i]) {
-			line6pcm->volume_playback[i] =
-			    ucontrol->value.integer.value[i];
-			changed = 1;
-		}
-
-	return changed;
-}
-
-/* control definition */
-static struct snd_kcontrol_new line6_control_playback = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "PCM Playback Volume",
-	.index = 0,
-	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
-	.info = snd_line6_control_playback_info,
-	.get = snd_line6_control_playback_get,
-	.put = snd_line6_control_playback_put
-};
-
-/*
-	Cleanup the PCM device.
-*/
-static void line6_cleanup_pcm(struct snd_pcm *pcm)
-{
-	int i;
-	struct snd_line6_pcm *line6pcm = snd_pcm_chip(pcm);
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	device_remove_file(line6pcm->line6->ifcdev, &dev_attr_impulse_volume);
-	device_remove_file(line6pcm->line6->ifcdev, &dev_attr_impulse_period);
-#endif
-
-	for (i = LINE6_ISO_BUFFERS; i--;) {
-		if (line6pcm->urb_audio_out[i]) {
-			usb_kill_urb(line6pcm->urb_audio_out[i]);
-			usb_free_urb(line6pcm->urb_audio_out[i]);
-		}
-		if (line6pcm->urb_audio_in[i]) {
-			usb_kill_urb(line6pcm->urb_audio_in[i]);
-			usb_free_urb(line6pcm->urb_audio_in[i]);
-		}
-	}
-}
-
-/* create a PCM device */
-static int snd_line6_new_pcm(struct snd_line6_pcm *line6pcm)
-{
-	struct snd_pcm *pcm;
-	int err;
-
-	err = snd_pcm_new(line6pcm->line6->card,
-			  (char *)line6pcm->line6->properties->name,
-			  0, 1, 1, &pcm);
-	if (err < 0)
-		return err;
-
-	pcm->private_data = line6pcm;
-	pcm->private_free = line6_cleanup_pcm;
-	line6pcm->pcm = pcm;
-	strcpy(pcm->name, line6pcm->line6->properties->name);
-
-	/* set operators */
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
-			&snd_line6_playback_ops);
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_line6_capture_ops);
-
-	/* pre-allocation of buffers */
-	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_CONTINUOUS,
-					      snd_dma_continuous_data
-					      (GFP_KERNEL), 64 * 1024,
-					      128 * 1024);
-
-	return 0;
-}
-
-/* PCM device destructor */
-static int snd_line6_pcm_free(struct snd_device *device)
-{
-	return 0;
-}
-
-/*
-	Stop substream if still running.
-*/
-static void pcm_disconnect_substream(struct snd_pcm_substream *substream)
-{
-	if (substream->runtime && snd_pcm_running(substream))
-		snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
-}
-
-/*
-	Stop PCM stream.
-*/
-void line6_pcm_disconnect(struct snd_line6_pcm *line6pcm)
-{
-	pcm_disconnect_substream(get_substream
-				 (line6pcm, SNDRV_PCM_STREAM_CAPTURE));
-	pcm_disconnect_substream(get_substream
-				 (line6pcm, SNDRV_PCM_STREAM_PLAYBACK));
-	line6_unlink_wait_clear_audio_out_urbs(line6pcm);
-	line6_unlink_wait_clear_audio_in_urbs(line6pcm);
-}
-
-/*
-	Create and register the PCM device and mixer entries.
-	Create URBs for playback and capture.
-*/
-int line6_init_pcm(struct usb_line6 *line6,
-		   struct line6_pcm_properties *properties)
-{
-	static struct snd_device_ops pcm_ops = {
-		.dev_free = snd_line6_pcm_free,
-	};
-
-	int err;
-	int ep_read = 0, ep_write = 0;
-	struct snd_line6_pcm *line6pcm;
-
-	if (!(line6->properties->capabilities & LINE6_BIT_PCM))
-		return 0;	/* skip PCM initialization and report success */
-
-	/* initialize PCM subsystem based on product id: */
-	switch (line6->product) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTLIVE:
-	case LINE6_DEVID_PODXTPRO:
-	case LINE6_DEVID_PODHD300:
-		ep_read = 0x82;
-		ep_write = 0x01;
-		break;
-
-	case LINE6_DEVID_PODHD500:
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
-		ep_read = 0x86;
-		ep_write = 0x02;
-		break;
-
-	case LINE6_DEVID_POCKETPOD:
-		ep_read = 0x82;
-		ep_write = 0x02;
-		break;
-
-	case LINE6_DEVID_GUITARPORT:
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-		ep_read = 0x82;
-		ep_write = 0x01;
-		break;
-
-		/* this is for interface_number == 1:
-		   case LINE6_DEVID_TONEPORT_UX2:
-		   case LINE6_DEVID_PODSTUDIO_UX2:
-		   ep_read  = 0x87;
-		   ep_write = 0x00;
-		   break;
-		 */
-
-	default:
-		MISSING_CASE;
-	}
-
-	line6pcm = kzalloc(sizeof(struct snd_line6_pcm), GFP_KERNEL);
-
-	if (line6pcm == NULL)
-		return -ENOMEM;
-
-	line6pcm->volume_playback[0] = line6pcm->volume_playback[1] = 255;
-	line6pcm->volume_monitor = 255;
-	line6pcm->line6 = line6;
-	line6pcm->ep_audio_read = ep_read;
-	line6pcm->ep_audio_write = ep_write;
-
-	/* Read and write buffers are sized identically, so choose minimum */
-	line6pcm->max_packet_size = min(
-			usb_maxpacket(line6->usbdev,
-				usb_rcvisocpipe(line6->usbdev, ep_read), 0),
-			usb_maxpacket(line6->usbdev,
-				usb_sndisocpipe(line6->usbdev, ep_write), 1));
-
-	line6pcm->properties = properties;
-	line6->line6pcm = line6pcm;
-
-	/* PCM device: */
-	err = snd_device_new(line6->card, SNDRV_DEV_PCM, line6, &pcm_ops);
-	if (err < 0)
-		return err;
-
-	snd_card_set_dev(line6->card, line6->ifcdev);
-
-	err = snd_line6_new_pcm(line6pcm);
-	if (err < 0)
-		return err;
-
-	spin_lock_init(&line6pcm->lock_audio_out);
-	spin_lock_init(&line6pcm->lock_audio_in);
-	spin_lock_init(&line6pcm->lock_trigger);
-
-	err = line6_create_audio_out_urbs(line6pcm);
-	if (err < 0)
-		return err;
-
-	err = line6_create_audio_in_urbs(line6pcm);
-	if (err < 0)
-		return err;
-
-	/* mixer: */
-	err =
-	    snd_ctl_add(line6->card,
-			snd_ctl_new1(&line6_control_playback, line6pcm));
-	if (err < 0)
-		return err;
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	/* impulse response test: */
-	err = device_create_file(line6->ifcdev, &dev_attr_impulse_volume);
-	if (err < 0)
-		return err;
-
-	err = device_create_file(line6->ifcdev, &dev_attr_impulse_period);
-	if (err < 0)
-		return err;
-
-	line6pcm->impulse_period = LINE6_IMPULSE_DEFAULT_PERIOD;
-#endif
-
-	return 0;
-}
-
-/* prepare pcm callback */
-int snd_line6_prepare(struct snd_pcm_substream *substream)
-{
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-
-	switch (substream->stream) {
-	case SNDRV_PCM_STREAM_PLAYBACK:
-		if ((line6pcm->flags & LINE6_BITS_PLAYBACK_STREAM) == 0)
-			line6_unlink_wait_clear_audio_out_urbs(line6pcm);
-
-		break;
-
-	case SNDRV_PCM_STREAM_CAPTURE:
-		if ((line6pcm->flags & LINE6_BITS_CAPTURE_STREAM) == 0)
-			line6_unlink_wait_clear_audio_in_urbs(line6pcm);
-
-		break;
-
-	default:
-		MISSING_CASE;
-	}
-
-	if (!test_and_set_bit(LINE6_INDEX_PREPARED, &line6pcm->flags)) {
-		line6pcm->count_out = 0;
-		line6pcm->pos_out = 0;
-		line6pcm->pos_out_done = 0;
-		line6pcm->bytes_out = 0;
-		line6pcm->count_in = 0;
-		line6pcm->pos_in_done = 0;
-		line6pcm->bytes_in = 0;
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/line6/pcm.h b/drivers/staging/line6/pcm.h
deleted file mode 100644
index 5210ec8..0000000
--- a/drivers/staging/line6/pcm.h
+++ /dev/null
@@ -1,382 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-/*
-	PCM interface to POD series devices.
-*/
-
-#ifndef PCM_H
-#define PCM_H
-
-#include <sound/pcm.h>
-
-#include "driver.h"
-#include "usbdefs.h"
-
-/* number of URBs */
-#define LINE6_ISO_BUFFERS	2
-
-/*
-	number of USB frames per URB
-	The Line6 Windows driver always transmits two frames per packet, but
-	the Linux driver performs significantly better (i.e., lower latency)
-	with only one frame per packet.
-*/
-#define LINE6_ISO_PACKETS	1
-
-/* in a "full speed" device (such as the PODxt Pro) this means 1ms */
-#define LINE6_ISO_INTERVAL	1
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-#define LINE6_IMPULSE_DEFAULT_PERIOD 100
-#endif
-
-/*
-	Get substream from Line6 PCM data structure
-*/
-#define get_substream(line6pcm, stream)	\
-		(line6pcm->pcm->streams[stream].substream)
-
-/*
-	PCM mode bits.
-
-	There are several features of the Line6 USB driver which require PCM
-	data to be exchanged with the device:
-	*) PCM playback and capture via ALSA
-	*) software monitoring (for devices without hardware monitoring)
-	*) optional impulse response measurement
-	However, from the device's point of view, there is just a single
-	capture and playback stream, which must be shared between these
-	subsystems. It is therefore necessary to maintain the state of the
-	subsystems with respect to PCM usage. We define several constants of
-	the form LINE6_BIT_PCM_<subsystem>_<direction>_<resource> with the
-	following meanings:
-	*) <subsystem> is one of
-	-) ALSA: PCM playback and capture via ALSA
-	-) MONITOR: software monitoring
-	-) IMPULSE: optional impulse response measurement
-	*) <direction> is one of
-	-) PLAYBACK: audio output (from host to device)
-	-) CAPTURE: audio input (from device to host)
-	*) <resource> is one of
-	-) BUFFER: buffer required by PCM data stream
-	-) STREAM: actual PCM data stream
-
-	The subsystems call line6_pcm_acquire() to acquire the (shared)
-	resources needed for a particular operation (e.g., allocate the buffer
-	for ALSA playback or start the capture stream for software monitoring).
-	When a resource is no longer needed, it is released by calling
-	line6_pcm_release(). Buffer allocation and stream startup are handled
-	separately to allow the ALSA kernel driver to perform them at
-	appropriate places (since the callback which starts a PCM stream is not
-	allowed to sleep).
-*/
-enum {
-	/* individual bit indices: */
-	LINE6_INDEX_PCM_ALSA_PLAYBACK_BUFFER,
-	LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM,
-	LINE6_INDEX_PCM_ALSA_CAPTURE_BUFFER,
-	LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM,
-	LINE6_INDEX_PCM_MONITOR_PLAYBACK_BUFFER,
-	LINE6_INDEX_PCM_MONITOR_PLAYBACK_STREAM,
-	LINE6_INDEX_PCM_MONITOR_CAPTURE_BUFFER,
-	LINE6_INDEX_PCM_MONITOR_CAPTURE_STREAM,
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	LINE6_INDEX_PCM_IMPULSE_PLAYBACK_BUFFER,
-	LINE6_INDEX_PCM_IMPULSE_PLAYBACK_STREAM,
-	LINE6_INDEX_PCM_IMPULSE_CAPTURE_BUFFER,
-	LINE6_INDEX_PCM_IMPULSE_CAPTURE_STREAM,
-#endif
-	LINE6_INDEX_PAUSE_PLAYBACK,
-	LINE6_INDEX_PREPARED,
-
-	/* individual bit masks: */
-	LINE6_BIT(PCM_ALSA_PLAYBACK_BUFFER),
-	LINE6_BIT(PCM_ALSA_PLAYBACK_STREAM),
-	LINE6_BIT(PCM_ALSA_CAPTURE_BUFFER),
-	LINE6_BIT(PCM_ALSA_CAPTURE_STREAM),
-	LINE6_BIT(PCM_MONITOR_PLAYBACK_BUFFER),
-	LINE6_BIT(PCM_MONITOR_PLAYBACK_STREAM),
-	LINE6_BIT(PCM_MONITOR_CAPTURE_BUFFER),
-	LINE6_BIT(PCM_MONITOR_CAPTURE_STREAM),
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	LINE6_BIT(PCM_IMPULSE_PLAYBACK_BUFFER),
-	LINE6_BIT(PCM_IMPULSE_PLAYBACK_STREAM),
-	LINE6_BIT(PCM_IMPULSE_CAPTURE_BUFFER),
-	LINE6_BIT(PCM_IMPULSE_CAPTURE_STREAM),
-#endif
-	LINE6_BIT(PAUSE_PLAYBACK),
-	LINE6_BIT(PREPARED),
-
-	/* combined bit masks (by operation): */
-	LINE6_BITS_PCM_ALSA_BUFFER =
-	    LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER |
-	    LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER,
-
-	LINE6_BITS_PCM_ALSA_STREAM =
-	    LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM |
-	    LINE6_BIT_PCM_ALSA_CAPTURE_STREAM,
-
-	LINE6_BITS_PCM_MONITOR =
-	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER |
-	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM |
-	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER |
-	    LINE6_BIT_PCM_MONITOR_CAPTURE_STREAM,
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	LINE6_BITS_PCM_IMPULSE =
-	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_BUFFER |
-	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_STREAM |
-	    LINE6_BIT_PCM_IMPULSE_CAPTURE_BUFFER |
-	    LINE6_BIT_PCM_IMPULSE_CAPTURE_STREAM,
-#endif
-
-	/* combined bit masks (by direction): */
-	LINE6_BITS_PLAYBACK_BUFFER =
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_BUFFER |
-#endif
-	    LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER |
-	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER ,
-
-	LINE6_BITS_PLAYBACK_STREAM =
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_STREAM |
-#endif
-	    LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM |
-	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM ,
-
-	LINE6_BITS_CAPTURE_BUFFER =
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	    LINE6_BIT_PCM_IMPULSE_CAPTURE_BUFFER |
-#endif
-	    LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER |
-	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER ,
-
-	LINE6_BITS_CAPTURE_STREAM =
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	    LINE6_BIT_PCM_IMPULSE_CAPTURE_STREAM |
-#endif
-	    LINE6_BIT_PCM_ALSA_CAPTURE_STREAM |
-	    LINE6_BIT_PCM_MONITOR_CAPTURE_STREAM,
-	
-	LINE6_BITS_STREAM =
-	    LINE6_BITS_PLAYBACK_STREAM |
-	    LINE6_BITS_CAPTURE_STREAM
-};
-
-struct line6_pcm_properties {
-	struct snd_pcm_hardware snd_line6_playback_hw, snd_line6_capture_hw;
-	struct snd_pcm_hw_constraint_ratdens snd_line6_rates;
-	int bytes_per_frame;
-};
-
-struct snd_line6_pcm {
-	/**
-		 Pointer back to the Line6 driver data structure.
-	*/
-	struct usb_line6 *line6;
-
-	/**
-		 Properties.
-	*/
-	struct line6_pcm_properties *properties;
-
-	/**
-		 ALSA pcm stream
-	*/
-	struct snd_pcm *pcm;
-
-	/**
-		 URBs for audio playback.
-	*/
-	struct urb *urb_audio_out[LINE6_ISO_BUFFERS];
-
-	/**
-		 URBs for audio capture.
-	*/
-	struct urb *urb_audio_in[LINE6_ISO_BUFFERS];
-
-	/**
-		 Temporary buffer for playback.
-		 Since the packet size is not known in advance, this buffer is
-		 large enough to store maximum size packets.
-	*/
-	unsigned char *buffer_out;
-
-	/**
-		 Temporary buffer for capture.
-		 Since the packet size is not known in advance, this buffer is
-		 large enough to store maximum size packets.
-	*/
-	unsigned char *buffer_in;
-
-	/**
-		 Previously captured frame (for software monitoring).
-	*/
-	unsigned char *prev_fbuf;
-
-	/**
-		 Size of previously captured frame (for software monitoring).
-	*/
-	int prev_fsize;
-
-	/**
-		 Free frame position in the playback buffer.
-	*/
-	snd_pcm_uframes_t pos_out;
-
-	/**
-		 Count processed bytes for playback.
-		 This is modulo period size (to determine when a period is
-		 finished).
-	*/
-	unsigned bytes_out;
-
-	/**
-		 Counter to create desired playback sample rate.
-	*/
-	unsigned count_out;
-
-	/**
-		 Playback period size in bytes
-	*/
-	unsigned period_out;
-
-	/**
-		 Processed frame position in the playback buffer.
-		 The contents of the output ring buffer have been consumed by
-		 the USB subsystem (i.e., sent to the USB device) up to this
-		 position.
-	*/
-	snd_pcm_uframes_t pos_out_done;
-
-	/**
-		 Count processed bytes for capture.
-		 This is modulo period size (to determine when a period is
-		 finished).
-	*/
-	unsigned bytes_in;
-
-	/**
-		 Counter to create desired capture sample rate.
-	*/
-	unsigned count_in;
-
-	/**
-		 Capture period size in bytes
-	*/
-	unsigned period_in;
-
-	/**
-		 Processed frame position in the capture buffer.
-		 The contents of the output ring buffer have been consumed by
-		 the USB subsystem (i.e., sent to the USB device) up to this
-		 position.
-	*/
-	snd_pcm_uframes_t pos_in_done;
-
-	/**
-		 Bit mask of active playback URBs.
-	*/
-	unsigned long active_urb_out;
-
-	/**
-		 Maximum size of USB packet.
-	*/
-	int max_packet_size;
-
-	/**
-		 USB endpoint for listening to audio data.
-	*/
-	int ep_audio_read;
-
-	/**
-		 USB endpoint for writing audio data.
-	*/
-	int ep_audio_write;
-
-	/**
-		 Bit mask of active capture URBs.
-	*/
-	unsigned long active_urb_in;
-
-	/**
-		 Bit mask of playback URBs currently being unlinked.
-	*/
-	unsigned long unlink_urb_out;
-
-	/**
-		 Bit mask of capture URBs currently being unlinked.
-	*/
-	unsigned long unlink_urb_in;
-
-	/**
-		 Spin lock to protect updates of the playback buffer positions (not
-		 contents!)
-	*/
-	spinlock_t lock_audio_out;
-
-	/**
-		 Spin lock to protect updates of the capture buffer positions (not
-		 contents!)
-	*/
-	spinlock_t lock_audio_in;
-
-	/**
-		 Spin lock to protect trigger.
-	*/
-	spinlock_t lock_trigger;
-
-	/**
-		 PCM playback volume (left and right).
-	*/
-	int volume_playback[2];
-
-	/**
-		 PCM monitor volume.
-	*/
-	int volume_monitor;
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-	/**
-		 Volume of impulse response test signal (if zero, test is disabled).
-	*/
-	int impulse_volume;
-
-	/**
-		 Period of impulse response test signal.
-	*/
-	int impulse_period;
-
-	/**
-		 Counter for impulse response test signal.
-	*/
-	int impulse_count;
-#endif
-
-	/**
-		 Several status bits (see LINE6_BIT_*).
-	*/
-	unsigned long flags;
-
-	int last_frame_in, last_frame_out;
-};
-
-extern int line6_init_pcm(struct usb_line6 *line6,
-			  struct line6_pcm_properties *properties);
-extern int snd_line6_trigger(struct snd_pcm_substream *substream, int cmd);
-extern int snd_line6_prepare(struct snd_pcm_substream *substream);
-extern void line6_pcm_disconnect(struct snd_line6_pcm *line6pcm);
-extern int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels);
-extern int line6_pcm_release(struct snd_line6_pcm *line6pcm, int channels);
-
-#endif
diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
deleted file mode 100644
index a0ab9d0..0000000
--- a/drivers/staging/line6/playback.c
+++ /dev/null
@@ -1,586 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-
-#include "audio.h"
-#include "capture.h"
-#include "driver.h"
-#include "pcm.h"
-#include "pod.h"
-#include "playback.h"
-
-/*
-	Software stereo volume control.
-*/
-static void change_volume(struct urb *urb_out, int volume[],
-			  int bytes_per_frame)
-{
-	int chn = 0;
-
-	if (volume[0] == 256 && volume[1] == 256)
-		return;		/* maximum volume - no change */
-
-	if (bytes_per_frame == 4) {
-		short *p, *buf_end;
-		p = (short *)urb_out->transfer_buffer;
-		buf_end = p + urb_out->transfer_buffer_length / sizeof(*p);
-
-		for (; p < buf_end; ++p) {
-			*p = (*p * volume[chn & 1]) >> 8;
-			++chn;
-		}
-	} else if (bytes_per_frame == 6) {
-		unsigned char *p, *buf_end;
-		p = (unsigned char *)urb_out->transfer_buffer;
-		buf_end = p + urb_out->transfer_buffer_length;
-
-		for (; p < buf_end; p += 3) {
-			int val;
-			val = p[0] + (p[1] << 8) + ((signed char)p[2] << 16);
-			val = (val * volume[chn & 1]) >> 8;
-			p[0] = val;
-			p[1] = val >> 8;
-			p[2] = val >> 16;
-			++chn;
-		}
-	}
-}
-
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-
-/*
-	Create signal for impulse response test.
-*/
-static void create_impulse_test_signal(struct snd_line6_pcm *line6pcm,
-				       struct urb *urb_out, int bytes_per_frame)
-{
-	int frames = urb_out->transfer_buffer_length / bytes_per_frame;
-
-	if (bytes_per_frame == 4) {
-		int i;
-		short *pi = (short *)line6pcm->prev_fbuf;
-		short *po = (short *)urb_out->transfer_buffer;
-
-		for (i = 0; i < frames; ++i) {
-			po[0] = pi[0];
-			po[1] = 0;
-			pi += 2;
-			po += 2;
-		}
-	} else if (bytes_per_frame == 6) {
-		int i, j;
-		unsigned char *pi = line6pcm->prev_fbuf;
-		unsigned char *po = urb_out->transfer_buffer;
-
-		for (i = 0; i < frames; ++i) {
-			for (j = 0; j < bytes_per_frame / 2; ++j)
-				po[j] = pi[j];
-
-			for (; j < bytes_per_frame; ++j)
-				po[j] = 0;
-
-			pi += bytes_per_frame;
-			po += bytes_per_frame;
-		}
-	}
-	if (--line6pcm->impulse_count <= 0) {
-		((unsigned char *)(urb_out->transfer_buffer))[bytes_per_frame -
-							      1] =
-		    line6pcm->impulse_volume;
-		line6pcm->impulse_count = line6pcm->impulse_period;
-	}
-}
-
-#endif
-
-/*
-	Add signal to buffer for software monitoring.
-*/
-static void add_monitor_signal(struct urb *urb_out, unsigned char *signal,
-			       int volume, int bytes_per_frame)
-{
-	if (volume == 0)
-		return;		/* zero volume - no change */
-
-	if (bytes_per_frame == 4) {
-		short *pi, *po, *buf_end;
-		pi = (short *)signal;
-		po = (short *)urb_out->transfer_buffer;
-		buf_end = po + urb_out->transfer_buffer_length / sizeof(*po);
-
-		for (; po < buf_end; ++pi, ++po)
-			*po += (*pi * volume) >> 8;
-	}
-
-	/*
-	   We don't need to handle devices with 6 bytes per frame here
-	   since they all support hardware monitoring.
-	 */
-}
-
-/*
-	Find a free URB, prepare audio data, and submit URB.
-*/
-static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
-{
-	int index;
-	unsigned long flags;
-	int i, urb_size, urb_frames;
-	int ret;
-	const int bytes_per_frame = line6pcm->properties->bytes_per_frame;
-	const int frame_increment =
-	    line6pcm->properties->snd_line6_rates.rats[0].num_min;
-	const int frame_factor =
-	    line6pcm->properties->snd_line6_rates.rats[0].den *
-	    (USB_INTERVALS_PER_SECOND / LINE6_ISO_INTERVAL);
-	struct urb *urb_out;
-
-	spin_lock_irqsave(&line6pcm->lock_audio_out, flags);
-	index =
-	    find_first_zero_bit(&line6pcm->active_urb_out, LINE6_ISO_BUFFERS);
-
-	if (index < 0 || index >= LINE6_ISO_BUFFERS) {
-		spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
-		dev_err(line6pcm->line6->ifcdev, "no free URB found\n");
-		return -EINVAL;
-	}
-
-	urb_out = line6pcm->urb_audio_out[index];
-	urb_size = 0;
-
-	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		/* compute frame size for given sampling rate */
-		int fsize = 0;
-		struct usb_iso_packet_descriptor *fout =
-		    &urb_out->iso_frame_desc[i];
-
-		if (line6pcm->flags & LINE6_BITS_CAPTURE_STREAM)
-			fsize = line6pcm->prev_fsize;
-
-		if (fsize == 0) {
-			int n;
-			line6pcm->count_out += frame_increment;
-			n = line6pcm->count_out / frame_factor;
-			line6pcm->count_out -= n * frame_factor;
-			fsize = n * bytes_per_frame;
-		}
-
-		fout->offset = urb_size;
-		fout->length = fsize;
-		urb_size += fsize;
-	}
-
-	if (urb_size == 0) {
-		/* can't determine URB size */
-		spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
-		dev_err(line6pcm->line6->ifcdev, "driver bug: urb_size = 0\n");	/* this is somewhat paranoid */
-		return -EINVAL;
-	}
-
-	urb_frames = urb_size / bytes_per_frame;
-	urb_out->transfer_buffer =
-	    line6pcm->buffer_out +
-	    index * LINE6_ISO_PACKETS * line6pcm->max_packet_size;
-	urb_out->transfer_buffer_length = urb_size;
-	urb_out->context = line6pcm;
-
-	if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags) &&
-	    !test_bit(LINE6_INDEX_PAUSE_PLAYBACK, &line6pcm->flags)) {
-		struct snd_pcm_runtime *runtime =
-		    get_substream(line6pcm, SNDRV_PCM_STREAM_PLAYBACK)->runtime;
-
-		if (line6pcm->pos_out + urb_frames > runtime->buffer_size) {
-			/*
-			   The transferred area goes over buffer boundary,
-			   copy the data to the temp buffer.
-			 */
-			int len;
-			len = runtime->buffer_size - line6pcm->pos_out;
-
-			if (len > 0) {
-				memcpy(urb_out->transfer_buffer,
-				       runtime->dma_area +
-				       line6pcm->pos_out * bytes_per_frame,
-				       len * bytes_per_frame);
-				memcpy(urb_out->transfer_buffer +
-				       len * bytes_per_frame, runtime->dma_area,
-				       (urb_frames - len) * bytes_per_frame);
-			} else
-				dev_err(line6pcm->line6->ifcdev, "driver bug: len = %d\n", len);	/* this is somewhat paranoid */
-		} else {
-			memcpy(urb_out->transfer_buffer,
-			       runtime->dma_area +
-			       line6pcm->pos_out * bytes_per_frame,
-			       urb_out->transfer_buffer_length);
-		}
-
-		line6pcm->pos_out += urb_frames;
-		if (line6pcm->pos_out >= runtime->buffer_size)
-			line6pcm->pos_out -= runtime->buffer_size;
-	} else {
-		memset(urb_out->transfer_buffer, 0,
-		       urb_out->transfer_buffer_length);
-	}
-
-	change_volume(urb_out, line6pcm->volume_playback, bytes_per_frame);
-
-	if (line6pcm->prev_fbuf != NULL) {
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-		if (line6pcm->flags & LINE6_BITS_PCM_IMPULSE) {
-			create_impulse_test_signal(line6pcm, urb_out,
-						   bytes_per_frame);
-			if (line6pcm->flags & LINE6_BIT_PCM_ALSA_CAPTURE_STREAM) {
-				line6_capture_copy(line6pcm,
-						   urb_out->transfer_buffer,
-						   urb_out->
-						   transfer_buffer_length);
-				line6_capture_check_period(line6pcm,
-							   urb_out->transfer_buffer_length);
-			}
-		} else {
-#endif
-			if (!
-			    (line6pcm->line6->
-			     properties->capabilities & LINE6_BIT_HWMON)
-			    && (line6pcm->flags & LINE6_BITS_PLAYBACK_STREAM)
-			    && (line6pcm->flags & LINE6_BITS_CAPTURE_STREAM))
-				add_monitor_signal(urb_out, line6pcm->prev_fbuf,
-						   line6pcm->volume_monitor,
-						   bytes_per_frame);
-#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-		}
-#endif
-	}
-#ifdef CONFIG_LINE6_USB_DUMP_PCM
-	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fout =
-		    &urb_out->iso_frame_desc[i];
-		line6_write_hexdump(line6pcm->line6, 'P',
-				    urb_out->transfer_buffer + fout->offset,
-				    fout->length);
-	}
-#endif
-
-	ret = usb_submit_urb(urb_out, GFP_ATOMIC);
-
-	if (ret == 0)
-		set_bit(index, &line6pcm->active_urb_out);
-	else
-		dev_err(line6pcm->line6->ifcdev,
-			"URB out #%d submission failed (%d)\n", index, ret);
-
-	spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
-	return 0;
-}
-
-/*
-	Submit all currently available playback URBs.
-*/
-int line6_submit_audio_out_all_urbs(struct snd_line6_pcm *line6pcm)
-{
-	int ret, i;
-
-	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
-		ret = submit_audio_out_urb(line6pcm);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
-/*
-	Unlink all currently active playback URBs.
-*/
-void line6_unlink_audio_out_urbs(struct snd_line6_pcm *line6pcm)
-{
-	unsigned int i;
-
-	for (i = LINE6_ISO_BUFFERS; i--;) {
-		if (test_bit(i, &line6pcm->active_urb_out)) {
-			if (!test_and_set_bit(i, &line6pcm->unlink_urb_out)) {
-				struct urb *u = line6pcm->urb_audio_out[i];
-				usb_unlink_urb(u);
-			}
-		}
-	}
-}
-
-/*
-	Wait until unlinking of all currently active playback URBs has been finished.
-*/
-void line6_wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm)
-{
-	int timeout = HZ;
-	unsigned int i;
-	int alive;
-
-	do {
-		alive = 0;
-		for (i = LINE6_ISO_BUFFERS; i--;) {
-			if (test_bit(i, &line6pcm->active_urb_out))
-				alive++;
-		}
-		if (!alive)
-			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(1);
-	} while (--timeout > 0);
-	if (alive)
-		snd_printk(KERN_ERR "timeout: still %d active urbs..\n", alive);
-}
-
-/*
-	Unlink all currently active playback URBs, and wait for finishing.
-*/
-void line6_unlink_wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm)
-{
-	line6_unlink_audio_out_urbs(line6pcm);
-	line6_wait_clear_audio_out_urbs(line6pcm);
-}
-
-void line6_free_playback_buffer(struct snd_line6_pcm *line6pcm)
-{
-	kfree(line6pcm->buffer_out);
-	line6pcm->buffer_out = NULL;
-}
-
-/*
-	Callback for completed playback URB.
-*/
-static void audio_out_callback(struct urb *urb)
-{
-	int i, index, length = 0, shutdown = 0;
-	unsigned long flags;
-
-	struct snd_line6_pcm *line6pcm = (struct snd_line6_pcm *)urb->context;
-	struct snd_pcm_substream *substream =
-	    get_substream(line6pcm, SNDRV_PCM_STREAM_PLAYBACK);
-
-#if USE_CLEAR_BUFFER_WORKAROUND
-	memset(urb->transfer_buffer, 0, urb->transfer_buffer_length);
-#endif
-
-	line6pcm->last_frame_out = urb->start_frame;
-
-	/* find index of URB */
-	for (index = LINE6_ISO_BUFFERS; index--;)
-		if (urb == line6pcm->urb_audio_out[index])
-			break;
-
-	if (index < 0)
-		return;		/* URB has been unlinked asynchronously */
-
-	for (i = LINE6_ISO_PACKETS; i--;)
-		length += urb->iso_frame_desc[i].length;
-
-	spin_lock_irqsave(&line6pcm->lock_audio_out, flags);
-
-	if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags)) {
-		struct snd_pcm_runtime *runtime = substream->runtime;
-		line6pcm->pos_out_done +=
-		    length / line6pcm->properties->bytes_per_frame;
-
-		if (line6pcm->pos_out_done >= runtime->buffer_size)
-			line6pcm->pos_out_done -= runtime->buffer_size;
-	}
-
-	clear_bit(index, &line6pcm->active_urb_out);
-
-	for (i = LINE6_ISO_PACKETS; i--;)
-		if (urb->iso_frame_desc[i].status == -EXDEV) {
-			shutdown = 1;
-			break;
-		}
-
-	if (test_and_clear_bit(index, &line6pcm->unlink_urb_out))
-		shutdown = 1;
-
-	spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
-
-	if (!shutdown) {
-		submit_audio_out_urb(line6pcm);
-
-		if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags)) {
-			line6pcm->bytes_out += length;
-			if (line6pcm->bytes_out >= line6pcm->period_out) {
-				line6pcm->bytes_out %= line6pcm->period_out;
-				snd_pcm_period_elapsed(substream);
-			}
-		}
-	}
-}
-
-/* open playback callback */
-static int snd_line6_playback_open(struct snd_pcm_substream *substream)
-{
-	int err;
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-
-	err = snd_pcm_hw_constraint_ratdens(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
-					    (&line6pcm->
-					     properties->snd_line6_rates));
-	if (err < 0)
-		return err;
-
-	runtime->hw = line6pcm->properties->snd_line6_playback_hw;
-	return 0;
-}
-
-/* close playback callback */
-static int snd_line6_playback_close(struct snd_pcm_substream *substream)
-{
-	return 0;
-}
-
-/* hw_params playback callback */
-static int snd_line6_playback_hw_params(struct snd_pcm_substream *substream,
-					struct snd_pcm_hw_params *hw_params)
-{
-	int ret;
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-
-	/* -- Florian Demski [FD] */
-	/* don't ask me why, but this fixes the bug on my machine */
-	if (line6pcm == NULL) {
-		if (substream->pcm == NULL)
-			return -ENOMEM;
-		if (substream->pcm->private_data == NULL)
-			return -ENOMEM;
-		substream->private_data = substream->pcm->private_data;
-		line6pcm = snd_pcm_substream_chip(substream);
-	}
-	/* -- [FD] end */
-
-	ret = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER);
-
-	if (ret < 0)
-		return ret;
-
-	ret = snd_pcm_lib_malloc_pages(substream,
-				       params_buffer_bytes(hw_params));
-	if (ret < 0) {
-		line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER);
-		return ret;
-	}
-
-	line6pcm->period_out = params_period_bytes(hw_params);
-	return 0;
-}
-
-/* hw_free playback callback */
-static int snd_line6_playback_hw_free(struct snd_pcm_substream *substream)
-{
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-	line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER);
-	return snd_pcm_lib_free_pages(substream);
-}
-
-/* trigger playback callback */
-int snd_line6_playback_trigger(struct snd_line6_pcm *line6pcm, int cmd)
-{
-	int err;
-
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-#ifdef CONFIG_PM
-	case SNDRV_PCM_TRIGGER_RESUME:
-#endif
-		err = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
-
-		if (err < 0)
-			return err;
-
-		break;
-
-	case SNDRV_PCM_TRIGGER_STOP:
-#ifdef CONFIG_PM
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-#endif
-		err = line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
-
-		if (err < 0)
-			return err;
-
-		break;
-
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		set_bit(LINE6_INDEX_PAUSE_PLAYBACK, &line6pcm->flags);
-		break;
-
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		clear_bit(LINE6_INDEX_PAUSE_PLAYBACK, &line6pcm->flags);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/* playback pointer callback */
-static snd_pcm_uframes_t
-snd_line6_playback_pointer(struct snd_pcm_substream *substream)
-{
-	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
-	return line6pcm->pos_out_done;
-}
-
-/* playback operators */
-struct snd_pcm_ops snd_line6_playback_ops = {
-	.open = snd_line6_playback_open,
-	.close = snd_line6_playback_close,
-	.ioctl = snd_pcm_lib_ioctl,
-	.hw_params = snd_line6_playback_hw_params,
-	.hw_free = snd_line6_playback_hw_free,
-	.prepare = snd_line6_prepare,
-	.trigger = snd_line6_trigger,
-	.pointer = snd_line6_playback_pointer,
-};
-
-int line6_create_audio_out_urbs(struct snd_line6_pcm *line6pcm)
-{
-	int i;
-
-	/* create audio URBs and fill in constant values: */
-	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
-		struct urb *urb;
-
-		/* URB for audio out: */
-		urb = line6pcm->urb_audio_out[i] =
-		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
-
-		if (urb == NULL) {
-			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
-			return -ENOMEM;
-		}
-
-		urb->dev = line6pcm->line6->usbdev;
-		urb->pipe =
-		    usb_sndisocpipe(line6pcm->line6->usbdev,
-				    line6pcm->ep_audio_write &
-				    USB_ENDPOINT_NUMBER_MASK);
-		urb->transfer_flags = URB_ISO_ASAP;
-		urb->start_frame = -1;
-		urb->number_of_packets = LINE6_ISO_PACKETS;
-		urb->interval = LINE6_ISO_INTERVAL;
-		urb->error_count = 0;
-		urb->complete = audio_out_callback;
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/line6/playback.h b/drivers/staging/line6/playback.h
deleted file mode 100644
index 743bd6f..0000000
--- a/drivers/staging/line6/playback.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef PLAYBACK_H
-#define PLAYBACK_H
-
-#include <sound/pcm.h>
-
-#include "driver.h"
-
-/*
- * When the TonePort is used with jack in full duplex mode and the outputs are
- * not connected, the software monitor produces an ugly noise since everything
- * written to the output buffer (i.e., the input signal) will be repeated in
- * the next period (sounds like a delay effect). As a workaround, the output
- * buffer is cleared after the data have been read, but there must be a better
- * solution. Until one is found, this workaround can be used to fix the
- * problem.
- */
-#define USE_CLEAR_BUFFER_WORKAROUND 1
-
-extern struct snd_pcm_ops snd_line6_playback_ops;
-
-extern int line6_create_audio_out_urbs(struct snd_line6_pcm *line6pcm);
-extern void line6_free_playback_buffer(struct snd_line6_pcm *line6pcm);
-extern int line6_submit_audio_out_all_urbs(struct snd_line6_pcm *line6pcm);
-extern void line6_unlink_audio_out_urbs(struct snd_line6_pcm *line6pcm);
-extern void line6_unlink_wait_clear_audio_out_urbs(struct snd_line6_pcm
-						   *line6pcm);
-extern void line6_wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm);
-extern int snd_line6_playback_trigger(struct snd_line6_pcm *line6pcm, int cmd);
-
-#endif
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
deleted file mode 100644
index 9edd053..0000000
--- a/drivers/staging/line6/pod.c
+++ /dev/null
@@ -1,1351 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-#include <linux/wait.h>
-#include <sound/control.h>
-
-#include "audio.h"
-#include "capture.h"
-#include "control.h"
-#include "driver.h"
-#include "playback.h"
-#include "pod.h"
-
-#define POD_SYSEX_CODE 3
-#define POD_BYTES_PER_FRAME 6	/* 24bit audio (stereo) */
-
-/* *INDENT-OFF* */
-
-enum {
-	POD_SYSEX_CLIP      = 0x0f,
-	POD_SYSEX_SAVE      = 0x24,
-	POD_SYSEX_SYSTEM    = 0x56,
-	POD_SYSEX_SYSTEMREQ = 0x57,
-	/* POD_SYSEX_UPDATE    = 0x6c, */  /* software update! */
-	POD_SYSEX_STORE     = 0x71,
-	POD_SYSEX_FINISH    = 0x72,
-	POD_SYSEX_DUMPMEM   = 0x73,
-	POD_SYSEX_DUMP      = 0x74,
-	POD_SYSEX_DUMPREQ   = 0x75
-	/* POD_SYSEX_DUMPMEM2  = 0x76 */   /* dumps entire internal memory of PODxt Pro */
-};
-
-enum {
-	POD_monitor_level  = 0x04,
-	POD_routing        = 0x05,
-	POD_tuner_mute     = 0x13,
-	POD_tuner_freq     = 0x15,
-	POD_tuner_note     = 0x16,
-	POD_tuner_pitch    = 0x17,
-	POD_system_invalid = 0x10000
-};
-
-/* *INDENT-ON* */
-
-enum {
-	POD_DUMP_MEMORY = 2
-};
-
-enum {
-	POD_BUSY_READ,
-	POD_BUSY_WRITE,
-	POD_CHANNEL_DIRTY,
-	POD_SAVE_PRESSED,
-	POD_BUSY_MIDISEND
-};
-
-static struct snd_ratden pod_ratden = {
-	.num_min = 78125,
-	.num_max = 78125,
-	.num_step = 1,
-	.den = 2
-};
-
-static struct line6_pcm_properties pod_pcm_properties = {
-	.snd_line6_playback_hw = {
-				  .info = (SNDRV_PCM_INFO_MMAP |
-					   SNDRV_PCM_INFO_INTERLEAVED |
-					   SNDRV_PCM_INFO_BLOCK_TRANSFER |
-					   SNDRV_PCM_INFO_MMAP_VALID |
-					   SNDRV_PCM_INFO_PAUSE |
-#ifdef CONFIG_PM
-					   SNDRV_PCM_INFO_RESUME |
-#endif
-					   SNDRV_PCM_INFO_SYNC_START),
-				  .formats = SNDRV_PCM_FMTBIT_S24_3LE,
-				  .rates = SNDRV_PCM_RATE_KNOT,
-				  .rate_min = 39062,
-				  .rate_max = 39063,
-				  .channels_min = 2,
-				  .channels_max = 2,
-				  .buffer_bytes_max = 60000,
-				  .period_bytes_min = 64,
-				  .period_bytes_max = 8192,
-				  .periods_min = 1,
-				  .periods_max = 1024},
-	.snd_line6_capture_hw = {
-				 .info = (SNDRV_PCM_INFO_MMAP |
-					  SNDRV_PCM_INFO_INTERLEAVED |
-					  SNDRV_PCM_INFO_BLOCK_TRANSFER |
-					  SNDRV_PCM_INFO_MMAP_VALID |
-#ifdef CONFIG_PM
-					  SNDRV_PCM_INFO_RESUME |
-#endif
-					  SNDRV_PCM_INFO_SYNC_START),
-				 .formats = SNDRV_PCM_FMTBIT_S24_3LE,
-				 .rates = SNDRV_PCM_RATE_KNOT,
-				 .rate_min = 39062,
-				 .rate_max = 39063,
-				 .channels_min = 2,
-				 .channels_max = 2,
-				 .buffer_bytes_max = 60000,
-				 .period_bytes_min = 64,
-				 .period_bytes_max = 8192,
-				 .periods_min = 1,
-				 .periods_max = 1024},
-	.snd_line6_rates = {
-			    .nrats = 1,
-			    .rats = &pod_ratden},
-	.bytes_per_frame = POD_BYTES_PER_FRAME
-};
-
-static const char pod_request_channel[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x03, 0x75, 0xf7
-};
-
-static const char pod_version_header[] = {
-	0xf2, 0x7e, 0x7f, 0x06, 0x02
-};
-
-/* forward declarations: */
-static void pod_startup2(unsigned long data);
-static void pod_startup3(struct usb_line6_pod *pod);
-static void pod_startup4(struct usb_line6_pod *pod);
-
-/*
-	Mark all parameters as dirty and notify waiting processes.
-*/
-static void pod_mark_batch_all_dirty(struct usb_line6_pod *pod)
-{
-	int i;
-
-	for (i = 0; i < POD_CONTROL_SIZE; i++)
-		set_bit(i, pod->param_dirty);
-}
-
-static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
-				    int size)
-{
-	return line6_alloc_sysex_buffer(&pod->line6, POD_SYSEX_CODE, code,
-					size);
-}
-
-/*
-	Send channel dump data to the PODxt Pro.
-*/
-static void pod_dump(struct usb_line6_pod *pod, const unsigned char *data)
-{
-	int size = 1 + sizeof(pod->prog_data);
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_DUMP, size);
-	if (!sysex)
-		return;
-	/* Don't know what this is good for, but PODxt Pro transmits it, so we
-	 * also do... */
-	sysex[SYSEX_DATA_OFS] = 5;
-	memcpy(sysex + SYSEX_DATA_OFS + 1, data, sizeof(pod->prog_data));
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	memcpy(&pod->prog_data, data, sizeof(pod->prog_data));
-	pod_mark_batch_all_dirty(pod);
-	kfree(sysex);
-}
-
-/*
-	Store parameter value in driver memory and mark it as dirty.
-*/
-static void pod_store_parameter(struct usb_line6_pod *pod, int param, int value)
-{
-	pod->prog_data.control[param] = value;
-	set_bit(param, pod->param_dirty);
-	pod->dirty = 1;
-}
-
-/*
-	Handle SAVE button.
-*/
-static void pod_save_button_pressed(struct usb_line6_pod *pod, int type,
-				    int index)
-{
-	pod->dirty = 0;
-	set_bit(POD_SAVE_PRESSED, &pod->atomic_flags);
-}
-
-/*
-	Process a completely received message.
-*/
-void line6_pod_process_message(struct usb_line6_pod *pod)
-{
-	const unsigned char *buf = pod->line6.buffer_message;
-
-	/* filter messages by type */
-	switch (buf[0] & 0xf0) {
-	case LINE6_PARAM_CHANGE:
-	case LINE6_PROGRAM_CHANGE:
-	case LINE6_SYSEX_BEGIN:
-		break;		/* handle these further down */
-
-	default:
-		return;		/* ignore all others */
-	}
-
-	/* process all remaining messages */
-	switch (buf[0]) {
-	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_DEVICE:
-		pod_store_parameter(pod, buf[1], buf[2]);
-		/* intentionally no break here! */
-
-	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
-		if ((buf[1] == POD_amp_model_setup) ||
-		    (buf[1] == POD_effect_setup))
-			/* these also affect other settings */
-			line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
-						 LINE6_DUMP_CURRENT);
-
-		break;
-
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		pod->channel_num = buf[1];
-		pod->dirty = 0;
-		set_bit(POD_CHANNEL_DIRTY, &pod->atomic_flags);
-		line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
-					 LINE6_DUMP_CURRENT);
-		break;
-
-	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_DEVICE:
-	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_UNKNOWN:
-		if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) == 0) {
-			switch (buf[5]) {
-			case POD_SYSEX_DUMP:
-				if (pod->line6.message_length ==
-				    sizeof(pod->prog_data) + 7) {
-					switch (pod->dumpreq.in_progress) {
-					case LINE6_DUMP_CURRENT:
-						memcpy(&pod->prog_data, buf + 7,
-						       sizeof(pod->prog_data));
-						pod_mark_batch_all_dirty(pod);
-						break;
-
-					case POD_DUMP_MEMORY:
-						memcpy(&pod->prog_data_buf,
-						       buf + 7,
-						       sizeof
-						       (pod->prog_data_buf));
-						break;
-
-					default:
-						DEBUG_MESSAGES(dev_err
-							       (pod->
-								line6.ifcdev,
-								"unknown dump code %02X\n",
-								pod->
-								dumpreq.in_progress));
-					}
-
-					line6_dump_finished(&pod->dumpreq);
-					pod_startup3(pod);
-				} else
-					DEBUG_MESSAGES(dev_err
-						       (pod->line6.ifcdev,
-							"wrong size of channel dump message (%d instead of %d)\n",
-							pod->
-							line6.message_length,
-							(int)
-							sizeof(pod->prog_data) +
-							7));
-
-				break;
-
-			case POD_SYSEX_SYSTEM:{
-					short value =
-					    ((int)buf[7] << 12) | ((int)buf[8]
-								   << 8) |
-					    ((int)buf[9] << 4) | (int)buf[10];
-
-#define PROCESS_SYSTEM_PARAM(x) \
-					case POD_ ## x: \
-						pod->x.value = value; \
-						wake_up(&pod->x.wait); \
-						break;
-
-					switch (buf[6]) {
-						PROCESS_SYSTEM_PARAM
-						    (monitor_level);
-						PROCESS_SYSTEM_PARAM(routing);
-						PROCESS_SYSTEM_PARAM
-						    (tuner_mute);
-						PROCESS_SYSTEM_PARAM
-						    (tuner_freq);
-						PROCESS_SYSTEM_PARAM
-						    (tuner_note);
-						PROCESS_SYSTEM_PARAM
-						    (tuner_pitch);
-
-#undef PROCESS_SYSTEM_PARAM
-
-					default:
-						DEBUG_MESSAGES(dev_err
-							       (pod->
-								line6.ifcdev,
-								"unknown tuner/system response %02X\n",
-								buf[6]));
-					}
-
-					break;
-				}
-
-			case POD_SYSEX_FINISH:
-				/* do we need to respond to this? */
-				break;
-
-			case POD_SYSEX_SAVE:
-				pod_save_button_pressed(pod, buf[6], buf[7]);
-				break;
-
-			case POD_SYSEX_CLIP:
-				DEBUG_MESSAGES(dev_err
-					       (pod->line6.ifcdev,
-						"audio clipped\n"));
-				pod->clipping.value = 1;
-				wake_up(&pod->clipping.wait);
-				break;
-
-			case POD_SYSEX_STORE:
-				DEBUG_MESSAGES(dev_err
-					       (pod->line6.ifcdev,
-						"message %02X not yet implemented\n",
-						buf[5]));
-				break;
-
-			default:
-				DEBUG_MESSAGES(dev_err
-					       (pod->line6.ifcdev,
-						"unknown sysex message %02X\n",
-						buf[5]));
-			}
-		} else
-		    if (memcmp
-			(buf, pod_version_header,
-			 sizeof(pod_version_header)) == 0) {
-			pod->firmware_version =
-			    buf[13] * 100 + buf[14] * 10 + buf[15];
-			pod->device_id =
-			    ((int)buf[8] << 16) | ((int)buf[9] << 8) | (int)
-			    buf[10];
-			pod_startup4(pod);
-		} else
-			DEBUG_MESSAGES(dev_err
-				       (pod->line6.ifcdev,
-					"unknown sysex header\n"));
-
-		break;
-
-	case LINE6_SYSEX_END:
-		break;
-
-	default:
-		DEBUG_MESSAGES(dev_err
-			       (pod->line6.ifcdev,
-				"POD: unknown message %02X\n", buf[0]));
-	}
-}
-
-/*
-	Detect some cases that require a channel dump after sending a command to the
-	device. Important notes:
-	*) The actual dump request can not be sent here since we are not allowed to
-	wait for the completion of the first message in this context, and sending
-	the dump request before completion of the previous message leaves the POD
-	in an undefined state. The dump request will be sent when the echoed
-	commands are received.
-	*) This method fails if a param change message is "chopped" after the first
-	byte.
-*/
-void line6_pod_midi_postprocess(struct usb_line6_pod *pod, unsigned char *data,
-				int length)
-{
-	int i;
-
-	if (!pod->midi_postprocess)
-		return;
-
-	for (i = 0; i < length; ++i) {
-		if (data[i] == (LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST)) {
-			line6_invalidate_current(&pod->dumpreq);
-			break;
-		} else
-		    if ((data[i] == (LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST))
-			&& (i < length - 1))
-			if ((data[i + 1] == POD_amp_model_setup)
-			    || (data[i + 1] == POD_effect_setup)) {
-				line6_invalidate_current(&pod->dumpreq);
-				break;
-			}
-	}
-}
-
-/*
-	Send channel number (i.e., switch to a different sound).
-*/
-static void pod_send_channel(struct usb_line6_pod *pod, u8 value)
-{
-	line6_invalidate_current(&pod->dumpreq);
-
-	if (line6_send_program(&pod->line6, value) == 0)
-		pod->channel_num = value;
-	else
-		line6_dump_finished(&pod->dumpreq);
-}
-
-/*
-	Transmit PODxt Pro control parameter.
-*/
-void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
-				  u8 value)
-{
-	if (line6_transmit_parameter(&pod->line6, param, value) == 0)
-		pod_store_parameter(pod, param, value);
-
-	if ((param == POD_amp_model_setup) || (param == POD_effect_setup))	/* these also affect other settings */
-		line6_invalidate_current(&pod->dumpreq);
-}
-
-/*
-	Resolve value to memory location.
-*/
-static int pod_resolve(const char *buf, short block0, short block1,
-		       unsigned char *location)
-{
-	u8 value;
-	short block;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	block = (value < 0x40) ? block0 : block1;
-	value &= 0x3f;
-	location[0] = block >> 7;
-	location[1] = value | (block & 0x7f);
-	return 0;
-}
-
-/*
-	Send command to store channel/effects setup/amp setup to PODxt Pro.
-*/
-static ssize_t pod_send_store_command(struct device *dev, const char *buf,
-				      size_t count, short block0, short block1)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int ret;
-	int size = 3 + sizeof(pod->prog_data_buf);
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_STORE, size);
-
-	if (!sysex)
-		return 0;
-
-	sysex[SYSEX_DATA_OFS] = 5;	/* see pod_dump() */
-	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS + 1);
-	if (ret) {
-		kfree(sysex);
-		return ret;
-	}
-
-	memcpy(sysex + SYSEX_DATA_OFS + 3, &pod->prog_data_buf,
-	       sizeof(pod->prog_data_buf));
-
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	kfree(sysex);
-	/* needs some delay here on AMD64 platform */
-	return count;
-}
-
-/*
-	Send command to retrieve channel/effects setup/amp setup to PODxt Pro.
-*/
-static ssize_t pod_send_retrieve_command(struct device *dev, const char *buf,
-					 size_t count, short block0,
-					 short block1)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int ret;
-	int size = 4;
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_DUMPMEM, size);
-
-	if (!sysex)
-		return 0;
-
-	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS);
-	if (ret) {
-		kfree(sysex);
-		return ret;
-	}
-	sysex[SYSEX_DATA_OFS + 2] = 0;
-	sysex[SYSEX_DATA_OFS + 3] = 0;
-	line6_dump_started(&pod->dumpreq, POD_DUMP_MEMORY);
-
-	if (line6_send_sysex_message(&pod->line6, sysex, size) < size)
-		line6_dump_finished(&pod->dumpreq);
-
-	kfree(sysex);
-	/* needs some delay here on AMD64 platform */
-	return count;
-}
-
-/*
-	Generic get name function.
-*/
-static ssize_t get_name_generic(struct usb_line6_pod *pod, const char *str,
-				char *buf)
-{
-	int length = 0;
-	const char *p1;
-	char *p2;
-	char *last_non_space = buf;
-
-	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
-	if (retval < 0)
-		return retval;
-
-	for (p1 = str, p2 = buf; *p1; ++p1, ++p2) {
-		*p2 = *p1;
-		if (*p2 != ' ')
-			last_non_space = p2;
-		if (++length == POD_NAME_LENGTH)
-			break;
-	}
-
-	*(last_non_space + 1) = '\n';
-	return last_non_space - buf + 2;
-}
-
-/*
-	"read" request on "channel" special file.
-*/
-static ssize_t pod_get_channel(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", pod->channel_num);
-}
-
-/*
-	"write" request on "channel" special file.
-*/
-static ssize_t pod_set_channel(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	pod_send_channel(pod, value);
-	return count;
-}
-
-/*
-	"read" request on "name" special file.
-*/
-static ssize_t pod_get_name(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return get_name_generic(pod, pod->prog_data.header + POD_NAME_OFFSET,
-				buf);
-}
-
-/*
-	"read" request on "name" special file.
-*/
-static ssize_t pod_get_name_buf(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return get_name_generic(pod,
-				pod->prog_data_buf.header + POD_NAME_OFFSET,
-				buf);
-}
-
-/*
-	"read" request on "dump" special file.
-*/
-static ssize_t pod_get_dump(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
-	if (retval < 0)
-		return retval;
-	memcpy(buf, &pod->prog_data, sizeof(pod->prog_data));
-	return sizeof(pod->prog_data);
-}
-
-/*
-	"write" request on "dump" special file.
-*/
-static ssize_t pod_set_dump(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-
-	if (count != sizeof(pod->prog_data)) {
-		dev_err(pod->line6.ifcdev,
-			"data block must be exactly %d bytes\n",
-			(int)sizeof(pod->prog_data));
-		return -EINVAL;
-	}
-
-	pod_dump(pod, buf);
-	return sizeof(pod->prog_data);
-}
-
-/*
-	Identify system parameters related to the tuner.
-*/
-static bool pod_is_tuner(int code)
-{
-	return
-	    (code == POD_tuner_mute) ||
-	    (code == POD_tuner_freq) ||
-	    (code == POD_tuner_note) || (code == POD_tuner_pitch);
-}
-
-/*
-	Get system parameter (as integer).
-	@param tuner non-zero, if code refers to a tuner parameter
-*/
-static int pod_get_system_param_int(struct usb_line6_pod *pod, int *value,
-				    int code, struct ValueWait *param, int sign)
-{
-	char *sysex;
-	static const int size = 1;
-	int retval = 0;
-
-	if (((pod->prog_data.control[POD_tuner] & 0x40) == 0)
-	    && pod_is_tuner(code))
-		return -ENODEV;
-
-	/* send value request to device: */
-	param->value = POD_system_invalid;
-	sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_SYSTEMREQ, size);
-
-	if (!sysex)
-		return -ENOMEM;
-
-	sysex[SYSEX_DATA_OFS] = code;
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	kfree(sysex);
-
-	/* wait for device to respond: */
-	retval =
-	    wait_event_interruptible(param->wait,
-				     param->value != POD_system_invalid);
-
-	if (retval < 0)
-		return retval;
-
-	*value = sign ? (int)(signed short)param->value : (int)(unsigned short)
-	    param->value;
-
-	if (*value == POD_system_invalid)
-		*value = 0;	/* don't report uninitialized values */
-
-	return 0;
-}
-
-/*
-	Get system parameter (as string).
-	@param tuner non-zero, if code refers to a tuner parameter
-*/
-static ssize_t pod_get_system_param_string(struct usb_line6_pod *pod, char *buf,
-					   int code, struct ValueWait *param,
-					   int sign)
-{
-	int retval, value = 0;
-	retval = pod_get_system_param_int(pod, &value, code, param, sign);
-
-	if (retval < 0)
-		return retval;
-
-	return sprintf(buf, "%d\n", value);
-}
-
-/*
-	Send system parameter (from integer).
-	@param tuner non-zero, if code refers to a tuner parameter
-*/
-static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
-				    int code)
-{
-	char *sysex;
-	static const int size = 5;
-
-	if (((pod->prog_data.control[POD_tuner] & 0x40) == 0)
-	    && pod_is_tuner(code))
-		return -EINVAL;
-
-	/* send value to tuner: */
-	sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_SYSTEM, size);
-	if (!sysex)
-		return -ENOMEM;
-	sysex[SYSEX_DATA_OFS] = code;
-	sysex[SYSEX_DATA_OFS + 1] = (value >> 12) & 0x0f;
-	sysex[SYSEX_DATA_OFS + 2] = (value >> 8) & 0x0f;
-	sysex[SYSEX_DATA_OFS + 3] = (value >> 4) & 0x0f;
-	sysex[SYSEX_DATA_OFS + 4] = (value) & 0x0f;
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	kfree(sysex);
-	return 0;
-}
-
-/*
-	Send system parameter (from string).
-	@param tuner non-zero, if code refers to a tuner parameter
-*/
-static ssize_t pod_set_system_param_string(struct usb_line6_pod *pod,
-					   const char *buf, int count, int code,
-					   unsigned short mask)
-{
-	int retval;
-	unsigned short value = simple_strtoul(buf, NULL, 10) & mask;
-	retval = pod_set_system_param_int(pod, value, code);
-	return (retval < 0) ? retval : count;
-}
-
-/*
-	"read" request on "dump_buf" special file.
-*/
-static ssize_t pod_get_dump_buf(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
-	if (retval < 0)
-		return retval;
-	memcpy(buf, &pod->prog_data_buf, sizeof(pod->prog_data_buf));
-	return sizeof(pod->prog_data_buf);
-}
-
-/*
-	"write" request on "dump_buf" special file.
-*/
-static ssize_t pod_set_dump_buf(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-
-	if (count != sizeof(pod->prog_data)) {
-		dev_err(pod->line6.ifcdev,
-			"data block must be exactly %d bytes\n",
-			(int)sizeof(pod->prog_data));
-		return -EINVAL;
-	}
-
-	memcpy(&pod->prog_data_buf, buf, sizeof(pod->prog_data));
-	return sizeof(pod->prog_data);
-}
-
-/*
-	"write" request on "finish" special file.
-*/
-static ssize_t pod_set_finish(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int size = 0;
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_FINISH, size);
-	if (!sysex)
-		return 0;
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	kfree(sysex);
-	return count;
-}
-
-/*
-	"write" request on "store_channel" special file.
-*/
-static ssize_t pod_set_store_channel(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	return pod_send_store_command(dev, buf, count, 0x0000, 0x00c0);
-}
-
-/*
-	"write" request on "store_effects_setup" special file.
-*/
-static ssize_t pod_set_store_effects_setup(struct device *dev,
-					   struct device_attribute *attr,
-					   const char *buf, size_t count)
-{
-	return pod_send_store_command(dev, buf, count, 0x0080, 0x0080);
-}
-
-/*
-	"write" request on "store_amp_setup" special file.
-*/
-static ssize_t pod_set_store_amp_setup(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t count)
-{
-	return pod_send_store_command(dev, buf, count, 0x0040, 0x0100);
-}
-
-/*
-	"write" request on "retrieve_channel" special file.
-*/
-static ssize_t pod_set_retrieve_channel(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	return pod_send_retrieve_command(dev, buf, count, 0x0000, 0x00c0);
-}
-
-/*
-	"write" request on "retrieve_effects_setup" special file.
-*/
-static ssize_t pod_set_retrieve_effects_setup(struct device *dev,
-					      struct device_attribute *attr,
-					      const char *buf, size_t count)
-{
-	return pod_send_retrieve_command(dev, buf, count, 0x0080, 0x0080);
-}
-
-/*
-	"write" request on "retrieve_amp_setup" special file.
-*/
-static ssize_t pod_set_retrieve_amp_setup(struct device *dev,
-					  struct device_attribute *attr,
-					  const char *buf, size_t count)
-{
-	return pod_send_retrieve_command(dev, buf, count, 0x0040, 0x0100);
-}
-
-/*
-	"read" request on "dirty" special file.
-*/
-static ssize_t pod_get_dirty(struct device *dev, struct device_attribute *attr,
-			     char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	buf[0] = pod->dirty ? '1' : '0';
-	buf[1] = '\n';
-	return 2;
-}
-
-/*
-	"read" request on "midi_postprocess" special file.
-*/
-static ssize_t pod_get_midi_postprocess(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", pod->midi_postprocess);
-}
-
-/*
-	"write" request on "midi_postprocess" special file.
-*/
-static ssize_t pod_set_midi_postprocess(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	pod->midi_postprocess = value ? 1 : 0;
-	return count;
-}
-
-/*
-	"read" request on "serial_number" special file.
-*/
-static ssize_t pod_get_serial_number(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", pod->serial_number);
-}
-
-/*
-	"read" request on "firmware_version" special file.
-*/
-static ssize_t pod_get_firmware_version(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return sprintf(buf, "%d.%02d\n", pod->firmware_version / 100,
-		       pod->firmware_version % 100);
-}
-
-/*
-	"read" request on "device_id" special file.
-*/
-static ssize_t pod_get_device_id(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", pod->device_id);
-}
-
-/*
-	"read" request on "clip" special file.
-*/
-static ssize_t pod_wait_for_clip(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return wait_event_interruptible(pod->clipping.wait,
-					pod->clipping.value != 0);
-}
-
-/*
-	POD startup procedure.
-	This is a sequence of functions with special requirements (e.g., must
-	not run immediately after initialization, must not run in interrupt
-	context). After the last one has finished, the device is ready to use.
-*/
-
-static void pod_startup1(struct usb_line6_pod *pod)
-{
-	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_INIT);
-
-	/* delay startup procedure: */
-	line6_start_timer(&pod->startup_timer, POD_STARTUP_DELAY, pod_startup2,
-			  (unsigned long)pod);
-}
-
-static void pod_startup2(unsigned long data)
-{
-	struct usb_line6_pod *pod = (struct usb_line6_pod *)data;
-
-	/* schedule another startup procedure until startup is complete: */
-	if (pod->startup_progress >= POD_STARTUP_LAST)
-		return;
-
-	pod->startup_progress = POD_STARTUP_DUMPREQ;
-	line6_start_timer(&pod->startup_timer, POD_STARTUP_DELAY, pod_startup2,
-			  (unsigned long)pod);
-
-	/* current channel dump: */
-	line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
-				 LINE6_DUMP_CURRENT);
-}
-
-static void pod_startup3(struct usb_line6_pod *pod)
-{
-	struct usb_line6 *line6 = &pod->line6;
-	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_VERSIONREQ);
-
-	/* request firmware version: */
-	line6_version_request_async(line6);
-}
-
-static void pod_startup4(struct usb_line6_pod *pod)
-{
-	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_WORKQUEUE);
-
-	/* schedule work for global work queue: */
-	schedule_work(&pod->startup_work);
-}
-
-static void pod_startup5(struct work_struct *work)
-{
-	struct usb_line6_pod *pod =
-	    container_of(work, struct usb_line6_pod, startup_work);
-	struct usb_line6 *line6 = &pod->line6;
-
-	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_SETUP);
-
-	/* serial number: */
-	line6_read_serial_number(&pod->line6, &pod->serial_number);
-
-	/* ALSA audio interface: */
-	line6_register_audio(line6);
-
-	/* device files: */
-	line6_pod_create_files(pod->firmware_version,
-			       line6->properties->device_bit, line6->ifcdev);
-}
-
-#define POD_GET_SYSTEM_PARAM(code, sign) \
-static ssize_t pod_get_ ## code(struct device *dev, \
-				struct device_attribute *attr, char *buf) \
-{ \
-	struct usb_interface *interface = to_usb_interface(dev); \
-	struct usb_line6_pod *pod = usb_get_intfdata(interface); \
-	return pod_get_system_param_string(pod, buf, POD_ ## code,	\
-					   &pod->code, sign);		\
-}
-
-#define POD_GET_SET_SYSTEM_PARAM(code, mask, sign) \
-POD_GET_SYSTEM_PARAM(code, sign) \
-static ssize_t pod_set_ ## code(struct device *dev, \
-				struct device_attribute *attr, \
-				const char *buf, size_t count) \
-{ \
-	struct usb_interface *interface = to_usb_interface(dev); \
-	struct usb_line6_pod *pod = usb_get_intfdata(interface); \
-	return pod_set_system_param_string(pod, buf, count, POD_ ## code, mask); \
-}
-
-POD_GET_SET_SYSTEM_PARAM(monitor_level, 0xffff, 0);
-POD_GET_SET_SYSTEM_PARAM(routing, 0x0003, 0);
-POD_GET_SET_SYSTEM_PARAM(tuner_mute, 0x0001, 0);
-POD_GET_SET_SYSTEM_PARAM(tuner_freq, 0xffff, 0);
-POD_GET_SYSTEM_PARAM(tuner_note, 1);
-POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
-
-#undef GET_SET_SYSTEM_PARAM
-#undef GET_SYSTEM_PARAM
-
-/* POD special files: */
-static DEVICE_ATTR(channel, S_IWUSR | S_IRUGO, pod_get_channel,
-		   pod_set_channel);
-static DEVICE_ATTR(clip, S_IRUGO, pod_wait_for_clip, line6_nop_write);
-static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
-static DEVICE_ATTR(dirty, S_IRUGO, pod_get_dirty, line6_nop_write);
-static DEVICE_ATTR(dump, S_IWUSR | S_IRUGO, pod_get_dump, pod_set_dump);
-static DEVICE_ATTR(dump_buf, S_IWUSR | S_IRUGO, pod_get_dump_buf,
-		   pod_set_dump_buf);
-static DEVICE_ATTR(finish, S_IWUSR, line6_nop_read, pod_set_finish);
-static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
-		   line6_nop_write);
-static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
-		   pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(monitor_level, S_IWUSR | S_IRUGO, pod_get_monitor_level,
-		   pod_set_monitor_level);
-static DEVICE_ATTR(name, S_IRUGO, pod_get_name, line6_nop_write);
-static DEVICE_ATTR(name_buf, S_IRUGO, pod_get_name_buf, line6_nop_write);
-static DEVICE_ATTR(retrieve_amp_setup, S_IWUSR, line6_nop_read,
-		   pod_set_retrieve_amp_setup);
-static DEVICE_ATTR(retrieve_channel, S_IWUSR, line6_nop_read,
-		   pod_set_retrieve_channel);
-static DEVICE_ATTR(retrieve_effects_setup, S_IWUSR, line6_nop_read,
-		   pod_set_retrieve_effects_setup);
-static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing,
-		   pod_set_routing);
-static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
-		   line6_nop_write);
-static DEVICE_ATTR(store_amp_setup, S_IWUSR, line6_nop_read,
-		   pod_set_store_amp_setup);
-static DEVICE_ATTR(store_channel, S_IWUSR, line6_nop_read,
-		   pod_set_store_channel);
-static DEVICE_ATTR(store_effects_setup, S_IWUSR, line6_nop_read,
-		   pod_set_store_effects_setup);
-static DEVICE_ATTR(tuner_freq, S_IWUSR | S_IRUGO, pod_get_tuner_freq,
-		   pod_set_tuner_freq);
-static DEVICE_ATTR(tuner_mute, S_IWUSR | S_IRUGO, pod_get_tuner_mute,
-		   pod_set_tuner_mute);
-static DEVICE_ATTR(tuner_note, S_IRUGO, pod_get_tuner_note, line6_nop_write);
-static DEVICE_ATTR(tuner_pitch, S_IRUGO, pod_get_tuner_pitch, line6_nop_write);
-
-#ifdef CONFIG_LINE6_USB_RAW
-static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
-#endif
-
-/* control info callback */
-static int snd_pod_control_monitor_info(struct snd_kcontrol *kcontrol,
-					struct snd_ctl_elem_info *uinfo)
-{
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
-	uinfo->count = 1;
-	uinfo->value.integer.min = 0;
-	uinfo->value.integer.max = 65535;
-	return 0;
-}
-
-/* control get callback */
-static int snd_pod_control_monitor_get(struct snd_kcontrol *kcontrol,
-				       struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-	struct usb_line6_pod *pod = (struct usb_line6_pod *)line6pcm->line6;
-	ucontrol->value.integer.value[0] = pod->monitor_level.value;
-	return 0;
-}
-
-/* control put callback */
-static int snd_pod_control_monitor_put(struct snd_kcontrol *kcontrol,
-				       struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-	struct usb_line6_pod *pod = (struct usb_line6_pod *)line6pcm->line6;
-
-	if (ucontrol->value.integer.value[0] == pod->monitor_level.value)
-		return 0;
-
-	pod->monitor_level.value = ucontrol->value.integer.value[0];
-	pod_set_system_param_int(pod, ucontrol->value.integer.value[0],
-				 POD_monitor_level);
-	return 1;
-}
-
-/* control definition */
-static struct snd_kcontrol_new pod_control_monitor = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Monitor Playback Volume",
-	.index = 0,
-	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
-	.info = snd_pod_control_monitor_info,
-	.get = snd_pod_control_monitor_get,
-	.put = snd_pod_control_monitor_put
-};
-
-/*
-	POD destructor.
-*/
-static void pod_destruct(struct usb_interface *interface)
-{
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-
-	if (pod == NULL)
-		return;
-	line6_cleanup_audio(&pod->line6);
-
-	del_timer(&pod->startup_timer);
-	cancel_work_sync(&pod->startup_work);
-
-	/* free dump request data: */
-	line6_dumpreq_destruct(&pod->dumpreq);
-}
-
-/*
-	Create sysfs entries.
-*/
-static int pod_create_files2(struct device *dev)
-{
-	int err;
-
-	CHECK_RETURN(device_create_file(dev, &dev_attr_channel));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_clip));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dirty));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dump_buf));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_monitor_level));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_name_buf));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_amp_setup));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_channel));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_effects_setup));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_routing));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_store_amp_setup));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_store_channel));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_store_effects_setup));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_freq));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_mute));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_note));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_pitch));
-
-#ifdef CONFIG_LINE6_USB_RAW
-	CHECK_RETURN(device_create_file(dev, &dev_attr_raw));
-#endif
-
-	return 0;
-}
-
-/*
-	 Try to init POD device.
-*/
-static int pod_try_init(struct usb_interface *interface,
-			struct usb_line6_pod *pod)
-{
-	int err;
-	struct usb_line6 *line6 = &pod->line6;
-
-	init_timer(&pod->startup_timer);
-	INIT_WORK(&pod->startup_work, pod_startup5);
-
-	if ((interface == NULL) || (pod == NULL))
-		return -ENODEV;
-
-	pod->channel_num = 255;
-
-	/* initialize wait queues: */
-	init_waitqueue_head(&pod->monitor_level.wait);
-	init_waitqueue_head(&pod->routing.wait);
-	init_waitqueue_head(&pod->tuner_mute.wait);
-	init_waitqueue_head(&pod->tuner_freq.wait);
-	init_waitqueue_head(&pod->tuner_note.wait);
-	init_waitqueue_head(&pod->tuner_pitch.wait);
-	init_waitqueue_head(&pod->clipping.wait);
-
-	memset(pod->param_dirty, 0xff, sizeof(pod->param_dirty));
-
-	/* initialize USB buffers: */
-	err = line6_dumpreq_init(&pod->dumpreq, pod_request_channel,
-				 sizeof(pod_request_channel));
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return -ENOMEM;
-	}
-
-	/* create sysfs entries: */
-	err = pod_create_files2(&interface->dev);
-	if (err < 0)
-		return err;
-
-	/* initialize audio system: */
-	err = line6_init_audio(line6);
-	if (err < 0)
-		return err;
-
-	/* initialize MIDI subsystem: */
-	err = line6_init_midi(line6);
-	if (err < 0)
-		return err;
-
-	/* initialize PCM subsystem: */
-	err = line6_init_pcm(line6, &pod_pcm_properties);
-	if (err < 0)
-		return err;
-
-	/* register monitor control: */
-	err = snd_ctl_add(line6->card,
-			  snd_ctl_new1(&pod_control_monitor, line6->line6pcm));
-	if (err < 0)
-		return err;
-
-	/*
-	   When the sound card is registered at this point, the PODxt Live
-	   displays "Invalid Code Error 07", so we do it later in the event
-	   handler.
-	 */
-
-	if (pod->line6.properties->capabilities & LINE6_BIT_CONTROL) {
-		pod->monitor_level.value = POD_system_invalid;
-
-		/* initiate startup procedure: */
-		pod_startup1(pod);
-	}
-
-	return 0;
-}
-
-/*
-	 Init POD device (and clean up in case of failure).
-*/
-int line6_pod_init(struct usb_interface *interface, struct usb_line6_pod *pod)
-{
-	int err = pod_try_init(interface, pod);
-
-	if (err < 0)
-		pod_destruct(interface);
-
-	return err;
-}
-
-/*
-	POD device disconnected.
-*/
-void line6_pod_disconnect(struct usb_interface *interface)
-{
-	struct usb_line6_pod *pod;
-
-	if (interface == NULL)
-		return;
-	pod = usb_get_intfdata(interface);
-
-	if (pod != NULL) {
-		struct snd_line6_pcm *line6pcm = pod->line6.line6pcm;
-		struct device *dev = &interface->dev;
-
-		if (line6pcm != NULL)
-			line6_pcm_disconnect(line6pcm);
-
-		if (dev != NULL) {
-			/* remove sysfs entries: */
-			line6_pod_remove_files(pod->firmware_version,
-					       pod->line6.
-					       properties->device_bit, dev);
-
-			device_remove_file(dev, &dev_attr_channel);
-			device_remove_file(dev, &dev_attr_clip);
-			device_remove_file(dev, &dev_attr_device_id);
-			device_remove_file(dev, &dev_attr_dirty);
-			device_remove_file(dev, &dev_attr_dump);
-			device_remove_file(dev, &dev_attr_dump_buf);
-			device_remove_file(dev, &dev_attr_finish);
-			device_remove_file(dev, &dev_attr_firmware_version);
-			device_remove_file(dev, &dev_attr_midi_postprocess);
-			device_remove_file(dev, &dev_attr_monitor_level);
-			device_remove_file(dev, &dev_attr_name);
-			device_remove_file(dev, &dev_attr_name_buf);
-			device_remove_file(dev, &dev_attr_retrieve_amp_setup);
-			device_remove_file(dev, &dev_attr_retrieve_channel);
-			device_remove_file(dev,
-					   &dev_attr_retrieve_effects_setup);
-			device_remove_file(dev, &dev_attr_routing);
-			device_remove_file(dev, &dev_attr_serial_number);
-			device_remove_file(dev, &dev_attr_store_amp_setup);
-			device_remove_file(dev, &dev_attr_store_channel);
-			device_remove_file(dev, &dev_attr_store_effects_setup);
-			device_remove_file(dev, &dev_attr_tuner_freq);
-			device_remove_file(dev, &dev_attr_tuner_mute);
-			device_remove_file(dev, &dev_attr_tuner_note);
-			device_remove_file(dev, &dev_attr_tuner_pitch);
-
-#ifdef CONFIG_LINE6_USB_RAW
-			device_remove_file(dev, &dev_attr_raw);
-#endif
-		}
-	}
-
-	pod_destruct(interface);
-}
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
deleted file mode 100644
index 47e0d1a..0000000
--- a/drivers/staging/line6/pod.h
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef POD_H
-#define POD_H
-
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/usb.h>
-#include <linux/wait.h>
-
-#include <sound/core.h>
-
-#include "driver.h"
-#include "dumprequest.h"
-
-/*
-	PODxt Live interfaces
-*/
-#define PODXTLIVE_INTERFACE_POD    0
-#define PODXTLIVE_INTERFACE_VARIAX 1
-
-/*
-	Locate name in binary program dump
-*/
-#define	POD_NAME_OFFSET 0
-#define	POD_NAME_LENGTH 16
-
-/*
-	Other constants
-*/
-#define POD_CONTROL_SIZE 0x80
-#define POD_BUFSIZE_DUMPREQ 7
-#define POD_STARTUP_DELAY 1000
-
-/*
-	Stages of POD startup procedure
-*/
-enum {
-	POD_STARTUP_INIT = 1,
-	POD_STARTUP_DUMPREQ,
-	POD_STARTUP_VERSIONREQ,
-	POD_STARTUP_WORKQUEUE,
-	POD_STARTUP_SETUP,
-	POD_STARTUP_LAST = POD_STARTUP_SETUP - 1
-};
-
-/**
-	Data structure for values that need to be requested explicitly.
-	This is the case for system and tuner settings.
-*/
-struct ValueWait {
-	int value;
-	wait_queue_head_t wait;
-};
-
-/**
-	Binary PODxt Pro program dump
-*/
-struct pod_program {
-	/**
-		Header information (including program name).
-	*/
-	unsigned char header[0x20];
-
-	/**
-		Program parameters.
-	*/
-	unsigned char control[POD_CONTROL_SIZE];
-};
-
-struct usb_line6_pod {
-	/**
-		Generic Line6 USB data.
-	*/
-	struct usb_line6 line6;
-
-	/**
-		Dump request structure.
-	*/
-	struct line6_dump_request dumpreq;
-
-	/**
-		Current program number.
-	*/
-	unsigned char channel_num;
-
-	/**
-		Current program settings.
-	*/
-	struct pod_program prog_data;
-
-	/**
-		Buffer for data retrieved from or to be stored on PODxt Pro.
-	*/
-	struct pod_program prog_data_buf;
-
-	/**
-		Tuner mute mode.
-	*/
-	struct ValueWait tuner_mute;
-
-	/**
-		Tuner base frequency (typically 440Hz).
-	*/
-	struct ValueWait tuner_freq;
-
-	/**
-		Note received from tuner.
-	*/
-	struct ValueWait tuner_note;
-
-	/**
-		Pitch value received from tuner.
-	*/
-	struct ValueWait tuner_pitch;
-
-	/**
-		Instrument monitor level.
-	*/
-	struct ValueWait monitor_level;
-
-	/**
-		Audio routing mode.
-		0: send processed guitar
-		1: send clean guitar
-		2: send clean guitar re-amp playback
-		3: send re-amp playback
-	*/
-	struct ValueWait routing;
-
-	/**
-		Wait for audio clipping event.
-	*/
-	struct ValueWait clipping;
-
-	/**
-		Timer for device initializaton.
-	*/
-	struct timer_list startup_timer;
-
-	/**
-		Work handler for device initializaton.
-	*/
-	struct work_struct startup_work;
-
-	/**
-		Current progress in startup procedure.
-	*/
-	int startup_progress;
-
-	/**
-		Dirty flags for access to parameter data.
-	*/
-	unsigned long param_dirty[POD_CONTROL_SIZE / sizeof(unsigned long)];
-
-	/**
-		Some atomic flags.
-	*/
-	unsigned long atomic_flags;
-
-	/**
-		Serial number of device.
-	*/
-	int serial_number;
-
-	/**
-		Firmware version (x 100).
-	*/
-	int firmware_version;
-
-	/**
-		Device ID.
-	*/
-	int device_id;
-
-	/**
-		Flag to indicate modification of current program settings.
-	*/
-	char dirty;
-
-	/**
-		Flag to enable MIDI postprocessing.
-	*/
-	char midi_postprocess;
-};
-
-extern void line6_pod_disconnect(struct usb_interface *interface);
-extern int line6_pod_init(struct usb_interface *interface,
-			  struct usb_line6_pod *pod);
-extern void line6_pod_midi_postprocess(struct usb_line6_pod *pod,
-				       unsigned char *data, int length);
-extern void line6_pod_process_message(struct usb_line6_pod *pod);
-extern void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
-					 u8 value);
-
-#endif
diff --git a/drivers/staging/line6/podhd.c b/drivers/staging/line6/podhd.c
deleted file mode 100644
index 7ef4543..0000000
--- a/drivers/staging/line6/podhd.c
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * Line6 Pod HD
- *
- * Copyright (C) 2011 Stefan Hajnoczi <stefanha@gmail.com>
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <sound/core.h>
-#include <sound/pcm.h>
-
-#include "audio.h"
-#include "driver.h"
-#include "pcm.h"
-#include "podhd.h"
-
-#define PODHD_BYTES_PER_FRAME 6	/* 24bit audio (stereo) */
-
-static struct snd_ratden podhd_ratden = {
-	.num_min = 48000,
-	.num_max = 48000,
-	.num_step = 1,
-	.den = 1,
-};
-
-static struct line6_pcm_properties podhd_pcm_properties = {
-	.snd_line6_playback_hw = {
-				  .info = (SNDRV_PCM_INFO_MMAP |
-					   SNDRV_PCM_INFO_INTERLEAVED |
-					   SNDRV_PCM_INFO_BLOCK_TRANSFER |
-					   SNDRV_PCM_INFO_MMAP_VALID |
-					   SNDRV_PCM_INFO_PAUSE |
-#ifdef CONFIG_PM
-					   SNDRV_PCM_INFO_RESUME |
-#endif
-					   SNDRV_PCM_INFO_SYNC_START),
-				  .formats = SNDRV_PCM_FMTBIT_S24_3LE,
-				  .rates = SNDRV_PCM_RATE_48000,
-				  .rate_min = 48000,
-				  .rate_max = 48000,
-				  .channels_min = 2,
-				  .channels_max = 2,
-				  .buffer_bytes_max = 60000,
-				  .period_bytes_min = 64,
-				  .period_bytes_max = 8192,
-				  .periods_min = 1,
-				  .periods_max = 1024},
-	.snd_line6_capture_hw = {
-				 .info = (SNDRV_PCM_INFO_MMAP |
-					  SNDRV_PCM_INFO_INTERLEAVED |
-					  SNDRV_PCM_INFO_BLOCK_TRANSFER |
-					  SNDRV_PCM_INFO_MMAP_VALID |
-#ifdef CONFIG_PM
-					  SNDRV_PCM_INFO_RESUME |
-#endif
-					  SNDRV_PCM_INFO_SYNC_START),
-				 .formats = SNDRV_PCM_FMTBIT_S24_3LE,
-				 .rates = SNDRV_PCM_RATE_48000,
-				 .rate_min = 48000,
-				 .rate_max = 48000,
-				 .channels_min = 2,
-				 .channels_max = 2,
-				 .buffer_bytes_max = 60000,
-				 .period_bytes_min = 64,
-				 .period_bytes_max = 8192,
-				 .periods_min = 1,
-				 .periods_max = 1024},
-	.snd_line6_rates = {
-			    .nrats = 1,
-			    .rats = &podhd_ratden},
-	.bytes_per_frame = PODHD_BYTES_PER_FRAME
-};
-
-/*
-	POD HD destructor.
-*/
-static void podhd_destruct(struct usb_interface *interface)
-{
-	struct usb_line6_podhd *podhd = usb_get_intfdata(interface);
-
-	if (podhd == NULL)
-		return;
-	line6_cleanup_audio(&podhd->line6);
-}
-
-/*
-	Try to init POD HD device.
-*/
-static int podhd_try_init(struct usb_interface *interface,
-			  struct usb_line6_podhd *podhd)
-{
-	int err;
-	struct usb_line6 *line6 = &podhd->line6;
-
-	if ((interface == NULL) || (podhd == NULL))
-		return -ENODEV;
-
-	/* initialize audio system: */
-	err = line6_init_audio(line6);
-	if (err < 0)
-		return err;
-
-	/* initialize MIDI subsystem: */
-	err = line6_init_midi(line6);
-	if (err < 0)
-		return err;
-
-	/* initialize PCM subsystem: */
-	err = line6_init_pcm(line6, &podhd_pcm_properties);
-	if (err < 0)
-		return err;
-
-	/* register USB audio system: */
-	err = line6_register_audio(line6);
-	return err;
-}
-
-/*
-	Init POD HD device (and clean up in case of failure).
-*/
-int line6_podhd_init(struct usb_interface *interface,
-		     struct usb_line6_podhd *podhd)
-{
-	int err = podhd_try_init(interface, podhd);
-
-	if (err < 0)
-		podhd_destruct(interface);
-
-	return err;
-}
-
-/*
-	POD HD device disconnected.
-*/
-void line6_podhd_disconnect(struct usb_interface *interface)
-{
-	struct usb_line6_podhd *podhd;
-
-	if (interface == NULL)
-		return;
-	podhd = usb_get_intfdata(interface);
-
-	if (podhd != NULL) {
-		struct snd_line6_pcm *line6pcm = podhd->line6.line6pcm;
-
-		if (line6pcm != NULL)
-			line6_pcm_disconnect(line6pcm);
-	}
-
-	podhd_destruct(interface);
-}
diff --git a/drivers/staging/line6/podhd.h b/drivers/staging/line6/podhd.h
deleted file mode 100644
index 652f740..0000000
--- a/drivers/staging/line6/podhd.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Line6 Pod HD
- *
- * Copyright (C) 2011 Stefan Hajnoczi <stefanha@gmail.com>
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef PODHD_H
-#define PODHD_H
-
-#include <linux/usb.h>
-
-#include "driver.h"
-
-struct usb_line6_podhd {
-	/**
-		Generic Line6 USB data.
-	*/
-	struct usb_line6 line6;
-};
-
-extern void line6_podhd_disconnect(struct usb_interface *interface);
-extern int line6_podhd_init(struct usb_interface *interface,
-			    struct usb_line6_podhd *podhd);
-
-#endif /* PODHD_H */
diff --git a/drivers/staging/line6/revision.h b/drivers/staging/line6/revision.h
deleted file mode 100644
index b4eee2b..0000000
--- a/drivers/staging/line6/revision.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef DRIVER_REVISION
-/* current subversion revision */
-#define DRIVER_REVISION " (904)"
-#endif
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
deleted file mode 100644
index 31b624b..0000000
--- a/drivers/staging/line6/toneport.c
+++ /dev/null
@@ -1,455 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *                         Emil Myhrman (emil.myhrman@gmail.com)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/wait.h>
-#include <sound/control.h>
-
-#include "audio.h"
-#include "capture.h"
-#include "driver.h"
-#include "playback.h"
-#include "toneport.h"
-
-static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2);
-
-#define TONEPORT_PCM_DELAY 1
-
-static struct snd_ratden toneport_ratden = {
-	.num_min = 44100,
-	.num_max = 44100,
-	.num_step = 1,
-	.den = 1
-};
-
-static struct line6_pcm_properties toneport_pcm_properties = {
-	.snd_line6_playback_hw = {
-				  .info = (SNDRV_PCM_INFO_MMAP |
-					   SNDRV_PCM_INFO_INTERLEAVED |
-					   SNDRV_PCM_INFO_BLOCK_TRANSFER |
-					   SNDRV_PCM_INFO_MMAP_VALID |
-					   SNDRV_PCM_INFO_PAUSE |
-#ifdef CONFIG_PM
-					   SNDRV_PCM_INFO_RESUME |
-#endif
-					   SNDRV_PCM_INFO_SYNC_START),
-				  .formats = SNDRV_PCM_FMTBIT_S16_LE,
-				  .rates = SNDRV_PCM_RATE_KNOT,
-				  .rate_min = 44100,
-				  .rate_max = 44100,
-				  .channels_min = 2,
-				  .channels_max = 2,
-				  .buffer_bytes_max = 60000,
-				  .period_bytes_min = 64,
-				  .period_bytes_max = 8192,
-				  .periods_min = 1,
-				  .periods_max = 1024},
-	.snd_line6_capture_hw = {
-				 .info = (SNDRV_PCM_INFO_MMAP |
-					  SNDRV_PCM_INFO_INTERLEAVED |
-					  SNDRV_PCM_INFO_BLOCK_TRANSFER |
-					  SNDRV_PCM_INFO_MMAP_VALID |
-#ifdef CONFIG_PM
-					  SNDRV_PCM_INFO_RESUME |
-#endif
-					  SNDRV_PCM_INFO_SYNC_START),
-				 .formats = SNDRV_PCM_FMTBIT_S16_LE,
-				 .rates = SNDRV_PCM_RATE_KNOT,
-				 .rate_min = 44100,
-				 .rate_max = 44100,
-				 .channels_min = 2,
-				 .channels_max = 2,
-				 .buffer_bytes_max = 60000,
-				 .period_bytes_min = 64,
-				 .period_bytes_max = 8192,
-				 .periods_min = 1,
-				 .periods_max = 1024},
-	.snd_line6_rates = {
-			    .nrats = 1,
-			    .rats = &toneport_ratden},
-	.bytes_per_frame = 4
-};
-
-/*
-	For the led on Guitarport.
-	Brightness goes from 0x00 to 0x26. Set a value above this to have led
-	blink.
-	(void cmd_0x02(byte red, byte green)
-*/
-static int led_red = 0x00;
-static int led_green = 0x26;
-
-struct ToneportSourceInfo {
-	const char *name;
-	int code;
-};
-
-static const struct ToneportSourceInfo toneport_source_info[] = {
-	{"Microphone", 0x0a01},
-	{"Line", 0x0801},
-	{"Instrument", 0x0b01},
-	{"Inst & Mic", 0x0901}
-};
-
-static bool toneport_has_led(short product)
-{
-	return
-	    (product == LINE6_DEVID_GUITARPORT) ||
-	    (product == LINE6_DEVID_TONEPORT_GX);
-	/* add your device here if you are missing support for the LEDs */
-}
-
-static void toneport_update_led(struct device *dev)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_toneport *tp = usb_get_intfdata(interface);
-	struct usb_line6 *line6;
-
-	if (!tp)
-		return;
-
-	line6 = &tp->line6;
-	if (line6)
-		toneport_send_cmd(line6->usbdev, (led_red << 8) | 0x0002,
-				  led_green);
-}
-
-static ssize_t toneport_set_led_red(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t count)
-{
-	int retval;
-	long value;
-
-	retval = strict_strtol(buf, 10, &value);
-	if (retval)
-		return retval;
-
-	led_red = value;
-	toneport_update_led(dev);
-	return count;
-}
-
-static ssize_t toneport_set_led_green(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf, size_t count)
-{
-	int retval;
-	long value;
-
-	retval = strict_strtol(buf, 10, &value);
-	if (retval)
-		return retval;
-
-	led_green = value;
-	toneport_update_led(dev);
-	return count;
-}
-
-static DEVICE_ATTR(led_red, S_IWUSR | S_IRUGO, line6_nop_read,
-		   toneport_set_led_red);
-static DEVICE_ATTR(led_green, S_IWUSR | S_IRUGO, line6_nop_read,
-		   toneport_set_led_green);
-
-static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2)
-{
-	int ret;
-
-	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
-			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			      cmd1, cmd2, NULL, 0, LINE6_TIMEOUT * HZ);
-
-	if (ret < 0) {
-		dev_err(&usbdev->dev, "send failed (error %d)\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-/* monitor info callback */
-static int snd_toneport_monitor_info(struct snd_kcontrol *kcontrol,
-				     struct snd_ctl_elem_info *uinfo)
-{
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
-	uinfo->count = 1;
-	uinfo->value.integer.min = 0;
-	uinfo->value.integer.max = 256;
-	return 0;
-}
-
-/* monitor get callback */
-static int snd_toneport_monitor_get(struct snd_kcontrol *kcontrol,
-				    struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-	ucontrol->value.integer.value[0] = line6pcm->volume_monitor;
-	return 0;
-}
-
-/* monitor put callback */
-static int snd_toneport_monitor_put(struct snd_kcontrol *kcontrol,
-				    struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-
-	if (ucontrol->value.integer.value[0] == line6pcm->volume_monitor)
-		return 0;
-
-	line6pcm->volume_monitor = ucontrol->value.integer.value[0];
-
-	if (line6pcm->volume_monitor > 0)
-		line6_pcm_acquire(line6pcm, LINE6_BITS_PCM_MONITOR);
-	else
-		line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
-
-	return 1;
-}
-
-/* source info callback */
-static int snd_toneport_source_info(struct snd_kcontrol *kcontrol,
-				    struct snd_ctl_elem_info *uinfo)
-{
-	const int size = ARRAY_SIZE(toneport_source_info);
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
-	uinfo->count = 1;
-	uinfo->value.enumerated.items = size;
-
-	if (uinfo->value.enumerated.item >= size)
-		uinfo->value.enumerated.item = size - 1;
-
-	strcpy(uinfo->value.enumerated.name,
-	       toneport_source_info[uinfo->value.enumerated.item].name);
-
-	return 0;
-}
-
-/* source get callback */
-static int snd_toneport_source_get(struct snd_kcontrol *kcontrol,
-				   struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-	struct usb_line6_toneport *toneport =
-	    (struct usb_line6_toneport *)line6pcm->line6;
-	ucontrol->value.enumerated.item[0] = toneport->source;
-	return 0;
-}
-
-/* source put callback */
-static int snd_toneport_source_put(struct snd_kcontrol *kcontrol,
-				   struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
-	struct usb_line6_toneport *toneport =
-	    (struct usb_line6_toneport *)line6pcm->line6;
-
-	if (ucontrol->value.enumerated.item[0] == toneport->source)
-		return 0;
-
-	toneport->source = ucontrol->value.enumerated.item[0];
-	toneport_send_cmd(toneport->line6.usbdev,
-			  toneport_source_info[toneport->source].code, 0x0000);
-	return 1;
-}
-
-static void toneport_start_pcm(unsigned long arg)
-{
-	struct usb_line6_toneport *toneport = (struct usb_line6_toneport *)arg;
-	struct usb_line6 *line6 = &toneport->line6;
-	line6_pcm_acquire(line6->line6pcm, LINE6_BITS_PCM_MONITOR);
-}
-
-/* control definition */
-static struct snd_kcontrol_new toneport_control_monitor = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Monitor Playback Volume",
-	.index = 0,
-	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
-	.info = snd_toneport_monitor_info,
-	.get = snd_toneport_monitor_get,
-	.put = snd_toneport_monitor_put
-};
-
-/* source selector definition */
-static struct snd_kcontrol_new toneport_control_source = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "PCM Capture Source",
-	.index = 0,
-	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
-	.info = snd_toneport_source_info,
-	.get = snd_toneport_source_get,
-	.put = snd_toneport_source_put
-};
-
-/*
-	Toneport destructor.
-*/
-static void toneport_destruct(struct usb_interface *interface)
-{
-	struct usb_line6_toneport *toneport = usb_get_intfdata(interface);
-
-	if (toneport == NULL)
-		return;
-	line6_cleanup_audio(&toneport->line6);
-}
-
-/*
-	Setup Toneport device.
-*/
-static void toneport_setup(struct usb_line6_toneport *toneport)
-{
-	int ticks;
-	struct usb_line6 *line6 = &toneport->line6;
-	struct usb_device *usbdev = line6->usbdev;
-
-	/* sync time on device with host: */
-	ticks = (int)get_seconds();
-	line6_write_data(line6, 0x80c6, &ticks, 4);
-
-	/* enable device: */
-	toneport_send_cmd(usbdev, 0x0301, 0x0000);
-
-	/* initialize source select: */
-	switch (usbdev->descriptor.idProduct) {
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-		toneport_send_cmd(usbdev,
-				  toneport_source_info[toneport->source].code,
-				  0x0000);
-	}
-
-	if (toneport_has_led(usbdev->descriptor.idProduct))
-		toneport_update_led(&usbdev->dev);
-}
-
-/*
-	 Try to init Toneport device.
-*/
-static int toneport_try_init(struct usb_interface *interface,
-			     struct usb_line6_toneport *toneport)
-{
-	int err;
-	struct usb_line6 *line6 = &toneport->line6;
-	struct usb_device *usbdev = line6->usbdev;
-
-	if ((interface == NULL) || (toneport == NULL))
-		return -ENODEV;
-
-	/* initialize audio system: */
-	err = line6_init_audio(line6);
-	if (err < 0)
-		return err;
-
-	/* initialize PCM subsystem: */
-	err = line6_init_pcm(line6, &toneport_pcm_properties);
-	if (err < 0)
-		return err;
-
-	/* register monitor control: */
-	err = snd_ctl_add(line6->card,
-			  snd_ctl_new1(&toneport_control_monitor,
-				       line6->line6pcm));
-	if (err < 0)
-		return err;
-
-	/* register source select control: */
-	switch (usbdev->descriptor.idProduct) {
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-		err =
-		    snd_ctl_add(line6->card,
-				snd_ctl_new1(&toneport_control_source,
-					     line6->line6pcm));
-		if (err < 0)
-			return err;
-	}
-
-	/* register audio system: */
-	err = line6_register_audio(line6);
-	if (err < 0)
-		return err;
-
-	line6_read_serial_number(line6, &toneport->serial_number);
-	line6_read_data(line6, 0x80c2, &toneport->firmware_version, 1);
-
-	if (toneport_has_led(usbdev->descriptor.idProduct)) {
-		CHECK_RETURN(device_create_file
-			     (&interface->dev, &dev_attr_led_red));
-		CHECK_RETURN(device_create_file
-			     (&interface->dev, &dev_attr_led_green));
-	}
-
-	toneport_setup(toneport);
-
-	init_timer(&toneport->timer);
-	toneport->timer.expires = jiffies + TONEPORT_PCM_DELAY * HZ;
-	toneport->timer.function = toneport_start_pcm;
-	toneport->timer.data = (unsigned long)toneport;
-	add_timer(&toneport->timer);
-
-	return 0;
-}
-
-/*
-	 Init Toneport device (and clean up in case of failure).
-*/
-int line6_toneport_init(struct usb_interface *interface,
-			struct usb_line6_toneport *toneport)
-{
-	int err = toneport_try_init(interface, toneport);
-
-	if (err < 0)
-		toneport_destruct(interface);
-
-	return err;
-}
-
-/*
-	Resume Toneport device after reset.
-*/
-void line6_toneport_reset_resume(struct usb_line6_toneport *toneport)
-{
-	toneport_setup(toneport);
-}
-
-/*
-	Toneport device disconnected.
-*/
-void line6_toneport_disconnect(struct usb_interface *interface)
-{
-	struct usb_line6_toneport *toneport;
-
-	if (interface == NULL)
-		return;
-
-	toneport = usb_get_intfdata(interface);
-	del_timer_sync(&toneport->timer);
-
-	if (toneport_has_led(toneport->line6.usbdev->descriptor.idProduct)) {
-		device_remove_file(&interface->dev, &dev_attr_led_red);
-		device_remove_file(&interface->dev, &dev_attr_led_green);
-	}
-
-	if (toneport != NULL) {
-		struct snd_line6_pcm *line6pcm = toneport->line6.line6pcm;
-
-		if (line6pcm != NULL) {
-			line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
-			line6_pcm_disconnect(line6pcm);
-		}
-	}
-
-	toneport_destruct(interface);
-}
diff --git a/drivers/staging/line6/toneport.h b/drivers/staging/line6/toneport.h
deleted file mode 100644
index 8576b72..0000000
--- a/drivers/staging/line6/toneport.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef TONEPORT_H
-#define TONEPORT_H
-
-#include <linux/usb.h>
-#include <sound/core.h>
-
-#include "driver.h"
-
-struct usb_line6_toneport {
-	/**
-		Generic Line6 USB data.
-	*/
-	struct usb_line6 line6;
-
-	/**
-		Source selector.
-	*/
-	int source;
-
-	/**
-		Serial number of device.
-	*/
-	int serial_number;
-
-	/**
-		Firmware version (x 100).
-	*/
-	int firmware_version;
-
-	/**
-		 Timer for delayed PCM startup.
-	*/
-	struct timer_list timer;
-};
-
-extern void line6_toneport_disconnect(struct usb_interface *interface);
-extern int line6_toneport_init(struct usb_interface *interface,
-			       struct usb_line6_toneport *toneport);
-extern void line6_toneport_reset_resume(struct usb_line6_toneport *toneport);
-
-#endif
diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
deleted file mode 100644
index 353d59d..0000000
--- a/drivers/staging/line6/usbdefs.h
+++ /dev/null
@@ -1,107 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2005-2008 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef USBDEFS_H
-#define USBDEFS_H
-
-#define LINE6_VENDOR_ID  0x0e41
-
-#define USB_INTERVALS_PER_SECOND 1000
-
-/*
-	Device ids.
-*/
-#define LINE6_DEVID_BASSPODXT     0x4250
-#define LINE6_DEVID_BASSPODXTLIVE 0x4642
-#define LINE6_DEVID_BASSPODXTPRO  0x4252
-#define LINE6_DEVID_GUITARPORT    0x4750
-#define LINE6_DEVID_POCKETPOD     0x5051
-#define LINE6_DEVID_PODHD300      0x5057
-#define LINE6_DEVID_PODHD500      0x414D
-#define LINE6_DEVID_PODSTUDIO_GX  0x4153
-#define LINE6_DEVID_PODSTUDIO_UX1 0x4150
-#define LINE6_DEVID_PODSTUDIO_UX2 0x4151
-#define LINE6_DEVID_PODX3         0x414a
-#define LINE6_DEVID_PODX3LIVE     0x414b
-#define LINE6_DEVID_PODXT         0x5044
-#define LINE6_DEVID_PODXTLIVE     0x4650
-#define LINE6_DEVID_PODXTPRO      0x5050
-#define LINE6_DEVID_TONEPORT_GX   0x4147
-#define LINE6_DEVID_TONEPORT_UX1  0x4141
-#define LINE6_DEVID_TONEPORT_UX2  0x4142
-#define LINE6_DEVID_VARIAX        0x534d
-
-#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
-
-enum {
-	LINE6_INDEX_BASSPODXT,
-	LINE6_INDEX_BASSPODXTLIVE,
-	LINE6_INDEX_BASSPODXTPRO,
-	LINE6_INDEX_GUITARPORT,
-	LINE6_INDEX_POCKETPOD,
-	LINE6_INDEX_PODHD300,
-	LINE6_INDEX_PODHD500,
-	LINE6_INDEX_PODSTUDIO_GX,
-	LINE6_INDEX_PODSTUDIO_UX1,
-	LINE6_INDEX_PODSTUDIO_UX2,
-	LINE6_INDEX_PODX3,
-	LINE6_INDEX_PODX3LIVE,
-	LINE6_INDEX_PODXT,
-	LINE6_INDEX_PODXTLIVE,
-	LINE6_INDEX_PODXTPRO,
-	LINE6_INDEX_TONEPORT_GX,
-	LINE6_INDEX_TONEPORT_UX1,
-	LINE6_INDEX_TONEPORT_UX2,
-	LINE6_INDEX_VARIAX,
-
-	LINE6_BIT(BASSPODXT),
-	LINE6_BIT(BASSPODXTLIVE),
-	LINE6_BIT(BASSPODXTPRO),
-	LINE6_BIT(GUITARPORT),
-	LINE6_BIT(POCKETPOD),
-	LINE6_BIT(PODHD300),
-	LINE6_BIT(PODHD500),
-	LINE6_BIT(PODSTUDIO_GX),
-	LINE6_BIT(PODSTUDIO_UX1),
-	LINE6_BIT(PODSTUDIO_UX2),
-	LINE6_BIT(PODX3),
-	LINE6_BIT(PODX3LIVE),
-	LINE6_BIT(PODXT),
-	LINE6_BIT(PODXTLIVE),
-	LINE6_BIT(PODXTPRO),
-	LINE6_BIT(TONEPORT_GX),
-	LINE6_BIT(TONEPORT_UX1),
-	LINE6_BIT(TONEPORT_UX2),
-	LINE6_BIT(VARIAX),
-
-	LINE6_BITS_PRO = LINE6_BIT_BASSPODXTPRO | LINE6_BIT_PODXTPRO,
-	LINE6_BITS_LIVE = LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_PODXTLIVE | LINE6_BIT_PODX3LIVE,
-	LINE6_BITS_PODXTALL = LINE6_BIT_PODXT | LINE6_BIT_PODXTLIVE | LINE6_BIT_PODXTPRO,
-	LINE6_BITS_PODX3ALL = LINE6_BIT_PODX3 | LINE6_BIT_PODX3LIVE,
-	LINE6_BITS_PODHDALL = LINE6_BIT_PODHD300 | LINE6_BIT_PODHD500,
-	LINE6_BITS_BASSPODXTALL	= LINE6_BIT_BASSPODXT |	LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_BASSPODXTPRO
-};
-
-/* device supports settings parameter via USB */
-#define LINE6_BIT_CONTROL (1 << 0)
-/* device supports PCM input/output via USB */
-#define LINE6_BIT_PCM (1 << 1)
-/* device support hardware monitoring */
-#define LINE6_BIT_HWMON (1 << 2)
-
-#define LINE6_BIT_CONTROL_PCM_HWMON	(LINE6_BIT_CONTROL |	\
-					 LINE6_BIT_PCM |	\
-					 LINE6_BIT_HWMON)
-
-#define LINE6_FALLBACK_INTERVAL 10
-#define LINE6_FALLBACK_MAXPACKETSIZE 16
-
-#endif
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
deleted file mode 100644
index f97416b..0000000
--- a/drivers/staging/line6/variax.c
+++ /dev/null
@@ -1,719 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-
-#include "audio.h"
-#include "control.h"
-#include "driver.h"
-#include "variax.h"
-
-#define VARIAX_SYSEX_CODE 7
-#define VARIAX_SYSEX_PARAM 0x3b
-#define VARIAX_SYSEX_ACTIVATE 0x2a
-#define VARIAX_MODEL_HEADER_LENGTH 7
-#define VARIAX_MODEL_MESSAGE_LENGTH 199
-#define VARIAX_OFFSET_ACTIVATE 7
-
-/*
-	This message is sent by the device during initialization and identifies
-	the connected guitar model.
-*/
-static const char variax_init_model[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x69, 0x02,
-	0x00
-};
-
-/*
-	This message is sent by the device during initialization and identifies
-	the connected guitar version.
-*/
-static const char variax_init_version[] = {
-	0xf0, 0x7e, 0x7f, 0x06, 0x02, 0x00, 0x01, 0x0c,
-	0x07, 0x00, 0x00, 0x00
-};
-
-/*
-	This message is the last one sent by the device during initialization.
-*/
-static const char variax_init_done[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x6b
-};
-
-static const char variax_activate[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x2a, 0x01,
-	0xf7
-};
-
-static const char variax_request_bank[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x6d, 0xf7
-};
-
-static const char variax_request_model1[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x3c, 0x00,
-	0x02, 0x00, 0x00, 0x00, 0x00, 0x03, 0x05, 0x03,
-	0x00, 0x00, 0x00, 0xf7
-};
-
-static const char variax_request_model2[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x3c, 0x00,
-	0x02, 0x00, 0x00, 0x00, 0x00, 0x03, 0x07, 0x03,
-	0x00, 0x00, 0x00, 0xf7
-};
-
-/* forward declarations: */
-static int variax_create_files2(struct device *dev);
-static void variax_startup2(unsigned long data);
-static void variax_startup4(unsigned long data);
-static void variax_startup5(unsigned long data);
-
-/*
-	Decode data transmitted by workbench.
-*/
-static void variax_decode(const unsigned char *raw_data, unsigned char *data,
-			  int raw_size)
-{
-	for (; raw_size > 0; raw_size -= 6) {
-		data[2] = raw_data[0] | (raw_data[1] << 4);
-		data[1] = raw_data[2] | (raw_data[3] << 4);
-		data[0] = raw_data[4] | (raw_data[5] << 4);
-		raw_data += 6;
-		data += 3;
-	}
-}
-
-static void variax_activate_async(struct usb_line6_variax *variax, int a)
-{
-	variax->buffer_activate[VARIAX_OFFSET_ACTIVATE] = a;
-	line6_send_raw_message_async(&variax->line6, variax->buffer_activate,
-				     sizeof(variax_activate));
-}
-
-/*
-	Variax startup procedure.
-	This is a sequence of functions with special requirements (e.g., must
-	not run immediately after initialization, must not run in interrupt
-	context). After the last one has finished, the device is ready to use.
-*/
-
-static void variax_startup1(struct usb_line6_variax *variax)
-{
-	CHECK_STARTUP_PROGRESS(variax->startup_progress, VARIAX_STARTUP_INIT);
-
-	/* delay startup procedure: */
-	line6_start_timer(&variax->startup_timer1, VARIAX_STARTUP_DELAY1,
-			  variax_startup2, (unsigned long)variax);
-}
-
-static void variax_startup2(unsigned long data)
-{
-	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
-	struct usb_line6 *line6 = &variax->line6;
-
-	/* schedule another startup procedure until startup is complete: */
-	if (variax->startup_progress >= VARIAX_STARTUP_LAST)
-		return;
-
-	variax->startup_progress = VARIAX_STARTUP_VERSIONREQ;
-	line6_start_timer(&variax->startup_timer1, VARIAX_STARTUP_DELAY1,
-			  variax_startup2, (unsigned long)variax);
-
-	/* request firmware version: */
-	line6_version_request_async(line6);
-}
-
-static void variax_startup3(struct usb_line6_variax *variax)
-{
-	CHECK_STARTUP_PROGRESS(variax->startup_progress, VARIAX_STARTUP_WAIT);
-
-	/* delay startup procedure: */
-	line6_start_timer(&variax->startup_timer2, VARIAX_STARTUP_DELAY3,
-			  variax_startup4, (unsigned long)variax);
-}
-
-static void variax_startup4(unsigned long data)
-{
-	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
-	CHECK_STARTUP_PROGRESS(variax->startup_progress,
-			       VARIAX_STARTUP_ACTIVATE);
-
-	/* activate device: */
-	variax_activate_async(variax, 1);
-	line6_start_timer(&variax->startup_timer2, VARIAX_STARTUP_DELAY4,
-			  variax_startup5, (unsigned long)variax);
-}
-
-static void variax_startup5(unsigned long data)
-{
-	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
-	CHECK_STARTUP_PROGRESS(variax->startup_progress,
-			       VARIAX_STARTUP_DUMPREQ);
-
-	/* current model dump: */
-	line6_dump_request_async(&variax->dumpreq, &variax->line6, 0,
-				 VARIAX_DUMP_PASS1);
-	/* passes 2 and 3 are performed implicitly before entering variax_startup6 */
-}
-
-static void variax_startup6(struct usb_line6_variax *variax)
-{
-	CHECK_STARTUP_PROGRESS(variax->startup_progress,
-			       VARIAX_STARTUP_WORKQUEUE);
-
-	/* schedule work for global work queue: */
-	schedule_work(&variax->startup_work);
-}
-
-static void variax_startup7(struct work_struct *work)
-{
-	struct usb_line6_variax *variax =
-	    container_of(work, struct usb_line6_variax, startup_work);
-	struct usb_line6 *line6 = &variax->line6;
-
-	CHECK_STARTUP_PROGRESS(variax->startup_progress, VARIAX_STARTUP_SETUP);
-
-	/* ALSA audio interface: */
-	line6_register_audio(&variax->line6);
-
-	/* device files: */
-	line6_variax_create_files(0, 0, line6->ifcdev);
-	variax_create_files2(line6->ifcdev);
-}
-
-/*
-	Process a completely received message.
-*/
-void line6_variax_process_message(struct usb_line6_variax *variax)
-{
-	const unsigned char *buf = variax->line6.buffer_message;
-
-	switch (buf[0]) {
-	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
-		switch (buf[1]) {
-		case VARIAXMIDI_volume:
-			variax->volume = buf[2];
-			break;
-
-		case VARIAXMIDI_tone:
-			variax->tone = buf[2];
-		}
-
-		break;
-
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		variax->model = buf[1];
-		line6_dump_request_async(&variax->dumpreq, &variax->line6, 0,
-					 VARIAX_DUMP_PASS1);
-		break;
-
-	case LINE6_RESET:
-		dev_info(variax->line6.ifcdev, "VARIAX reset\n");
-		break;
-
-	case LINE6_SYSEX_BEGIN:
-		if (memcmp(buf + 1, variax_request_model1 + 1,
-			   VARIAX_MODEL_HEADER_LENGTH - 1) == 0) {
-			if (variax->line6.message_length ==
-			    VARIAX_MODEL_MESSAGE_LENGTH) {
-				switch (variax->dumpreq.in_progress) {
-				case VARIAX_DUMP_PASS1:
-					variax_decode(buf +
-						      VARIAX_MODEL_HEADER_LENGTH,
-						      (unsigned char *)
-						      &variax->model_data,
-						      (sizeof
-						       (variax->model_data.
-							name) +
-						       sizeof(variax->
-							      model_data.
-							      control)
-						       / 2) * 2);
-					line6_dump_request_async
-					    (&variax->dumpreq, &variax->line6,
-					     1, VARIAX_DUMP_PASS2);
-					break;
-
-				case VARIAX_DUMP_PASS2:
-					/* model name is transmitted twice, so skip it here: */
-					variax_decode(buf +
-						      VARIAX_MODEL_HEADER_LENGTH,
-						      (unsigned char *)
-						      &variax->
-						      model_data.control +
-						      sizeof(variax->model_data.
-							     control)
-						      / 2,
-						      sizeof(variax->model_data.
-							     control)
-						      / 2 * 2);
-					line6_dump_request_async
-					    (&variax->dumpreq, &variax->line6,
-					     2, VARIAX_DUMP_PASS3);
-				}
-			} else {
-				DEBUG_MESSAGES(dev_err
-					       (variax->line6.ifcdev,
-						"illegal length %d of model data\n",
-						variax->line6.message_length));
-				line6_dump_finished(&variax->dumpreq);
-			}
-		} else if (memcmp(buf + 1, variax_request_bank + 1,
-				  sizeof(variax_request_bank) - 2) == 0) {
-			memcpy(variax->bank,
-			       buf + sizeof(variax_request_bank) - 1,
-			       sizeof(variax->bank));
-			line6_dump_finished(&variax->dumpreq);
-			variax_startup6(variax);
-		} else if (memcmp(buf + 1, variax_init_model + 1,
-				  sizeof(variax_init_model) - 1) == 0) {
-			memcpy(variax->guitar,
-			       buf + sizeof(variax_init_model),
-			       sizeof(variax->guitar));
-		} else if (memcmp(buf + 1, variax_init_version + 1,
-				  sizeof(variax_init_version) - 1) == 0) {
-			variax_startup3(variax);
-		} else if (memcmp(buf + 1, variax_init_done + 1,
-				  sizeof(variax_init_done) - 1) == 0) {
-			/* notify of complete initialization: */
-			variax_startup4((unsigned long)variax);
-		}
-
-		break;
-
-	case LINE6_SYSEX_END:
-		break;
-
-	default:
-		DEBUG_MESSAGES(dev_err
-			       (variax->line6.ifcdev,
-				"Variax: unknown message %02X\n", buf[0]));
-	}
-}
-
-/*
-	"read" request on "volume" special file.
-*/
-static ssize_t variax_get_volume(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%d\n", variax->volume);
-}
-
-/*
-	"write" request on "volume" special file.
-*/
-static ssize_t variax_set_volume(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	if (line6_transmit_parameter(&variax->line6, VARIAXMIDI_volume,
-				     value) == 0)
-		variax->volume = value;
-
-	return count;
-}
-
-/*
-	"read" request on "model" special file.
-*/
-static ssize_t variax_get_model(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%d\n", variax->model);
-}
-
-/*
-	"write" request on "model" special file.
-*/
-static ssize_t variax_set_model(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	if (line6_send_program(&variax->line6, value) == 0)
-		variax->model = value;
-
-	return count;
-}
-
-/*
-	"read" request on "active" special file.
-*/
-static ssize_t variax_get_active(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%d\n",
-		       variax->buffer_activate[VARIAX_OFFSET_ACTIVATE]);
-}
-
-/*
-	"write" request on "active" special file.
-*/
-static ssize_t variax_set_active(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	variax_activate_async(variax, value ? 1 : 0);
-	return count;
-}
-
-/*
-	"read" request on "tone" special file.
-*/
-static ssize_t variax_get_tone(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%d\n", variax->tone);
-}
-
-/*
-	"write" request on "tone" special file.
-*/
-static ssize_t variax_set_tone(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	if (line6_transmit_parameter(&variax->line6, VARIAXMIDI_tone,
-				     value) == 0)
-		variax->tone = value;
-
-	return count;
-}
-
-static ssize_t get_string(char *buf, const char *data, int length)
-{
-	int i;
-	memcpy(buf, data, length);
-
-	for (i = length; i--;) {
-		char c = buf[i];
-
-		if ((c != 0) && (c != ' '))
-			break;
-	}
-
-	buf[i + 1] = '\n';
-	return i + 2;
-}
-
-/*
-	"read" request on "name" special file.
-*/
-static ssize_t variax_get_name(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	line6_dump_wait_interruptible(&variax->dumpreq);
-	return get_string(buf, variax->model_data.name,
-			  sizeof(variax->model_data.name));
-}
-
-/*
-	"read" request on "bank" special file.
-*/
-static ssize_t variax_get_bank(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	line6_dump_wait_interruptible(&variax->dumpreq);
-	return get_string(buf, variax->bank, sizeof(variax->bank));
-}
-
-/*
-	"read" request on "dump" special file.
-*/
-static ssize_t variax_get_dump(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	int retval;
-	retval = line6_dump_wait_interruptible(&variax->dumpreq);
-	if (retval < 0)
-		return retval;
-	memcpy(buf, &variax->model_data.control,
-	       sizeof(variax->model_data.control));
-	return sizeof(variax->model_data.control);
-}
-
-/*
-	"read" request on "guitar" special file.
-*/
-static ssize_t variax_get_guitar(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%s\n", variax->guitar);
-}
-
-#ifdef CONFIG_LINE6_USB_RAW
-
-static char *variax_alloc_sysex_buffer(struct usb_line6_variax *variax,
-				       int code, int size)
-{
-	return line6_alloc_sysex_buffer(&variax->line6, VARIAX_SYSEX_CODE, code,
-					size);
-}
-
-/*
-	"write" request on "raw" special file.
-*/
-static ssize_t variax_set_raw2(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	int size;
-	int i;
-	char *sysex;
-
-	count -= count % 3;
-	size = count * 2;
-	sysex = variax_alloc_sysex_buffer(variax, VARIAX_SYSEX_PARAM, size);
-
-	if (!sysex)
-		return 0;
-
-	for (i = 0; i < count; i += 3) {
-		const unsigned char *p1 = buf + i;
-		char *p2 = sysex + SYSEX_DATA_OFS + i * 2;
-		p2[0] = p1[2] & 0x0f;
-		p2[1] = p1[2] >> 4;
-		p2[2] = p1[1] & 0x0f;
-		p2[3] = p1[1] >> 4;
-		p2[4] = p1[0] & 0x0f;
-		p2[5] = p1[0] >> 4;
-	}
-
-	line6_send_sysex_message(&variax->line6, sysex, size);
-	kfree(sysex);
-	return count;
-}
-
-#endif
-
-/* Variax workbench special files: */
-static DEVICE_ATTR(model, S_IWUSR | S_IRUGO, variax_get_model,
-		   variax_set_model);
-static DEVICE_ATTR(volume, S_IWUSR | S_IRUGO, variax_get_volume,
-		   variax_set_volume);
-static DEVICE_ATTR(tone, S_IWUSR | S_IRUGO, variax_get_tone, variax_set_tone);
-static DEVICE_ATTR(name, S_IRUGO, variax_get_name, line6_nop_write);
-static DEVICE_ATTR(bank, S_IRUGO, variax_get_bank, line6_nop_write);
-static DEVICE_ATTR(dump, S_IRUGO, variax_get_dump, line6_nop_write);
-static DEVICE_ATTR(active, S_IWUSR | S_IRUGO, variax_get_active,
-		   variax_set_active);
-static DEVICE_ATTR(guitar, S_IRUGO, variax_get_guitar, line6_nop_write);
-
-#ifdef CONFIG_LINE6_USB_RAW
-static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
-static DEVICE_ATTR(raw2, S_IWUSR, line6_nop_read, variax_set_raw2);
-#endif
-
-/*
-	Variax destructor.
-*/
-static void variax_destruct(struct usb_interface *interface)
-{
-	struct usb_line6_variax *variax = usb_get_intfdata(interface);
-
-	if (variax == NULL)
-		return;
-	line6_cleanup_audio(&variax->line6);
-
-	del_timer(&variax->startup_timer1);
-	del_timer(&variax->startup_timer2);
-	cancel_work_sync(&variax->startup_work);
-
-	/* free dump request data: */
-	line6_dumpreq_destructbuf(&variax->dumpreq, 2);
-	line6_dumpreq_destructbuf(&variax->dumpreq, 1);
-	line6_dumpreq_destruct(&variax->dumpreq);
-
-	kfree(variax->buffer_activate);
-}
-
-/*
-	Create sysfs entries.
-*/
-static int variax_create_files2(struct device *dev)
-{
-	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_model));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_volume));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tone));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_bank));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_active));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_guitar));
-#ifdef CONFIG_LINE6_USB_RAW
-	CHECK_RETURN(device_create_file(dev, &dev_attr_raw));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_raw2));
-#endif
-	return 0;
-}
-
-/*
-	 Try to init workbench device.
-*/
-static int variax_try_init(struct usb_interface *interface,
-			   struct usb_line6_variax *variax)
-{
-	int err;
-
-	init_timer(&variax->startup_timer1);
-	init_timer(&variax->startup_timer2);
-	INIT_WORK(&variax->startup_work, variax_startup7);
-
-	if ((interface == NULL) || (variax == NULL))
-		return -ENODEV;
-
-	/* initialize USB buffers: */
-	err = line6_dumpreq_init(&variax->dumpreq, variax_request_model1,
-				 sizeof(variax_request_model1));
-
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return err;
-	}
-
-	err = line6_dumpreq_initbuf(&variax->dumpreq, variax_request_model2,
-				    sizeof(variax_request_model2), 1);
-
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return err;
-	}
-
-	err = line6_dumpreq_initbuf(&variax->dumpreq, variax_request_bank,
-				    sizeof(variax_request_bank), 2);
-
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return err;
-	}
-
-	variax->buffer_activate = kmemdup(variax_activate,
-					  sizeof(variax_activate), GFP_KERNEL);
-
-	if (variax->buffer_activate == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return -ENOMEM;
-	}
-
-	/* initialize audio system: */
-	err = line6_init_audio(&variax->line6);
-	if (err < 0)
-		return err;
-
-	/* initialize MIDI subsystem: */
-	err = line6_init_midi(&variax->line6);
-	if (err < 0)
-		return err;
-
-	/* initiate startup procedure: */
-	variax_startup1(variax);
-	return 0;
-}
-
-/*
-	 Init workbench device (and clean up in case of failure).
-*/
-int line6_variax_init(struct usb_interface *interface,
-		      struct usb_line6_variax *variax)
-{
-	int err = variax_try_init(interface, variax);
-
-	if (err < 0)
-		variax_destruct(interface);
-
-	return err;
-}
-
-/*
-	Workbench device disconnected.
-*/
-void line6_variax_disconnect(struct usb_interface *interface)
-{
-	struct device *dev;
-
-	if (interface == NULL)
-		return;
-	dev = &interface->dev;
-
-	if (dev != NULL) {
-		/* remove sysfs entries: */
-		line6_variax_remove_files(0, 0, dev);
-		device_remove_file(dev, &dev_attr_model);
-		device_remove_file(dev, &dev_attr_volume);
-		device_remove_file(dev, &dev_attr_tone);
-		device_remove_file(dev, &dev_attr_name);
-		device_remove_file(dev, &dev_attr_bank);
-		device_remove_file(dev, &dev_attr_dump);
-		device_remove_file(dev, &dev_attr_active);
-		device_remove_file(dev, &dev_attr_guitar);
-#ifdef CONFIG_LINE6_USB_RAW
-		device_remove_file(dev, &dev_attr_raw);
-		device_remove_file(dev, &dev_attr_raw2);
-#endif
-	}
-
-	variax_destruct(interface);
-}
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
deleted file mode 100644
index e2999ab..0000000
--- a/drivers/staging/line6/variax.h
+++ /dev/null
@@ -1,132 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef VARIAX_H
-#define VARIAX_H
-
-#include <linux/spinlock.h>
-#include <linux/usb.h>
-#include <linux/wait.h>
-#include <sound/core.h>
-
-#include "driver.h"
-#include "dumprequest.h"
-
-#define VARIAX_STARTUP_DELAY1 1000
-#define VARIAX_STARTUP_DELAY3 100
-#define VARIAX_STARTUP_DELAY4 100
-
-/*
-	Stages of Variax startup procedure
-*/
-enum {
-	VARIAX_STARTUP_INIT = 1,
-	VARIAX_STARTUP_VERSIONREQ,
-	VARIAX_STARTUP_WAIT,
-	VARIAX_STARTUP_ACTIVATE,
-	VARIAX_STARTUP_DUMPREQ,
-	VARIAX_STARTUP_WORKQUEUE,
-	VARIAX_STARTUP_SETUP,
-	VARIAX_STARTUP_LAST = VARIAX_STARTUP_SETUP - 1
-};
-
-enum {
-	VARIAX_DUMP_PASS1 = LINE6_DUMP_CURRENT,
-	VARIAX_DUMP_PASS2,
-	VARIAX_DUMP_PASS3
-};
-
-/**
-	Binary Variax model dump
-*/
-struct variax_model {
-	/**
-		Header information (including program name).
-	*/
-	unsigned char name[18];
-
-	/**
-		Model parameters.
-	*/
-	unsigned char control[78 * 2];
-};
-
-struct usb_line6_variax {
-	/**
-		Generic Line6 USB data.
-	*/
-	struct usb_line6 line6;
-
-	/**
-		Dump request structure.
-		Append two extra buffers for 3-pass data query.
-	*/
-	struct line6_dump_request dumpreq;
-	struct line6_dump_reqbuf extrabuf[2];
-
-	/**
-		Buffer for activation code.
-	*/
-	unsigned char *buffer_activate;
-
-	/**
-		Model number.
-	*/
-	int model;
-
-	/**
-		Current model settings.
-	*/
-	struct variax_model model_data;
-
-	/**
-		Name of connected guitar.
-	*/
-	unsigned char guitar[18];
-
-	/**
-		Name of current model bank.
-	*/
-	unsigned char bank[18];
-
-	/**
-		Position of volume dial.
-	*/
-	int volume;
-
-	/**
-		Position of tone control dial.
-	*/
-	int tone;
-
-	/**
-		Handler for device initializaton.
-	*/
-	struct work_struct startup_work;
-
-	/**
-		Timers for device initializaton.
-	*/
-	struct timer_list startup_timer1;
-	struct timer_list startup_timer2;
-
-	/**
-		Current progress in startup procedure.
-	*/
-	int startup_progress;
-};
-
-extern void line6_variax_disconnect(struct usb_interface *interface);
-extern int line6_variax_init(struct usb_interface *interface,
-			     struct usb_line6_variax *variax);
-extern void line6_variax_process_message(struct usb_line6_variax *variax);
-
-#endif
diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index 225dfd7..cb17e4b 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -115,5 +115,7 @@ config SND_USB_6FIRE
           and further help can be found at
           http://sixfireusb.sourceforge.net
 
+source "sound/usb/line6/Kconfig"
+
 endif	# SND_USB
 
diff --git a/sound/usb/Makefile b/sound/usb/Makefile
index ac256dc..0ce292e 100644
--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -23,4 +23,4 @@ obj-$(CONFIG_SND_USB_UA101) += snd-usbmidi-lib.o
 obj-$(CONFIG_SND_USB_USX2Y) += snd-usbmidi-lib.o
 obj-$(CONFIG_SND_USB_US122L) += snd-usbmidi-lib.o
 
-obj-$(CONFIG_SND) += misc/ usx2y/ caiaq/ 6fire/
+obj-$(CONFIG_SND) += misc/ usx2y/ caiaq/ 6fire/ line6/
diff --git a/sound/usb/line6/Kconfig b/sound/usb/line6/Kconfig
new file mode 100644
index 0000000..43120ff
--- /dev/null
+++ b/sound/usb/line6/Kconfig
@@ -0,0 +1,85 @@
+menuconfig LINE6_USB
+	tristate "Line6 USB support"
+	depends on USB && SND
+	select SND_RAWMIDI
+	select SND_PCM
+	help
+	  This is a driver for the guitar amp, cab, and effects modeller
+	  PODxt Pro by Line6 (and similar devices), supporting the
+	  following features:
+	    * Reading/writing individual parameters
+	    * Reading/writing complete channel, effects setup, and amp
+	      setup data
+	    * Channel switching
+	    * Virtual MIDI interface
+	    * Tuner access
+	    * Playback/capture/mixer device for any ALSA-compatible PCM
+	      audio application
+	    * Signal routing (record clean/processed guitar signal,
+	      re-amping)
+
+	  Preliminary support for the Variax Workbench and TonePort
+	  devices is included.
+
+if LINE6_USB
+
+config LINE6_USB_DEBUG
+	bool "print debug messages"
+	default n
+	help
+	  Say Y here to write debug messages to the syslog.
+
+	  If unsure, say N.
+
+config LINE6_USB_DUMP_CTRL
+	bool "dump control messages"
+	default n
+	help
+	  Say Y here to write control messages sent to and received from
+	  Line6 devices to the syslog.
+
+	  If unsure, say N.
+
+config LINE6_USB_DUMP_MIDI
+	bool "dump MIDI messages"
+	default n
+	help
+	  Say Y here to write MIDI messages sent to and received from
+	  Line6 devices to the syslog.
+
+	  If unsure, say N.
+
+config LINE6_USB_DUMP_PCM
+	bool "dump PCM data"
+	default n
+	help
+	  Say Y here to write PCM data sent to and received from Line6
+	  devices to the syslog. This will produce a huge amount of
+	  syslog data during playback and capture.
+
+	  If unsure, say N.
+
+config LINE6_USB_RAW
+	bool "raw data communication"
+	default n
+	help
+	  Say Y here to create special files which allow to send raw data
+	  to the device. This bypasses any sanity checks, so if you discover
+	  the code to erase the firmware, feel free to render your device
+	  useless, but only after reading the GPL section "NO WARRANTY".
+
+	  If unsure, say N.
+
+config LINE6_USB_IMPULSE_RESPONSE
+	bool "measure impulse response"
+	default n
+	help
+	  Say Y here to add code to measure the impulse response of a Line6
+	  device. This is more accurate than user-space methods since it
+	  bypasses any PCM data buffering (e.g., by ALSA or jack). This is
+	  useful for assessing the performance of new devices, but is not
+	  required for normal operation.
+
+	  If unsure, say N.
+
+endif # LINE6_USB
diff --git a/sound/usb/line6/Makefile b/sound/usb/line6/Makefile
new file mode 100644
index 0000000..34a2dda
--- /dev/null
+++ b/sound/usb/line6/Makefile
@@ -0,0 +1,16 @@
+obj-$(CONFIG_LINE6_USB)		+= line6usb.o
+
+line6usb-y := 		\
+		audio.o		\
+		capture.o	\
+		control.o	\
+		driver.o	\
+		dumprequest.o	\
+		midi.o		\
+		midibuf.o	\
+		pcm.o		\
+		playback.o	\
+		pod.o		\
+		toneport.o	\
+		variax.o	\
+		podhd.o
diff --git a/sound/usb/line6/audio.c b/sound/usb/line6/audio.c
new file mode 100644
index 0000000..a92e21f
--- /dev/null
+++ b/sound/usb/line6/audio.c
@@ -0,0 +1,70 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <sound/core.h>
+#include <sound/initval.h>
+#include <linux/export.h>
+
+#include "driver.h"
+#include "audio.h"
+
+/*
+	Initialize the Line6 USB audio system.
+*/
+int line6_init_audio(struct usb_line6 *line6)
+{
+	struct snd_card *card;
+	int err;
+
+	err = snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
+			      THIS_MODULE, 0, &card);
+	if (err < 0)
+		return err;
+
+	line6->card = card;
+
+	strcpy(card->id, line6->properties->id);
+	strcpy(card->driver, DRIVER_NAME);
+	strcpy(card->shortname, line6->properties->name);
+	/* longname is 80 chars - see asound.h */
+	sprintf(card->longname, "Line6 %s at USB %s", line6->properties->name,
+		dev_name(line6->ifcdev));
+	return 0;
+}
+
+/*
+	Register the Line6 USB audio system.
+*/
+int line6_register_audio(struct usb_line6 *line6)
+{
+	int err;
+
+	err = snd_card_register(line6->card);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+/*
+	Cleanup the Line6 USB audio system.
+*/
+void line6_cleanup_audio(struct usb_line6 *line6)
+{
+	struct snd_card *card = line6->card;
+
+	if (card == NULL)
+		return;
+
+	snd_card_disconnect(card);
+	snd_card_free(card);
+	line6->card = NULL;
+}
diff --git a/sound/usb/line6/audio.h b/sound/usb/line6/audio.h
new file mode 100644
index 0000000..5f8a09a
--- /dev/null
+++ b/sound/usb/line6/audio.h
@@ -0,0 +1,21 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef AUDIO_H
+#define AUDIO_H
+
+#include "driver.h"
+
+extern void line6_cleanup_audio(struct usb_line6 *);
+extern int line6_init_audio(struct usb_line6 *);
+extern int line6_register_audio(struct usb_line6 *);
+
+#endif
diff --git a/sound/usb/line6/capture.c b/sound/usb/line6/capture.c
new file mode 100644
index 0000000..c85c5b6
--- /dev/null
+++ b/sound/usb/line6/capture.c
@@ -0,0 +1,435 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+
+#include "audio.h"
+#include "capture.h"
+#include "driver.h"
+#include "pcm.h"
+#include "pod.h"
+
+/*
+	Find a free URB and submit it.
+*/
+static int submit_audio_in_urb(struct snd_line6_pcm *line6pcm)
+{
+	int index;
+	unsigned long flags;
+	int i, urb_size;
+	int ret;
+	struct urb *urb_in;
+
+	spin_lock_irqsave(&line6pcm->lock_audio_in, flags);
+	index =
+	    find_first_zero_bit(&line6pcm->active_urb_in, LINE6_ISO_BUFFERS);
+
+	if (index < 0 || index >= LINE6_ISO_BUFFERS) {
+		spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
+		dev_err(line6pcm->line6->ifcdev, "no free URB found\n");
+		return -EINVAL;
+	}
+
+	urb_in = line6pcm->urb_audio_in[index];
+	urb_size = 0;
+
+	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
+		struct usb_iso_packet_descriptor *fin =
+		    &urb_in->iso_frame_desc[i];
+		fin->offset = urb_size;
+		fin->length = line6pcm->max_packet_size;
+		urb_size += line6pcm->max_packet_size;
+	}
+
+	urb_in->transfer_buffer =
+	    line6pcm->buffer_in +
+	    index * LINE6_ISO_PACKETS * line6pcm->max_packet_size;
+	urb_in->transfer_buffer_length = urb_size;
+	urb_in->context = line6pcm;
+
+	ret = usb_submit_urb(urb_in, GFP_ATOMIC);
+
+	if (ret == 0)
+		set_bit(index, &line6pcm->active_urb_in);
+	else
+		dev_err(line6pcm->line6->ifcdev,
+			"URB in #%d submission failed (%d)\n", index, ret);
+
+	spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
+	return 0;
+}
+
+/*
+	Submit all currently available capture URBs.
+*/
+int line6_submit_audio_in_all_urbs(struct snd_line6_pcm *line6pcm)
+{
+	int ret, i;
+
+	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
+		ret = submit_audio_in_urb(line6pcm);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+	Unlink all currently active capture URBs.
+*/
+void line6_unlink_audio_in_urbs(struct snd_line6_pcm *line6pcm)
+{
+	unsigned int i;
+
+	for (i = LINE6_ISO_BUFFERS; i--;) {
+		if (test_bit(i, &line6pcm->active_urb_in)) {
+			if (!test_and_set_bit(i, &line6pcm->unlink_urb_in)) {
+				struct urb *u = line6pcm->urb_audio_in[i];
+				usb_unlink_urb(u);
+			}
+		}
+	}
+}
+
+/*
+	Wait until unlinking of all currently active capture URBs has been
+	finished.
+*/
+void line6_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm)
+{
+	int timeout = HZ;
+	unsigned int i;
+	int alive;
+
+	do {
+		alive = 0;
+		for (i = LINE6_ISO_BUFFERS; i--;) {
+			if (test_bit(i, &line6pcm->active_urb_in))
+				alive++;
+		}
+		if (!alive)
+			break;
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(1);
+	} while (--timeout > 0);
+	if (alive)
+		snd_printk(KERN_ERR "timeout: still %d active urbs..\n", alive);
+}
+
+/*
+	Unlink all currently active capture URBs, and wait for finishing.
+*/
+void line6_unlink_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm)
+{
+	line6_unlink_audio_in_urbs(line6pcm);
+	line6_wait_clear_audio_in_urbs(line6pcm);
+}
+
+/*
+	Copy data into ALSA capture buffer.
+*/
+void line6_capture_copy(struct snd_line6_pcm *line6pcm, char *fbuf, int fsize)
+{
+	struct snd_pcm_substream *substream =
+	    get_substream(line6pcm, SNDRV_PCM_STREAM_CAPTURE);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	const int bytes_per_frame = line6pcm->properties->bytes_per_frame;
+	int frames = fsize / bytes_per_frame;
+
+	if (runtime == NULL)
+		return;
+
+	if (line6pcm->pos_in_done + frames > runtime->buffer_size) {
+		/*
+		   The transferred area goes over buffer boundary,
+		   copy two separate chunks.
+		 */
+		int len;
+		len = runtime->buffer_size - line6pcm->pos_in_done;
+
+		if (len > 0) {
+			memcpy(runtime->dma_area +
+			       line6pcm->pos_in_done * bytes_per_frame, fbuf,
+			       len * bytes_per_frame);
+			memcpy(runtime->dma_area, fbuf + len * bytes_per_frame,
+			       (frames - len) * bytes_per_frame);
+		} else {
+			/* this is somewhat paranoid */
+			dev_err(line6pcm->line6->ifcdev,
+				"driver bug: len = %d\n", len);
+		}
+	} else {
+		/* copy single chunk */
+		memcpy(runtime->dma_area +
+		       line6pcm->pos_in_done * bytes_per_frame, fbuf, fsize);
+	}
+
+	line6pcm->pos_in_done += frames;
+	if (line6pcm->pos_in_done >= runtime->buffer_size)
+		line6pcm->pos_in_done -= runtime->buffer_size;
+}
+
+void line6_capture_check_period(struct snd_line6_pcm *line6pcm, int length)
+{
+	struct snd_pcm_substream *substream =
+	    get_substream(line6pcm, SNDRV_PCM_STREAM_CAPTURE);
+
+	line6pcm->bytes_in += length;
+	if (line6pcm->bytes_in >= line6pcm->period_in) {
+		line6pcm->bytes_in %= line6pcm->period_in;
+		snd_pcm_period_elapsed(substream);
+	}
+}
+
+void line6_free_capture_buffer(struct snd_line6_pcm *line6pcm)
+{
+	kfree(line6pcm->buffer_in);
+	line6pcm->buffer_in = NULL;
+}
+
+/*
+ * Callback for completed capture URB.
+ */
+static void audio_in_callback(struct urb *urb)
+{
+	int i, index, length = 0, shutdown = 0;
+	unsigned long flags;
+
+	struct snd_line6_pcm *line6pcm = (struct snd_line6_pcm *)urb->context;
+
+	line6pcm->last_frame_in = urb->start_frame;
+
+	/* find index of URB */
+	for (index = 0; index < LINE6_ISO_BUFFERS; ++index)
+		if (urb == line6pcm->urb_audio_in[index])
+			break;
+
+#ifdef CONFIG_LINE6_USB_DUMP_PCM
+	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
+		struct usb_iso_packet_descriptor *fout =
+		    &urb->iso_frame_desc[i];
+		line6_write_hexdump(line6pcm->line6, 'C',
+				    urb->transfer_buffer + fout->offset,
+				    fout->length);
+	}
+#endif
+
+	spin_lock_irqsave(&line6pcm->lock_audio_in, flags);
+
+	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
+		char *fbuf;
+		int fsize;
+		struct usb_iso_packet_descriptor *fin = &urb->iso_frame_desc[i];
+
+		if (fin->status == -EXDEV) {
+			shutdown = 1;
+			break;
+		}
+
+		fbuf = urb->transfer_buffer + fin->offset;
+		fsize = fin->actual_length;
+
+		if (fsize > line6pcm->max_packet_size) {
+			dev_err(line6pcm->line6->ifcdev,
+				"driver and/or device bug: packet too large (%d > %d)\n",
+				fsize, line6pcm->max_packet_size);
+		}
+
+		length += fsize;
+
+		/* the following assumes LINE6_ISO_PACKETS == 1: */
+		line6pcm->prev_fbuf = fbuf;
+		line6pcm->prev_fsize = fsize;
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
+#endif
+			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm->flags)
+			    && (fsize > 0))
+				line6_capture_copy(line6pcm, fbuf, fsize);
+	}
+
+	clear_bit(index, &line6pcm->active_urb_in);
+
+	if (test_and_clear_bit(index, &line6pcm->unlink_urb_in))
+		shutdown = 1;
+
+	spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
+
+	if (!shutdown) {
+		submit_audio_in_urb(line6pcm);
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
+#endif
+			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm->flags))
+				line6_capture_check_period(line6pcm, length);
+	}
+}
+
+/* open capture callback */
+static int snd_line6_capture_open(struct snd_pcm_substream *substream)
+{
+	int err;
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
+	err = snd_pcm_hw_constraint_ratdens(runtime, 0,
+					    SNDRV_PCM_HW_PARAM_RATE,
+					    (&line6pcm->
+					     properties->snd_line6_rates));
+	if (err < 0)
+		return err;
+
+	runtime->hw = line6pcm->properties->snd_line6_capture_hw;
+	return 0;
+}
+
+/* close capture callback */
+static int snd_line6_capture_close(struct snd_pcm_substream *substream)
+{
+	return 0;
+}
+
+/* hw_params capture callback */
+static int snd_line6_capture_hw_params(struct snd_pcm_substream *substream,
+				       struct snd_pcm_hw_params *hw_params)
+{
+	int ret;
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
+	/* -- Florian Demski [FD] */
+	/* don't ask me why, but this fixes the bug on my machine */
+	if (line6pcm == NULL) {
+		if (substream->pcm == NULL)
+			return -ENOMEM;
+		if (substream->pcm->private_data == NULL)
+			return -ENOMEM;
+		substream->private_data = substream->pcm->private_data;
+		line6pcm = snd_pcm_substream_chip(substream);
+	}
+	/* -- [FD] end */
+
+	ret = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER);
+
+	if (ret < 0)
+		return ret;
+
+	ret = snd_pcm_lib_malloc_pages(substream,
+				       params_buffer_bytes(hw_params));
+	if (ret < 0) {
+		line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER);
+		return ret;
+	}
+
+	line6pcm->period_in = params_period_bytes(hw_params);
+	return 0;
+}
+
+/* hw_free capture callback */
+static int snd_line6_capture_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+	line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER);
+	return snd_pcm_lib_free_pages(substream);
+}
+
+/* trigger callback */
+int snd_line6_capture_trigger(struct snd_line6_pcm *line6pcm, int cmd)
+{
+	int err;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+#ifdef CONFIG_PM
+	case SNDRV_PCM_TRIGGER_RESUME:
+#endif
+		err = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
+
+		if (err < 0)
+			return err;
+
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+#ifdef CONFIG_PM
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+#endif
+		err = line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
+
+		if (err < 0)
+			return err;
+
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* capture pointer callback */
+static snd_pcm_uframes_t
+snd_line6_capture_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+	return line6pcm->pos_in_done;
+}
+
+/* capture operators */
+struct snd_pcm_ops snd_line6_capture_ops = {
+	.open = snd_line6_capture_open,
+	.close = snd_line6_capture_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = snd_line6_capture_hw_params,
+	.hw_free = snd_line6_capture_hw_free,
+	.prepare = snd_line6_prepare,
+	.trigger = snd_line6_trigger,
+	.pointer = snd_line6_capture_pointer,
+};
+
+int line6_create_audio_in_urbs(struct snd_line6_pcm *line6pcm)
+{
+	int i;
+
+	/* create audio URBs and fill in constant values: */
+	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
+		struct urb *urb;
+
+		/* URB for audio in: */
+		urb = line6pcm->urb_audio_in[i] =
+		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
+
+		if (urb == NULL) {
+			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
+			return -ENOMEM;
+		}
+
+		urb->dev = line6pcm->line6->usbdev;
+		urb->pipe =
+		    usb_rcvisocpipe(line6pcm->line6->usbdev,
+				    line6pcm->ep_audio_read &
+				    USB_ENDPOINT_NUMBER_MASK);
+		urb->transfer_flags = URB_ISO_ASAP;
+		urb->start_frame = -1;
+		urb->number_of_packets = LINE6_ISO_PACKETS;
+		urb->interval = LINE6_ISO_INTERVAL;
+		urb->error_count = 0;
+		urb->complete = audio_in_callback;
+	}
+
+	return 0;
+}
diff --git a/sound/usb/line6/capture.h b/sound/usb/line6/capture.h
new file mode 100644
index 0000000..4157bcb
--- /dev/null
+++ b/sound/usb/line6/capture.h
@@ -0,0 +1,35 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef CAPTURE_H
+#define CAPTURE_H
+
+#include <sound/pcm.h>
+
+#include "driver.h"
+#include "pcm.h"
+
+extern struct snd_pcm_ops snd_line6_capture_ops;
+
+extern void line6_capture_copy(struct snd_line6_pcm *line6pcm, char *fbuf,
+			       int fsize);
+extern void line6_capture_check_period(struct snd_line6_pcm *line6pcm,
+				       int length);
+extern int line6_create_audio_in_urbs(struct snd_line6_pcm *line6pcm);
+extern void line6_free_capture_buffer(struct snd_line6_pcm *line6pcm);
+extern int line6_submit_audio_in_all_urbs(struct snd_line6_pcm *line6pcm);
+extern void line6_unlink_audio_in_urbs(struct snd_line6_pcm *line6pcm);
+extern void line6_unlink_wait_clear_audio_in_urbs(struct snd_line6_pcm
+						  *line6pcm);
+extern void line6_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm);
+extern int snd_line6_capture_trigger(struct snd_line6_pcm *line6pcm, int cmd);
+
+#endif
diff --git a/sound/usb/line6/control.c b/sound/usb/line6/control.c
new file mode 100644
index 0000000..f8326f5
--- /dev/null
+++ b/sound/usb/line6/control.c
@@ -0,0 +1,995 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/usb.h>
+
+#include "control.h"
+#include "driver.h"
+#include "pod.h"
+#include "usbdefs.h"
+#include "variax.h"
+
+#define DEVICE_ATTR2(_name1, _name2, _mode, _show, _store) \
+struct device_attribute dev_attr_##_name1 = __ATTR(_name2, _mode, _show, _store)
+
+#define LINE6_PARAM_R(PREFIX, prefix, type, param) \
+static ssize_t prefix##_get_##param(struct device *dev, \
+			struct device_attribute *attr, char *buf) \
+{ \
+	return prefix##_get_param_##type(dev, buf, PREFIX##_##param); \
+}
+
+#define LINE6_PARAM_RW(PREFIX, prefix, type, param) \
+LINE6_PARAM_R(PREFIX, prefix, type, param); \
+static ssize_t prefix##_set_##param(struct device *dev, \
+		struct device_attribute *attr, const char *buf, size_t count) \
+{ \
+	return prefix##_set_param_##type(dev, buf, count, PREFIX##_##param); \
+}
+
+#define POD_PARAM_R(type, param) LINE6_PARAM_R(POD, pod, type, param)
+#define POD_PARAM_RW(type, param) LINE6_PARAM_RW(POD, pod, type, param)
+#define VARIAX_PARAM_R(type, param) LINE6_PARAM_R(VARIAX, variax, type, param)
+#define VARIAX_PARAM_RW(type, param) LINE6_PARAM_RW(VARIAX, variax, type, param)
+
+static ssize_t pod_get_param_int(struct device *dev, char *buf, int param)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
+	if (retval < 0)
+		return retval;
+	return sprintf(buf, "%d\n", pod->prog_data.control[param]);
+}
+
+static ssize_t pod_set_param_int(struct device *dev, const char *buf,
+				 size_t count, int param)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	u8 value;
+	int retval;
+
+	retval = kstrtou8(buf, 10, &value);
+	if (retval)
+		return retval;
+
+	line6_pod_transmit_parameter(pod, param, value);
+	return count;
+}
+
+static ssize_t variax_get_param_int(struct device *dev, char *buf, int param)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_variax *variax = usb_get_intfdata(interface);
+	int retval = line6_dump_wait_interruptible(&variax->dumpreq);
+	if (retval < 0)
+		return retval;
+	return sprintf(buf, "%d\n", variax->model_data.control[param]);
+}
+
+static ssize_t variax_get_param_float(struct device *dev, char *buf, int param)
+{
+	/*
+	   We do our own floating point handling here since at the time
+	   this code was written (Jan 2006) it was highly discouraged to
+	   use floating point arithmetic in the kernel. If you think that
+	   this no longer applies, feel free to replace this by generic
+	   floating point code.
+	 */
+
+	static const int BIAS = 0x7f;
+	static const int OFFSET = 0xf;
+	static const int PRECISION = 1000;
+
+	int len = 0;
+	unsigned part_int, part_frac;
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_variax *variax = usb_get_intfdata(interface);
+	const unsigned char *p = variax->model_data.control + param;
+	int retval = line6_dump_wait_interruptible(&variax->dumpreq);
+	if (retval < 0)
+		return retval;
+
+	if ((p[0] == 0) && (p[1] == 0) && (p[2] == 0))
+		part_int = part_frac = 0;
+	else {
+		int exponent = (((p[0] & 0x7f) << 1) | (p[1] >> 7)) - BIAS;
+		unsigned mantissa = (p[1] << 8) | p[2] | 0x8000;
+		exponent -= OFFSET;
+
+		if (exponent >= 0) {
+			part_int = mantissa << exponent;
+			part_frac = 0;
+		} else {
+			part_int = mantissa >> -exponent;
+			part_frac = (mantissa << (32 + exponent)) & 0xffffffff;
+		}
+
+		part_frac =
+		    (part_frac / ((1UL << 31) / (PRECISION / 2 * 10)) + 5) / 10;
+	}
+
+	len +=
+	    sprintf(buf + len, "%s%d.%03d\n", ((p[0] & 0x80) ? "-" : ""),
+		    part_int, part_frac);
+	return len;
+}
+
+POD_PARAM_RW(int, tweak);
+POD_PARAM_RW(int, wah_position);
+POD_PARAM_RW(int, compression_gain);
+POD_PARAM_RW(int, vol_pedal_position);
+POD_PARAM_RW(int, compression_threshold);
+POD_PARAM_RW(int, pan);
+POD_PARAM_RW(int, amp_model_setup);
+POD_PARAM_RW(int, amp_model);
+POD_PARAM_RW(int, drive);
+POD_PARAM_RW(int, bass);
+POD_PARAM_RW(int, mid);
+POD_PARAM_RW(int, lowmid);
+POD_PARAM_RW(int, treble);
+POD_PARAM_RW(int, highmid);
+POD_PARAM_RW(int, chan_vol);
+POD_PARAM_RW(int, reverb_mix);
+POD_PARAM_RW(int, effect_setup);
+POD_PARAM_RW(int, band_1_frequency);
+POD_PARAM_RW(int, presence);
+POD_PARAM_RW(int, treble__bass);
+POD_PARAM_RW(int, noise_gate_enable);
+POD_PARAM_RW(int, gate_threshold);
+POD_PARAM_RW(int, gate_decay_time);
+POD_PARAM_RW(int, stomp_enable);
+POD_PARAM_RW(int, comp_enable);
+POD_PARAM_RW(int, stomp_time);
+POD_PARAM_RW(int, delay_enable);
+POD_PARAM_RW(int, mod_param_1);
+POD_PARAM_RW(int, delay_param_1);
+POD_PARAM_RW(int, delay_param_1_note_value);
+POD_PARAM_RW(int, band_2_frequency__bass);
+POD_PARAM_RW(int, delay_param_2);
+POD_PARAM_RW(int, delay_volume_mix);
+POD_PARAM_RW(int, delay_param_3);
+POD_PARAM_RW(int, reverb_enable);
+POD_PARAM_RW(int, reverb_type);
+POD_PARAM_RW(int, reverb_decay);
+POD_PARAM_RW(int, reverb_tone);
+POD_PARAM_RW(int, reverb_pre_delay);
+POD_PARAM_RW(int, reverb_pre_post);
+POD_PARAM_RW(int, band_2_frequency);
+POD_PARAM_RW(int, band_3_frequency__bass);
+POD_PARAM_RW(int, wah_enable);
+POD_PARAM_RW(int, modulation_lo_cut);
+POD_PARAM_RW(int, delay_reverb_lo_cut);
+POD_PARAM_RW(int, volume_pedal_minimum);
+POD_PARAM_RW(int, eq_pre_post);
+POD_PARAM_RW(int, volume_pre_post);
+POD_PARAM_RW(int, di_model);
+POD_PARAM_RW(int, di_delay);
+POD_PARAM_RW(int, mod_enable);
+POD_PARAM_RW(int, mod_param_1_note_value);
+POD_PARAM_RW(int, mod_param_2);
+POD_PARAM_RW(int, mod_param_3);
+POD_PARAM_RW(int, mod_param_4);
+POD_PARAM_RW(int, mod_param_5);
+POD_PARAM_RW(int, mod_volume_mix);
+POD_PARAM_RW(int, mod_pre_post);
+POD_PARAM_RW(int, modulation_model);
+POD_PARAM_RW(int, band_3_frequency);
+POD_PARAM_RW(int, band_4_frequency__bass);
+POD_PARAM_RW(int, mod_param_1_double_precision);
+POD_PARAM_RW(int, delay_param_1_double_precision);
+POD_PARAM_RW(int, eq_enable);
+POD_PARAM_RW(int, tap);
+POD_PARAM_RW(int, volume_tweak_pedal_assign);
+POD_PARAM_RW(int, band_5_frequency);
+POD_PARAM_RW(int, tuner);
+POD_PARAM_RW(int, mic_selection);
+POD_PARAM_RW(int, cabinet_model);
+POD_PARAM_RW(int, stomp_model);
+POD_PARAM_RW(int, roomlevel);
+POD_PARAM_RW(int, band_4_frequency);
+POD_PARAM_RW(int, band_6_frequency);
+POD_PARAM_RW(int, stomp_param_1_note_value);
+POD_PARAM_RW(int, stomp_param_2);
+POD_PARAM_RW(int, stomp_param_3);
+POD_PARAM_RW(int, stomp_param_4);
+POD_PARAM_RW(int, stomp_param_5);
+POD_PARAM_RW(int, stomp_param_6);
+POD_PARAM_RW(int, amp_switch_select);
+POD_PARAM_RW(int, delay_param_4);
+POD_PARAM_RW(int, delay_param_5);
+POD_PARAM_RW(int, delay_pre_post);
+POD_PARAM_RW(int, delay_model);
+POD_PARAM_RW(int, delay_verb_model);
+POD_PARAM_RW(int, tempo_msb);
+POD_PARAM_RW(int, tempo_lsb);
+POD_PARAM_RW(int, wah_model);
+POD_PARAM_RW(int, bypass_volume);
+POD_PARAM_RW(int, fx_loop_on_off);
+POD_PARAM_RW(int, tweak_param_select);
+POD_PARAM_RW(int, amp1_engage);
+POD_PARAM_RW(int, band_1_gain);
+POD_PARAM_RW(int, band_2_gain__bass);
+POD_PARAM_RW(int, band_2_gain);
+POD_PARAM_RW(int, band_3_gain__bass);
+POD_PARAM_RW(int, band_3_gain);
+POD_PARAM_RW(int, band_4_gain__bass);
+POD_PARAM_RW(int, band_5_gain__bass);
+POD_PARAM_RW(int, band_4_gain);
+POD_PARAM_RW(int, band_6_gain__bass);
+VARIAX_PARAM_R(int, body);
+VARIAX_PARAM_R(int, pickup1_enable);
+VARIAX_PARAM_R(int, pickup1_type);
+VARIAX_PARAM_R(float, pickup1_position);
+VARIAX_PARAM_R(float, pickup1_angle);
+VARIAX_PARAM_R(float, pickup1_level);
+VARIAX_PARAM_R(int, pickup2_enable);
+VARIAX_PARAM_R(int, pickup2_type);
+VARIAX_PARAM_R(float, pickup2_position);
+VARIAX_PARAM_R(float, pickup2_angle);
+VARIAX_PARAM_R(float, pickup2_level);
+VARIAX_PARAM_R(int, pickup_phase);
+VARIAX_PARAM_R(float, capacitance);
+VARIAX_PARAM_R(float, tone_resistance);
+VARIAX_PARAM_R(float, volume_resistance);
+VARIAX_PARAM_R(int, taper);
+VARIAX_PARAM_R(float, tone_dump);
+VARIAX_PARAM_R(int, save_tone);
+VARIAX_PARAM_R(float, volume_dump);
+VARIAX_PARAM_R(int, tuning_enable);
+VARIAX_PARAM_R(int, tuning6);
+VARIAX_PARAM_R(int, tuning5);
+VARIAX_PARAM_R(int, tuning4);
+VARIAX_PARAM_R(int, tuning3);
+VARIAX_PARAM_R(int, tuning2);
+VARIAX_PARAM_R(int, tuning1);
+VARIAX_PARAM_R(float, detune6);
+VARIAX_PARAM_R(float, detune5);
+VARIAX_PARAM_R(float, detune4);
+VARIAX_PARAM_R(float, detune3);
+VARIAX_PARAM_R(float, detune2);
+VARIAX_PARAM_R(float, detune1);
+VARIAX_PARAM_R(float, mix6);
+VARIAX_PARAM_R(float, mix5);
+VARIAX_PARAM_R(float, mix4);
+VARIAX_PARAM_R(float, mix3);
+VARIAX_PARAM_R(float, mix2);
+VARIAX_PARAM_R(float, mix1);
+VARIAX_PARAM_R(int, pickup_wiring);
+
+static DEVICE_ATTR(tweak, S_IWUSR | S_IRUGO, pod_get_tweak, pod_set_tweak);
+static DEVICE_ATTR(wah_position, S_IWUSR | S_IRUGO, pod_get_wah_position,
+		   pod_set_wah_position);
+static DEVICE_ATTR(compression_gain, S_IWUSR | S_IRUGO,
+		   pod_get_compression_gain, pod_set_compression_gain);
+static DEVICE_ATTR(vol_pedal_position, S_IWUSR | S_IRUGO,
+		   pod_get_vol_pedal_position, pod_set_vol_pedal_position);
+static DEVICE_ATTR(compression_threshold, S_IWUSR | S_IRUGO,
+		   pod_get_compression_threshold,
+		   pod_set_compression_threshold);
+static DEVICE_ATTR(pan, S_IWUSR | S_IRUGO, pod_get_pan, pod_set_pan);
+static DEVICE_ATTR(amp_model_setup, S_IWUSR | S_IRUGO, pod_get_amp_model_setup,
+		   pod_set_amp_model_setup);
+static DEVICE_ATTR(amp_model, S_IWUSR | S_IRUGO, pod_get_amp_model,
+		   pod_set_amp_model);
+static DEVICE_ATTR(drive, S_IWUSR | S_IRUGO, pod_get_drive, pod_set_drive);
+static DEVICE_ATTR(bass, S_IWUSR | S_IRUGO, pod_get_bass, pod_set_bass);
+static DEVICE_ATTR(mid, S_IWUSR | S_IRUGO, pod_get_mid, pod_set_mid);
+static DEVICE_ATTR(lowmid, S_IWUSR | S_IRUGO, pod_get_lowmid, pod_set_lowmid);
+static DEVICE_ATTR(treble, S_IWUSR | S_IRUGO, pod_get_treble, pod_set_treble);
+static DEVICE_ATTR(highmid, S_IWUSR | S_IRUGO, pod_get_highmid,
+		   pod_set_highmid);
+static DEVICE_ATTR(chan_vol, S_IWUSR | S_IRUGO, pod_get_chan_vol,
+		   pod_set_chan_vol);
+static DEVICE_ATTR(reverb_mix, S_IWUSR | S_IRUGO, pod_get_reverb_mix,
+		   pod_set_reverb_mix);
+static DEVICE_ATTR(effect_setup, S_IWUSR | S_IRUGO, pod_get_effect_setup,
+		   pod_set_effect_setup);
+static DEVICE_ATTR(band_1_frequency, S_IWUSR | S_IRUGO,
+		   pod_get_band_1_frequency, pod_set_band_1_frequency);
+static DEVICE_ATTR(presence, S_IWUSR | S_IRUGO, pod_get_presence,
+		   pod_set_presence);
+static DEVICE_ATTR2(treble__bass, treble, S_IWUSR | S_IRUGO,
+		    pod_get_treble__bass, pod_set_treble__bass);
+static DEVICE_ATTR(noise_gate_enable, S_IWUSR | S_IRUGO,
+		   pod_get_noise_gate_enable, pod_set_noise_gate_enable);
+static DEVICE_ATTR(gate_threshold, S_IWUSR | S_IRUGO, pod_get_gate_threshold,
+		   pod_set_gate_threshold);
+static DEVICE_ATTR(gate_decay_time, S_IWUSR | S_IRUGO, pod_get_gate_decay_time,
+		   pod_set_gate_decay_time);
+static DEVICE_ATTR(stomp_enable, S_IWUSR | S_IRUGO, pod_get_stomp_enable,
+		   pod_set_stomp_enable);
+static DEVICE_ATTR(comp_enable, S_IWUSR | S_IRUGO, pod_get_comp_enable,
+		   pod_set_comp_enable);
+static DEVICE_ATTR(stomp_time, S_IWUSR | S_IRUGO, pod_get_stomp_time,
+		   pod_set_stomp_time);
+static DEVICE_ATTR(delay_enable, S_IWUSR | S_IRUGO, pod_get_delay_enable,
+		   pod_set_delay_enable);
+static DEVICE_ATTR(mod_param_1, S_IWUSR | S_IRUGO, pod_get_mod_param_1,
+		   pod_set_mod_param_1);
+static DEVICE_ATTR(delay_param_1, S_IWUSR | S_IRUGO, pod_get_delay_param_1,
+		   pod_set_delay_param_1);
+static DEVICE_ATTR(delay_param_1_note_value, S_IWUSR | S_IRUGO,
+		   pod_get_delay_param_1_note_value,
+		   pod_set_delay_param_1_note_value);
+static DEVICE_ATTR2(band_2_frequency__bass, band_2_frequency, S_IWUSR | S_IRUGO,
+		    pod_get_band_2_frequency__bass,
+		    pod_set_band_2_frequency__bass);
+static DEVICE_ATTR(delay_param_2, S_IWUSR | S_IRUGO, pod_get_delay_param_2,
+		   pod_set_delay_param_2);
+static DEVICE_ATTR(delay_volume_mix, S_IWUSR | S_IRUGO,
+		   pod_get_delay_volume_mix, pod_set_delay_volume_mix);
+static DEVICE_ATTR(delay_param_3, S_IWUSR | S_IRUGO, pod_get_delay_param_3,
+		   pod_set_delay_param_3);
+static DEVICE_ATTR(reverb_enable, S_IWUSR | S_IRUGO, pod_get_reverb_enable,
+		   pod_set_reverb_enable);
+static DEVICE_ATTR(reverb_type, S_IWUSR | S_IRUGO, pod_get_reverb_type,
+		   pod_set_reverb_type);
+static DEVICE_ATTR(reverb_decay, S_IWUSR | S_IRUGO, pod_get_reverb_decay,
+		   pod_set_reverb_decay);
+static DEVICE_ATTR(reverb_tone, S_IWUSR | S_IRUGO, pod_get_reverb_tone,
+		   pod_set_reverb_tone);
+static DEVICE_ATTR(reverb_pre_delay, S_IWUSR | S_IRUGO,
+		   pod_get_reverb_pre_delay, pod_set_reverb_pre_delay);
+static DEVICE_ATTR(reverb_pre_post, S_IWUSR | S_IRUGO, pod_get_reverb_pre_post,
+		   pod_set_reverb_pre_post);
+static DEVICE_ATTR(band_2_frequency, S_IWUSR | S_IRUGO,
+		   pod_get_band_2_frequency, pod_set_band_2_frequency);
+static DEVICE_ATTR2(band_3_frequency__bass, band_3_frequency, S_IWUSR | S_IRUGO,
+		    pod_get_band_3_frequency__bass,
+		    pod_set_band_3_frequency__bass);
+static DEVICE_ATTR(wah_enable, S_IWUSR | S_IRUGO, pod_get_wah_enable,
+		   pod_set_wah_enable);
+static DEVICE_ATTR(modulation_lo_cut, S_IWUSR | S_IRUGO,
+		   pod_get_modulation_lo_cut, pod_set_modulation_lo_cut);
+static DEVICE_ATTR(delay_reverb_lo_cut, S_IWUSR | S_IRUGO,
+		   pod_get_delay_reverb_lo_cut, pod_set_delay_reverb_lo_cut);
+static DEVICE_ATTR(volume_pedal_minimum, S_IWUSR | S_IRUGO,
+		   pod_get_volume_pedal_minimum, pod_set_volume_pedal_minimum);
+static DEVICE_ATTR(eq_pre_post, S_IWUSR | S_IRUGO, pod_get_eq_pre_post,
+		   pod_set_eq_pre_post);
+static DEVICE_ATTR(volume_pre_post, S_IWUSR | S_IRUGO, pod_get_volume_pre_post,
+		   pod_set_volume_pre_post);
+static DEVICE_ATTR(di_model, S_IWUSR | S_IRUGO, pod_get_di_model,
+		   pod_set_di_model);
+static DEVICE_ATTR(di_delay, S_IWUSR | S_IRUGO, pod_get_di_delay,
+		   pod_set_di_delay);
+static DEVICE_ATTR(mod_enable, S_IWUSR | S_IRUGO, pod_get_mod_enable,
+		   pod_set_mod_enable);
+static DEVICE_ATTR(mod_param_1_note_value, S_IWUSR | S_IRUGO,
+		   pod_get_mod_param_1_note_value,
+		   pod_set_mod_param_1_note_value);
+static DEVICE_ATTR(mod_param_2, S_IWUSR | S_IRUGO, pod_get_mod_param_2,
+		   pod_set_mod_param_2);
+static DEVICE_ATTR(mod_param_3, S_IWUSR | S_IRUGO, pod_get_mod_param_3,
+		   pod_set_mod_param_3);
+static DEVICE_ATTR(mod_param_4, S_IWUSR | S_IRUGO, pod_get_mod_param_4,
+		   pod_set_mod_param_4);
+static DEVICE_ATTR(mod_param_5, S_IWUSR | S_IRUGO, pod_get_mod_param_5,
+		   pod_set_mod_param_5);
+static DEVICE_ATTR(mod_volume_mix, S_IWUSR | S_IRUGO, pod_get_mod_volume_mix,
+		   pod_set_mod_volume_mix);
+static DEVICE_ATTR(mod_pre_post, S_IWUSR | S_IRUGO, pod_get_mod_pre_post,
+		   pod_set_mod_pre_post);
+static DEVICE_ATTR(modulation_model, S_IWUSR | S_IRUGO,
+		   pod_get_modulation_model, pod_set_modulation_model);
+static DEVICE_ATTR(band_3_frequency, S_IWUSR | S_IRUGO,
+		   pod_get_band_3_frequency, pod_set_band_3_frequency);
+static DEVICE_ATTR2(band_4_frequency__bass, band_4_frequency, S_IWUSR | S_IRUGO,
+		    pod_get_band_4_frequency__bass,
+		    pod_set_band_4_frequency__bass);
+static DEVICE_ATTR(mod_param_1_double_precision, S_IWUSR | S_IRUGO,
+		   pod_get_mod_param_1_double_precision,
+		   pod_set_mod_param_1_double_precision);
+static DEVICE_ATTR(delay_param_1_double_precision, S_IWUSR | S_IRUGO,
+		   pod_get_delay_param_1_double_precision,
+		   pod_set_delay_param_1_double_precision);
+static DEVICE_ATTR(eq_enable, S_IWUSR | S_IRUGO, pod_get_eq_enable,
+		   pod_set_eq_enable);
+static DEVICE_ATTR(tap, S_IWUSR | S_IRUGO, pod_get_tap, pod_set_tap);
+static DEVICE_ATTR(volume_tweak_pedal_assign, S_IWUSR | S_IRUGO,
+		   pod_get_volume_tweak_pedal_assign,
+		   pod_set_volume_tweak_pedal_assign);
+static DEVICE_ATTR(band_5_frequency, S_IWUSR | S_IRUGO,
+		   pod_get_band_5_frequency, pod_set_band_5_frequency);
+static DEVICE_ATTR(tuner, S_IWUSR | S_IRUGO, pod_get_tuner, pod_set_tuner);
+static DEVICE_ATTR(mic_selection, S_IWUSR | S_IRUGO, pod_get_mic_selection,
+		   pod_set_mic_selection);
+static DEVICE_ATTR(cabinet_model, S_IWUSR | S_IRUGO, pod_get_cabinet_model,
+		   pod_set_cabinet_model);
+static DEVICE_ATTR(stomp_model, S_IWUSR | S_IRUGO, pod_get_stomp_model,
+		   pod_set_stomp_model);
+static DEVICE_ATTR(roomlevel, S_IWUSR | S_IRUGO, pod_get_roomlevel,
+		   pod_set_roomlevel);
+static DEVICE_ATTR(band_4_frequency, S_IWUSR | S_IRUGO,
+		   pod_get_band_4_frequency, pod_set_band_4_frequency);
+static DEVICE_ATTR(band_6_frequency, S_IWUSR | S_IRUGO,
+		   pod_get_band_6_frequency, pod_set_band_6_frequency);
+static DEVICE_ATTR(stomp_param_1_note_value, S_IWUSR | S_IRUGO,
+		   pod_get_stomp_param_1_note_value,
+		   pod_set_stomp_param_1_note_value);
+static DEVICE_ATTR(stomp_param_2, S_IWUSR | S_IRUGO, pod_get_stomp_param_2,
+		   pod_set_stomp_param_2);
+static DEVICE_ATTR(stomp_param_3, S_IWUSR | S_IRUGO, pod_get_stomp_param_3,
+		   pod_set_stomp_param_3);
+static DEVICE_ATTR(stomp_param_4, S_IWUSR | S_IRUGO, pod_get_stomp_param_4,
+		   pod_set_stomp_param_4);
+static DEVICE_ATTR(stomp_param_5, S_IWUSR | S_IRUGO, pod_get_stomp_param_5,
+		   pod_set_stomp_param_5);
+static DEVICE_ATTR(stomp_param_6, S_IWUSR | S_IRUGO, pod_get_stomp_param_6,
+		   pod_set_stomp_param_6);
+static DEVICE_ATTR(amp_switch_select, S_IWUSR | S_IRUGO,
+		   pod_get_amp_switch_select, pod_set_amp_switch_select);
+static DEVICE_ATTR(delay_param_4, S_IWUSR | S_IRUGO, pod_get_delay_param_4,
+		   pod_set_delay_param_4);
+static DEVICE_ATTR(delay_param_5, S_IWUSR | S_IRUGO, pod_get_delay_param_5,
+		   pod_set_delay_param_5);
+static DEVICE_ATTR(delay_pre_post, S_IWUSR | S_IRUGO, pod_get_delay_pre_post,
+		   pod_set_delay_pre_post);
+static DEVICE_ATTR(delay_model, S_IWUSR | S_IRUGO, pod_get_delay_model,
+		   pod_set_delay_model);
+static DEVICE_ATTR(delay_verb_model, S_IWUSR | S_IRUGO,
+		   pod_get_delay_verb_model, pod_set_delay_verb_model);
+static DEVICE_ATTR(tempo_msb, S_IWUSR | S_IRUGO, pod_get_tempo_msb,
+		   pod_set_tempo_msb);
+static DEVICE_ATTR(tempo_lsb, S_IWUSR | S_IRUGO, pod_get_tempo_lsb,
+		   pod_set_tempo_lsb);
+static DEVICE_ATTR(wah_model, S_IWUSR | S_IRUGO, pod_get_wah_model,
+		   pod_set_wah_model);
+static DEVICE_ATTR(bypass_volume, S_IWUSR | S_IRUGO, pod_get_bypass_volume,
+		   pod_set_bypass_volume);
+static DEVICE_ATTR(fx_loop_on_off, S_IWUSR | S_IRUGO, pod_get_fx_loop_on_off,
+		   pod_set_fx_loop_on_off);
+static DEVICE_ATTR(tweak_param_select, S_IWUSR | S_IRUGO,
+		   pod_get_tweak_param_select, pod_set_tweak_param_select);
+static DEVICE_ATTR(amp1_engage, S_IWUSR | S_IRUGO, pod_get_amp1_engage,
+		   pod_set_amp1_engage);
+static DEVICE_ATTR(band_1_gain, S_IWUSR | S_IRUGO, pod_get_band_1_gain,
+		   pod_set_band_1_gain);
+static DEVICE_ATTR2(band_2_gain__bass, band_2_gain, S_IWUSR | S_IRUGO,
+		    pod_get_band_2_gain__bass, pod_set_band_2_gain__bass);
+static DEVICE_ATTR(band_2_gain, S_IWUSR | S_IRUGO, pod_get_band_2_gain,
+		   pod_set_band_2_gain);
+static DEVICE_ATTR2(band_3_gain__bass, band_3_gain, S_IWUSR | S_IRUGO,
+		    pod_get_band_3_gain__bass, pod_set_band_3_gain__bass);
+static DEVICE_ATTR(band_3_gain, S_IWUSR | S_IRUGO, pod_get_band_3_gain,
+		   pod_set_band_3_gain);
+static DEVICE_ATTR2(band_4_gain__bass, band_4_gain, S_IWUSR | S_IRUGO,
+		    pod_get_band_4_gain__bass, pod_set_band_4_gain__bass);
+static DEVICE_ATTR2(band_5_gain__bass, band_5_gain, S_IWUSR | S_IRUGO,
+		    pod_get_band_5_gain__bass, pod_set_band_5_gain__bass);
+static DEVICE_ATTR(band_4_gain, S_IWUSR | S_IRUGO, pod_get_band_4_gain,
+		   pod_set_band_4_gain);
+static DEVICE_ATTR2(band_6_gain__bass, band_6_gain, S_IWUSR | S_IRUGO,
+		    pod_get_band_6_gain__bass, pod_set_band_6_gain__bass);
+static DEVICE_ATTR(body, S_IRUGO, variax_get_body, line6_nop_write);
+static DEVICE_ATTR(pickup1_enable, S_IRUGO, variax_get_pickup1_enable,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup1_type, S_IRUGO, variax_get_pickup1_type,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup1_position, S_IRUGO, variax_get_pickup1_position,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup1_angle, S_IRUGO, variax_get_pickup1_angle,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup1_level, S_IRUGO, variax_get_pickup1_level,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup2_enable, S_IRUGO, variax_get_pickup2_enable,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup2_type, S_IRUGO, variax_get_pickup2_type,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup2_position, S_IRUGO, variax_get_pickup2_position,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup2_angle, S_IRUGO, variax_get_pickup2_angle,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup2_level, S_IRUGO, variax_get_pickup2_level,
+		   line6_nop_write);
+static DEVICE_ATTR(pickup_phase, S_IRUGO, variax_get_pickup_phase,
+		   line6_nop_write);
+static DEVICE_ATTR(capacitance, S_IRUGO, variax_get_capacitance,
+		   line6_nop_write);
+static DEVICE_ATTR(tone_resistance, S_IRUGO, variax_get_tone_resistance,
+		   line6_nop_write);
+static DEVICE_ATTR(volume_resistance, S_IRUGO, variax_get_volume_resistance,
+		   line6_nop_write);
+static DEVICE_ATTR(taper, S_IRUGO, variax_get_taper, line6_nop_write);
+static DEVICE_ATTR(tone_dump, S_IRUGO, variax_get_tone_dump, line6_nop_write);
+static DEVICE_ATTR(save_tone, S_IRUGO, variax_get_save_tone, line6_nop_write);
+static DEVICE_ATTR(volume_dump, S_IRUGO, variax_get_volume_dump,
+		   line6_nop_write);
+static DEVICE_ATTR(tuning_enable, S_IRUGO, variax_get_tuning_enable,
+		   line6_nop_write);
+static DEVICE_ATTR(tuning6, S_IRUGO, variax_get_tuning6, line6_nop_write);
+static DEVICE_ATTR(tuning5, S_IRUGO, variax_get_tuning5, line6_nop_write);
+static DEVICE_ATTR(tuning4, S_IRUGO, variax_get_tuning4, line6_nop_write);
+static DEVICE_ATTR(tuning3, S_IRUGO, variax_get_tuning3, line6_nop_write);
+static DEVICE_ATTR(tuning2, S_IRUGO, variax_get_tuning2, line6_nop_write);
+static DEVICE_ATTR(tuning1, S_IRUGO, variax_get_tuning1, line6_nop_write);
+static DEVICE_ATTR(detune6, S_IRUGO, variax_get_detune6, line6_nop_write);
+static DEVICE_ATTR(detune5, S_IRUGO, variax_get_detune5, line6_nop_write);
+static DEVICE_ATTR(detune4, S_IRUGO, variax_get_detune4, line6_nop_write);
+static DEVICE_ATTR(detune3, S_IRUGO, variax_get_detune3, line6_nop_write);
+static DEVICE_ATTR(detune2, S_IRUGO, variax_get_detune2, line6_nop_write);
+static DEVICE_ATTR(detune1, S_IRUGO, variax_get_detune1, line6_nop_write);
+static DEVICE_ATTR(mix6, S_IRUGO, variax_get_mix6, line6_nop_write);
+static DEVICE_ATTR(mix5, S_IRUGO, variax_get_mix5, line6_nop_write);
+static DEVICE_ATTR(mix4, S_IRUGO, variax_get_mix4, line6_nop_write);
+static DEVICE_ATTR(mix3, S_IRUGO, variax_get_mix3, line6_nop_write);
+static DEVICE_ATTR(mix2, S_IRUGO, variax_get_mix2, line6_nop_write);
+static DEVICE_ATTR(mix1, S_IRUGO, variax_get_mix1, line6_nop_write);
+static DEVICE_ATTR(pickup_wiring, S_IRUGO, variax_get_pickup_wiring,
+		   line6_nop_write);
+
+int line6_pod_create_files(int firmware, int type, struct device *dev)
+{
+	int err;
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tweak));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_wah_position));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_compression_gain));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_vol_pedal_position));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_compression_threshold));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pan));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_amp_model_setup));
+	if (firmware >= 200)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_amp_model));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_drive));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_bass));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_mid));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_lowmid));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_treble));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_highmid));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_chan_vol));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_mix));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_effect_setup));
+	if (firmware >= 200)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_band_1_frequency));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_presence));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_treble__bass));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_noise_gate_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_gate_threshold));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_gate_decay_time));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_comp_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_time));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_1));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_1));
+	CHECK_RETURN(device_create_file
+		     (dev, &dev_attr_delay_param_1_note_value));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_2_frequency__bass));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_2));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_volume_mix));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_3));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_enable));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_type));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_decay));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_reverb_tone));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_reverb_pre_delay));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_reverb_pre_post));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_2_frequency));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_3_frequency__bass));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_wah_enable));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_modulation_lo_cut));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_delay_reverb_lo_cut));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_volume_pedal_minimum));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_eq_pre_post));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_volume_pre_post));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_di_model));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_di_delay));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_1_note_value));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_2));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_3));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_4));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_mod_param_5));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_volume_mix));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mod_pre_post));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_modulation_model));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_3_frequency));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_4_frequency__bass));
+	CHECK_RETURN(device_create_file
+		     (dev, &dev_attr_mod_param_1_double_precision));
+	CHECK_RETURN(device_create_file
+		     (dev, &dev_attr_delay_param_1_double_precision));
+	if (firmware >= 200)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_eq_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tap));
+	CHECK_RETURN(device_create_file
+		     (dev, &dev_attr_volume_tweak_pedal_assign));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_5_frequency));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mic_selection));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_cabinet_model));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_model));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_roomlevel));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_4_frequency));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_6_frequency));
+	CHECK_RETURN(device_create_file
+		     (dev, &dev_attr_stomp_param_1_note_value));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_2));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_3));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_4));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_5));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_stomp_param_6));
+	if ((type & (LINE6_BITS_LIVE)) != 0)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_amp_switch_select));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_4));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_param_5));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_delay_pre_post));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_delay_model));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		CHECK_RETURN(device_create_file
+			     (dev, &dev_attr_delay_verb_model));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tempo_msb));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tempo_lsb));
+	if (firmware >= 300)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_wah_model));
+	if (firmware >= 214)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_bypass_volume));
+	if ((type & (LINE6_BITS_PRO)) != 0)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_fx_loop_on_off));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tweak_param_select));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_amp1_engage));
+	if (firmware >= 200)
+		CHECK_RETURN(device_create_file(dev, &dev_attr_band_1_gain));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_2_gain__bass));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_2_gain));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_3_gain__bass));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_3_gain));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_4_gain__bass));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_5_gain__bass));
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_4_gain));
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			CHECK_RETURN(device_create_file
+				     (dev, &dev_attr_band_6_gain__bass));
+	return 0;
+}
+
+void line6_pod_remove_files(int firmware, int type, struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_tweak);
+	device_remove_file(dev, &dev_attr_wah_position);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_compression_gain);
+	device_remove_file(dev, &dev_attr_vol_pedal_position);
+	device_remove_file(dev, &dev_attr_compression_threshold);
+	device_remove_file(dev, &dev_attr_pan);
+	device_remove_file(dev, &dev_attr_amp_model_setup);
+	if (firmware >= 200)
+		device_remove_file(dev, &dev_attr_amp_model);
+	device_remove_file(dev, &dev_attr_drive);
+	device_remove_file(dev, &dev_attr_bass);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_mid);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_lowmid);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_treble);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_highmid);
+	device_remove_file(dev, &dev_attr_chan_vol);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_reverb_mix);
+	device_remove_file(dev, &dev_attr_effect_setup);
+	if (firmware >= 200)
+		device_remove_file(dev, &dev_attr_band_1_frequency);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_presence);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_treble__bass);
+	device_remove_file(dev, &dev_attr_noise_gate_enable);
+	device_remove_file(dev, &dev_attr_gate_threshold);
+	device_remove_file(dev, &dev_attr_gate_decay_time);
+	device_remove_file(dev, &dev_attr_stomp_enable);
+	device_remove_file(dev, &dev_attr_comp_enable);
+	device_remove_file(dev, &dev_attr_stomp_time);
+	device_remove_file(dev, &dev_attr_delay_enable);
+	device_remove_file(dev, &dev_attr_mod_param_1);
+	device_remove_file(dev, &dev_attr_delay_param_1);
+	device_remove_file(dev, &dev_attr_delay_param_1_note_value);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev,
+					   &dev_attr_band_2_frequency__bass);
+	device_remove_file(dev, &dev_attr_delay_param_2);
+	device_remove_file(dev, &dev_attr_delay_volume_mix);
+	device_remove_file(dev, &dev_attr_delay_param_3);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_reverb_enable);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_reverb_type);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_reverb_decay);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_reverb_tone);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_reverb_pre_delay);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_reverb_pre_post);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_2_frequency);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev,
+					   &dev_attr_band_3_frequency__bass);
+	device_remove_file(dev, &dev_attr_wah_enable);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_modulation_lo_cut);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_delay_reverb_lo_cut);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_volume_pedal_minimum);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_eq_pre_post);
+	device_remove_file(dev, &dev_attr_volume_pre_post);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_di_model);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_di_delay);
+	device_remove_file(dev, &dev_attr_mod_enable);
+	device_remove_file(dev, &dev_attr_mod_param_1_note_value);
+	device_remove_file(dev, &dev_attr_mod_param_2);
+	device_remove_file(dev, &dev_attr_mod_param_3);
+	device_remove_file(dev, &dev_attr_mod_param_4);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_mod_param_5);
+	device_remove_file(dev, &dev_attr_mod_volume_mix);
+	device_remove_file(dev, &dev_attr_mod_pre_post);
+	device_remove_file(dev, &dev_attr_modulation_model);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_3_frequency);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev,
+					   &dev_attr_band_4_frequency__bass);
+	device_remove_file(dev, &dev_attr_mod_param_1_double_precision);
+	device_remove_file(dev, &dev_attr_delay_param_1_double_precision);
+	if (firmware >= 200)
+		device_remove_file(dev, &dev_attr_eq_enable);
+	device_remove_file(dev, &dev_attr_tap);
+	device_remove_file(dev, &dev_attr_volume_tweak_pedal_assign);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_5_frequency);
+	device_remove_file(dev, &dev_attr_tuner);
+	device_remove_file(dev, &dev_attr_mic_selection);
+	device_remove_file(dev, &dev_attr_cabinet_model);
+	device_remove_file(dev, &dev_attr_stomp_model);
+	device_remove_file(dev, &dev_attr_roomlevel);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_4_frequency);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_6_frequency);
+	device_remove_file(dev, &dev_attr_stomp_param_1_note_value);
+	device_remove_file(dev, &dev_attr_stomp_param_2);
+	device_remove_file(dev, &dev_attr_stomp_param_3);
+	device_remove_file(dev, &dev_attr_stomp_param_4);
+	device_remove_file(dev, &dev_attr_stomp_param_5);
+	device_remove_file(dev, &dev_attr_stomp_param_6);
+	if ((type & (LINE6_BITS_LIVE)) != 0)
+		device_remove_file(dev, &dev_attr_amp_switch_select);
+	device_remove_file(dev, &dev_attr_delay_param_4);
+	device_remove_file(dev, &dev_attr_delay_param_5);
+	device_remove_file(dev, &dev_attr_delay_pre_post);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_delay_model);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		device_remove_file(dev, &dev_attr_delay_verb_model);
+	device_remove_file(dev, &dev_attr_tempo_msb);
+	device_remove_file(dev, &dev_attr_tempo_lsb);
+	if (firmware >= 300)
+		device_remove_file(dev, &dev_attr_wah_model);
+	if (firmware >= 214)
+		device_remove_file(dev, &dev_attr_bypass_volume);
+	if ((type & (LINE6_BITS_PRO)) != 0)
+		device_remove_file(dev, &dev_attr_fx_loop_on_off);
+	device_remove_file(dev, &dev_attr_tweak_param_select);
+	device_remove_file(dev, &dev_attr_amp1_engage);
+	if (firmware >= 200)
+		device_remove_file(dev, &dev_attr_band_1_gain);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_2_gain__bass);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_2_gain);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_3_gain__bass);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_3_gain);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_4_gain__bass);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_5_gain__bass);
+	if ((type & (LINE6_BITS_PODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_4_gain);
+	if ((type & (LINE6_BITS_BASSPODXTALL)) != 0)
+		if (firmware >= 200)
+			device_remove_file(dev, &dev_attr_band_6_gain__bass);
+}
+
+int line6_variax_create_files(int firmware, int type, struct device *dev)
+{
+	int err;
+	CHECK_RETURN(device_create_file(dev, &dev_attr_body));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_type));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_position));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_angle));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup1_level));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_type));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_position));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_angle));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup2_level));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup_phase));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_capacitance));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tone_resistance));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_volume_resistance));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_taper));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tone_dump));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_save_tone));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_volume_dump));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning_enable));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning6));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning5));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning4));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning3));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning2));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuning1));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_detune6));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_detune5));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_detune4));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_detune3));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_detune2));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_detune1));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mix6));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mix5));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mix4));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mix3));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mix2));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_mix1));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_pickup_wiring));
+	return 0;
+}
+
+void line6_variax_remove_files(int firmware, int type, struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_body);
+	device_remove_file(dev, &dev_attr_pickup1_enable);
+	device_remove_file(dev, &dev_attr_pickup1_type);
+	device_remove_file(dev, &dev_attr_pickup1_position);
+	device_remove_file(dev, &dev_attr_pickup1_angle);
+	device_remove_file(dev, &dev_attr_pickup1_level);
+	device_remove_file(dev, &dev_attr_pickup2_enable);
+	device_remove_file(dev, &dev_attr_pickup2_type);
+	device_remove_file(dev, &dev_attr_pickup2_position);
+	device_remove_file(dev, &dev_attr_pickup2_angle);
+	device_remove_file(dev, &dev_attr_pickup2_level);
+	device_remove_file(dev, &dev_attr_pickup_phase);
+	device_remove_file(dev, &dev_attr_capacitance);
+	device_remove_file(dev, &dev_attr_tone_resistance);
+	device_remove_file(dev, &dev_attr_volume_resistance);
+	device_remove_file(dev, &dev_attr_taper);
+	device_remove_file(dev, &dev_attr_tone_dump);
+	device_remove_file(dev, &dev_attr_save_tone);
+	device_remove_file(dev, &dev_attr_volume_dump);
+	device_remove_file(dev, &dev_attr_tuning_enable);
+	device_remove_file(dev, &dev_attr_tuning6);
+	device_remove_file(dev, &dev_attr_tuning5);
+	device_remove_file(dev, &dev_attr_tuning4);
+	device_remove_file(dev, &dev_attr_tuning3);
+	device_remove_file(dev, &dev_attr_tuning2);
+	device_remove_file(dev, &dev_attr_tuning1);
+	device_remove_file(dev, &dev_attr_detune6);
+	device_remove_file(dev, &dev_attr_detune5);
+	device_remove_file(dev, &dev_attr_detune4);
+	device_remove_file(dev, &dev_attr_detune3);
+	device_remove_file(dev, &dev_attr_detune2);
+	device_remove_file(dev, &dev_attr_detune1);
+	device_remove_file(dev, &dev_attr_mix6);
+	device_remove_file(dev, &dev_attr_mix5);
+	device_remove_file(dev, &dev_attr_mix4);
+	device_remove_file(dev, &dev_attr_mix3);
+	device_remove_file(dev, &dev_attr_mix2);
+	device_remove_file(dev, &dev_attr_mix1);
+	device_remove_file(dev, &dev_attr_pickup_wiring);
+}
diff --git a/sound/usb/line6/control.h b/sound/usb/line6/control.h
new file mode 100644
index 0000000..e4c5d2c
--- /dev/null
+++ b/sound/usb/line6/control.h
@@ -0,0 +1,195 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef LINE6_CONTROL_H
+#define LINE6_CONTROL_H
+
+/**
+   List of PODxt Pro controls.
+   See Appendix C of the "PODxt (Pro) Pilot's Handbook" by Line6.
+   Comments after the number refer to the PODxt Pro firmware version required
+   for this feature.
+
+   Please *don't* reformat this file since "control.c" is created automatically
+   from "control.h", and this process depends on the exact formatting of the
+   code and the comments below!
+*/
+
+/* *INDENT-OFF* */
+
+enum {
+	POD_tweak                          =   1,
+	POD_wah_position                   =   4,
+	POD_compression_gain               =   5,  /* device: LINE6_BITS_PODXTALL */
+	POD_vol_pedal_position             =   7,
+	POD_compression_threshold          =   9,
+	POD_pan                            =  10,
+	POD_amp_model_setup                =  11,
+	POD_amp_model                      =  12,  /* firmware: 2.0 */
+	POD_drive                          =  13,
+	POD_bass                           =  14,
+	POD_mid                            =  15,  /* device: LINE6_BITS_PODXTALL */
+	POD_lowmid                         =  15,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_treble                         =  16,  /* device: LINE6_BITS_PODXTALL */
+	POD_highmid                        =  16,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_chan_vol                       =  17,
+	POD_reverb_mix                     =  18,  /* device: LINE6_BITS_PODXTALL */
+	POD_effect_setup                   =  19,
+	POD_band_1_frequency               =  20,  /* firmware: 2.0 */
+	POD_presence                       =  21,  /* device: LINE6_BITS_PODXTALL */
+	POD_treble__bass                   =  21,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_noise_gate_enable              =  22,
+	POD_gate_threshold                 =  23,
+	POD_gate_decay_time                =  24,
+	POD_stomp_enable                   =  25,
+	POD_comp_enable                    =  26,
+	POD_stomp_time                     =  27,
+	POD_delay_enable                   =  28,
+	POD_mod_param_1                    =  29,
+	POD_delay_param_1                  =  30,
+	POD_delay_param_1_note_value       =  31,
+	POD_band_2_frequency__bass         =  32,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_delay_param_2                  =  33,
+	POD_delay_volume_mix               =  34,
+	POD_delay_param_3                  =  35,
+	POD_reverb_enable                  =  36,  /* device: LINE6_BITS_PODXTALL */
+	POD_reverb_type                    =  37,  /* device: LINE6_BITS_PODXTALL */
+	POD_reverb_decay                   =  38,  /* device: LINE6_BITS_PODXTALL */
+	POD_reverb_tone                    =  39,  /* device: LINE6_BITS_PODXTALL */
+	POD_reverb_pre_delay               =  40,  /* device: LINE6_BITS_PODXTALL */
+	POD_reverb_pre_post                =  41,  /* device: LINE6_BITS_PODXTALL */
+	POD_band_2_frequency               =  42,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
+	POD_band_3_frequency__bass         =  42,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_wah_enable                     =  43,
+	POD_modulation_lo_cut              =  44,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_delay_reverb_lo_cut            =  45,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_volume_pedal_minimum           =  46,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
+	POD_eq_pre_post                    =  46,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_volume_pre_post                =  47,
+	POD_di_model                       =  48,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_di_delay                       =  49,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_mod_enable                     =  50,
+	POD_mod_param_1_note_value         =  51,
+	POD_mod_param_2                    =  52,
+	POD_mod_param_3                    =  53,
+	POD_mod_param_4                    =  54,
+	POD_mod_param_5                    =  55,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_mod_volume_mix                 =  56,
+	POD_mod_pre_post                   =  57,
+	POD_modulation_model               =  58,
+	POD_band_3_frequency               =  60,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
+	POD_band_4_frequency__bass         =  60,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_mod_param_1_double_precision   =  61,
+	POD_delay_param_1_double_precision =  62,
+	POD_eq_enable                      =  63,  /* firmware: 2.0 */
+	POD_tap                            =  64,
+	POD_volume_tweak_pedal_assign      =  65,
+	POD_band_5_frequency               =  68,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_tuner                          =  69,
+	POD_mic_selection                  =  70,
+	POD_cabinet_model                  =  71,
+	POD_stomp_model                    =  75,
+	POD_roomlevel                      =  76,
+	POD_band_4_frequency               =  77,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
+	POD_band_6_frequency               =  77,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_stomp_param_1_note_value       =  78,
+	POD_stomp_param_2                  =  79,
+	POD_stomp_param_3                  =  80,
+	POD_stomp_param_4                  =  81,
+	POD_stomp_param_5                  =  82,
+	POD_stomp_param_6                  =  83,
+	POD_amp_switch_select              =  84,  /* device: LINE6_BITS_LIVE */
+	POD_delay_param_4                  =  85,
+	POD_delay_param_5                  =  86,
+	POD_delay_pre_post                 =  87,
+	POD_delay_model                    =  88,  /* device: LINE6_BITS_PODXTALL */
+	POD_delay_verb_model               =  88,  /* device: LINE6_BITS_BASSPODXTALL */
+	POD_tempo_msb                      =  89,
+	POD_tempo_lsb                      =  90,
+	POD_wah_model                      =  91,  /* firmware: 3.0 */
+	POD_bypass_volume                  = 105,  /* firmware: 2.14 */
+	POD_fx_loop_on_off                 = 107,  /* device: LINE6_BITS_PRO */
+	POD_tweak_param_select             = 108,
+	POD_amp1_engage                    = 111,
+	POD_band_1_gain                    = 114,  /* firmware: 2.0 */
+	POD_band_2_gain__bass              = 115,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_band_2_gain                    = 116,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
+	POD_band_3_gain__bass              = 116,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_band_3_gain                    = 117,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
+	POD_band_4_gain__bass              = 117,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_band_5_gain__bass              = 118,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+	POD_band_4_gain                    = 119,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
+	POD_band_6_gain__bass              = 119   /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+};
+
+/**
+   List of Variax workbench controls (dump).
+*/
+enum {
+	VARIAX_body                        =   3,
+	VARIAX_pickup1_enable              =   4,  /* 0: enabled, 1: disabled */
+	VARIAX_pickup1_type                =   8,
+	VARIAX_pickup1_position            =   9,  /* type: 24 bit float */
+	VARIAX_pickup1_angle               =  12,  /* type: 24 bit float */
+	VARIAX_pickup1_level               =  15,  /* type: 24 bit float */
+	VARIAX_pickup2_enable              =  18,  /* 0: enabled, 1: disabled */
+	VARIAX_pickup2_type                =  22,
+	VARIAX_pickup2_position            =  23,  /* type: 24 bit float */
+	VARIAX_pickup2_angle               =  26,  /* type: 24 bit float */
+	VARIAX_pickup2_level               =  29,  /* type: 24 bit float */
+	VARIAX_pickup_phase                =  32,  /* 0: in phase, 1: out of phase */
+	VARIAX_capacitance                 =  33,  /* type: 24 bit float */
+	VARIAX_tone_resistance             =  36,  /* type: 24 bit float */
+	VARIAX_volume_resistance           =  39,  /* type: 24 bit float */
+	VARIAX_taper                       =  42,  /* 0: Linear, 1: Audio */
+	VARIAX_tone_dump                   =  43,  /* type: 24 bit float */
+	VARIAX_save_tone                   =  46,
+	VARIAX_volume_dump                 =  47,  /* type: 24 bit float */
+	VARIAX_tuning_enable               =  50,
+	VARIAX_tuning6                     =  51,
+	VARIAX_tuning5                     =  52,
+	VARIAX_tuning4                     =  53,
+	VARIAX_tuning3                     =  54,
+	VARIAX_tuning2                     =  55,
+	VARIAX_tuning1                     =  56,
+	VARIAX_detune6                     =  57,  /* type: 24 bit float */
+	VARIAX_detune5                     =  60,  /* type: 24 bit float */
+	VARIAX_detune4                     =  63,  /* type: 24 bit float */
+	VARIAX_detune3                     =  66,  /* type: 24 bit float */
+	VARIAX_detune2                     =  69,  /* type: 24 bit float */
+	VARIAX_detune1                     =  72,  /* type: 24 bit float */
+	VARIAX_mix6                        =  75,  /* type: 24 bit float */
+	VARIAX_mix5                        =  78,  /* type: 24 bit float */
+	VARIAX_mix4                        =  81,  /* type: 24 bit float */
+	VARIAX_mix3                        =  84,  /* type: 24 bit float */
+	VARIAX_mix2                        =  87,  /* type: 24 bit float */
+	VARIAX_mix1                        =  90,  /* type: 24 bit float */
+	VARIAX_pickup_wiring               =  96   /* 0: parallel, 1: series */
+};
+
+/**
+   List of Variax workbench controls (MIDI).
+*/
+enum {
+	VARIAXMIDI_volume                  =   7,
+	VARIAXMIDI_tone                    =  79,
+};
+
+/* *INDENT-ON* */
+
+extern int line6_pod_create_files(int firmware, int type, struct device *dev);
+extern void line6_pod_remove_files(int firmware, int type, struct device *dev);
+extern int line6_variax_create_files(int firmware, int type,
+				     struct device *dev);
+extern void line6_variax_remove_files(int firmware, int type,
+				      struct device *dev);
+
+#endif
diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
new file mode 100644
index 0000000..ac11a3b
--- /dev/null
+++ b/sound/usb/line6/driver.c
@@ -0,0 +1,1290 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+
+#include "audio.h"
+#include "capture.h"
+#include "control.h"
+#include "driver.h"
+#include "midi.h"
+#include "playback.h"
+#include "pod.h"
+#include "podhd.h"
+#include "revision.h"
+#include "toneport.h"
+#include "usbdefs.h"
+#include "variax.h"
+
+#define DRIVER_AUTHOR  "Markus Grabner <grabner@icg.tugraz.at>"
+#define DRIVER_DESC    "Line6 USB Driver"
+#define DRIVER_VERSION "0.9.1beta" DRIVER_REVISION
+
+/* table of devices that work with this driver */
+static const struct usb_device_id line6_id_table[] = {
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXT)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTLIVE)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTPRO)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_GUITARPORT)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_POCKETPOD)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD300)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD500)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX2)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODX3)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODX3LIVE)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXT)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTLIVE)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTPRO)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_GX)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_UX1)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_UX2)},
+	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_VARIAX)},
+	{},
+};
+
+MODULE_DEVICE_TABLE(usb, line6_id_table);
+
+/* *INDENT-OFF* */
+static struct line6_properties line6_properties_table[] = {
+	{ LINE6_BIT_BASSPODXT,     "BassPODxt",     "BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
+	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
+	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODX3,         "PODX3",         "POD X3",           LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODX3LIVE,     "PODX3Live",     "POD X3 Live",      LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODXT,         "PODxt",         "PODxt",            LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODXTLIVE,     "PODxtLive",     "PODxt Live",       LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODXTPRO,      "PODxtPro",      "PODxt Pro",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_TONEPORT_GX,   "TonePortGX",    "TonePort GX",      LINE6_BIT_PCM               },
+	{ LINE6_BIT_TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     LINE6_BIT_PCM               },
+	{ LINE6_BIT_TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     LINE6_BIT_PCM               },
+	{ LINE6_BIT_VARIAX,        "Variax",        "Variax Workbench", LINE6_BIT_CONTROL           },
+};
+/* *INDENT-ON* */
+
+/*
+	This is Line6's MIDI manufacturer ID.
+*/
+const unsigned char line6_midi_id[] = {
+	0x00, 0x01, 0x0c
+};
+
+/*
+	Code to request version of POD, Variax interface
+	(and maybe other devices).
+*/
+static const char line6_request_version[] = {
+	0xf0, 0x7e, 0x7f, 0x06, 0x01, 0xf7
+};
+
+/**
+	 Class for asynchronous messages.
+*/
+struct message {
+	struct usb_line6 *line6;
+	const char *buffer;
+	int size;
+	int done;
+};
+
+/*
+	Forward declarations.
+*/
+static void line6_data_received(struct urb *urb);
+static int line6_send_raw_message_async_part(struct message *msg,
+					     struct urb *urb);
+
+/*
+	Start to listen on endpoint.
+*/
+static int line6_start_listen(struct usb_line6 *line6)
+{
+	int err;
+	usb_fill_int_urb(line6->urb_listen, line6->usbdev,
+			 usb_rcvintpipe(line6->usbdev, line6->ep_control_read),
+			 line6->buffer_listen, LINE6_BUFSIZE_LISTEN,
+			 line6_data_received, line6, line6->interval);
+	line6->urb_listen->actual_length = 0;
+	err = usb_submit_urb(line6->urb_listen, GFP_ATOMIC);
+	return err;
+}
+
+/*
+	Stop listening on endpoint.
+*/
+static void line6_stop_listen(struct usb_line6 *line6)
+{
+	usb_kill_urb(line6->urb_listen);
+}
+
+#ifdef CONFIG_LINE6_USB_DUMP_ANY
+/*
+	Write hexdump to syslog.
+*/
+void line6_write_hexdump(struct usb_line6 *line6, char dir,
+			 const unsigned char *buffer, int size)
+{
+	static const int BYTES_PER_LINE = 8;
+	char hexdump[100];
+	char asc[BYTES_PER_LINE + 1];
+	int i, j;
+
+	for (i = 0; i < size; i += BYTES_PER_LINE) {
+		int hexdumpsize = sizeof(hexdump);
+		char *p = hexdump;
+		int n = min(size - i, BYTES_PER_LINE);
+		asc[n] = 0;
+
+		for (j = 0; j < BYTES_PER_LINE; ++j) {
+			int bytes;
+
+			if (j < n) {
+				unsigned char val = buffer[i + j];
+				bytes = snprintf(p, hexdumpsize, " %02X", val);
+				asc[j] = ((val >= 0x20)
+					  && (val < 0x7f)) ? val : '.';
+			} else
+				bytes = snprintf(p, hexdumpsize, "   ");
+
+			if (bytes > hexdumpsize)
+				break;	/* buffer overflow */
+
+			p += bytes;
+			hexdumpsize -= bytes;
+		}
+
+		dev_info(line6->ifcdev, "%c%04X:%s %s\n", dir, i, hexdump, asc);
+	}
+}
+#endif
+
+#ifdef CONFIG_LINE6_USB_DUMP_CTRL
+/*
+	Dump URB data to syslog.
+*/
+static void line6_dump_urb(struct urb *urb)
+{
+	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
+
+	if (urb->status < 0)
+		return;
+
+	line6_write_hexdump(line6, 'R', (unsigned char *)urb->transfer_buffer,
+			    urb->actual_length);
+}
+#endif
+
+/*
+	Send raw message in pieces of wMaxPacketSize bytes.
+*/
+int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
+			   int size)
+{
+	int i, done = 0;
+
+#ifdef CONFIG_LINE6_USB_DUMP_CTRL
+	line6_write_hexdump(line6, 'S', buffer, size);
+#endif
+
+	for (i = 0; i < size; i += line6->max_packet_size) {
+		int partial;
+		const char *frag_buf = buffer + i;
+		int frag_size = min(line6->max_packet_size, size - i);
+		int retval;
+
+		retval = usb_interrupt_msg(line6->usbdev,
+					   usb_sndintpipe(line6->usbdev,
+							  line6->ep_control_write),
+					   (char *)frag_buf, frag_size,
+					   &partial, LINE6_TIMEOUT * HZ);
+
+		if (retval) {
+			dev_err(line6->ifcdev,
+				"usb_interrupt_msg failed (%d)\n", retval);
+			break;
+		}
+
+		done += frag_size;
+	}
+
+	return done;
+}
+
+/*
+	Notification of completion of asynchronous request transmission.
+*/
+static void line6_async_request_sent(struct urb *urb)
+{
+	struct message *msg = (struct message *)urb->context;
+
+	if (msg->done >= msg->size) {
+		usb_free_urb(urb);
+		kfree(msg);
+	} else
+		line6_send_raw_message_async_part(msg, urb);
+}
+
+/*
+	Asynchronously send part of a raw message.
+*/
+static int line6_send_raw_message_async_part(struct message *msg,
+					     struct urb *urb)
+{
+	int retval;
+	struct usb_line6 *line6 = msg->line6;
+	int done = msg->done;
+	int bytes = min(msg->size - done, line6->max_packet_size);
+
+	usb_fill_int_urb(urb, line6->usbdev,
+			 usb_sndintpipe(line6->usbdev, line6->ep_control_write),
+			 (char *)msg->buffer + done, bytes,
+			 line6_async_request_sent, msg, line6->interval);
+
+#ifdef CONFIG_LINE6_USB_DUMP_CTRL
+	line6_write_hexdump(line6, 'S', (char *)msg->buffer + done, bytes);
+#endif
+
+	msg->done += bytes;
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
+
+	if (retval < 0) {
+		dev_err(line6->ifcdev, "%s: usb_submit_urb failed (%d)\n",
+			__func__, retval);
+		usb_free_urb(urb);
+		kfree(msg);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+	Setup and start timer.
+*/
+void line6_start_timer(struct timer_list *timer, unsigned int msecs,
+		       void (*function) (unsigned long), unsigned long data)
+{
+	setup_timer(timer, function, data);
+	timer->expires = jiffies + msecs * HZ / 1000;
+	add_timer(timer);
+}
+
+/*
+	Asynchronously send raw message.
+*/
+int line6_send_raw_message_async(struct usb_line6 *line6, const char *buffer,
+				 int size)
+{
+	struct message *msg;
+	struct urb *urb;
+
+	/* create message: */
+	msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
+
+	if (msg == NULL) {
+		dev_err(line6->ifcdev, "Out of memory\n");
+		return -ENOMEM;
+	}
+
+	/* create URB: */
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+
+	if (urb == NULL) {
+		kfree(msg);
+		dev_err(line6->ifcdev, "Out of memory\n");
+		return -ENOMEM;
+	}
+
+	/* set message data: */
+	msg->line6 = line6;
+	msg->buffer = buffer;
+	msg->size = size;
+	msg->done = 0;
+
+	/* start sending: */
+	return line6_send_raw_message_async_part(msg, urb);
+}
+
+/*
+	Send asynchronous device version request.
+*/
+int line6_version_request_async(struct usb_line6 *line6)
+{
+	char *buffer;
+	int retval;
+
+	buffer = kmalloc(sizeof(line6_request_version), GFP_ATOMIC);
+	if (buffer == NULL) {
+		dev_err(line6->ifcdev, "Out of memory");
+		return -ENOMEM;
+	}
+
+	memcpy(buffer, line6_request_version, sizeof(line6_request_version));
+
+	retval = line6_send_raw_message_async(line6, buffer,
+					      sizeof(line6_request_version));
+	kfree(buffer);
+	return retval;
+}
+
+/*
+	Send sysex message in pieces of wMaxPacketSize bytes.
+*/
+int line6_send_sysex_message(struct usb_line6 *line6, const char *buffer,
+			     int size)
+{
+	return line6_send_raw_message(line6, buffer,
+				      size + SYSEX_EXTRA_SIZE) -
+	    SYSEX_EXTRA_SIZE;
+}
+
+/*
+	Send sysex message in pieces of wMaxPacketSize bytes.
+*/
+int line6_send_sysex_message_async(struct usb_line6 *line6, const char *buffer,
+				   int size)
+{
+	return line6_send_raw_message_async(line6, buffer,
+					    size + SYSEX_EXTRA_SIZE) -
+	    SYSEX_EXTRA_SIZE;
+}
+
+/*
+	Allocate buffer for sysex message and prepare header.
+	@param code sysex message code
+	@param size number of bytes between code and sysex end
+*/
+char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1, int code2,
+			       int size)
+{
+	char *buffer = kmalloc(size + SYSEX_EXTRA_SIZE, GFP_ATOMIC);
+
+	if (!buffer) {
+		dev_err(line6->ifcdev, "out of memory\n");
+		return NULL;
+	}
+
+	buffer[0] = LINE6_SYSEX_BEGIN;
+	memcpy(buffer + 1, line6_midi_id, sizeof(line6_midi_id));
+	buffer[sizeof(line6_midi_id) + 1] = code1;
+	buffer[sizeof(line6_midi_id) + 2] = code2;
+	buffer[sizeof(line6_midi_id) + 3 + size] = LINE6_SYSEX_END;
+	return buffer;
+}
+
+/*
+	Notification of data received from the Line6 device.
+*/
+static void line6_data_received(struct urb *urb)
+{
+	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
+	struct MidiBuffer *mb = &line6->line6midi->midibuf_in;
+	int done;
+
+	if (urb->status == -ESHUTDOWN)
+		return;
+
+#ifdef CONFIG_LINE6_USB_DUMP_CTRL
+	line6_dump_urb(urb);
+#endif
+
+	done =
+	    line6_midibuf_write(mb, urb->transfer_buffer, urb->actual_length);
+
+	if (done < urb->actual_length) {
+		line6_midibuf_ignore(mb, done);
+		DEBUG_MESSAGES(dev_err
+			       (line6->ifcdev,
+				"%d %d buffer overflow - message skipped\n",
+				done, urb->actual_length));
+	}
+
+	for (;;) {
+		done =
+		    line6_midibuf_read(mb, line6->buffer_message,
+				       LINE6_MESSAGE_MAXLEN);
+
+		if (done == 0)
+			break;
+
+		/* MIDI input filter */
+		if (line6_midibuf_skip_message
+		    (mb, line6->line6midi->midi_mask_receive))
+			continue;
+
+		line6->message_length = done;
+#ifdef CONFIG_LINE6_USB_DUMP_MIDI
+		line6_write_hexdump(line6, 'r', line6->buffer_message, done);
+#endif
+		line6_midi_receive(line6, line6->buffer_message, done);
+
+		switch (line6->usbdev->descriptor.idProduct) {
+		case LINE6_DEVID_BASSPODXT:
+		case LINE6_DEVID_BASSPODXTLIVE:
+		case LINE6_DEVID_BASSPODXTPRO:
+		case LINE6_DEVID_PODXT:
+		case LINE6_DEVID_PODXTPRO:
+		case LINE6_DEVID_POCKETPOD:
+			line6_pod_process_message((struct usb_line6_pod *)
+						  line6);
+			break;
+
+		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD500:
+			break; /* let userspace handle MIDI */
+
+		case LINE6_DEVID_PODXTLIVE:
+			switch (line6->interface_number) {
+			case PODXTLIVE_INTERFACE_POD:
+				line6_pod_process_message((struct usb_line6_pod
+							   *)line6);
+				break;
+
+			case PODXTLIVE_INTERFACE_VARIAX:
+				line6_variax_process_message((struct
+							      usb_line6_variax
+							      *)line6);
+				break;
+
+			default:
+				dev_err(line6->ifcdev,
+					"PODxt Live interface %d not supported\n",
+					line6->interface_number);
+			}
+			break;
+
+		case LINE6_DEVID_VARIAX:
+			line6_variax_process_message((struct usb_line6_variax *)
+						     line6);
+			break;
+
+		default:
+			MISSING_CASE;
+		}
+	}
+
+	line6_start_listen(line6);
+}
+
+/*
+	Send channel number (i.e., switch to a different sound).
+*/
+int line6_send_program(struct usb_line6 *line6, u8 value)
+{
+	int retval;
+	unsigned char *buffer;
+	int partial;
+
+	buffer = kmalloc(2, GFP_KERNEL);
+
+	if (!buffer) {
+		dev_err(line6->ifcdev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	buffer[0] = LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST;
+	buffer[1] = value;
+
+#ifdef CONFIG_LINE6_USB_DUMP_CTRL
+	line6_write_hexdump(line6, 'S', buffer, 2);
+#endif
+
+	retval = usb_interrupt_msg(line6->usbdev,
+				   usb_sndintpipe(line6->usbdev,
+						  line6->ep_control_write),
+				   buffer, 2, &partial, LINE6_TIMEOUT * HZ);
+
+	if (retval)
+		dev_err(line6->ifcdev, "usb_interrupt_msg failed (%d)\n",
+			retval);
+
+	kfree(buffer);
+	return retval;
+}
+
+/*
+	Transmit Line6 control parameter.
+*/
+int line6_transmit_parameter(struct usb_line6 *line6, int param, u8 value)
+{
+	int retval;
+	unsigned char *buffer;
+	int partial;
+
+	buffer = kmalloc(3, GFP_KERNEL);
+
+	if (!buffer) {
+		dev_err(line6->ifcdev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	buffer[0] = LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST;
+	buffer[1] = param;
+	buffer[2] = value;
+
+#ifdef CONFIG_LINE6_USB_DUMP_CTRL
+	line6_write_hexdump(line6, 'S', buffer, 3);
+#endif
+
+	retval = usb_interrupt_msg(line6->usbdev,
+				   usb_sndintpipe(line6->usbdev,
+						  line6->ep_control_write),
+				   buffer, 3, &partial, LINE6_TIMEOUT * HZ);
+
+	if (retval)
+		dev_err(line6->ifcdev, "usb_interrupt_msg failed (%d)\n",
+			retval);
+
+	kfree(buffer);
+	return retval;
+}
+
+/*
+	Read data from device.
+*/
+int line6_read_data(struct usb_line6 *line6, int address, void *data,
+		    size_t datalen)
+{
+	struct usb_device *usbdev = line6->usbdev;
+	int ret;
+	unsigned char len;
+
+	/* query the serial number: */
+	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
+			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			      (datalen << 8) | 0x21, address,
+			      NULL, 0, LINE6_TIMEOUT * HZ);
+
+	if (ret < 0) {
+		dev_err(line6->ifcdev, "read request failed (error %d)\n", ret);
+		return ret;
+	}
+
+	/* Wait for data length. We'll get a couple of 0xff until length arrives. */
+	do {
+		ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
+				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
+				      USB_DIR_IN,
+				      0x0012, 0x0000, &len, 1,
+				      LINE6_TIMEOUT * HZ);
+		if (ret < 0) {
+			dev_err(line6->ifcdev,
+				"receive length failed (error %d)\n", ret);
+			return ret;
+		}
+	} while (len == 0xff);
+
+	if (len != datalen) {
+		/* should be equal or something went wrong */
+		dev_err(line6->ifcdev,
+			"length mismatch (expected %d, got %d)\n",
+			(int)datalen, (int)len);
+		return -EINVAL;
+	}
+
+	/* receive the result: */
+	ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
+			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+			      0x0013, 0x0000, data, datalen,
+			      LINE6_TIMEOUT * HZ);
+
+	if (ret < 0) {
+		dev_err(line6->ifcdev, "read failed (error %d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+	Write data to device.
+*/
+int line6_write_data(struct usb_line6 *line6, int address, void *data,
+		     size_t datalen)
+{
+	struct usb_device *usbdev = line6->usbdev;
+	int ret;
+	unsigned char status;
+
+	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
+			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			      0x0022, address, data, datalen,
+			      LINE6_TIMEOUT * HZ);
+
+	if (ret < 0) {
+		dev_err(line6->ifcdev,
+			"write request failed (error %d)\n", ret);
+		return ret;
+	}
+
+	do {
+		ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0),
+				      0x67,
+				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
+				      USB_DIR_IN,
+				      0x0012, 0x0000,
+				      &status, 1, LINE6_TIMEOUT * HZ);
+
+		if (ret < 0) {
+			dev_err(line6->ifcdev,
+				"receiving status failed (error %d)\n", ret);
+			return ret;
+		}
+	} while (status == 0xff);
+
+	if (status != 0) {
+		dev_err(line6->ifcdev, "write failed (error %d)\n", ret);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+	Read Line6 device serial number.
+	(POD, TonePort, GuitarPort)
+*/
+int line6_read_serial_number(struct usb_line6 *line6, int *serial_number)
+{
+	return line6_read_data(line6, 0x80d0, serial_number,
+			       sizeof(*serial_number));
+}
+
+/*
+	No operation (i.e., unsupported).
+*/
+ssize_t line6_nop_read(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	return 0;
+}
+
+/*
+	No operation (i.e., unsupported).
+*/
+ssize_t line6_nop_write(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	return count;
+}
+
+/*
+	"write" request on "raw" special file.
+*/
+#ifdef CONFIG_LINE6_USB_RAW
+ssize_t line6_set_raw(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+	line6_send_raw_message(line6, buf, count);
+	return count;
+}
+#endif
+
+/*
+	Generic destructor.
+*/
+static void line6_destruct(struct usb_interface *interface)
+{
+	struct usb_line6 *line6;
+
+	if (interface == NULL)
+		return;
+	line6 = usb_get_intfdata(interface);
+	if (line6 == NULL)
+		return;
+
+	/* free buffer memory first: */
+	kfree(line6->buffer_message);
+	kfree(line6->buffer_listen);
+
+	/* then free URBs: */
+	usb_free_urb(line6->urb_listen);
+
+	/* make sure the device isn't destructed twice: */
+	usb_set_intfdata(interface, NULL);
+
+	/* free interface data: */
+	kfree(line6);
+}
+
+/*
+	Probe USB device.
+*/
+static int line6_probe(struct usb_interface *interface,
+		       const struct usb_device_id *id)
+{
+	int devtype;
+	struct usb_device *usbdev;
+	struct usb_line6 *line6;
+	const struct line6_properties *properties;
+	int interface_number, alternate = 0;
+	int product;
+	int size = 0;
+	int ep_read = 0, ep_write = 0;
+	int ret;
+
+	if (interface == NULL)
+		return -ENODEV;
+	usbdev = interface_to_usbdev(interface);
+	if (usbdev == NULL)
+		return -ENODEV;
+
+	/* we don't handle multiple configurations */
+	if (usbdev->descriptor.bNumConfigurations != 1) {
+		ret = -ENODEV;
+		goto err_put;
+	}
+
+	/* check vendor and product id */
+	for (devtype = ARRAY_SIZE(line6_id_table) - 1; devtype--;) {
+		u16 idVendor = le16_to_cpu(usbdev->descriptor.idVendor);
+		u16 idProduct = le16_to_cpu(usbdev->descriptor.idProduct);
+
+		if (idVendor == line6_id_table[devtype].idVendor &&
+		    idProduct == line6_id_table[devtype].idProduct)
+			break;
+	}
+
+	if (devtype < 0) {
+		ret = -ENODEV;
+		goto err_put;
+	}
+
+	/* initialize device info: */
+	properties = &line6_properties_table[devtype];
+	dev_info(&interface->dev, "Line6 %s found\n", properties->name);
+	product = le16_to_cpu(usbdev->descriptor.idProduct);
+
+	/* query interface number */
+	interface_number = interface->cur_altsetting->desc.bInterfaceNumber;
+
+	switch (product) {
+	case LINE6_DEVID_BASSPODXTLIVE:
+	case LINE6_DEVID_PODXTLIVE:
+	case LINE6_DEVID_VARIAX:
+		alternate = 1;
+		break;
+
+	case LINE6_DEVID_POCKETPOD:
+		switch (interface_number) {
+		case 0:
+			return 0;	/* this interface has no endpoints */
+		case 1:
+			alternate = 0;
+			break;
+		default:
+			MISSING_CASE;
+		}
+		break;
+
+	case LINE6_DEVID_PODHD500:
+	case LINE6_DEVID_PODX3:
+	case LINE6_DEVID_PODX3LIVE:
+		switch (interface_number) {
+		case 0:
+			alternate = 1;
+			break;
+		case 1:
+			alternate = 0;
+			break;
+		default:
+			MISSING_CASE;
+		}
+		break;
+
+	case LINE6_DEVID_BASSPODXT:
+	case LINE6_DEVID_BASSPODXTPRO:
+	case LINE6_DEVID_PODXT:
+	case LINE6_DEVID_PODXTPRO:
+	case LINE6_DEVID_PODHD300:
+		alternate = 5;
+		break;
+
+	case LINE6_DEVID_GUITARPORT:
+	case LINE6_DEVID_PODSTUDIO_GX:
+	case LINE6_DEVID_PODSTUDIO_UX1:
+	case LINE6_DEVID_TONEPORT_GX:
+	case LINE6_DEVID_TONEPORT_UX1:
+		alternate = 2;	/* 1..4 seem to be ok */
+		break;
+
+	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+		switch (interface_number) {
+		case 0:
+			/* defaults to 44.1kHz, 16-bit */
+			alternate = 2;
+			break;
+		case 1:
+			/* don't know yet what this is ...
+			   alternate = 1;
+			   break;
+			 */
+			return -ENODEV;
+		default:
+			MISSING_CASE;
+		}
+		break;
+
+	default:
+		MISSING_CASE;
+		ret = -ENODEV;
+		goto err_put;
+	}
+
+	ret = usb_set_interface(usbdev, interface_number, alternate);
+	if (ret < 0) {
+		dev_err(&interface->dev, "set_interface failed\n");
+		goto err_put;
+	}
+
+	/* initialize device data based on product id: */
+	switch (product) {
+	case LINE6_DEVID_BASSPODXT:
+	case LINE6_DEVID_BASSPODXTLIVE:
+	case LINE6_DEVID_BASSPODXTPRO:
+	case LINE6_DEVID_PODXT:
+	case LINE6_DEVID_PODXTPRO:
+		size = sizeof(struct usb_line6_pod);
+		ep_read = 0x84;
+		ep_write = 0x03;
+		break;
+
+	case LINE6_DEVID_PODHD300:
+		size = sizeof(struct usb_line6_podhd);
+		ep_read = 0x84;
+		ep_write = 0x03;
+		break;
+
+	case LINE6_DEVID_PODHD500:
+		size = sizeof(struct usb_line6_podhd);
+		ep_read = 0x81;
+		ep_write = 0x01;
+		break;
+
+	case LINE6_DEVID_POCKETPOD:
+		size = sizeof(struct usb_line6_pod);
+		ep_read = 0x82;
+		ep_write = 0x02;
+		break;
+
+	case LINE6_DEVID_PODX3:
+	case LINE6_DEVID_PODX3LIVE:
+		/* currently unused! */
+		size = sizeof(struct usb_line6_pod);
+		ep_read = 0x81;
+		ep_write = 0x01;
+		break;
+
+	case LINE6_DEVID_PODSTUDIO_GX:
+	case LINE6_DEVID_PODSTUDIO_UX1:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+	case LINE6_DEVID_TONEPORT_GX:
+	case LINE6_DEVID_TONEPORT_UX1:
+	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_DEVID_GUITARPORT:
+		size = sizeof(struct usb_line6_toneport);
+		/* these don't have a control channel */
+		break;
+
+	case LINE6_DEVID_PODXTLIVE:
+		switch (interface_number) {
+		case PODXTLIVE_INTERFACE_POD:
+			size = sizeof(struct usb_line6_pod);
+			ep_read = 0x84;
+			ep_write = 0x03;
+			break;
+
+		case PODXTLIVE_INTERFACE_VARIAX:
+			size = sizeof(struct usb_line6_variax);
+			ep_read = 0x86;
+			ep_write = 0x05;
+			break;
+
+		default:
+			ret = -ENODEV;
+			goto err_put;
+		}
+		break;
+
+	case LINE6_DEVID_VARIAX:
+		size = sizeof(struct usb_line6_variax);
+		ep_read = 0x82;
+		ep_write = 0x01;
+		break;
+
+	default:
+		MISSING_CASE;
+		ret = -ENODEV;
+		goto err_put;
+	}
+
+	if (size == 0) {
+		dev_err(&interface->dev,
+			"driver bug: interface data size not set\n");
+		ret = -ENODEV;
+		goto err_put;
+	}
+
+	line6 = kzalloc(size, GFP_KERNEL);
+
+	if (line6 == NULL) {
+		dev_err(&interface->dev, "Out of memory\n");
+		ret = -ENODEV;
+		goto err_put;
+	}
+
+	/* store basic data: */
+	line6->interface_number = interface_number;
+	line6->properties = properties;
+	line6->usbdev = usbdev;
+	line6->ifcdev = &interface->dev;
+	line6->ep_control_read = ep_read;
+	line6->ep_control_write = ep_write;
+	line6->product = product;
+
+	/* get data from endpoint descriptor (see usb_maxpacket): */
+	{
+		struct usb_host_endpoint *ep;
+		unsigned epnum =
+		    usb_pipeendpoint(usb_rcvintpipe(usbdev, ep_read));
+		ep = usbdev->ep_in[epnum];
+
+		if (ep != NULL) {
+			line6->interval = ep->desc.bInterval;
+			line6->max_packet_size =
+			    le16_to_cpu(ep->desc.wMaxPacketSize);
+		} else {
+			line6->interval = LINE6_FALLBACK_INTERVAL;
+			line6->max_packet_size = LINE6_FALLBACK_MAXPACKETSIZE;
+			dev_err(line6->ifcdev,
+				"endpoint not available, using fallback values");
+		}
+	}
+
+	usb_set_intfdata(interface, line6);
+
+	if (properties->capabilities & LINE6_BIT_CONTROL) {
+		/* initialize USB buffers: */
+		line6->buffer_listen =
+		    kmalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
+
+		if (line6->buffer_listen == NULL) {
+			dev_err(&interface->dev, "Out of memory\n");
+			ret = -ENOMEM;
+			goto err_destruct;
+		}
+
+		line6->buffer_message =
+		    kmalloc(LINE6_MESSAGE_MAXLEN, GFP_KERNEL);
+
+		if (line6->buffer_message == NULL) {
+			dev_err(&interface->dev, "Out of memory\n");
+			ret = -ENOMEM;
+			goto err_destruct;
+		}
+
+		line6->urb_listen = usb_alloc_urb(0, GFP_KERNEL);
+
+		if (line6->urb_listen == NULL) {
+			dev_err(&interface->dev, "Out of memory\n");
+			line6_destruct(interface);
+			ret = -ENOMEM;
+			goto err_destruct;
+		}
+
+		ret = line6_start_listen(line6);
+		if (ret < 0) {
+			dev_err(&interface->dev, "%s: usb_submit_urb failed\n",
+				__func__);
+			goto err_destruct;
+		}
+	}
+
+	/* initialize device data based on product id: */
+	switch (product) {
+	case LINE6_DEVID_BASSPODXT:
+	case LINE6_DEVID_BASSPODXTLIVE:
+	case LINE6_DEVID_BASSPODXTPRO:
+	case LINE6_DEVID_POCKETPOD:
+	case LINE6_DEVID_PODX3:
+	case LINE6_DEVID_PODX3LIVE:
+	case LINE6_DEVID_PODXT:
+	case LINE6_DEVID_PODXTPRO:
+		ret = line6_pod_init(interface, (struct usb_line6_pod *)line6);
+		break;
+
+	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD500:
+		ret = line6_podhd_init(interface,
+				       (struct usb_line6_podhd *)line6);
+		break;
+
+	case LINE6_DEVID_PODXTLIVE:
+		switch (interface_number) {
+		case PODXTLIVE_INTERFACE_POD:
+			ret =
+			    line6_pod_init(interface,
+					   (struct usb_line6_pod *)line6);
+			break;
+
+		case PODXTLIVE_INTERFACE_VARIAX:
+			ret =
+			    line6_variax_init(interface,
+					      (struct usb_line6_variax *)line6);
+			break;
+
+		default:
+			dev_err(&interface->dev,
+				"PODxt Live interface %d not supported\n",
+				interface_number);
+			ret = -ENODEV;
+		}
+
+		break;
+
+	case LINE6_DEVID_VARIAX:
+		ret =
+		    line6_variax_init(interface,
+				      (struct usb_line6_variax *)line6);
+		break;
+
+	case LINE6_DEVID_PODSTUDIO_GX:
+	case LINE6_DEVID_PODSTUDIO_UX1:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+	case LINE6_DEVID_TONEPORT_GX:
+	case LINE6_DEVID_TONEPORT_UX1:
+	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_DEVID_GUITARPORT:
+		ret =
+		    line6_toneport_init(interface,
+					(struct usb_line6_toneport *)line6);
+		break;
+
+	default:
+		MISSING_CASE;
+		ret = -ENODEV;
+	}
+
+	if (ret < 0)
+		goto err_destruct;
+
+	ret = sysfs_create_link(&interface->dev.kobj, &usbdev->dev.kobj,
+				"usb_device");
+	if (ret < 0)
+		goto err_destruct;
+
+	/* creation of additional special files should go here */
+
+	dev_info(&interface->dev, "Line6 %s now attached\n",
+		 line6->properties->name);
+
+	switch (product) {
+	case LINE6_DEVID_PODX3:
+	case LINE6_DEVID_PODX3LIVE:
+		dev_info(&interface->dev,
+			 "NOTE: the Line6 %s is detected, but not yet supported\n",
+			 line6->properties->name);
+	}
+
+	/* increment reference counters: */
+	usb_get_intf(interface);
+	usb_get_dev(usbdev);
+
+	return 0;
+
+err_destruct:
+	line6_destruct(interface);
+err_put:
+	return ret;
+}
+
+/*
+	Line6 device disconnected.
+*/
+static void line6_disconnect(struct usb_interface *interface)
+{
+	struct usb_line6 *line6;
+	struct usb_device *usbdev;
+	int interface_number;
+
+	if (interface == NULL)
+		return;
+	usbdev = interface_to_usbdev(interface);
+	if (usbdev == NULL)
+		return;
+
+	/* removal of additional special files should go here */
+
+	sysfs_remove_link(&interface->dev.kobj, "usb_device");
+
+	interface_number = interface->cur_altsetting->desc.bInterfaceNumber;
+	line6 = usb_get_intfdata(interface);
+
+	if (line6 != NULL) {
+		if (line6->urb_listen != NULL)
+			line6_stop_listen(line6);
+
+		if (usbdev != line6->usbdev)
+			dev_err(line6->ifcdev,
+				"driver bug: inconsistent usb device\n");
+
+		switch (line6->usbdev->descriptor.idProduct) {
+		case LINE6_DEVID_BASSPODXT:
+		case LINE6_DEVID_BASSPODXTLIVE:
+		case LINE6_DEVID_BASSPODXTPRO:
+		case LINE6_DEVID_POCKETPOD:
+		case LINE6_DEVID_PODX3:
+		case LINE6_DEVID_PODX3LIVE:
+		case LINE6_DEVID_PODXT:
+		case LINE6_DEVID_PODXTPRO:
+			line6_pod_disconnect(interface);
+			break;
+
+		case LINE6_DEVID_PODHD300:
+		case LINE6_DEVID_PODHD500:
+			line6_podhd_disconnect(interface);
+			break;
+
+		case LINE6_DEVID_PODXTLIVE:
+			switch (interface_number) {
+			case PODXTLIVE_INTERFACE_POD:
+				line6_pod_disconnect(interface);
+				break;
+
+			case PODXTLIVE_INTERFACE_VARIAX:
+				line6_variax_disconnect(interface);
+				break;
+			}
+
+			break;
+
+		case LINE6_DEVID_VARIAX:
+			line6_variax_disconnect(interface);
+			break;
+
+		case LINE6_DEVID_PODSTUDIO_GX:
+		case LINE6_DEVID_PODSTUDIO_UX1:
+		case LINE6_DEVID_PODSTUDIO_UX2:
+		case LINE6_DEVID_TONEPORT_GX:
+		case LINE6_DEVID_TONEPORT_UX1:
+		case LINE6_DEVID_TONEPORT_UX2:
+		case LINE6_DEVID_GUITARPORT:
+			line6_toneport_disconnect(interface);
+			break;
+
+		default:
+			MISSING_CASE;
+		}
+
+		dev_info(&interface->dev, "Line6 %s now disconnected\n",
+			 line6->properties->name);
+	}
+
+	line6_destruct(interface);
+
+	/* decrement reference counters: */
+	usb_put_intf(interface);
+	usb_put_dev(usbdev);
+}
+
+#ifdef CONFIG_PM
+
+/*
+	Suspend Line6 device.
+*/
+static int line6_suspend(struct usb_interface *interface, pm_message_t message)
+{
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+	struct snd_line6_pcm *line6pcm = line6->line6pcm;
+
+	snd_power_change_state(line6->card, SNDRV_CTL_POWER_D3hot);
+
+	if (line6->properties->capabilities & LINE6_BIT_CONTROL)
+		line6_stop_listen(line6);
+
+	if (line6pcm != NULL) {
+		snd_pcm_suspend_all(line6pcm->pcm);
+		line6_pcm_disconnect(line6pcm);
+		line6pcm->flags = 0;
+	}
+
+	return 0;
+}
+
+/*
+	Resume Line6 device.
+*/
+static int line6_resume(struct usb_interface *interface)
+{
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+
+	if (line6->properties->capabilities & LINE6_BIT_CONTROL)
+		line6_start_listen(line6);
+
+	snd_power_change_state(line6->card, SNDRV_CTL_POWER_D0);
+	return 0;
+}
+
+/*
+	Resume Line6 device after reset.
+*/
+static int line6_reset_resume(struct usb_interface *interface)
+{
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+
+	switch (line6->usbdev->descriptor.idProduct) {
+	case LINE6_DEVID_PODSTUDIO_GX:
+	case LINE6_DEVID_PODSTUDIO_UX1:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+	case LINE6_DEVID_TONEPORT_GX:
+	case LINE6_DEVID_TONEPORT_UX1:
+	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_DEVID_GUITARPORT:
+		line6_toneport_reset_resume((struct usb_line6_toneport *)line6);
+	}
+
+	return line6_resume(interface);
+}
+
+#endif /* CONFIG_PM */
+
+static struct usb_driver line6_driver = {
+	.name = DRIVER_NAME,
+	.probe = line6_probe,
+	.disconnect = line6_disconnect,
+#ifdef CONFIG_PM
+	.suspend = line6_suspend,
+	.resume = line6_resume,
+	.reset_resume = line6_reset_resume,
+#endif
+	.id_table = line6_id_table,
+};
+
+module_usb_driver(line6_driver);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
diff --git a/sound/usb/line6/driver.h b/sound/usb/line6/driver.h
new file mode 100644
index 0000000..35246cf
--- /dev/null
+++ b/sound/usb/line6/driver.h
@@ -0,0 +1,235 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef DRIVER_H
+#define DRIVER_H
+
+#include <linux/spinlock.h>
+#include <linux/usb.h>
+#include <sound/core.h>
+
+#include "midi.h"
+
+#define DRIVER_NAME "line6usb"
+
+#if defined(CONFIG_LINE6_USB_DUMP_CTRL) || defined(CONFIG_LINE6_USB_DUMP_MIDI) || defined(CONFIG_LINE6_USB_DUMP_PCM)
+#define CONFIG_LINE6_USB_DUMP_ANY
+#endif
+
+#define LINE6_TIMEOUT 1
+#define LINE6_BUFSIZE_LISTEN 32
+#define LINE6_MESSAGE_MAXLEN 256
+
+/*
+	Line6 MIDI control commands
+*/
+#define LINE6_PARAM_CHANGE   0xb0
+#define LINE6_PROGRAM_CHANGE 0xc0
+#define LINE6_SYSEX_BEGIN    0xf0
+#define LINE6_SYSEX_END      0xf7
+#define LINE6_RESET          0xff
+
+/*
+	MIDI channel for messages initiated by the host
+	(and eventually echoed back by the device)
+*/
+#define LINE6_CHANNEL_HOST   0x00
+
+/*
+	MIDI channel for messages initiated by the device
+*/
+#define LINE6_CHANNEL_DEVICE 0x02
+
+#define LINE6_CHANNEL_UNKNOWN 5	/* don't know yet what this is good for */
+
+#define LINE6_CHANNEL_MASK 0x0f
+
+#ifdef CONFIG_LINE6_USB_DEBUG
+#define DEBUG_MESSAGES(x) (x)
+#else
+#define DEBUG_MESSAGES(x)
+#endif
+
+#define MISSING_CASE	\
+	printk(KERN_ERR "line6usb driver bug: missing case in %s:%d\n", \
+		__FILE__, __LINE__)
+
+#define CHECK_RETURN(x)		\
+do {				\
+	err = x;		\
+	if (err < 0)		\
+		return err;	\
+} while (0)
+
+#define CHECK_STARTUP_PROGRESS(x, n)	\
+do {					\
+	if ((x) >= (n))			\
+		return;			\
+	x = (n);			\
+} while (0)
+
+extern const unsigned char line6_midi_id[3];
+
+static const int SYSEX_DATA_OFS = sizeof(line6_midi_id) + 3;
+static const int SYSEX_EXTRA_SIZE = sizeof(line6_midi_id) + 4;
+
+/**
+	 Common properties of Line6 devices.
+*/
+struct line6_properties {
+	/**
+		 Bit identifying this device in the line6usb driver.
+	*/
+	int device_bit;
+
+	/**
+		 Card id string (maximum 16 characters).
+		 This can be used to address the device in ALSA programs as
+		 "default:CARD=<id>"
+	*/
+	const char *id;
+
+	/**
+		 Card short name (maximum 32 characters).
+	*/
+	const char *name;
+
+	/**
+		 Bit vector defining this device's capabilities in the
+		 line6usb driver.
+	*/
+	int capabilities;
+};
+
+/**
+	 Common data shared by all Line6 devices.
+	 Corresponds to a pair of USB endpoints.
+*/
+struct usb_line6 {
+	/**
+		 USB device.
+	*/
+	struct usb_device *usbdev;
+
+	/**
+		 Product id.
+	*/
+	int product;
+
+	/**
+		 Properties.
+	*/
+	const struct line6_properties *properties;
+
+	/**
+		 Interface number.
+	*/
+	int interface_number;
+
+	/**
+		 Interval (ms).
+	*/
+	int interval;
+
+	/**
+		 Maximum size of USB packet.
+	*/
+	int max_packet_size;
+
+	/**
+		 Device representing the USB interface.
+	*/
+	struct device *ifcdev;
+
+	/**
+		 Line6 sound card data structure.
+		 Each device has at least MIDI or PCM.
+	*/
+	struct snd_card *card;
+
+	/**
+		 Line6 PCM device data structure.
+	*/
+	struct snd_line6_pcm *line6pcm;
+
+	/**
+		 Line6 MIDI device data structure.
+	*/
+	struct snd_line6_midi *line6midi;
+
+	/**
+		 USB endpoint for listening to control commands.
+	*/
+	int ep_control_read;
+
+	/**
+		 USB endpoint for writing control commands.
+	*/
+	int ep_control_write;
+
+	/**
+		 URB for listening to PODxt Pro control endpoint.
+	*/
+	struct urb *urb_listen;
+
+	/**
+		 Buffer for listening to PODxt Pro control endpoint.
+	*/
+	unsigned char *buffer_listen;
+
+	/**
+		 Buffer for message to be processed.
+	*/
+	unsigned char *buffer_message;
+
+	/**
+		 Length of message to be processed.
+	*/
+	int message_length;
+};
+
+extern char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1,
+				      int code2, int size);
+extern ssize_t line6_nop_read(struct device *dev,
+			      struct device_attribute *attr, char *buf);
+extern ssize_t line6_nop_write(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count);
+extern int line6_read_data(struct usb_line6 *line6, int address, void *data,
+			   size_t datalen);
+extern int line6_read_serial_number(struct usb_line6 *line6,
+				    int *serial_number);
+extern int line6_send_program(struct usb_line6 *line6, u8 value);
+extern int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
+				  int size);
+extern int line6_send_raw_message_async(struct usb_line6 *line6,
+					const char *buffer, int size);
+extern int line6_send_sysex_message(struct usb_line6 *line6,
+				    const char *buffer, int size);
+extern int line6_send_sysex_message_async(struct usb_line6 *line6,
+					  const char *buffer, int size);
+extern ssize_t line6_set_raw(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count);
+extern void line6_start_timer(struct timer_list *timer, unsigned int msecs,
+			      void (*function) (unsigned long),
+			      unsigned long data);
+extern int line6_transmit_parameter(struct usb_line6 *line6, int param,
+				    u8 value);
+extern int line6_version_request_async(struct usb_line6 *line6);
+extern int line6_write_data(struct usb_line6 *line6, int address, void *data,
+			    size_t datalen);
+
+#ifdef CONFIG_LINE6_USB_DUMP_ANY
+extern void line6_write_hexdump(struct usb_line6 *line6, char dir,
+				const unsigned char *buffer, int size);
+#endif
+
+#endif
diff --git a/sound/usb/line6/dumprequest.c b/sound/usb/line6/dumprequest.c
new file mode 100644
index 0000000..60c7bae
--- /dev/null
+++ b/sound/usb/line6/dumprequest.c
@@ -0,0 +1,135 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+
+#include "driver.h"
+#include "dumprequest.h"
+
+/*
+	Set "dump in progress" flag.
+*/
+void line6_dump_started(struct line6_dump_request *l6dr, int dest)
+{
+	l6dr->in_progress = dest;
+}
+
+/*
+	Invalidate current channel, i.e., set "dump in progress" flag.
+	Reading from the "dump" special file blocks until dump is completed.
+*/
+void line6_invalidate_current(struct line6_dump_request *l6dr)
+{
+	line6_dump_started(l6dr, LINE6_DUMP_CURRENT);
+}
+
+/*
+	Clear "dump in progress" flag and notify waiting processes.
+*/
+void line6_dump_finished(struct line6_dump_request *l6dr)
+{
+	l6dr->in_progress = LINE6_DUMP_NONE;
+	wake_up(&l6dr->wait);
+}
+
+/*
+	Send an asynchronous channel dump request.
+*/
+int line6_dump_request_async(struct line6_dump_request *l6dr,
+			     struct usb_line6 *line6, int num, int dest)
+{
+	int ret;
+	line6_dump_started(l6dr, dest);
+	ret = line6_send_raw_message_async(line6, l6dr->reqbufs[num].buffer,
+					   l6dr->reqbufs[num].length);
+
+	if (ret < 0)
+		line6_dump_finished(l6dr);
+
+	return ret;
+}
+
+/*
+	Wait for completion (interruptible).
+*/
+int line6_dump_wait_interruptible(struct line6_dump_request *l6dr)
+{
+	return wait_event_interruptible(l6dr->wait,
+					l6dr->in_progress == LINE6_DUMP_NONE);
+}
+
+/*
+	Wait for completion.
+*/
+void line6_dump_wait(struct line6_dump_request *l6dr)
+{
+	wait_event(l6dr->wait, l6dr->in_progress == LINE6_DUMP_NONE);
+}
+
+/*
+	Wait for completion (with timeout).
+*/
+int line6_dump_wait_timeout(struct line6_dump_request *l6dr, long timeout)
+{
+	return wait_event_timeout(l6dr->wait,
+				  l6dr->in_progress == LINE6_DUMP_NONE,
+				  timeout);
+}
+
+/*
+	Initialize dump request buffer.
+*/
+int line6_dumpreq_initbuf(struct line6_dump_request *l6dr, const void *buf,
+			  size_t len, int num)
+{
+	l6dr->reqbufs[num].buffer = kmemdup(buf, len, GFP_KERNEL);
+	if (l6dr->reqbufs[num].buffer == NULL)
+		return -ENOMEM;
+	l6dr->reqbufs[num].length = len;
+	return 0;
+}
+
+/*
+	Initialize dump request data structure (including one buffer).
+*/
+int line6_dumpreq_init(struct line6_dump_request *l6dr, const void *buf,
+		       size_t len)
+{
+	int ret;
+	ret = line6_dumpreq_initbuf(l6dr, buf, len, 0);
+	if (ret < 0)
+		return ret;
+	init_waitqueue_head(&l6dr->wait);
+	return 0;
+}
+
+/*
+	Destruct dump request data structure.
+*/
+void line6_dumpreq_destructbuf(struct line6_dump_request *l6dr, int num)
+{
+	if (l6dr == NULL)
+		return;
+	if (l6dr->reqbufs[num].buffer == NULL)
+		return;
+	kfree(l6dr->reqbufs[num].buffer);
+	l6dr->reqbufs[num].buffer = NULL;
+}
+
+/*
+	Destruct dump request data structure.
+*/
+void line6_dumpreq_destruct(struct line6_dump_request *l6dr)
+{
+	if (l6dr->reqbufs[0].buffer == NULL)
+		return;
+	line6_dumpreq_destructbuf(l6dr, 0);
+}
diff --git a/sound/usb/line6/dumprequest.h b/sound/usb/line6/dumprequest.h
new file mode 100644
index 0000000..c17a262
--- /dev/null
+++ b/sound/usb/line6/dumprequest.h
@@ -0,0 +1,76 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef DUMPREQUEST_H
+#define DUMPREQUEST_H
+
+#include <linux/usb.h>
+#include <linux/wait.h>
+#include <sound/core.h>
+
+enum {
+	LINE6_DUMP_NONE,
+	LINE6_DUMP_CURRENT
+};
+
+struct line6_dump_reqbuf {
+	/**
+		 Buffer for dump requests.
+	*/
+	unsigned char *buffer;
+
+	/**
+		 Size of dump request.
+	*/
+	size_t length;
+};
+
+/**
+	 Provides the functionality to request channel/model/... dump data from a
+	 Line6 device.
+*/
+struct line6_dump_request {
+	/**
+		 Wait queue for access to program dump data.
+	*/
+	wait_queue_head_t wait;
+
+	/**
+		 Indicates an unfinished program dump request.
+		 0: no dump
+		 1: dump current settings
+		 Other device-specific values are also allowed.
+	*/
+	int in_progress;
+
+	/**
+		 Dump request buffers
+	*/
+	struct line6_dump_reqbuf reqbufs[1];
+};
+
+extern void line6_dump_finished(struct line6_dump_request *l6dr);
+extern int line6_dump_request_async(struct line6_dump_request *l6dr,
+				    struct usb_line6 *line6, int num, int dest);
+extern void line6_dump_started(struct line6_dump_request *l6dr, int dest);
+extern void line6_dumpreq_destruct(struct line6_dump_request *l6dr);
+extern void line6_dumpreq_destructbuf(struct line6_dump_request *l6dr, int num);
+extern int line6_dumpreq_init(struct line6_dump_request *l6dr, const void *buf,
+			      size_t len);
+extern int line6_dumpreq_initbuf(struct line6_dump_request *l6dr,
+				 const void *buf, size_t len, int num);
+extern void line6_invalidate_current(struct line6_dump_request *l6dr);
+extern void line6_dump_wait(struct line6_dump_request *l6dr);
+extern int line6_dump_wait_interruptible(struct line6_dump_request *l6dr);
+extern int line6_dump_wait_timeout(struct line6_dump_request *l6dr,
+				   long timeout);
+
+#endif
diff --git a/sound/usb/line6/midi.c b/sound/usb/line6/midi.c
new file mode 100644
index 0000000..5040729
--- /dev/null
+++ b/sound/usb/line6/midi.c
@@ -0,0 +1,446 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <sound/core.h>
+#include <sound/rawmidi.h>
+
+#include "audio.h"
+#include "driver.h"
+#include "midi.h"
+#include "pod.h"
+#include "usbdefs.h"
+
+#define line6_rawmidi_substream_midi(substream) \
+	((struct snd_line6_midi *)((substream)->rmidi->private_data))
+
+static int send_midi_async(struct usb_line6 *line6, unsigned char *data,
+			   int length);
+
+/*
+	Pass data received via USB to MIDI.
+*/
+void line6_midi_receive(struct usb_line6 *line6, unsigned char *data,
+			int length)
+{
+	if (line6->line6midi->substream_receive)
+		snd_rawmidi_receive(line6->line6midi->substream_receive,
+				    data, length);
+}
+
+/*
+	Read data from MIDI buffer and transmit them via USB.
+*/
+static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
+{
+	struct usb_line6 *line6 =
+	    line6_rawmidi_substream_midi(substream)->line6;
+	struct snd_line6_midi *line6midi = line6->line6midi;
+	struct MidiBuffer *mb = &line6midi->midibuf_out;
+	unsigned long flags;
+	unsigned char chunk[line6->max_packet_size];
+	int req, done;
+
+	spin_lock_irqsave(&line6->line6midi->midi_transmit_lock, flags);
+
+	for (;;) {
+		req = min(line6_midibuf_bytes_free(mb), line6->max_packet_size);
+		done = snd_rawmidi_transmit_peek(substream, chunk, req);
+
+		if (done == 0)
+			break;
+
+#ifdef CONFIG_LINE6_USB_DUMP_MIDI
+		line6_write_hexdump(line6, 's', chunk, done);
+#endif
+		line6_midibuf_write(mb, chunk, done);
+		snd_rawmidi_transmit_ack(substream, done);
+	}
+
+	for (;;) {
+		done = line6_midibuf_read(mb, chunk, line6->max_packet_size);
+
+		if (done == 0)
+			break;
+
+		if (line6_midibuf_skip_message
+		    (mb, line6midi->midi_mask_transmit))
+			continue;
+
+		send_midi_async(line6, chunk, done);
+	}
+
+	spin_unlock_irqrestore(&line6->line6midi->midi_transmit_lock, flags);
+}
+
+/*
+	Notification of completion of MIDI transmission.
+*/
+static void midi_sent(struct urb *urb)
+{
+	unsigned long flags;
+	int status;
+	int num;
+	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
+
+	status = urb->status;
+	kfree(urb->transfer_buffer);
+	usb_free_urb(urb);
+
+	if (status == -ESHUTDOWN)
+		return;
+
+	spin_lock_irqsave(&line6->line6midi->send_urb_lock, flags);
+	num = --line6->line6midi->num_active_send_urbs;
+
+	if (num == 0) {
+		line6_midi_transmit(line6->line6midi->substream_transmit);
+		num = line6->line6midi->num_active_send_urbs;
+	}
+
+	if (num == 0)
+		wake_up(&line6->line6midi->send_wait);
+
+	spin_unlock_irqrestore(&line6->line6midi->send_urb_lock, flags);
+}
+
+/*
+	Send an asynchronous MIDI message.
+	Assumes that line6->line6midi->send_urb_lock is held
+	(i.e., this function is serialized).
+*/
+static int send_midi_async(struct usb_line6 *line6, unsigned char *data,
+			   int length)
+{
+	struct urb *urb;
+	int retval;
+	unsigned char *transfer_buffer;
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+
+	if (urb == NULL) {
+		dev_err(line6->ifcdev, "Out of memory\n");
+		return -ENOMEM;
+	}
+#ifdef CONFIG_LINE6_USB_DUMP_CTRL
+	line6_write_hexdump(line6, 'S', data, length);
+#endif
+
+	transfer_buffer = kmemdup(data, length, GFP_ATOMIC);
+
+	if (transfer_buffer == NULL) {
+		usb_free_urb(urb);
+		dev_err(line6->ifcdev, "Out of memory\n");
+		return -ENOMEM;
+	}
+
+	usb_fill_int_urb(urb, line6->usbdev,
+			 usb_sndbulkpipe(line6->usbdev,
+					 line6->ep_control_write),
+			 transfer_buffer, length, midi_sent, line6,
+			 line6->interval);
+	urb->actual_length = 0;
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
+
+	if (retval < 0) {
+		dev_err(line6->ifcdev, "usb_submit_urb failed\n");
+		usb_free_urb(urb);
+		return -EINVAL;
+	}
+
+	++line6->line6midi->num_active_send_urbs;
+
+	switch (line6->usbdev->descriptor.idProduct) {
+	case LINE6_DEVID_BASSPODXT:
+	case LINE6_DEVID_BASSPODXTLIVE:
+	case LINE6_DEVID_BASSPODXTPRO:
+	case LINE6_DEVID_PODXT:
+	case LINE6_DEVID_PODXTLIVE:
+	case LINE6_DEVID_PODXTPRO:
+	case LINE6_DEVID_POCKETPOD:
+		line6_pod_midi_postprocess((struct usb_line6_pod *)line6, data,
+					   length);
+		break;
+
+	case LINE6_DEVID_VARIAX:
+	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD500:
+		break;
+
+	default:
+		MISSING_CASE;
+	}
+
+	return 0;
+}
+
+static int line6_midi_output_open(struct snd_rawmidi_substream *substream)
+{
+	return 0;
+}
+
+static int line6_midi_output_close(struct snd_rawmidi_substream *substream)
+{
+	return 0;
+}
+
+static void line6_midi_output_trigger(struct snd_rawmidi_substream *substream,
+				      int up)
+{
+	unsigned long flags;
+	struct usb_line6 *line6 =
+	    line6_rawmidi_substream_midi(substream)->line6;
+
+	line6->line6midi->substream_transmit = substream;
+	spin_lock_irqsave(&line6->line6midi->send_urb_lock, flags);
+
+	if (line6->line6midi->num_active_send_urbs == 0)
+		line6_midi_transmit(substream);
+
+	spin_unlock_irqrestore(&line6->line6midi->send_urb_lock, flags);
+}
+
+static void line6_midi_output_drain(struct snd_rawmidi_substream *substream)
+{
+	struct usb_line6 *line6 =
+	    line6_rawmidi_substream_midi(substream)->line6;
+	struct snd_line6_midi *midi = line6->line6midi;
+	wait_event_interruptible(midi->send_wait,
+				 midi->num_active_send_urbs == 0);
+}
+
+static int line6_midi_input_open(struct snd_rawmidi_substream *substream)
+{
+	return 0;
+}
+
+static int line6_midi_input_close(struct snd_rawmidi_substream *substream)
+{
+	return 0;
+}
+
+static void line6_midi_input_trigger(struct snd_rawmidi_substream *substream,
+				     int up)
+{
+	struct usb_line6 *line6 =
+	    line6_rawmidi_substream_midi(substream)->line6;
+
+	if (up)
+		line6->line6midi->substream_receive = substream;
+	else
+		line6->line6midi->substream_receive = 0;
+}
+
+static struct snd_rawmidi_ops line6_midi_output_ops = {
+	.open = line6_midi_output_open,
+	.close = line6_midi_output_close,
+	.trigger = line6_midi_output_trigger,
+	.drain = line6_midi_output_drain,
+};
+
+static struct snd_rawmidi_ops line6_midi_input_ops = {
+	.open = line6_midi_input_open,
+	.close = line6_midi_input_close,
+	.trigger = line6_midi_input_trigger,
+};
+
+/*
+	Cleanup the Line6 MIDI device.
+*/
+static void line6_cleanup_midi(struct snd_rawmidi *rmidi)
+{
+}
+
+/* Create a MIDI device */
+static int snd_line6_new_midi(struct snd_line6_midi *line6midi)
+{
+	struct snd_rawmidi *rmidi;
+	int err;
+
+	err = snd_rawmidi_new(line6midi->line6->card, "Line6 MIDI", 0, 1, 1,
+			      &rmidi);
+	if (err < 0)
+		return err;
+
+	rmidi->private_data = line6midi;
+	rmidi->private_free = line6_cleanup_midi;
+	strcpy(rmidi->id, line6midi->line6->properties->id);
+	strcpy(rmidi->name, line6midi->line6->properties->name);
+
+	rmidi->info_flags =
+	    SNDRV_RAWMIDI_INFO_OUTPUT |
+	    SNDRV_RAWMIDI_INFO_INPUT | SNDRV_RAWMIDI_INFO_DUPLEX;
+
+	snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT,
+			    &line6_midi_output_ops);
+	snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_INPUT,
+			    &line6_midi_input_ops);
+	return 0;
+}
+
+/*
+	"read" request on "midi_mask_transmit" special file.
+*/
+static ssize_t midi_get_midi_mask_transmit(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+	return sprintf(buf, "%d\n", line6->line6midi->midi_mask_transmit);
+}
+
+/*
+	"write" request on "midi_mask" special file.
+*/
+static ssize_t midi_set_midi_mask_transmit(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+	unsigned short value;
+	int ret;
+
+	ret = kstrtou16(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	line6->line6midi->midi_mask_transmit = value;
+	return count;
+}
+
+/*
+	"read" request on "midi_mask_receive" special file.
+*/
+static ssize_t midi_get_midi_mask_receive(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+	return sprintf(buf, "%d\n", line6->line6midi->midi_mask_receive);
+}
+
+/*
+	"write" request on "midi_mask" special file.
+*/
+static ssize_t midi_set_midi_mask_receive(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+	unsigned short value;
+	int ret;
+
+	ret = kstrtou16(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	line6->line6midi->midi_mask_receive = value;
+	return count;
+}
+
+static DEVICE_ATTR(midi_mask_transmit, S_IWUSR | S_IRUGO,
+		   midi_get_midi_mask_transmit, midi_set_midi_mask_transmit);
+static DEVICE_ATTR(midi_mask_receive, S_IWUSR | S_IRUGO,
+		   midi_get_midi_mask_receive, midi_set_midi_mask_receive);
+
+/* MIDI device destructor */
+static int snd_line6_midi_free(struct snd_device *device)
+{
+	struct snd_line6_midi *line6midi = device->device_data;
+	device_remove_file(line6midi->line6->ifcdev,
+			   &dev_attr_midi_mask_transmit);
+	device_remove_file(line6midi->line6->ifcdev,
+			   &dev_attr_midi_mask_receive);
+	line6_midibuf_destroy(&line6midi->midibuf_in);
+	line6_midibuf_destroy(&line6midi->midibuf_out);
+	return 0;
+}
+
+/*
+	Initialize the Line6 MIDI subsystem.
+*/
+int line6_init_midi(struct usb_line6 *line6)
+{
+	static struct snd_device_ops midi_ops = {
+		.dev_free = snd_line6_midi_free,
+	};
+
+	int err;
+	struct snd_line6_midi *line6midi;
+
+	if (!(line6->properties->capabilities & LINE6_BIT_CONTROL)) {
+		/* skip MIDI initialization and report success */
+		return 0;
+	}
+
+	line6midi = kzalloc(sizeof(struct snd_line6_midi), GFP_KERNEL);
+
+	if (line6midi == NULL)
+		return -ENOMEM;
+
+	err = line6_midibuf_init(&line6midi->midibuf_in, MIDI_BUFFER_SIZE, 0);
+	if (err < 0) {
+		kfree(line6midi);
+		return err;
+	}
+
+	err = line6_midibuf_init(&line6midi->midibuf_out, MIDI_BUFFER_SIZE, 1);
+	if (err < 0) {
+		kfree(line6midi->midibuf_in.buf);
+		kfree(line6midi);
+		return err;
+	}
+
+	line6midi->line6 = line6;
+
+	switch (line6->product) {
+	case LINE6_DEVID_PODHD300:
+	case LINE6_DEVID_PODHD500:
+		line6midi->midi_mask_transmit = 1;
+		line6midi->midi_mask_receive = 1;
+		break;
+
+	default:
+		line6midi->midi_mask_transmit = 1;
+		line6midi->midi_mask_receive = 4;
+	}
+
+	line6->line6midi = line6midi;
+
+	err = snd_device_new(line6->card, SNDRV_DEV_RAWMIDI, line6midi,
+			     &midi_ops);
+	if (err < 0)
+		return err;
+
+	snd_card_set_dev(line6->card, line6->ifcdev);
+
+	err = snd_line6_new_midi(line6midi);
+	if (err < 0)
+		return err;
+
+	err = device_create_file(line6->ifcdev, &dev_attr_midi_mask_transmit);
+	if (err < 0)
+		return err;
+
+	err = device_create_file(line6->ifcdev, &dev_attr_midi_mask_receive);
+	if (err < 0)
+		return err;
+
+	init_waitqueue_head(&line6midi->send_wait);
+	spin_lock_init(&line6midi->send_urb_lock);
+	spin_lock_init(&line6midi->midi_transmit_lock);
+	return 0;
+}
diff --git a/sound/usb/line6/midi.h b/sound/usb/line6/midi.h
new file mode 100644
index 0000000..4a9e9f9
--- /dev/null
+++ b/sound/usb/line6/midi.h
@@ -0,0 +1,82 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef MIDI_H
+#define MIDI_H
+
+#include <sound/rawmidi.h>
+
+#include "midibuf.h"
+
+#define MIDI_BUFFER_SIZE 1024
+
+struct snd_line6_midi {
+	/**
+		 Pointer back to the Line6 driver data structure.
+	*/
+	struct usb_line6 *line6;
+
+	/**
+		 MIDI substream for receiving (or NULL if not active).
+	*/
+	struct snd_rawmidi_substream *substream_receive;
+
+	/**
+		 MIDI substream for transmitting (or NULL if not active).
+	*/
+	struct snd_rawmidi_substream *substream_transmit;
+
+	/**
+		 Number of currently active MIDI send URBs.
+	*/
+	int num_active_send_urbs;
+
+	/**
+		 Spin lock to protect updates of send_urb.
+	*/
+	spinlock_t send_urb_lock;
+
+	/**
+		 Spin lock to protect MIDI buffer handling.
+	*/
+	spinlock_t midi_transmit_lock;
+
+	/**
+		 Wait queue for MIDI transmission.
+	*/
+	wait_queue_head_t send_wait;
+
+	/**
+		 Bit mask for output MIDI channels.
+	*/
+	unsigned short midi_mask_transmit;
+
+	/**
+		 Bit mask for input MIDI channels.
+	*/
+	unsigned short midi_mask_receive;
+
+	/**
+		 Buffer for incoming MIDI stream.
+	*/
+	struct MidiBuffer midibuf_in;
+
+	/**
+		 Buffer for outgoing MIDI stream.
+	*/
+	struct MidiBuffer midibuf_out;
+};
+
+extern int line6_init_midi(struct usb_line6 *line6);
+extern void line6_midi_receive(struct usb_line6 *line6, unsigned char *data,
+			       int length);
+
+#endif
diff --git a/sound/usb/line6/midibuf.c b/sound/usb/line6/midibuf.c
new file mode 100644
index 0000000..836e8c8
--- /dev/null
+++ b/sound/usb/line6/midibuf.c
@@ -0,0 +1,264 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+
+#include "midibuf.h"
+
+static int midibuf_message_length(unsigned char code)
+{
+	if (code < 0x80)
+		return -1;
+	else if (code < 0xf0) {
+		static const int length[] = { 3, 3, 3, 3, 2, 2, 3 };
+		return length[(code >> 4) - 8];
+	} else {
+		/*
+		   Note that according to the MIDI specification 0xf2 is
+		   the "Song Position Pointer", but this is used by Line6
+		   to send sysex messages to the host.
+		 */
+		static const int length[] = { -1, 2, -1, 2, -1, -1, 1, 1, 1, 1,
+			1, 1, 1, -1, 1, 1
+		};
+		return length[code & 0x0f];
+	}
+}
+
+static int midibuf_is_empty(struct MidiBuffer *this)
+{
+	return (this->pos_read == this->pos_write) && !this->full;
+}
+
+static int midibuf_is_full(struct MidiBuffer *this)
+{
+	return this->full;
+}
+
+void line6_midibuf_reset(struct MidiBuffer *this)
+{
+	this->pos_read = this->pos_write = this->full = 0;
+	this->command_prev = -1;
+}
+
+int line6_midibuf_init(struct MidiBuffer *this, int size, int split)
+{
+	this->buf = kmalloc(size, GFP_KERNEL);
+
+	if (this->buf == NULL)
+		return -ENOMEM;
+
+	this->size = size;
+	this->split = split;
+	line6_midibuf_reset(this);
+	return 0;
+}
+
+void line6_midibuf_status(struct MidiBuffer *this)
+{
+	pr_debug("midibuf size=%d split=%d pos_read=%d pos_write=%d "
+	       "full=%d command_prev=%02x\n", this->size, this->split,
+	       this->pos_read, this->pos_write, this->full, this->command_prev);
+}
+
+int line6_midibuf_bytes_free(struct MidiBuffer *this)
+{
+	return
+	    midibuf_is_full(this) ?
+	    0 :
+	    (this->pos_read - this->pos_write + this->size - 1) % this->size +
+	    1;
+}
+
+int line6_midibuf_bytes_used(struct MidiBuffer *this)
+{
+	return
+	    midibuf_is_empty(this) ?
+	    0 :
+	    (this->pos_write - this->pos_read + this->size - 1) % this->size +
+	    1;
+}
+
+int line6_midibuf_write(struct MidiBuffer *this, unsigned char *data,
+			int length)
+{
+	int bytes_free;
+	int length1, length2;
+	int skip_active_sense = 0;
+
+	if (midibuf_is_full(this) || (length <= 0))
+		return 0;
+
+	/* skip trailing active sense */
+	if (data[length - 1] == 0xfe) {
+		--length;
+		skip_active_sense = 1;
+	}
+
+	bytes_free = line6_midibuf_bytes_free(this);
+
+	if (length > bytes_free)
+		length = bytes_free;
+
+	if (length > 0) {
+		length1 = this->size - this->pos_write;
+
+		if (length < length1) {
+			/* no buffer wraparound */
+			memcpy(this->buf + this->pos_write, data, length);
+			this->pos_write += length;
+		} else {
+			/* buffer wraparound */
+			length2 = length - length1;
+			memcpy(this->buf + this->pos_write, data, length1);
+			memcpy(this->buf, data + length1, length2);
+			this->pos_write = length2;
+		}
+
+		if (this->pos_write == this->pos_read)
+			this->full = 1;
+	}
+
+	return length + skip_active_sense;
+}
+
+int line6_midibuf_read(struct MidiBuffer *this, unsigned char *data, int length)
+{
+	int bytes_used;
+	int length1, length2;
+	int command;
+	int midi_length;
+	int repeat = 0;
+	int i;
+
+	/* we need to be able to store at least a 3 byte MIDI message */
+	if (length < 3)
+		return -EINVAL;
+
+	if (midibuf_is_empty(this))
+		return 0;
+
+	bytes_used = line6_midibuf_bytes_used(this);
+
+	if (length > bytes_used)
+		length = bytes_used;
+
+	length1 = this->size - this->pos_read;
+
+	/* check MIDI command length */
+	command = this->buf[this->pos_read];
+
+	if (command & 0x80) {
+		midi_length = midibuf_message_length(command);
+		this->command_prev = command;
+	} else {
+		if (this->command_prev > 0) {
+			int midi_length_prev =
+			    midibuf_message_length(this->command_prev);
+
+			if (midi_length_prev > 0) {
+				midi_length = midi_length_prev - 1;
+				repeat = 1;
+			} else
+				midi_length = -1;
+		} else
+			midi_length = -1;
+	}
+
+	if (midi_length < 0) {
+		/* search for end of message */
+		if (length < length1) {
+			/* no buffer wraparound */
+			for (i = 1; i < length; ++i)
+				if (this->buf[this->pos_read + i] & 0x80)
+					break;
+
+			midi_length = i;
+		} else {
+			/* buffer wraparound */
+			length2 = length - length1;
+
+			for (i = 1; i < length1; ++i)
+				if (this->buf[this->pos_read + i] & 0x80)
+					break;
+
+			if (i < length1)
+				midi_length = i;
+			else {
+				for (i = 0; i < length2; ++i)
+					if (this->buf[i] & 0x80)
+						break;
+
+				midi_length = length1 + i;
+			}
+		}
+
+		if (midi_length == length)
+			midi_length = -1;	/* end of message not found */
+	}
+
+	if (midi_length < 0) {
+		if (!this->split)
+			return 0;	/* command is not yet complete */
+	} else {
+		if (length < midi_length)
+			return 0;	/* command is not yet complete */
+
+		length = midi_length;
+	}
+
+	if (length < length1) {
+		/* no buffer wraparound */
+		memcpy(data + repeat, this->buf + this->pos_read, length);
+		this->pos_read += length;
+	} else {
+		/* buffer wraparound */
+		length2 = length - length1;
+		memcpy(data + repeat, this->buf + this->pos_read, length1);
+		memcpy(data + repeat + length1, this->buf, length2);
+		this->pos_read = length2;
+	}
+
+	if (repeat)
+		data[0] = this->command_prev;
+
+	this->full = 0;
+	return length + repeat;
+}
+
+int line6_midibuf_ignore(struct MidiBuffer *this, int length)
+{
+	int bytes_used = line6_midibuf_bytes_used(this);
+
+	if (length > bytes_used)
+		length = bytes_used;
+
+	this->pos_read = (this->pos_read + length) % this->size;
+	this->full = 0;
+	return length;
+}
+
+int line6_midibuf_skip_message(struct MidiBuffer *this, unsigned short mask)
+{
+	int cmd = this->command_prev;
+
+	if ((cmd >= 0x80) && (cmd < 0xf0))
+		if ((mask & (1 << (cmd & 0x0f))) == 0)
+			return 1;
+
+	return 0;
+}
+
+void line6_midibuf_destroy(struct MidiBuffer *this)
+{
+	kfree(this->buf);
+	this->buf = NULL;
+}
diff --git a/sound/usb/line6/midibuf.h b/sound/usb/line6/midibuf.h
new file mode 100644
index 0000000..444cb3a
--- /dev/null
+++ b/sound/usb/line6/midibuf.h
@@ -0,0 +1,38 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef MIDIBUF_H
+#define MIDIBUF_H
+
+struct MidiBuffer {
+	unsigned char *buf;
+	int size;
+	int split;
+	int pos_read, pos_write;
+	int full;
+	int command_prev;
+};
+
+extern int line6_midibuf_bytes_used(struct MidiBuffer *mb);
+extern int line6_midibuf_bytes_free(struct MidiBuffer *mb);
+extern void line6_midibuf_destroy(struct MidiBuffer *mb);
+extern int line6_midibuf_ignore(struct MidiBuffer *mb, int length);
+extern int line6_midibuf_init(struct MidiBuffer *mb, int size, int split);
+extern int line6_midibuf_read(struct MidiBuffer *mb, unsigned char *data,
+			      int length);
+extern void line6_midibuf_reset(struct MidiBuffer *mb);
+extern int line6_midibuf_skip_message(struct MidiBuffer *mb,
+				      unsigned short mask);
+extern void line6_midibuf_status(struct MidiBuffer *mb);
+extern int line6_midibuf_write(struct MidiBuffer *mb, unsigned char *data,
+			       int length);
+
+#endif
diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
new file mode 100644
index 0000000..7fe44a6
--- /dev/null
+++ b/sound/usb/line6/pcm.c
@@ -0,0 +1,570 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/control.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+
+#include "audio.h"
+#include "capture.h"
+#include "driver.h"
+#include "playback.h"
+#include "pod.h"
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+
+static struct snd_line6_pcm *dev2pcm(struct device *dev)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6 *line6 = usb_get_intfdata(interface);
+	struct snd_line6_pcm *line6pcm = line6->line6pcm;
+	return line6pcm;
+}
+
+/*
+	"read" request on "impulse_volume" special file.
+*/
+static ssize_t pcm_get_impulse_volume(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", dev2pcm(dev)->impulse_volume);
+}
+
+/*
+	"write" request on "impulse_volume" special file.
+*/
+static ssize_t pcm_set_impulse_volume(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct snd_line6_pcm *line6pcm = dev2pcm(dev);
+	int value;
+	int rv;
+
+	rv = kstrtoint(buf, 10, &value);
+	if (rv < 0)
+		return rv;
+
+	line6pcm->impulse_volume = value;
+
+	if (value > 0)
+		line6_pcm_acquire(line6pcm, LINE6_BITS_PCM_IMPULSE);
+	else
+		line6_pcm_release(line6pcm, LINE6_BITS_PCM_IMPULSE);
+
+	return count;
+}
+
+/*
+	"read" request on "impulse_period" special file.
+*/
+static ssize_t pcm_get_impulse_period(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", dev2pcm(dev)->impulse_period);
+}
+
+/*
+	"write" request on "impulse_period" special file.
+*/
+static ssize_t pcm_set_impulse_period(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	dev2pcm(dev)->impulse_period = simple_strtoul(buf, NULL, 10);
+	return count;
+}
+
+static DEVICE_ATTR(impulse_volume, S_IWUSR | S_IRUGO, pcm_get_impulse_volume,
+		   pcm_set_impulse_volume);
+static DEVICE_ATTR(impulse_period, S_IWUSR | S_IRUGO, pcm_get_impulse_period,
+		   pcm_set_impulse_period);
+
+#endif
+
+static bool test_flags(unsigned long flags0, unsigned long flags1,
+		       unsigned long mask)
+{
+	return ((flags0 & mask) == 0) && ((flags1 & mask) != 0);
+}
+
+int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
+{
+	unsigned long flags_old =
+	    __sync_fetch_and_or(&line6pcm->flags, channels);
+	unsigned long flags_new = flags_old | channels;
+	unsigned long flags_final = flags_old;
+	int err = 0;
+
+	line6pcm->prev_fbuf = NULL;
+
+	if (test_flags(flags_old, flags_new, LINE6_BITS_CAPTURE_BUFFER)) {
+		/* We may be invoked multiple times in a row so allocate once only */
+		if (!line6pcm->buffer_in) {
+			line6pcm->buffer_in =
+				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
+					line6pcm->max_packet_size, GFP_KERNEL);
+
+			if (!line6pcm->buffer_in) {
+				dev_err(line6pcm->line6->ifcdev,
+					"cannot malloc capture buffer\n");
+				err = -ENOMEM;
+				goto pcm_acquire_error;
+			}
+
+			flags_final |= channels & LINE6_BITS_CAPTURE_BUFFER;
+		}
+	}
+
+	if (test_flags(flags_old, flags_new, LINE6_BITS_CAPTURE_STREAM)) {
+		/*
+		   Waiting for completion of active URBs in the stop handler is
+		   a bug, we therefore report an error if capturing is restarted
+		   too soon.
+		 */
+		if (line6pcm->active_urb_in | line6pcm->unlink_urb_in) {
+			dev_err(line6pcm->line6->ifcdev, "Device not yet ready\n");
+			return -EBUSY;
+		}
+
+		line6pcm->count_in = 0;
+		line6pcm->prev_fsize = 0;
+		err = line6_submit_audio_in_all_urbs(line6pcm);
+
+		if (err < 0)
+			goto pcm_acquire_error;
+
+		flags_final |= channels & LINE6_BITS_CAPTURE_STREAM;
+	}
+
+	if (test_flags(flags_old, flags_new, LINE6_BITS_PLAYBACK_BUFFER)) {
+		/* We may be invoked multiple times in a row so allocate once only */
+		if (!line6pcm->buffer_out) {
+			line6pcm->buffer_out =
+				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
+					line6pcm->max_packet_size, GFP_KERNEL);
+
+			if (!line6pcm->buffer_out) {
+				dev_err(line6pcm->line6->ifcdev,
+					"cannot malloc playback buffer\n");
+				err = -ENOMEM;
+				goto pcm_acquire_error;
+			}
+
+			flags_final |= channels & LINE6_BITS_PLAYBACK_BUFFER;
+		}
+	}
+
+	if (test_flags(flags_old, flags_new, LINE6_BITS_PLAYBACK_STREAM)) {
+		/*
+		  See comment above regarding PCM restart.
+		*/
+		if (line6pcm->active_urb_out | line6pcm->unlink_urb_out) {
+			dev_err(line6pcm->line6->ifcdev, "Device not yet ready\n");
+			return -EBUSY;
+		}
+
+		line6pcm->count_out = 0;
+		err = line6_submit_audio_out_all_urbs(line6pcm);
+
+		if (err < 0)
+			goto pcm_acquire_error;
+
+		flags_final |= channels & LINE6_BITS_PLAYBACK_STREAM;
+	}
+
+	return 0;
+
+pcm_acquire_error:
+	/*
+	   If not all requested resources/streams could be obtained, release
+	   those which were successfully obtained (if any).
+	*/
+	line6_pcm_release(line6pcm, flags_final & channels);
+	return err;
+}
+
+int line6_pcm_release(struct snd_line6_pcm *line6pcm, int channels)
+{
+	unsigned long flags_old =
+	    __sync_fetch_and_and(&line6pcm->flags, ~channels);
+	unsigned long flags_new = flags_old & ~channels;
+
+	if (test_flags(flags_new, flags_old, LINE6_BITS_CAPTURE_STREAM))
+		line6_unlink_audio_in_urbs(line6pcm);
+
+	if (test_flags(flags_new, flags_old, LINE6_BITS_CAPTURE_BUFFER)) {
+		line6_wait_clear_audio_in_urbs(line6pcm);
+		line6_free_capture_buffer(line6pcm);
+	}
+
+	if (test_flags(flags_new, flags_old, LINE6_BITS_PLAYBACK_STREAM))
+		line6_unlink_audio_out_urbs(line6pcm);
+
+	if (test_flags(flags_new, flags_old, LINE6_BITS_PLAYBACK_BUFFER)) {
+		line6_wait_clear_audio_out_urbs(line6pcm);
+		line6_free_playback_buffer(line6pcm);
+	}
+
+	return 0;
+}
+
+/* trigger callback */
+int snd_line6_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+	struct snd_pcm_substream *s;
+	int err;
+	unsigned long flags;
+
+	spin_lock_irqsave(&line6pcm->lock_trigger, flags);
+	clear_bit(LINE6_INDEX_PREPARED, &line6pcm->flags);
+
+	snd_pcm_group_for_each_entry(s, substream) {
+		switch (s->stream) {
+		case SNDRV_PCM_STREAM_PLAYBACK:
+			err = snd_line6_playback_trigger(line6pcm, cmd);
+
+			if (err < 0) {
+				spin_unlock_irqrestore(&line6pcm->lock_trigger,
+						       flags);
+				return err;
+			}
+
+			break;
+
+		case SNDRV_PCM_STREAM_CAPTURE:
+			err = snd_line6_capture_trigger(line6pcm, cmd);
+
+			if (err < 0) {
+				spin_unlock_irqrestore(&line6pcm->lock_trigger,
+						       flags);
+				return err;
+			}
+
+			break;
+
+		default:
+			dev_err(line6pcm->line6->ifcdev,
+				"Unknown stream direction %d\n", s->stream);
+		}
+	}
+
+	spin_unlock_irqrestore(&line6pcm->lock_trigger, flags);
+	return 0;
+}
+
+/* control info callback */
+static int snd_line6_control_playback_info(struct snd_kcontrol *kcontrol,
+					   struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = 2;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = 256;
+	return 0;
+}
+
+/* control get callback */
+static int snd_line6_control_playback_get(struct snd_kcontrol *kcontrol,
+					  struct snd_ctl_elem_value *ucontrol)
+{
+	int i;
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+
+	for (i = 2; i--;)
+		ucontrol->value.integer.value[i] = line6pcm->volume_playback[i];
+
+	return 0;
+}
+
+/* control put callback */
+static int snd_line6_control_playback_put(struct snd_kcontrol *kcontrol,
+					  struct snd_ctl_elem_value *ucontrol)
+{
+	int i, changed = 0;
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+
+	for (i = 2; i--;)
+		if (line6pcm->volume_playback[i] !=
+		    ucontrol->value.integer.value[i]) {
+			line6pcm->volume_playback[i] =
+			    ucontrol->value.integer.value[i];
+			changed = 1;
+		}
+
+	return changed;
+}
+
+/* control definition */
+static struct snd_kcontrol_new line6_control_playback = {
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "PCM Playback Volume",
+	.index = 0,
+	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info = snd_line6_control_playback_info,
+	.get = snd_line6_control_playback_get,
+	.put = snd_line6_control_playback_put
+};
+
+/*
+	Cleanup the PCM device.
+*/
+static void line6_cleanup_pcm(struct snd_pcm *pcm)
+{
+	int i;
+	struct snd_line6_pcm *line6pcm = snd_pcm_chip(pcm);
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	device_remove_file(line6pcm->line6->ifcdev, &dev_attr_impulse_volume);
+	device_remove_file(line6pcm->line6->ifcdev, &dev_attr_impulse_period);
+#endif
+
+	for (i = LINE6_ISO_BUFFERS; i--;) {
+		if (line6pcm->urb_audio_out[i]) {
+			usb_kill_urb(line6pcm->urb_audio_out[i]);
+			usb_free_urb(line6pcm->urb_audio_out[i]);
+		}
+		if (line6pcm->urb_audio_in[i]) {
+			usb_kill_urb(line6pcm->urb_audio_in[i]);
+			usb_free_urb(line6pcm->urb_audio_in[i]);
+		}
+	}
+}
+
+/* create a PCM device */
+static int snd_line6_new_pcm(struct snd_line6_pcm *line6pcm)
+{
+	struct snd_pcm *pcm;
+	int err;
+
+	err = snd_pcm_new(line6pcm->line6->card,
+			  (char *)line6pcm->line6->properties->name,
+			  0, 1, 1, &pcm);
+	if (err < 0)
+		return err;
+
+	pcm->private_data = line6pcm;
+	pcm->private_free = line6_cleanup_pcm;
+	line6pcm->pcm = pcm;
+	strcpy(pcm->name, line6pcm->line6->properties->name);
+
+	/* set operators */
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
+			&snd_line6_playback_ops);
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_line6_capture_ops);
+
+	/* pre-allocation of buffers */
+	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_CONTINUOUS,
+					      snd_dma_continuous_data
+					      (GFP_KERNEL), 64 * 1024,
+					      128 * 1024);
+
+	return 0;
+}
+
+/* PCM device destructor */
+static int snd_line6_pcm_free(struct snd_device *device)
+{
+	return 0;
+}
+
+/*
+	Stop substream if still running.
+*/
+static void pcm_disconnect_substream(struct snd_pcm_substream *substream)
+{
+	if (substream->runtime && snd_pcm_running(substream))
+		snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
+}
+
+/*
+	Stop PCM stream.
+*/
+void line6_pcm_disconnect(struct snd_line6_pcm *line6pcm)
+{
+	pcm_disconnect_substream(get_substream
+				 (line6pcm, SNDRV_PCM_STREAM_CAPTURE));
+	pcm_disconnect_substream(get_substream
+				 (line6pcm, SNDRV_PCM_STREAM_PLAYBACK));
+	line6_unlink_wait_clear_audio_out_urbs(line6pcm);
+	line6_unlink_wait_clear_audio_in_urbs(line6pcm);
+}
+
+/*
+	Create and register the PCM device and mixer entries.
+	Create URBs for playback and capture.
+*/
+int line6_init_pcm(struct usb_line6 *line6,
+		   struct line6_pcm_properties *properties)
+{
+	static struct snd_device_ops pcm_ops = {
+		.dev_free = snd_line6_pcm_free,
+	};
+
+	int err;
+	int ep_read = 0, ep_write = 0;
+	struct snd_line6_pcm *line6pcm;
+
+	if (!(line6->properties->capabilities & LINE6_BIT_PCM))
+		return 0;	/* skip PCM initialization and report success */
+
+	/* initialize PCM subsystem based on product id: */
+	switch (line6->product) {
+	case LINE6_DEVID_BASSPODXT:
+	case LINE6_DEVID_BASSPODXTLIVE:
+	case LINE6_DEVID_BASSPODXTPRO:
+	case LINE6_DEVID_PODXT:
+	case LINE6_DEVID_PODXTLIVE:
+	case LINE6_DEVID_PODXTPRO:
+	case LINE6_DEVID_PODHD300:
+		ep_read = 0x82;
+		ep_write = 0x01;
+		break;
+
+	case LINE6_DEVID_PODHD500:
+	case LINE6_DEVID_PODX3:
+	case LINE6_DEVID_PODX3LIVE:
+		ep_read = 0x86;
+		ep_write = 0x02;
+		break;
+
+	case LINE6_DEVID_POCKETPOD:
+		ep_read = 0x82;
+		ep_write = 0x02;
+		break;
+
+	case LINE6_DEVID_GUITARPORT:
+	case LINE6_DEVID_PODSTUDIO_GX:
+	case LINE6_DEVID_PODSTUDIO_UX1:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+	case LINE6_DEVID_TONEPORT_GX:
+	case LINE6_DEVID_TONEPORT_UX1:
+	case LINE6_DEVID_TONEPORT_UX2:
+		ep_read = 0x82;
+		ep_write = 0x01;
+		break;
+
+		/* this is for interface_number == 1:
+		   case LINE6_DEVID_TONEPORT_UX2:
+		   case LINE6_DEVID_PODSTUDIO_UX2:
+		   ep_read  = 0x87;
+		   ep_write = 0x00;
+		   break;
+		 */
+
+	default:
+		MISSING_CASE;
+	}
+
+	line6pcm = kzalloc(sizeof(struct snd_line6_pcm), GFP_KERNEL);
+
+	if (line6pcm == NULL)
+		return -ENOMEM;
+
+	line6pcm->volume_playback[0] = line6pcm->volume_playback[1] = 255;
+	line6pcm->volume_monitor = 255;
+	line6pcm->line6 = line6;
+	line6pcm->ep_audio_read = ep_read;
+	line6pcm->ep_audio_write = ep_write;
+
+	/* Read and write buffers are sized identically, so choose minimum */
+	line6pcm->max_packet_size = min(
+			usb_maxpacket(line6->usbdev,
+				usb_rcvisocpipe(line6->usbdev, ep_read), 0),
+			usb_maxpacket(line6->usbdev,
+				usb_sndisocpipe(line6->usbdev, ep_write), 1));
+
+	line6pcm->properties = properties;
+	line6->line6pcm = line6pcm;
+
+	/* PCM device: */
+	err = snd_device_new(line6->card, SNDRV_DEV_PCM, line6, &pcm_ops);
+	if (err < 0)
+		return err;
+
+	snd_card_set_dev(line6->card, line6->ifcdev);
+
+	err = snd_line6_new_pcm(line6pcm);
+	if (err < 0)
+		return err;
+
+	spin_lock_init(&line6pcm->lock_audio_out);
+	spin_lock_init(&line6pcm->lock_audio_in);
+	spin_lock_init(&line6pcm->lock_trigger);
+
+	err = line6_create_audio_out_urbs(line6pcm);
+	if (err < 0)
+		return err;
+
+	err = line6_create_audio_in_urbs(line6pcm);
+	if (err < 0)
+		return err;
+
+	/* mixer: */
+	err =
+	    snd_ctl_add(line6->card,
+			snd_ctl_new1(&line6_control_playback, line6pcm));
+	if (err < 0)
+		return err;
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	/* impulse response test: */
+	err = device_create_file(line6->ifcdev, &dev_attr_impulse_volume);
+	if (err < 0)
+		return err;
+
+	err = device_create_file(line6->ifcdev, &dev_attr_impulse_period);
+	if (err < 0)
+		return err;
+
+	line6pcm->impulse_period = LINE6_IMPULSE_DEFAULT_PERIOD;
+#endif
+
+	return 0;
+}
+
+/* prepare pcm callback */
+int snd_line6_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
+	switch (substream->stream) {
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		if ((line6pcm->flags & LINE6_BITS_PLAYBACK_STREAM) == 0)
+			line6_unlink_wait_clear_audio_out_urbs(line6pcm);
+
+		break;
+
+	case SNDRV_PCM_STREAM_CAPTURE:
+		if ((line6pcm->flags & LINE6_BITS_CAPTURE_STREAM) == 0)
+			line6_unlink_wait_clear_audio_in_urbs(line6pcm);
+
+		break;
+
+	default:
+		MISSING_CASE;
+	}
+
+	if (!test_and_set_bit(LINE6_INDEX_PREPARED, &line6pcm->flags)) {
+		line6pcm->count_out = 0;
+		line6pcm->pos_out = 0;
+		line6pcm->pos_out_done = 0;
+		line6pcm->bytes_out = 0;
+		line6pcm->count_in = 0;
+		line6pcm->pos_in_done = 0;
+		line6pcm->bytes_in = 0;
+	}
+
+	return 0;
+}
diff --git a/sound/usb/line6/pcm.h b/sound/usb/line6/pcm.h
new file mode 100644
index 0000000..5210ec8
--- /dev/null
+++ b/sound/usb/line6/pcm.h
@@ -0,0 +1,382 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+/*
+	PCM interface to POD series devices.
+*/
+
+#ifndef PCM_H
+#define PCM_H
+
+#include <sound/pcm.h>
+
+#include "driver.h"
+#include "usbdefs.h"
+
+/* number of URBs */
+#define LINE6_ISO_BUFFERS	2
+
+/*
+	number of USB frames per URB
+	The Line6 Windows driver always transmits two frames per packet, but
+	the Linux driver performs significantly better (i.e., lower latency)
+	with only one frame per packet.
+*/
+#define LINE6_ISO_PACKETS	1
+
+/* in a "full speed" device (such as the PODxt Pro) this means 1ms */
+#define LINE6_ISO_INTERVAL	1
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+#define LINE6_IMPULSE_DEFAULT_PERIOD 100
+#endif
+
+/*
+	Get substream from Line6 PCM data structure
+*/
+#define get_substream(line6pcm, stream)	\
+		(line6pcm->pcm->streams[stream].substream)
+
+/*
+	PCM mode bits.
+
+	There are several features of the Line6 USB driver which require PCM
+	data to be exchanged with the device:
+	*) PCM playback and capture via ALSA
+	*) software monitoring (for devices without hardware monitoring)
+	*) optional impulse response measurement
+	However, from the device's point of view, there is just a single
+	capture and playback stream, which must be shared between these
+	subsystems. It is therefore necessary to maintain the state of the
+	subsystems with respect to PCM usage. We define several constants of
+	the form LINE6_BIT_PCM_<subsystem>_<direction>_<resource> with the
+	following meanings:
+	*) <subsystem> is one of
+	-) ALSA: PCM playback and capture via ALSA
+	-) MONITOR: software monitoring
+	-) IMPULSE: optional impulse response measurement
+	*) <direction> is one of
+	-) PLAYBACK: audio output (from host to device)
+	-) CAPTURE: audio input (from device to host)
+	*) <resource> is one of
+	-) BUFFER: buffer required by PCM data stream
+	-) STREAM: actual PCM data stream
+
+	The subsystems call line6_pcm_acquire() to acquire the (shared)
+	resources needed for a particular operation (e.g., allocate the buffer
+	for ALSA playback or start the capture stream for software monitoring).
+	When a resource is no longer needed, it is released by calling
+	line6_pcm_release(). Buffer allocation and stream startup are handled
+	separately to allow the ALSA kernel driver to perform them at
+	appropriate places (since the callback which starts a PCM stream is not
+	allowed to sleep).
+*/
+enum {
+	/* individual bit indices: */
+	LINE6_INDEX_PCM_ALSA_PLAYBACK_BUFFER,
+	LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM,
+	LINE6_INDEX_PCM_ALSA_CAPTURE_BUFFER,
+	LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM,
+	LINE6_INDEX_PCM_MONITOR_PLAYBACK_BUFFER,
+	LINE6_INDEX_PCM_MONITOR_PLAYBACK_STREAM,
+	LINE6_INDEX_PCM_MONITOR_CAPTURE_BUFFER,
+	LINE6_INDEX_PCM_MONITOR_CAPTURE_STREAM,
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	LINE6_INDEX_PCM_IMPULSE_PLAYBACK_BUFFER,
+	LINE6_INDEX_PCM_IMPULSE_PLAYBACK_STREAM,
+	LINE6_INDEX_PCM_IMPULSE_CAPTURE_BUFFER,
+	LINE6_INDEX_PCM_IMPULSE_CAPTURE_STREAM,
+#endif
+	LINE6_INDEX_PAUSE_PLAYBACK,
+	LINE6_INDEX_PREPARED,
+
+	/* individual bit masks: */
+	LINE6_BIT(PCM_ALSA_PLAYBACK_BUFFER),
+	LINE6_BIT(PCM_ALSA_PLAYBACK_STREAM),
+	LINE6_BIT(PCM_ALSA_CAPTURE_BUFFER),
+	LINE6_BIT(PCM_ALSA_CAPTURE_STREAM),
+	LINE6_BIT(PCM_MONITOR_PLAYBACK_BUFFER),
+	LINE6_BIT(PCM_MONITOR_PLAYBACK_STREAM),
+	LINE6_BIT(PCM_MONITOR_CAPTURE_BUFFER),
+	LINE6_BIT(PCM_MONITOR_CAPTURE_STREAM),
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	LINE6_BIT(PCM_IMPULSE_PLAYBACK_BUFFER),
+	LINE6_BIT(PCM_IMPULSE_PLAYBACK_STREAM),
+	LINE6_BIT(PCM_IMPULSE_CAPTURE_BUFFER),
+	LINE6_BIT(PCM_IMPULSE_CAPTURE_STREAM),
+#endif
+	LINE6_BIT(PAUSE_PLAYBACK),
+	LINE6_BIT(PREPARED),
+
+	/* combined bit masks (by operation): */
+	LINE6_BITS_PCM_ALSA_BUFFER =
+	    LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER |
+	    LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER,
+
+	LINE6_BITS_PCM_ALSA_STREAM =
+	    LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM |
+	    LINE6_BIT_PCM_ALSA_CAPTURE_STREAM,
+
+	LINE6_BITS_PCM_MONITOR =
+	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER |
+	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM |
+	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER |
+	    LINE6_BIT_PCM_MONITOR_CAPTURE_STREAM,
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	LINE6_BITS_PCM_IMPULSE =
+	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_BUFFER |
+	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_STREAM |
+	    LINE6_BIT_PCM_IMPULSE_CAPTURE_BUFFER |
+	    LINE6_BIT_PCM_IMPULSE_CAPTURE_STREAM,
+#endif
+
+	/* combined bit masks (by direction): */
+	LINE6_BITS_PLAYBACK_BUFFER =
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_BUFFER |
+#endif
+	    LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER |
+	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER ,
+
+	LINE6_BITS_PLAYBACK_STREAM =
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_STREAM |
+#endif
+	    LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM |
+	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM ,
+
+	LINE6_BITS_CAPTURE_BUFFER =
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	    LINE6_BIT_PCM_IMPULSE_CAPTURE_BUFFER |
+#endif
+	    LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER |
+	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER ,
+
+	LINE6_BITS_CAPTURE_STREAM =
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	    LINE6_BIT_PCM_IMPULSE_CAPTURE_STREAM |
+#endif
+	    LINE6_BIT_PCM_ALSA_CAPTURE_STREAM |
+	    LINE6_BIT_PCM_MONITOR_CAPTURE_STREAM,
+	
+	LINE6_BITS_STREAM =
+	    LINE6_BITS_PLAYBACK_STREAM |
+	    LINE6_BITS_CAPTURE_STREAM
+};
+
+struct line6_pcm_properties {
+	struct snd_pcm_hardware snd_line6_playback_hw, snd_line6_capture_hw;
+	struct snd_pcm_hw_constraint_ratdens snd_line6_rates;
+	int bytes_per_frame;
+};
+
+struct snd_line6_pcm {
+	/**
+		 Pointer back to the Line6 driver data structure.
+	*/
+	struct usb_line6 *line6;
+
+	/**
+		 Properties.
+	*/
+	struct line6_pcm_properties *properties;
+
+	/**
+		 ALSA pcm stream
+	*/
+	struct snd_pcm *pcm;
+
+	/**
+		 URBs for audio playback.
+	*/
+	struct urb *urb_audio_out[LINE6_ISO_BUFFERS];
+
+	/**
+		 URBs for audio capture.
+	*/
+	struct urb *urb_audio_in[LINE6_ISO_BUFFERS];
+
+	/**
+		 Temporary buffer for playback.
+		 Since the packet size is not known in advance, this buffer is
+		 large enough to store maximum size packets.
+	*/
+	unsigned char *buffer_out;
+
+	/**
+		 Temporary buffer for capture.
+		 Since the packet size is not known in advance, this buffer is
+		 large enough to store maximum size packets.
+	*/
+	unsigned char *buffer_in;
+
+	/**
+		 Previously captured frame (for software monitoring).
+	*/
+	unsigned char *prev_fbuf;
+
+	/**
+		 Size of previously captured frame (for software monitoring).
+	*/
+	int prev_fsize;
+
+	/**
+		 Free frame position in the playback buffer.
+	*/
+	snd_pcm_uframes_t pos_out;
+
+	/**
+		 Count processed bytes for playback.
+		 This is modulo period size (to determine when a period is
+		 finished).
+	*/
+	unsigned bytes_out;
+
+	/**
+		 Counter to create desired playback sample rate.
+	*/
+	unsigned count_out;
+
+	/**
+		 Playback period size in bytes
+	*/
+	unsigned period_out;
+
+	/**
+		 Processed frame position in the playback buffer.
+		 The contents of the output ring buffer have been consumed by
+		 the USB subsystem (i.e., sent to the USB device) up to this
+		 position.
+	*/
+	snd_pcm_uframes_t pos_out_done;
+
+	/**
+		 Count processed bytes for capture.
+		 This is modulo period size (to determine when a period is
+		 finished).
+	*/
+	unsigned bytes_in;
+
+	/**
+		 Counter to create desired capture sample rate.
+	*/
+	unsigned count_in;
+
+	/**
+		 Capture period size in bytes
+	*/
+	unsigned period_in;
+
+	/**
+		 Processed frame position in the capture buffer.
+		 The contents of the output ring buffer have been consumed by
+		 the USB subsystem (i.e., sent to the USB device) up to this
+		 position.
+	*/
+	snd_pcm_uframes_t pos_in_done;
+
+	/**
+		 Bit mask of active playback URBs.
+	*/
+	unsigned long active_urb_out;
+
+	/**
+		 Maximum size of USB packet.
+	*/
+	int max_packet_size;
+
+	/**
+		 USB endpoint for listening to audio data.
+	*/
+	int ep_audio_read;
+
+	/**
+		 USB endpoint for writing audio data.
+	*/
+	int ep_audio_write;
+
+	/**
+		 Bit mask of active capture URBs.
+	*/
+	unsigned long active_urb_in;
+
+	/**
+		 Bit mask of playback URBs currently being unlinked.
+	*/
+	unsigned long unlink_urb_out;
+
+	/**
+		 Bit mask of capture URBs currently being unlinked.
+	*/
+	unsigned long unlink_urb_in;
+
+	/**
+		 Spin lock to protect updates of the playback buffer positions (not
+		 contents!)
+	*/
+	spinlock_t lock_audio_out;
+
+	/**
+		 Spin lock to protect updates of the capture buffer positions (not
+		 contents!)
+	*/
+	spinlock_t lock_audio_in;
+
+	/**
+		 Spin lock to protect trigger.
+	*/
+	spinlock_t lock_trigger;
+
+	/**
+		 PCM playback volume (left and right).
+	*/
+	int volume_playback[2];
+
+	/**
+		 PCM monitor volume.
+	*/
+	int volume_monitor;
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+	/**
+		 Volume of impulse response test signal (if zero, test is disabled).
+	*/
+	int impulse_volume;
+
+	/**
+		 Period of impulse response test signal.
+	*/
+	int impulse_period;
+
+	/**
+		 Counter for impulse response test signal.
+	*/
+	int impulse_count;
+#endif
+
+	/**
+		 Several status bits (see LINE6_BIT_*).
+	*/
+	unsigned long flags;
+
+	int last_frame_in, last_frame_out;
+};
+
+extern int line6_init_pcm(struct usb_line6 *line6,
+			  struct line6_pcm_properties *properties);
+extern int snd_line6_trigger(struct snd_pcm_substream *substream, int cmd);
+extern int snd_line6_prepare(struct snd_pcm_substream *substream);
+extern void line6_pcm_disconnect(struct snd_line6_pcm *line6pcm);
+extern int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels);
+extern int line6_pcm_release(struct snd_line6_pcm *line6pcm, int channels);
+
+#endif
diff --git a/sound/usb/line6/playback.c b/sound/usb/line6/playback.c
new file mode 100644
index 0000000..a0ab9d0
--- /dev/null
+++ b/sound/usb/line6/playback.c
@@ -0,0 +1,586 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+
+#include "audio.h"
+#include "capture.h"
+#include "driver.h"
+#include "pcm.h"
+#include "pod.h"
+#include "playback.h"
+
+/*
+	Software stereo volume control.
+*/
+static void change_volume(struct urb *urb_out, int volume[],
+			  int bytes_per_frame)
+{
+	int chn = 0;
+
+	if (volume[0] == 256 && volume[1] == 256)
+		return;		/* maximum volume - no change */
+
+	if (bytes_per_frame == 4) {
+		short *p, *buf_end;
+		p = (short *)urb_out->transfer_buffer;
+		buf_end = p + urb_out->transfer_buffer_length / sizeof(*p);
+
+		for (; p < buf_end; ++p) {
+			*p = (*p * volume[chn & 1]) >> 8;
+			++chn;
+		}
+	} else if (bytes_per_frame == 6) {
+		unsigned char *p, *buf_end;
+		p = (unsigned char *)urb_out->transfer_buffer;
+		buf_end = p + urb_out->transfer_buffer_length;
+
+		for (; p < buf_end; p += 3) {
+			int val;
+			val = p[0] + (p[1] << 8) + ((signed char)p[2] << 16);
+			val = (val * volume[chn & 1]) >> 8;
+			p[0] = val;
+			p[1] = val >> 8;
+			p[2] = val >> 16;
+			++chn;
+		}
+	}
+}
+
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+
+/*
+	Create signal for impulse response test.
+*/
+static void create_impulse_test_signal(struct snd_line6_pcm *line6pcm,
+				       struct urb *urb_out, int bytes_per_frame)
+{
+	int frames = urb_out->transfer_buffer_length / bytes_per_frame;
+
+	if (bytes_per_frame == 4) {
+		int i;
+		short *pi = (short *)line6pcm->prev_fbuf;
+		short *po = (short *)urb_out->transfer_buffer;
+
+		for (i = 0; i < frames; ++i) {
+			po[0] = pi[0];
+			po[1] = 0;
+			pi += 2;
+			po += 2;
+		}
+	} else if (bytes_per_frame == 6) {
+		int i, j;
+		unsigned char *pi = line6pcm->prev_fbuf;
+		unsigned char *po = urb_out->transfer_buffer;
+
+		for (i = 0; i < frames; ++i) {
+			for (j = 0; j < bytes_per_frame / 2; ++j)
+				po[j] = pi[j];
+
+			for (; j < bytes_per_frame; ++j)
+				po[j] = 0;
+
+			pi += bytes_per_frame;
+			po += bytes_per_frame;
+		}
+	}
+	if (--line6pcm->impulse_count <= 0) {
+		((unsigned char *)(urb_out->transfer_buffer))[bytes_per_frame -
+							      1] =
+		    line6pcm->impulse_volume;
+		line6pcm->impulse_count = line6pcm->impulse_period;
+	}
+}
+
+#endif
+
+/*
+	Add signal to buffer for software monitoring.
+*/
+static void add_monitor_signal(struct urb *urb_out, unsigned char *signal,
+			       int volume, int bytes_per_frame)
+{
+	if (volume == 0)
+		return;		/* zero volume - no change */
+
+	if (bytes_per_frame == 4) {
+		short *pi, *po, *buf_end;
+		pi = (short *)signal;
+		po = (short *)urb_out->transfer_buffer;
+		buf_end = po + urb_out->transfer_buffer_length / sizeof(*po);
+
+		for (; po < buf_end; ++pi, ++po)
+			*po += (*pi * volume) >> 8;
+	}
+
+	/*
+	   We don't need to handle devices with 6 bytes per frame here
+	   since they all support hardware monitoring.
+	 */
+}
+
+/*
+	Find a free URB, prepare audio data, and submit URB.
+*/
+static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
+{
+	int index;
+	unsigned long flags;
+	int i, urb_size, urb_frames;
+	int ret;
+	const int bytes_per_frame = line6pcm->properties->bytes_per_frame;
+	const int frame_increment =
+	    line6pcm->properties->snd_line6_rates.rats[0].num_min;
+	const int frame_factor =
+	    line6pcm->properties->snd_line6_rates.rats[0].den *
+	    (USB_INTERVALS_PER_SECOND / LINE6_ISO_INTERVAL);
+	struct urb *urb_out;
+
+	spin_lock_irqsave(&line6pcm->lock_audio_out, flags);
+	index =
+	    find_first_zero_bit(&line6pcm->active_urb_out, LINE6_ISO_BUFFERS);
+
+	if (index < 0 || index >= LINE6_ISO_BUFFERS) {
+		spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
+		dev_err(line6pcm->line6->ifcdev, "no free URB found\n");
+		return -EINVAL;
+	}
+
+	urb_out = line6pcm->urb_audio_out[index];
+	urb_size = 0;
+
+	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
+		/* compute frame size for given sampling rate */
+		int fsize = 0;
+		struct usb_iso_packet_descriptor *fout =
+		    &urb_out->iso_frame_desc[i];
+
+		if (line6pcm->flags & LINE6_BITS_CAPTURE_STREAM)
+			fsize = line6pcm->prev_fsize;
+
+		if (fsize == 0) {
+			int n;
+			line6pcm->count_out += frame_increment;
+			n = line6pcm->count_out / frame_factor;
+			line6pcm->count_out -= n * frame_factor;
+			fsize = n * bytes_per_frame;
+		}
+
+		fout->offset = urb_size;
+		fout->length = fsize;
+		urb_size += fsize;
+	}
+
+	if (urb_size == 0) {
+		/* can't determine URB size */
+		spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
+		dev_err(line6pcm->line6->ifcdev, "driver bug: urb_size = 0\n");	/* this is somewhat paranoid */
+		return -EINVAL;
+	}
+
+	urb_frames = urb_size / bytes_per_frame;
+	urb_out->transfer_buffer =
+	    line6pcm->buffer_out +
+	    index * LINE6_ISO_PACKETS * line6pcm->max_packet_size;
+	urb_out->transfer_buffer_length = urb_size;
+	urb_out->context = line6pcm;
+
+	if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags) &&
+	    !test_bit(LINE6_INDEX_PAUSE_PLAYBACK, &line6pcm->flags)) {
+		struct snd_pcm_runtime *runtime =
+		    get_substream(line6pcm, SNDRV_PCM_STREAM_PLAYBACK)->runtime;
+
+		if (line6pcm->pos_out + urb_frames > runtime->buffer_size) {
+			/*
+			   The transferred area goes over buffer boundary,
+			   copy the data to the temp buffer.
+			 */
+			int len;
+			len = runtime->buffer_size - line6pcm->pos_out;
+
+			if (len > 0) {
+				memcpy(urb_out->transfer_buffer,
+				       runtime->dma_area +
+				       line6pcm->pos_out * bytes_per_frame,
+				       len * bytes_per_frame);
+				memcpy(urb_out->transfer_buffer +
+				       len * bytes_per_frame, runtime->dma_area,
+				       (urb_frames - len) * bytes_per_frame);
+			} else
+				dev_err(line6pcm->line6->ifcdev, "driver bug: len = %d\n", len);	/* this is somewhat paranoid */
+		} else {
+			memcpy(urb_out->transfer_buffer,
+			       runtime->dma_area +
+			       line6pcm->pos_out * bytes_per_frame,
+			       urb_out->transfer_buffer_length);
+		}
+
+		line6pcm->pos_out += urb_frames;
+		if (line6pcm->pos_out >= runtime->buffer_size)
+			line6pcm->pos_out -= runtime->buffer_size;
+	} else {
+		memset(urb_out->transfer_buffer, 0,
+		       urb_out->transfer_buffer_length);
+	}
+
+	change_volume(urb_out, line6pcm->volume_playback, bytes_per_frame);
+
+	if (line6pcm->prev_fbuf != NULL) {
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+		if (line6pcm->flags & LINE6_BITS_PCM_IMPULSE) {
+			create_impulse_test_signal(line6pcm, urb_out,
+						   bytes_per_frame);
+			if (line6pcm->flags & LINE6_BIT_PCM_ALSA_CAPTURE_STREAM) {
+				line6_capture_copy(line6pcm,
+						   urb_out->transfer_buffer,
+						   urb_out->
+						   transfer_buffer_length);
+				line6_capture_check_period(line6pcm,
+							   urb_out->transfer_buffer_length);
+			}
+		} else {
+#endif
+			if (!
+			    (line6pcm->line6->
+			     properties->capabilities & LINE6_BIT_HWMON)
+			    && (line6pcm->flags & LINE6_BITS_PLAYBACK_STREAM)
+			    && (line6pcm->flags & LINE6_BITS_CAPTURE_STREAM))
+				add_monitor_signal(urb_out, line6pcm->prev_fbuf,
+						   line6pcm->volume_monitor,
+						   bytes_per_frame);
+#ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
+		}
+#endif
+	}
+#ifdef CONFIG_LINE6_USB_DUMP_PCM
+	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
+		struct usb_iso_packet_descriptor *fout =
+		    &urb_out->iso_frame_desc[i];
+		line6_write_hexdump(line6pcm->line6, 'P',
+				    urb_out->transfer_buffer + fout->offset,
+				    fout->length);
+	}
+#endif
+
+	ret = usb_submit_urb(urb_out, GFP_ATOMIC);
+
+	if (ret == 0)
+		set_bit(index, &line6pcm->active_urb_out);
+	else
+		dev_err(line6pcm->line6->ifcdev,
+			"URB out #%d submission failed (%d)\n", index, ret);
+
+	spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
+	return 0;
+}
+
+/*
+	Submit all currently available playback URBs.
+*/
+int line6_submit_audio_out_all_urbs(struct snd_line6_pcm *line6pcm)
+{
+	int ret, i;
+
+	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
+		ret = submit_audio_out_urb(line6pcm);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+	Unlink all currently active playback URBs.
+*/
+void line6_unlink_audio_out_urbs(struct snd_line6_pcm *line6pcm)
+{
+	unsigned int i;
+
+	for (i = LINE6_ISO_BUFFERS; i--;) {
+		if (test_bit(i, &line6pcm->active_urb_out)) {
+			if (!test_and_set_bit(i, &line6pcm->unlink_urb_out)) {
+				struct urb *u = line6pcm->urb_audio_out[i];
+				usb_unlink_urb(u);
+			}
+		}
+	}
+}
+
+/*
+	Wait until unlinking of all currently active playback URBs has been finished.
+*/
+void line6_wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm)
+{
+	int timeout = HZ;
+	unsigned int i;
+	int alive;
+
+	do {
+		alive = 0;
+		for (i = LINE6_ISO_BUFFERS; i--;) {
+			if (test_bit(i, &line6pcm->active_urb_out))
+				alive++;
+		}
+		if (!alive)
+			break;
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(1);
+	} while (--timeout > 0);
+	if (alive)
+		snd_printk(KERN_ERR "timeout: still %d active urbs..\n", alive);
+}
+
+/*
+	Unlink all currently active playback URBs, and wait for finishing.
+*/
+void line6_unlink_wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm)
+{
+	line6_unlink_audio_out_urbs(line6pcm);
+	line6_wait_clear_audio_out_urbs(line6pcm);
+}
+
+void line6_free_playback_buffer(struct snd_line6_pcm *line6pcm)
+{
+	kfree(line6pcm->buffer_out);
+	line6pcm->buffer_out = NULL;
+}
+
+/*
+	Callback for completed playback URB.
+*/
+static void audio_out_callback(struct urb *urb)
+{
+	int i, index, length = 0, shutdown = 0;
+	unsigned long flags;
+
+	struct snd_line6_pcm *line6pcm = (struct snd_line6_pcm *)urb->context;
+	struct snd_pcm_substream *substream =
+	    get_substream(line6pcm, SNDRV_PCM_STREAM_PLAYBACK);
+
+#if USE_CLEAR_BUFFER_WORKAROUND
+	memset(urb->transfer_buffer, 0, urb->transfer_buffer_length);
+#endif
+
+	line6pcm->last_frame_out = urb->start_frame;
+
+	/* find index of URB */
+	for (index = LINE6_ISO_BUFFERS; index--;)
+		if (urb == line6pcm->urb_audio_out[index])
+			break;
+
+	if (index < 0)
+		return;		/* URB has been unlinked asynchronously */
+
+	for (i = LINE6_ISO_PACKETS; i--;)
+		length += urb->iso_frame_desc[i].length;
+
+	spin_lock_irqsave(&line6pcm->lock_audio_out, flags);
+
+	if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags)) {
+		struct snd_pcm_runtime *runtime = substream->runtime;
+		line6pcm->pos_out_done +=
+		    length / line6pcm->properties->bytes_per_frame;
+
+		if (line6pcm->pos_out_done >= runtime->buffer_size)
+			line6pcm->pos_out_done -= runtime->buffer_size;
+	}
+
+	clear_bit(index, &line6pcm->active_urb_out);
+
+	for (i = LINE6_ISO_PACKETS; i--;)
+		if (urb->iso_frame_desc[i].status == -EXDEV) {
+			shutdown = 1;
+			break;
+		}
+
+	if (test_and_clear_bit(index, &line6pcm->unlink_urb_out))
+		shutdown = 1;
+
+	spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
+
+	if (!shutdown) {
+		submit_audio_out_urb(line6pcm);
+
+		if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags)) {
+			line6pcm->bytes_out += length;
+			if (line6pcm->bytes_out >= line6pcm->period_out) {
+				line6pcm->bytes_out %= line6pcm->period_out;
+				snd_pcm_period_elapsed(substream);
+			}
+		}
+	}
+}
+
+/* open playback callback */
+static int snd_line6_playback_open(struct snd_pcm_substream *substream)
+{
+	int err;
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
+	err = snd_pcm_hw_constraint_ratdens(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
+					    (&line6pcm->
+					     properties->snd_line6_rates));
+	if (err < 0)
+		return err;
+
+	runtime->hw = line6pcm->properties->snd_line6_playback_hw;
+	return 0;
+}
+
+/* close playback callback */
+static int snd_line6_playback_close(struct snd_pcm_substream *substream)
+{
+	return 0;
+}
+
+/* hw_params playback callback */
+static int snd_line6_playback_hw_params(struct snd_pcm_substream *substream,
+					struct snd_pcm_hw_params *hw_params)
+{
+	int ret;
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
+	/* -- Florian Demski [FD] */
+	/* don't ask me why, but this fixes the bug on my machine */
+	if (line6pcm == NULL) {
+		if (substream->pcm == NULL)
+			return -ENOMEM;
+		if (substream->pcm->private_data == NULL)
+			return -ENOMEM;
+		substream->private_data = substream->pcm->private_data;
+		line6pcm = snd_pcm_substream_chip(substream);
+	}
+	/* -- [FD] end */
+
+	ret = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER);
+
+	if (ret < 0)
+		return ret;
+
+	ret = snd_pcm_lib_malloc_pages(substream,
+				       params_buffer_bytes(hw_params));
+	if (ret < 0) {
+		line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER);
+		return ret;
+	}
+
+	line6pcm->period_out = params_period_bytes(hw_params);
+	return 0;
+}
+
+/* hw_free playback callback */
+static int snd_line6_playback_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+	line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER);
+	return snd_pcm_lib_free_pages(substream);
+}
+
+/* trigger playback callback */
+int snd_line6_playback_trigger(struct snd_line6_pcm *line6pcm, int cmd)
+{
+	int err;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+#ifdef CONFIG_PM
+	case SNDRV_PCM_TRIGGER_RESUME:
+#endif
+		err = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
+
+		if (err < 0)
+			return err;
+
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+#ifdef CONFIG_PM
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+#endif
+		err = line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
+
+		if (err < 0)
+			return err;
+
+		break;
+
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		set_bit(LINE6_INDEX_PAUSE_PLAYBACK, &line6pcm->flags);
+		break;
+
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		clear_bit(LINE6_INDEX_PAUSE_PLAYBACK, &line6pcm->flags);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* playback pointer callback */
+static snd_pcm_uframes_t
+snd_line6_playback_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+	return line6pcm->pos_out_done;
+}
+
+/* playback operators */
+struct snd_pcm_ops snd_line6_playback_ops = {
+	.open = snd_line6_playback_open,
+	.close = snd_line6_playback_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = snd_line6_playback_hw_params,
+	.hw_free = snd_line6_playback_hw_free,
+	.prepare = snd_line6_prepare,
+	.trigger = snd_line6_trigger,
+	.pointer = snd_line6_playback_pointer,
+};
+
+int line6_create_audio_out_urbs(struct snd_line6_pcm *line6pcm)
+{
+	int i;
+
+	/* create audio URBs and fill in constant values: */
+	for (i = 0; i < LINE6_ISO_BUFFERS; ++i) {
+		struct urb *urb;
+
+		/* URB for audio out: */
+		urb = line6pcm->urb_audio_out[i] =
+		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
+
+		if (urb == NULL) {
+			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
+			return -ENOMEM;
+		}
+
+		urb->dev = line6pcm->line6->usbdev;
+		urb->pipe =
+		    usb_sndisocpipe(line6pcm->line6->usbdev,
+				    line6pcm->ep_audio_write &
+				    USB_ENDPOINT_NUMBER_MASK);
+		urb->transfer_flags = URB_ISO_ASAP;
+		urb->start_frame = -1;
+		urb->number_of_packets = LINE6_ISO_PACKETS;
+		urb->interval = LINE6_ISO_INTERVAL;
+		urb->error_count = 0;
+		urb->complete = audio_out_callback;
+	}
+
+	return 0;
+}
diff --git a/sound/usb/line6/playback.h b/sound/usb/line6/playback.h
new file mode 100644
index 0000000..743bd6f
--- /dev/null
+++ b/sound/usb/line6/playback.h
@@ -0,0 +1,41 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef PLAYBACK_H
+#define PLAYBACK_H
+
+#include <sound/pcm.h>
+
+#include "driver.h"
+
+/*
+ * When the TonePort is used with jack in full duplex mode and the outputs are
+ * not connected, the software monitor produces an ugly noise since everything
+ * written to the output buffer (i.e., the input signal) will be repeated in
+ * the next period (sounds like a delay effect). As a workaround, the output
+ * buffer is cleared after the data have been read, but there must be a better
+ * solution. Until one is found, this workaround can be used to fix the
+ * problem.
+ */
+#define USE_CLEAR_BUFFER_WORKAROUND 1
+
+extern struct snd_pcm_ops snd_line6_playback_ops;
+
+extern int line6_create_audio_out_urbs(struct snd_line6_pcm *line6pcm);
+extern void line6_free_playback_buffer(struct snd_line6_pcm *line6pcm);
+extern int line6_submit_audio_out_all_urbs(struct snd_line6_pcm *line6pcm);
+extern void line6_unlink_audio_out_urbs(struct snd_line6_pcm *line6pcm);
+extern void line6_unlink_wait_clear_audio_out_urbs(struct snd_line6_pcm
+						   *line6pcm);
+extern void line6_wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm);
+extern int snd_line6_playback_trigger(struct snd_line6_pcm *line6pcm, int cmd);
+
+#endif
diff --git a/sound/usb/line6/pod.c b/sound/usb/line6/pod.c
new file mode 100644
index 0000000..9edd053
--- /dev/null
+++ b/sound/usb/line6/pod.c
@@ -0,0 +1,1351 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <sound/control.h>
+
+#include "audio.h"
+#include "capture.h"
+#include "control.h"
+#include "driver.h"
+#include "playback.h"
+#include "pod.h"
+
+#define POD_SYSEX_CODE 3
+#define POD_BYTES_PER_FRAME 6	/* 24bit audio (stereo) */
+
+/* *INDENT-OFF* */
+
+enum {
+	POD_SYSEX_CLIP      = 0x0f,
+	POD_SYSEX_SAVE      = 0x24,
+	POD_SYSEX_SYSTEM    = 0x56,
+	POD_SYSEX_SYSTEMREQ = 0x57,
+	/* POD_SYSEX_UPDATE    = 0x6c, */  /* software update! */
+	POD_SYSEX_STORE     = 0x71,
+	POD_SYSEX_FINISH    = 0x72,
+	POD_SYSEX_DUMPMEM   = 0x73,
+	POD_SYSEX_DUMP      = 0x74,
+	POD_SYSEX_DUMPREQ   = 0x75
+	/* POD_SYSEX_DUMPMEM2  = 0x76 */   /* dumps entire internal memory of PODxt Pro */
+};
+
+enum {
+	POD_monitor_level  = 0x04,
+	POD_routing        = 0x05,
+	POD_tuner_mute     = 0x13,
+	POD_tuner_freq     = 0x15,
+	POD_tuner_note     = 0x16,
+	POD_tuner_pitch    = 0x17,
+	POD_system_invalid = 0x10000
+};
+
+/* *INDENT-ON* */
+
+enum {
+	POD_DUMP_MEMORY = 2
+};
+
+enum {
+	POD_BUSY_READ,
+	POD_BUSY_WRITE,
+	POD_CHANNEL_DIRTY,
+	POD_SAVE_PRESSED,
+	POD_BUSY_MIDISEND
+};
+
+static struct snd_ratden pod_ratden = {
+	.num_min = 78125,
+	.num_max = 78125,
+	.num_step = 1,
+	.den = 2
+};
+
+static struct line6_pcm_properties pod_pcm_properties = {
+	.snd_line6_playback_hw = {
+				  .info = (SNDRV_PCM_INFO_MMAP |
+					   SNDRV_PCM_INFO_INTERLEAVED |
+					   SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					   SNDRV_PCM_INFO_MMAP_VALID |
+					   SNDRV_PCM_INFO_PAUSE |
+#ifdef CONFIG_PM
+					   SNDRV_PCM_INFO_RESUME |
+#endif
+					   SNDRV_PCM_INFO_SYNC_START),
+				  .formats = SNDRV_PCM_FMTBIT_S24_3LE,
+				  .rates = SNDRV_PCM_RATE_KNOT,
+				  .rate_min = 39062,
+				  .rate_max = 39063,
+				  .channels_min = 2,
+				  .channels_max = 2,
+				  .buffer_bytes_max = 60000,
+				  .period_bytes_min = 64,
+				  .period_bytes_max = 8192,
+				  .periods_min = 1,
+				  .periods_max = 1024},
+	.snd_line6_capture_hw = {
+				 .info = (SNDRV_PCM_INFO_MMAP |
+					  SNDRV_PCM_INFO_INTERLEAVED |
+					  SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					  SNDRV_PCM_INFO_MMAP_VALID |
+#ifdef CONFIG_PM
+					  SNDRV_PCM_INFO_RESUME |
+#endif
+					  SNDRV_PCM_INFO_SYNC_START),
+				 .formats = SNDRV_PCM_FMTBIT_S24_3LE,
+				 .rates = SNDRV_PCM_RATE_KNOT,
+				 .rate_min = 39062,
+				 .rate_max = 39063,
+				 .channels_min = 2,
+				 .channels_max = 2,
+				 .buffer_bytes_max = 60000,
+				 .period_bytes_min = 64,
+				 .period_bytes_max = 8192,
+				 .periods_min = 1,
+				 .periods_max = 1024},
+	.snd_line6_rates = {
+			    .nrats = 1,
+			    .rats = &pod_ratden},
+	.bytes_per_frame = POD_BYTES_PER_FRAME
+};
+
+static const char pod_request_channel[] = {
+	0xf0, 0x00, 0x01, 0x0c, 0x03, 0x75, 0xf7
+};
+
+static const char pod_version_header[] = {
+	0xf2, 0x7e, 0x7f, 0x06, 0x02
+};
+
+/* forward declarations: */
+static void pod_startup2(unsigned long data);
+static void pod_startup3(struct usb_line6_pod *pod);
+static void pod_startup4(struct usb_line6_pod *pod);
+
+/*
+	Mark all parameters as dirty and notify waiting processes.
+*/
+static void pod_mark_batch_all_dirty(struct usb_line6_pod *pod)
+{
+	int i;
+
+	for (i = 0; i < POD_CONTROL_SIZE; i++)
+		set_bit(i, pod->param_dirty);
+}
+
+static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
+				    int size)
+{
+	return line6_alloc_sysex_buffer(&pod->line6, POD_SYSEX_CODE, code,
+					size);
+}
+
+/*
+	Send channel dump data to the PODxt Pro.
+*/
+static void pod_dump(struct usb_line6_pod *pod, const unsigned char *data)
+{
+	int size = 1 + sizeof(pod->prog_data);
+	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_DUMP, size);
+	if (!sysex)
+		return;
+	/* Don't know what this is good for, but PODxt Pro transmits it, so we
+	 * also do... */
+	sysex[SYSEX_DATA_OFS] = 5;
+	memcpy(sysex + SYSEX_DATA_OFS + 1, data, sizeof(pod->prog_data));
+	line6_send_sysex_message(&pod->line6, sysex, size);
+	memcpy(&pod->prog_data, data, sizeof(pod->prog_data));
+	pod_mark_batch_all_dirty(pod);
+	kfree(sysex);
+}
+
+/*
+	Store parameter value in driver memory and mark it as dirty.
+*/
+static void pod_store_parameter(struct usb_line6_pod *pod, int param, int value)
+{
+	pod->prog_data.control[param] = value;
+	set_bit(param, pod->param_dirty);
+	pod->dirty = 1;
+}
+
+/*
+	Handle SAVE button.
+*/
+static void pod_save_button_pressed(struct usb_line6_pod *pod, int type,
+				    int index)
+{
+	pod->dirty = 0;
+	set_bit(POD_SAVE_PRESSED, &pod->atomic_flags);
+}
+
+/*
+	Process a completely received message.
+*/
+void line6_pod_process_message(struct usb_line6_pod *pod)
+{
+	const unsigned char *buf = pod->line6.buffer_message;
+
+	/* filter messages by type */
+	switch (buf[0] & 0xf0) {
+	case LINE6_PARAM_CHANGE:
+	case LINE6_PROGRAM_CHANGE:
+	case LINE6_SYSEX_BEGIN:
+		break;		/* handle these further down */
+
+	default:
+		return;		/* ignore all others */
+	}
+
+	/* process all remaining messages */
+	switch (buf[0]) {
+	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_DEVICE:
+		pod_store_parameter(pod, buf[1], buf[2]);
+		/* intentionally no break here! */
+
+	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
+		if ((buf[1] == POD_amp_model_setup) ||
+		    (buf[1] == POD_effect_setup))
+			/* these also affect other settings */
+			line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
+						 LINE6_DUMP_CURRENT);
+
+		break;
+
+	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
+	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
+		pod->channel_num = buf[1];
+		pod->dirty = 0;
+		set_bit(POD_CHANNEL_DIRTY, &pod->atomic_flags);
+		line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
+					 LINE6_DUMP_CURRENT);
+		break;
+
+	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_DEVICE:
+	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_UNKNOWN:
+		if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) == 0) {
+			switch (buf[5]) {
+			case POD_SYSEX_DUMP:
+				if (pod->line6.message_length ==
+				    sizeof(pod->prog_data) + 7) {
+					switch (pod->dumpreq.in_progress) {
+					case LINE6_DUMP_CURRENT:
+						memcpy(&pod->prog_data, buf + 7,
+						       sizeof(pod->prog_data));
+						pod_mark_batch_all_dirty(pod);
+						break;
+
+					case POD_DUMP_MEMORY:
+						memcpy(&pod->prog_data_buf,
+						       buf + 7,
+						       sizeof
+						       (pod->prog_data_buf));
+						break;
+
+					default:
+						DEBUG_MESSAGES(dev_err
+							       (pod->
+								line6.ifcdev,
+								"unknown dump code %02X\n",
+								pod->
+								dumpreq.in_progress));
+					}
+
+					line6_dump_finished(&pod->dumpreq);
+					pod_startup3(pod);
+				} else
+					DEBUG_MESSAGES(dev_err
+						       (pod->line6.ifcdev,
+							"wrong size of channel dump message (%d instead of %d)\n",
+							pod->
+							line6.message_length,
+							(int)
+							sizeof(pod->prog_data) +
+							7));
+
+				break;
+
+			case POD_SYSEX_SYSTEM:{
+					short value =
+					    ((int)buf[7] << 12) | ((int)buf[8]
+								   << 8) |
+					    ((int)buf[9] << 4) | (int)buf[10];
+
+#define PROCESS_SYSTEM_PARAM(x) \
+					case POD_ ## x: \
+						pod->x.value = value; \
+						wake_up(&pod->x.wait); \
+						break;
+
+					switch (buf[6]) {
+						PROCESS_SYSTEM_PARAM
+						    (monitor_level);
+						PROCESS_SYSTEM_PARAM(routing);
+						PROCESS_SYSTEM_PARAM
+						    (tuner_mute);
+						PROCESS_SYSTEM_PARAM
+						    (tuner_freq);
+						PROCESS_SYSTEM_PARAM
+						    (tuner_note);
+						PROCESS_SYSTEM_PARAM
+						    (tuner_pitch);
+
+#undef PROCESS_SYSTEM_PARAM
+
+					default:
+						DEBUG_MESSAGES(dev_err
+							       (pod->
+								line6.ifcdev,
+								"unknown tuner/system response %02X\n",
+								buf[6]));
+					}
+
+					break;
+				}
+
+			case POD_SYSEX_FINISH:
+				/* do we need to respond to this? */
+				break;
+
+			case POD_SYSEX_SAVE:
+				pod_save_button_pressed(pod, buf[6], buf[7]);
+				break;
+
+			case POD_SYSEX_CLIP:
+				DEBUG_MESSAGES(dev_err
+					       (pod->line6.ifcdev,
+						"audio clipped\n"));
+				pod->clipping.value = 1;
+				wake_up(&pod->clipping.wait);
+				break;
+
+			case POD_SYSEX_STORE:
+				DEBUG_MESSAGES(dev_err
+					       (pod->line6.ifcdev,
+						"message %02X not yet implemented\n",
+						buf[5]));
+				break;
+
+			default:
+				DEBUG_MESSAGES(dev_err
+					       (pod->line6.ifcdev,
+						"unknown sysex message %02X\n",
+						buf[5]));
+			}
+		} else
+		    if (memcmp
+			(buf, pod_version_header,
+			 sizeof(pod_version_header)) == 0) {
+			pod->firmware_version =
+			    buf[13] * 100 + buf[14] * 10 + buf[15];
+			pod->device_id =
+			    ((int)buf[8] << 16) | ((int)buf[9] << 8) | (int)
+			    buf[10];
+			pod_startup4(pod);
+		} else
+			DEBUG_MESSAGES(dev_err
+				       (pod->line6.ifcdev,
+					"unknown sysex header\n"));
+
+		break;
+
+	case LINE6_SYSEX_END:
+		break;
+
+	default:
+		DEBUG_MESSAGES(dev_err
+			       (pod->line6.ifcdev,
+				"POD: unknown message %02X\n", buf[0]));
+	}
+}
+
+/*
+	Detect some cases that require a channel dump after sending a command to the
+	device. Important notes:
+	*) The actual dump request can not be sent here since we are not allowed to
+	wait for the completion of the first message in this context, and sending
+	the dump request before completion of the previous message leaves the POD
+	in an undefined state. The dump request will be sent when the echoed
+	commands are received.
+	*) This method fails if a param change message is "chopped" after the first
+	byte.
+*/
+void line6_pod_midi_postprocess(struct usb_line6_pod *pod, unsigned char *data,
+				int length)
+{
+	int i;
+
+	if (!pod->midi_postprocess)
+		return;
+
+	for (i = 0; i < length; ++i) {
+		if (data[i] == (LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST)) {
+			line6_invalidate_current(&pod->dumpreq);
+			break;
+		} else
+		    if ((data[i] == (LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST))
+			&& (i < length - 1))
+			if ((data[i + 1] == POD_amp_model_setup)
+			    || (data[i + 1] == POD_effect_setup)) {
+				line6_invalidate_current(&pod->dumpreq);
+				break;
+			}
+	}
+}
+
+/*
+	Send channel number (i.e., switch to a different sound).
+*/
+static void pod_send_channel(struct usb_line6_pod *pod, u8 value)
+{
+	line6_invalidate_current(&pod->dumpreq);
+
+	if (line6_send_program(&pod->line6, value) == 0)
+		pod->channel_num = value;
+	else
+		line6_dump_finished(&pod->dumpreq);
+}
+
+/*
+	Transmit PODxt Pro control parameter.
+*/
+void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
+				  u8 value)
+{
+	if (line6_transmit_parameter(&pod->line6, param, value) == 0)
+		pod_store_parameter(pod, param, value);
+
+	if ((param == POD_amp_model_setup) || (param == POD_effect_setup))	/* these also affect other settings */
+		line6_invalidate_current(&pod->dumpreq);
+}
+
+/*
+	Resolve value to memory location.
+*/
+static int pod_resolve(const char *buf, short block0, short block1,
+		       unsigned char *location)
+{
+	u8 value;
+	short block;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	block = (value < 0x40) ? block0 : block1;
+	value &= 0x3f;
+	location[0] = block >> 7;
+	location[1] = value | (block & 0x7f);
+	return 0;
+}
+
+/*
+	Send command to store channel/effects setup/amp setup to PODxt Pro.
+*/
+static ssize_t pod_send_store_command(struct device *dev, const char *buf,
+				      size_t count, short block0, short block1)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	int ret;
+	int size = 3 + sizeof(pod->prog_data_buf);
+	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_STORE, size);
+
+	if (!sysex)
+		return 0;
+
+	sysex[SYSEX_DATA_OFS] = 5;	/* see pod_dump() */
+	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS + 1);
+	if (ret) {
+		kfree(sysex);
+		return ret;
+	}
+
+	memcpy(sysex + SYSEX_DATA_OFS + 3, &pod->prog_data_buf,
+	       sizeof(pod->prog_data_buf));
+
+	line6_send_sysex_message(&pod->line6, sysex, size);
+	kfree(sysex);
+	/* needs some delay here on AMD64 platform */
+	return count;
+}
+
+/*
+	Send command to retrieve channel/effects setup/amp setup to PODxt Pro.
+*/
+static ssize_t pod_send_retrieve_command(struct device *dev, const char *buf,
+					 size_t count, short block0,
+					 short block1)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	int ret;
+	int size = 4;
+	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_DUMPMEM, size);
+
+	if (!sysex)
+		return 0;
+
+	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS);
+	if (ret) {
+		kfree(sysex);
+		return ret;
+	}
+	sysex[SYSEX_DATA_OFS + 2] = 0;
+	sysex[SYSEX_DATA_OFS + 3] = 0;
+	line6_dump_started(&pod->dumpreq, POD_DUMP_MEMORY);
+
+	if (line6_send_sysex_message(&pod->line6, sysex, size) < size)
+		line6_dump_finished(&pod->dumpreq);
+
+	kfree(sysex);
+	/* needs some delay here on AMD64 platform */
+	return count;
+}
+
+/*
+	Generic get name function.
+*/
+static ssize_t get_name_generic(struct usb_line6_pod *pod, const char *str,
+				char *buf)
+{
+	int length = 0;
+	const char *p1;
+	char *p2;
+	char *last_non_space = buf;
+
+	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
+	if (retval < 0)
+		return retval;
+
+	for (p1 = str, p2 = buf; *p1; ++p1, ++p2) {
+		*p2 = *p1;
+		if (*p2 != ' ')
+			last_non_space = p2;
+		if (++length == POD_NAME_LENGTH)
+			break;
+	}
+
+	*(last_non_space + 1) = '\n';
+	return last_non_space - buf + 2;
+}
+
+/*
+	"read" request on "channel" special file.
+*/
+static ssize_t pod_get_channel(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return sprintf(buf, "%d\n", pod->channel_num);
+}
+
+/*
+	"write" request on "channel" special file.
+*/
+static ssize_t pod_set_channel(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	pod_send_channel(pod, value);
+	return count;
+}
+
+/*
+	"read" request on "name" special file.
+*/
+static ssize_t pod_get_name(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return get_name_generic(pod, pod->prog_data.header + POD_NAME_OFFSET,
+				buf);
+}
+
+/*
+	"read" request on "name" special file.
+*/
+static ssize_t pod_get_name_buf(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return get_name_generic(pod,
+				pod->prog_data_buf.header + POD_NAME_OFFSET,
+				buf);
+}
+
+/*
+	"read" request on "dump" special file.
+*/
+static ssize_t pod_get_dump(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
+	if (retval < 0)
+		return retval;
+	memcpy(buf, &pod->prog_data, sizeof(pod->prog_data));
+	return sizeof(pod->prog_data);
+}
+
+/*
+	"write" request on "dump" special file.
+*/
+static ssize_t pod_set_dump(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+
+	if (count != sizeof(pod->prog_data)) {
+		dev_err(pod->line6.ifcdev,
+			"data block must be exactly %d bytes\n",
+			(int)sizeof(pod->prog_data));
+		return -EINVAL;
+	}
+
+	pod_dump(pod, buf);
+	return sizeof(pod->prog_data);
+}
+
+/*
+	Identify system parameters related to the tuner.
+*/
+static bool pod_is_tuner(int code)
+{
+	return
+	    (code == POD_tuner_mute) ||
+	    (code == POD_tuner_freq) ||
+	    (code == POD_tuner_note) || (code == POD_tuner_pitch);
+}
+
+/*
+	Get system parameter (as integer).
+	@param tuner non-zero, if code refers to a tuner parameter
+*/
+static int pod_get_system_param_int(struct usb_line6_pod *pod, int *value,
+				    int code, struct ValueWait *param, int sign)
+{
+	char *sysex;
+	static const int size = 1;
+	int retval = 0;
+
+	if (((pod->prog_data.control[POD_tuner] & 0x40) == 0)
+	    && pod_is_tuner(code))
+		return -ENODEV;
+
+	/* send value request to device: */
+	param->value = POD_system_invalid;
+	sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_SYSTEMREQ, size);
+
+	if (!sysex)
+		return -ENOMEM;
+
+	sysex[SYSEX_DATA_OFS] = code;
+	line6_send_sysex_message(&pod->line6, sysex, size);
+	kfree(sysex);
+
+	/* wait for device to respond: */
+	retval =
+	    wait_event_interruptible(param->wait,
+				     param->value != POD_system_invalid);
+
+	if (retval < 0)
+		return retval;
+
+	*value = sign ? (int)(signed short)param->value : (int)(unsigned short)
+	    param->value;
+
+	if (*value == POD_system_invalid)
+		*value = 0;	/* don't report uninitialized values */
+
+	return 0;
+}
+
+/*
+	Get system parameter (as string).
+	@param tuner non-zero, if code refers to a tuner parameter
+*/
+static ssize_t pod_get_system_param_string(struct usb_line6_pod *pod, char *buf,
+					   int code, struct ValueWait *param,
+					   int sign)
+{
+	int retval, value = 0;
+	retval = pod_get_system_param_int(pod, &value, code, param, sign);
+
+	if (retval < 0)
+		return retval;
+
+	return sprintf(buf, "%d\n", value);
+}
+
+/*
+	Send system parameter (from integer).
+	@param tuner non-zero, if code refers to a tuner parameter
+*/
+static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
+				    int code)
+{
+	char *sysex;
+	static const int size = 5;
+
+	if (((pod->prog_data.control[POD_tuner] & 0x40) == 0)
+	    && pod_is_tuner(code))
+		return -EINVAL;
+
+	/* send value to tuner: */
+	sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_SYSTEM, size);
+	if (!sysex)
+		return -ENOMEM;
+	sysex[SYSEX_DATA_OFS] = code;
+	sysex[SYSEX_DATA_OFS + 1] = (value >> 12) & 0x0f;
+	sysex[SYSEX_DATA_OFS + 2] = (value >> 8) & 0x0f;
+	sysex[SYSEX_DATA_OFS + 3] = (value >> 4) & 0x0f;
+	sysex[SYSEX_DATA_OFS + 4] = (value) & 0x0f;
+	line6_send_sysex_message(&pod->line6, sysex, size);
+	kfree(sysex);
+	return 0;
+}
+
+/*
+	Send system parameter (from string).
+	@param tuner non-zero, if code refers to a tuner parameter
+*/
+static ssize_t pod_set_system_param_string(struct usb_line6_pod *pod,
+					   const char *buf, int count, int code,
+					   unsigned short mask)
+{
+	int retval;
+	unsigned short value = simple_strtoul(buf, NULL, 10) & mask;
+	retval = pod_set_system_param_int(pod, value, code);
+	return (retval < 0) ? retval : count;
+}
+
+/*
+	"read" request on "dump_buf" special file.
+*/
+static ssize_t pod_get_dump_buf(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
+	if (retval < 0)
+		return retval;
+	memcpy(buf, &pod->prog_data_buf, sizeof(pod->prog_data_buf));
+	return sizeof(pod->prog_data_buf);
+}
+
+/*
+	"write" request on "dump_buf" special file.
+*/
+static ssize_t pod_set_dump_buf(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+
+	if (count != sizeof(pod->prog_data)) {
+		dev_err(pod->line6.ifcdev,
+			"data block must be exactly %d bytes\n",
+			(int)sizeof(pod->prog_data));
+		return -EINVAL;
+	}
+
+	memcpy(&pod->prog_data_buf, buf, sizeof(pod->prog_data));
+	return sizeof(pod->prog_data);
+}
+
+/*
+	"write" request on "finish" special file.
+*/
+static ssize_t pod_set_finish(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	int size = 0;
+	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_FINISH, size);
+	if (!sysex)
+		return 0;
+	line6_send_sysex_message(&pod->line6, sysex, size);
+	kfree(sysex);
+	return count;
+}
+
+/*
+	"write" request on "store_channel" special file.
+*/
+static ssize_t pod_set_store_channel(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return pod_send_store_command(dev, buf, count, 0x0000, 0x00c0);
+}
+
+/*
+	"write" request on "store_effects_setup" special file.
+*/
+static ssize_t pod_set_store_effects_setup(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	return pod_send_store_command(dev, buf, count, 0x0080, 0x0080);
+}
+
+/*
+	"write" request on "store_amp_setup" special file.
+*/
+static ssize_t pod_set_store_amp_setup(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	return pod_send_store_command(dev, buf, count, 0x0040, 0x0100);
+}
+
+/*
+	"write" request on "retrieve_channel" special file.
+*/
+static ssize_t pod_set_retrieve_channel(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	return pod_send_retrieve_command(dev, buf, count, 0x0000, 0x00c0);
+}
+
+/*
+	"write" request on "retrieve_effects_setup" special file.
+*/
+static ssize_t pod_set_retrieve_effects_setup(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t count)
+{
+	return pod_send_retrieve_command(dev, buf, count, 0x0080, 0x0080);
+}
+
+/*
+	"write" request on "retrieve_amp_setup" special file.
+*/
+static ssize_t pod_set_retrieve_amp_setup(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	return pod_send_retrieve_command(dev, buf, count, 0x0040, 0x0100);
+}
+
+/*
+	"read" request on "dirty" special file.
+*/
+static ssize_t pod_get_dirty(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	buf[0] = pod->dirty ? '1' : '0';
+	buf[1] = '\n';
+	return 2;
+}
+
+/*
+	"read" request on "midi_postprocess" special file.
+*/
+static ssize_t pod_get_midi_postprocess(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return sprintf(buf, "%d\n", pod->midi_postprocess);
+}
+
+/*
+	"write" request on "midi_postprocess" special file.
+*/
+static ssize_t pod_set_midi_postprocess(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	pod->midi_postprocess = value ? 1 : 0;
+	return count;
+}
+
+/*
+	"read" request on "serial_number" special file.
+*/
+static ssize_t pod_get_serial_number(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return sprintf(buf, "%d\n", pod->serial_number);
+}
+
+/*
+	"read" request on "firmware_version" special file.
+*/
+static ssize_t pod_get_firmware_version(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return sprintf(buf, "%d.%02d\n", pod->firmware_version / 100,
+		       pod->firmware_version % 100);
+}
+
+/*
+	"read" request on "device_id" special file.
+*/
+static ssize_t pod_get_device_id(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return sprintf(buf, "%d\n", pod->device_id);
+}
+
+/*
+	"read" request on "clip" special file.
+*/
+static ssize_t pod_wait_for_clip(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+	return wait_event_interruptible(pod->clipping.wait,
+					pod->clipping.value != 0);
+}
+
+/*
+	POD startup procedure.
+	This is a sequence of functions with special requirements (e.g., must
+	not run immediately after initialization, must not run in interrupt
+	context). After the last one has finished, the device is ready to use.
+*/
+
+static void pod_startup1(struct usb_line6_pod *pod)
+{
+	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_INIT);
+
+	/* delay startup procedure: */
+	line6_start_timer(&pod->startup_timer, POD_STARTUP_DELAY, pod_startup2,
+			  (unsigned long)pod);
+}
+
+static void pod_startup2(unsigned long data)
+{
+	struct usb_line6_pod *pod = (struct usb_line6_pod *)data;
+
+	/* schedule another startup procedure until startup is complete: */
+	if (pod->startup_progress >= POD_STARTUP_LAST)
+		return;
+
+	pod->startup_progress = POD_STARTUP_DUMPREQ;
+	line6_start_timer(&pod->startup_timer, POD_STARTUP_DELAY, pod_startup2,
+			  (unsigned long)pod);
+
+	/* current channel dump: */
+	line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
+				 LINE6_DUMP_CURRENT);
+}
+
+static void pod_startup3(struct usb_line6_pod *pod)
+{
+	struct usb_line6 *line6 = &pod->line6;
+	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_VERSIONREQ);
+
+	/* request firmware version: */
+	line6_version_request_async(line6);
+}
+
+static void pod_startup4(struct usb_line6_pod *pod)
+{
+	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_WORKQUEUE);
+
+	/* schedule work for global work queue: */
+	schedule_work(&pod->startup_work);
+}
+
+static void pod_startup5(struct work_struct *work)
+{
+	struct usb_line6_pod *pod =
+	    container_of(work, struct usb_line6_pod, startup_work);
+	struct usb_line6 *line6 = &pod->line6;
+
+	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_SETUP);
+
+	/* serial number: */
+	line6_read_serial_number(&pod->line6, &pod->serial_number);
+
+	/* ALSA audio interface: */
+	line6_register_audio(line6);
+
+	/* device files: */
+	line6_pod_create_files(pod->firmware_version,
+			       line6->properties->device_bit, line6->ifcdev);
+}
+
+#define POD_GET_SYSTEM_PARAM(code, sign) \
+static ssize_t pod_get_ ## code(struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	struct usb_interface *interface = to_usb_interface(dev); \
+	struct usb_line6_pod *pod = usb_get_intfdata(interface); \
+	return pod_get_system_param_string(pod, buf, POD_ ## code,	\
+					   &pod->code, sign);		\
+}
+
+#define POD_GET_SET_SYSTEM_PARAM(code, mask, sign) \
+POD_GET_SYSTEM_PARAM(code, sign) \
+static ssize_t pod_set_ ## code(struct device *dev, \
+				struct device_attribute *attr, \
+				const char *buf, size_t count) \
+{ \
+	struct usb_interface *interface = to_usb_interface(dev); \
+	struct usb_line6_pod *pod = usb_get_intfdata(interface); \
+	return pod_set_system_param_string(pod, buf, count, POD_ ## code, mask); \
+}
+
+POD_GET_SET_SYSTEM_PARAM(monitor_level, 0xffff, 0);
+POD_GET_SET_SYSTEM_PARAM(routing, 0x0003, 0);
+POD_GET_SET_SYSTEM_PARAM(tuner_mute, 0x0001, 0);
+POD_GET_SET_SYSTEM_PARAM(tuner_freq, 0xffff, 0);
+POD_GET_SYSTEM_PARAM(tuner_note, 1);
+POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
+
+#undef GET_SET_SYSTEM_PARAM
+#undef GET_SYSTEM_PARAM
+
+/* POD special files: */
+static DEVICE_ATTR(channel, S_IWUSR | S_IRUGO, pod_get_channel,
+		   pod_set_channel);
+static DEVICE_ATTR(clip, S_IRUGO, pod_wait_for_clip, line6_nop_write);
+static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
+static DEVICE_ATTR(dirty, S_IRUGO, pod_get_dirty, line6_nop_write);
+static DEVICE_ATTR(dump, S_IWUSR | S_IRUGO, pod_get_dump, pod_set_dump);
+static DEVICE_ATTR(dump_buf, S_IWUSR | S_IRUGO, pod_get_dump_buf,
+		   pod_set_dump_buf);
+static DEVICE_ATTR(finish, S_IWUSR, line6_nop_read, pod_set_finish);
+static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
+		   line6_nop_write);
+static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
+		   pod_get_midi_postprocess, pod_set_midi_postprocess);
+static DEVICE_ATTR(monitor_level, S_IWUSR | S_IRUGO, pod_get_monitor_level,
+		   pod_set_monitor_level);
+static DEVICE_ATTR(name, S_IRUGO, pod_get_name, line6_nop_write);
+static DEVICE_ATTR(name_buf, S_IRUGO, pod_get_name_buf, line6_nop_write);
+static DEVICE_ATTR(retrieve_amp_setup, S_IWUSR, line6_nop_read,
+		   pod_set_retrieve_amp_setup);
+static DEVICE_ATTR(retrieve_channel, S_IWUSR, line6_nop_read,
+		   pod_set_retrieve_channel);
+static DEVICE_ATTR(retrieve_effects_setup, S_IWUSR, line6_nop_read,
+		   pod_set_retrieve_effects_setup);
+static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing,
+		   pod_set_routing);
+static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
+		   line6_nop_write);
+static DEVICE_ATTR(store_amp_setup, S_IWUSR, line6_nop_read,
+		   pod_set_store_amp_setup);
+static DEVICE_ATTR(store_channel, S_IWUSR, line6_nop_read,
+		   pod_set_store_channel);
+static DEVICE_ATTR(store_effects_setup, S_IWUSR, line6_nop_read,
+		   pod_set_store_effects_setup);
+static DEVICE_ATTR(tuner_freq, S_IWUSR | S_IRUGO, pod_get_tuner_freq,
+		   pod_set_tuner_freq);
+static DEVICE_ATTR(tuner_mute, S_IWUSR | S_IRUGO, pod_get_tuner_mute,
+		   pod_set_tuner_mute);
+static DEVICE_ATTR(tuner_note, S_IRUGO, pod_get_tuner_note, line6_nop_write);
+static DEVICE_ATTR(tuner_pitch, S_IRUGO, pod_get_tuner_pitch, line6_nop_write);
+
+#ifdef CONFIG_LINE6_USB_RAW
+static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
+#endif
+
+/* control info callback */
+static int snd_pod_control_monitor_info(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = 1;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = 65535;
+	return 0;
+}
+
+/* control get callback */
+static int snd_pod_control_monitor_get(struct snd_kcontrol *kcontrol,
+				       struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+	struct usb_line6_pod *pod = (struct usb_line6_pod *)line6pcm->line6;
+	ucontrol->value.integer.value[0] = pod->monitor_level.value;
+	return 0;
+}
+
+/* control put callback */
+static int snd_pod_control_monitor_put(struct snd_kcontrol *kcontrol,
+				       struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+	struct usb_line6_pod *pod = (struct usb_line6_pod *)line6pcm->line6;
+
+	if (ucontrol->value.integer.value[0] == pod->monitor_level.value)
+		return 0;
+
+	pod->monitor_level.value = ucontrol->value.integer.value[0];
+	pod_set_system_param_int(pod, ucontrol->value.integer.value[0],
+				 POD_monitor_level);
+	return 1;
+}
+
+/* control definition */
+static struct snd_kcontrol_new pod_control_monitor = {
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "Monitor Playback Volume",
+	.index = 0,
+	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info = snd_pod_control_monitor_info,
+	.get = snd_pod_control_monitor_get,
+	.put = snd_pod_control_monitor_put
+};
+
+/*
+	POD destructor.
+*/
+static void pod_destruct(struct usb_interface *interface)
+{
+	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+
+	if (pod == NULL)
+		return;
+	line6_cleanup_audio(&pod->line6);
+
+	del_timer(&pod->startup_timer);
+	cancel_work_sync(&pod->startup_work);
+
+	/* free dump request data: */
+	line6_dumpreq_destruct(&pod->dumpreq);
+}
+
+/*
+	Create sysfs entries.
+*/
+static int pod_create_files2(struct device *dev)
+{
+	int err;
+
+	CHECK_RETURN(device_create_file(dev, &dev_attr_channel));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_clip));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_dirty));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_dump_buf));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_monitor_level));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_name_buf));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_amp_setup));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_channel));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_effects_setup));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_routing));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_store_amp_setup));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_store_channel));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_store_effects_setup));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_freq));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_mute));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_note));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_pitch));
+
+#ifdef CONFIG_LINE6_USB_RAW
+	CHECK_RETURN(device_create_file(dev, &dev_attr_raw));
+#endif
+
+	return 0;
+}
+
+/*
+	 Try to init POD device.
+*/
+static int pod_try_init(struct usb_interface *interface,
+			struct usb_line6_pod *pod)
+{
+	int err;
+	struct usb_line6 *line6 = &pod->line6;
+
+	init_timer(&pod->startup_timer);
+	INIT_WORK(&pod->startup_work, pod_startup5);
+
+	if ((interface == NULL) || (pod == NULL))
+		return -ENODEV;
+
+	pod->channel_num = 255;
+
+	/* initialize wait queues: */
+	init_waitqueue_head(&pod->monitor_level.wait);
+	init_waitqueue_head(&pod->routing.wait);
+	init_waitqueue_head(&pod->tuner_mute.wait);
+	init_waitqueue_head(&pod->tuner_freq.wait);
+	init_waitqueue_head(&pod->tuner_note.wait);
+	init_waitqueue_head(&pod->tuner_pitch.wait);
+	init_waitqueue_head(&pod->clipping.wait);
+
+	memset(pod->param_dirty, 0xff, sizeof(pod->param_dirty));
+
+	/* initialize USB buffers: */
+	err = line6_dumpreq_init(&pod->dumpreq, pod_request_channel,
+				 sizeof(pod_request_channel));
+	if (err < 0) {
+		dev_err(&interface->dev, "Out of memory\n");
+		return -ENOMEM;
+	}
+
+	/* create sysfs entries: */
+	err = pod_create_files2(&interface->dev);
+	if (err < 0)
+		return err;
+
+	/* initialize audio system: */
+	err = line6_init_audio(line6);
+	if (err < 0)
+		return err;
+
+	/* initialize MIDI subsystem: */
+	err = line6_init_midi(line6);
+	if (err < 0)
+		return err;
+
+	/* initialize PCM subsystem: */
+	err = line6_init_pcm(line6, &pod_pcm_properties);
+	if (err < 0)
+		return err;
+
+	/* register monitor control: */
+	err = snd_ctl_add(line6->card,
+			  snd_ctl_new1(&pod_control_monitor, line6->line6pcm));
+	if (err < 0)
+		return err;
+
+	/*
+	   When the sound card is registered at this point, the PODxt Live
+	   displays "Invalid Code Error 07", so we do it later in the event
+	   handler.
+	 */
+
+	if (pod->line6.properties->capabilities & LINE6_BIT_CONTROL) {
+		pod->monitor_level.value = POD_system_invalid;
+
+		/* initiate startup procedure: */
+		pod_startup1(pod);
+	}
+
+	return 0;
+}
+
+/*
+	 Init POD device (and clean up in case of failure).
+*/
+int line6_pod_init(struct usb_interface *interface, struct usb_line6_pod *pod)
+{
+	int err = pod_try_init(interface, pod);
+
+	if (err < 0)
+		pod_destruct(interface);
+
+	return err;
+}
+
+/*
+	POD device disconnected.
+*/
+void line6_pod_disconnect(struct usb_interface *interface)
+{
+	struct usb_line6_pod *pod;
+
+	if (interface == NULL)
+		return;
+	pod = usb_get_intfdata(interface);
+
+	if (pod != NULL) {
+		struct snd_line6_pcm *line6pcm = pod->line6.line6pcm;
+		struct device *dev = &interface->dev;
+
+		if (line6pcm != NULL)
+			line6_pcm_disconnect(line6pcm);
+
+		if (dev != NULL) {
+			/* remove sysfs entries: */
+			line6_pod_remove_files(pod->firmware_version,
+					       pod->line6.
+					       properties->device_bit, dev);
+
+			device_remove_file(dev, &dev_attr_channel);
+			device_remove_file(dev, &dev_attr_clip);
+			device_remove_file(dev, &dev_attr_device_id);
+			device_remove_file(dev, &dev_attr_dirty);
+			device_remove_file(dev, &dev_attr_dump);
+			device_remove_file(dev, &dev_attr_dump_buf);
+			device_remove_file(dev, &dev_attr_finish);
+			device_remove_file(dev, &dev_attr_firmware_version);
+			device_remove_file(dev, &dev_attr_midi_postprocess);
+			device_remove_file(dev, &dev_attr_monitor_level);
+			device_remove_file(dev, &dev_attr_name);
+			device_remove_file(dev, &dev_attr_name_buf);
+			device_remove_file(dev, &dev_attr_retrieve_amp_setup);
+			device_remove_file(dev, &dev_attr_retrieve_channel);
+			device_remove_file(dev,
+					   &dev_attr_retrieve_effects_setup);
+			device_remove_file(dev, &dev_attr_routing);
+			device_remove_file(dev, &dev_attr_serial_number);
+			device_remove_file(dev, &dev_attr_store_amp_setup);
+			device_remove_file(dev, &dev_attr_store_channel);
+			device_remove_file(dev, &dev_attr_store_effects_setup);
+			device_remove_file(dev, &dev_attr_tuner_freq);
+			device_remove_file(dev, &dev_attr_tuner_mute);
+			device_remove_file(dev, &dev_attr_tuner_note);
+			device_remove_file(dev, &dev_attr_tuner_pitch);
+
+#ifdef CONFIG_LINE6_USB_RAW
+			device_remove_file(dev, &dev_attr_raw);
+#endif
+		}
+	}
+
+	pod_destruct(interface);
+}
diff --git a/sound/usb/line6/pod.h b/sound/usb/line6/pod.h
new file mode 100644
index 0000000..47e0d1a
--- /dev/null
+++ b/sound/usb/line6/pod.h
@@ -0,0 +1,205 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef POD_H
+#define POD_H
+
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/usb.h>
+#include <linux/wait.h>
+
+#include <sound/core.h>
+
+#include "driver.h"
+#include "dumprequest.h"
+
+/*
+	PODxt Live interfaces
+*/
+#define PODXTLIVE_INTERFACE_POD    0
+#define PODXTLIVE_INTERFACE_VARIAX 1
+
+/*
+	Locate name in binary program dump
+*/
+#define	POD_NAME_OFFSET 0
+#define	POD_NAME_LENGTH 16
+
+/*
+	Other constants
+*/
+#define POD_CONTROL_SIZE 0x80
+#define POD_BUFSIZE_DUMPREQ 7
+#define POD_STARTUP_DELAY 1000
+
+/*
+	Stages of POD startup procedure
+*/
+enum {
+	POD_STARTUP_INIT = 1,
+	POD_STARTUP_DUMPREQ,
+	POD_STARTUP_VERSIONREQ,
+	POD_STARTUP_WORKQUEUE,
+	POD_STARTUP_SETUP,
+	POD_STARTUP_LAST = POD_STARTUP_SETUP - 1
+};
+
+/**
+	Data structure for values that need to be requested explicitly.
+	This is the case for system and tuner settings.
+*/
+struct ValueWait {
+	int value;
+	wait_queue_head_t wait;
+};
+
+/**
+	Binary PODxt Pro program dump
+*/
+struct pod_program {
+	/**
+		Header information (including program name).
+	*/
+	unsigned char header[0x20];
+
+	/**
+		Program parameters.
+	*/
+	unsigned char control[POD_CONTROL_SIZE];
+};
+
+struct usb_line6_pod {
+	/**
+		Generic Line6 USB data.
+	*/
+	struct usb_line6 line6;
+
+	/**
+		Dump request structure.
+	*/
+	struct line6_dump_request dumpreq;
+
+	/**
+		Current program number.
+	*/
+	unsigned char channel_num;
+
+	/**
+		Current program settings.
+	*/
+	struct pod_program prog_data;
+
+	/**
+		Buffer for data retrieved from or to be stored on PODxt Pro.
+	*/
+	struct pod_program prog_data_buf;
+
+	/**
+		Tuner mute mode.
+	*/
+	struct ValueWait tuner_mute;
+
+	/**
+		Tuner base frequency (typically 440Hz).
+	*/
+	struct ValueWait tuner_freq;
+
+	/**
+		Note received from tuner.
+	*/
+	struct ValueWait tuner_note;
+
+	/**
+		Pitch value received from tuner.
+	*/
+	struct ValueWait tuner_pitch;
+
+	/**
+		Instrument monitor level.
+	*/
+	struct ValueWait monitor_level;
+
+	/**
+		Audio routing mode.
+		0: send processed guitar
+		1: send clean guitar
+		2: send clean guitar re-amp playback
+		3: send re-amp playback
+	*/
+	struct ValueWait routing;
+
+	/**
+		Wait for audio clipping event.
+	*/
+	struct ValueWait clipping;
+
+	/**
+		Timer for device initializaton.
+	*/
+	struct timer_list startup_timer;
+
+	/**
+		Work handler for device initializaton.
+	*/
+	struct work_struct startup_work;
+
+	/**
+		Current progress in startup procedure.
+	*/
+	int startup_progress;
+
+	/**
+		Dirty flags for access to parameter data.
+	*/
+	unsigned long param_dirty[POD_CONTROL_SIZE / sizeof(unsigned long)];
+
+	/**
+		Some atomic flags.
+	*/
+	unsigned long atomic_flags;
+
+	/**
+		Serial number of device.
+	*/
+	int serial_number;
+
+	/**
+		Firmware version (x 100).
+	*/
+	int firmware_version;
+
+	/**
+		Device ID.
+	*/
+	int device_id;
+
+	/**
+		Flag to indicate modification of current program settings.
+	*/
+	char dirty;
+
+	/**
+		Flag to enable MIDI postprocessing.
+	*/
+	char midi_postprocess;
+};
+
+extern void line6_pod_disconnect(struct usb_interface *interface);
+extern int line6_pod_init(struct usb_interface *interface,
+			  struct usb_line6_pod *pod);
+extern void line6_pod_midi_postprocess(struct usb_line6_pod *pod,
+				       unsigned char *data, int length);
+extern void line6_pod_process_message(struct usb_line6_pod *pod);
+extern void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
+					 u8 value);
+
+#endif
diff --git a/sound/usb/line6/podhd.c b/sound/usb/line6/podhd.c
new file mode 100644
index 0000000..7ef4543
--- /dev/null
+++ b/sound/usb/line6/podhd.c
@@ -0,0 +1,154 @@
+/*
+ * Line6 Pod HD
+ *
+ * Copyright (C) 2011 Stefan Hajnoczi <stefanha@gmail.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+
+#include "audio.h"
+#include "driver.h"
+#include "pcm.h"
+#include "podhd.h"
+
+#define PODHD_BYTES_PER_FRAME 6	/* 24bit audio (stereo) */
+
+static struct snd_ratden podhd_ratden = {
+	.num_min = 48000,
+	.num_max = 48000,
+	.num_step = 1,
+	.den = 1,
+};
+
+static struct line6_pcm_properties podhd_pcm_properties = {
+	.snd_line6_playback_hw = {
+				  .info = (SNDRV_PCM_INFO_MMAP |
+					   SNDRV_PCM_INFO_INTERLEAVED |
+					   SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					   SNDRV_PCM_INFO_MMAP_VALID |
+					   SNDRV_PCM_INFO_PAUSE |
+#ifdef CONFIG_PM
+					   SNDRV_PCM_INFO_RESUME |
+#endif
+					   SNDRV_PCM_INFO_SYNC_START),
+				  .formats = SNDRV_PCM_FMTBIT_S24_3LE,
+				  .rates = SNDRV_PCM_RATE_48000,
+				  .rate_min = 48000,
+				  .rate_max = 48000,
+				  .channels_min = 2,
+				  .channels_max = 2,
+				  .buffer_bytes_max = 60000,
+				  .period_bytes_min = 64,
+				  .period_bytes_max = 8192,
+				  .periods_min = 1,
+				  .periods_max = 1024},
+	.snd_line6_capture_hw = {
+				 .info = (SNDRV_PCM_INFO_MMAP |
+					  SNDRV_PCM_INFO_INTERLEAVED |
+					  SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					  SNDRV_PCM_INFO_MMAP_VALID |
+#ifdef CONFIG_PM
+					  SNDRV_PCM_INFO_RESUME |
+#endif
+					  SNDRV_PCM_INFO_SYNC_START),
+				 .formats = SNDRV_PCM_FMTBIT_S24_3LE,
+				 .rates = SNDRV_PCM_RATE_48000,
+				 .rate_min = 48000,
+				 .rate_max = 48000,
+				 .channels_min = 2,
+				 .channels_max = 2,
+				 .buffer_bytes_max = 60000,
+				 .period_bytes_min = 64,
+				 .period_bytes_max = 8192,
+				 .periods_min = 1,
+				 .periods_max = 1024},
+	.snd_line6_rates = {
+			    .nrats = 1,
+			    .rats = &podhd_ratden},
+	.bytes_per_frame = PODHD_BYTES_PER_FRAME
+};
+
+/*
+	POD HD destructor.
+*/
+static void podhd_destruct(struct usb_interface *interface)
+{
+	struct usb_line6_podhd *podhd = usb_get_intfdata(interface);
+
+	if (podhd == NULL)
+		return;
+	line6_cleanup_audio(&podhd->line6);
+}
+
+/*
+	Try to init POD HD device.
+*/
+static int podhd_try_init(struct usb_interface *interface,
+			  struct usb_line6_podhd *podhd)
+{
+	int err;
+	struct usb_line6 *line6 = &podhd->line6;
+
+	if ((interface == NULL) || (podhd == NULL))
+		return -ENODEV;
+
+	/* initialize audio system: */
+	err = line6_init_audio(line6);
+	if (err < 0)
+		return err;
+
+	/* initialize MIDI subsystem: */
+	err = line6_init_midi(line6);
+	if (err < 0)
+		return err;
+
+	/* initialize PCM subsystem: */
+	err = line6_init_pcm(line6, &podhd_pcm_properties);
+	if (err < 0)
+		return err;
+
+	/* register USB audio system: */
+	err = line6_register_audio(line6);
+	return err;
+}
+
+/*
+	Init POD HD device (and clean up in case of failure).
+*/
+int line6_podhd_init(struct usb_interface *interface,
+		     struct usb_line6_podhd *podhd)
+{
+	int err = podhd_try_init(interface, podhd);
+
+	if (err < 0)
+		podhd_destruct(interface);
+
+	return err;
+}
+
+/*
+	POD HD device disconnected.
+*/
+void line6_podhd_disconnect(struct usb_interface *interface)
+{
+	struct usb_line6_podhd *podhd;
+
+	if (interface == NULL)
+		return;
+	podhd = usb_get_intfdata(interface);
+
+	if (podhd != NULL) {
+		struct snd_line6_pcm *line6pcm = podhd->line6.line6pcm;
+
+		if (line6pcm != NULL)
+			line6_pcm_disconnect(line6pcm);
+	}
+
+	podhd_destruct(interface);
+}
diff --git a/sound/usb/line6/podhd.h b/sound/usb/line6/podhd.h
new file mode 100644
index 0000000..652f740
--- /dev/null
+++ b/sound/usb/line6/podhd.h
@@ -0,0 +1,30 @@
+/*
+ * Line6 Pod HD
+ *
+ * Copyright (C) 2011 Stefan Hajnoczi <stefanha@gmail.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef PODHD_H
+#define PODHD_H
+
+#include <linux/usb.h>
+
+#include "driver.h"
+
+struct usb_line6_podhd {
+	/**
+		Generic Line6 USB data.
+	*/
+	struct usb_line6 line6;
+};
+
+extern void line6_podhd_disconnect(struct usb_interface *interface);
+extern int line6_podhd_init(struct usb_interface *interface,
+			    struct usb_line6_podhd *podhd);
+
+#endif /* PODHD_H */
diff --git a/sound/usb/line6/revision.h b/sound/usb/line6/revision.h
new file mode 100644
index 0000000..b4eee2b
--- /dev/null
+++ b/sound/usb/line6/revision.h
@@ -0,0 +1,4 @@
+#ifndef DRIVER_REVISION
+/* current subversion revision */
+#define DRIVER_REVISION " (904)"
+#endif
diff --git a/sound/usb/line6/toneport.c b/sound/usb/line6/toneport.c
new file mode 100644
index 0000000..31b624b
--- /dev/null
+++ b/sound/usb/line6/toneport.c
@@ -0,0 +1,455 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *                         Emil Myhrman (emil.myhrman@gmail.com)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/wait.h>
+#include <sound/control.h>
+
+#include "audio.h"
+#include "capture.h"
+#include "driver.h"
+#include "playback.h"
+#include "toneport.h"
+
+static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2);
+
+#define TONEPORT_PCM_DELAY 1
+
+static struct snd_ratden toneport_ratden = {
+	.num_min = 44100,
+	.num_max = 44100,
+	.num_step = 1,
+	.den = 1
+};
+
+static struct line6_pcm_properties toneport_pcm_properties = {
+	.snd_line6_playback_hw = {
+				  .info = (SNDRV_PCM_INFO_MMAP |
+					   SNDRV_PCM_INFO_INTERLEAVED |
+					   SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					   SNDRV_PCM_INFO_MMAP_VALID |
+					   SNDRV_PCM_INFO_PAUSE |
+#ifdef CONFIG_PM
+					   SNDRV_PCM_INFO_RESUME |
+#endif
+					   SNDRV_PCM_INFO_SYNC_START),
+				  .formats = SNDRV_PCM_FMTBIT_S16_LE,
+				  .rates = SNDRV_PCM_RATE_KNOT,
+				  .rate_min = 44100,
+				  .rate_max = 44100,
+				  .channels_min = 2,
+				  .channels_max = 2,
+				  .buffer_bytes_max = 60000,
+				  .period_bytes_min = 64,
+				  .period_bytes_max = 8192,
+				  .periods_min = 1,
+				  .periods_max = 1024},
+	.snd_line6_capture_hw = {
+				 .info = (SNDRV_PCM_INFO_MMAP |
+					  SNDRV_PCM_INFO_INTERLEAVED |
+					  SNDRV_PCM_INFO_BLOCK_TRANSFER |
+					  SNDRV_PCM_INFO_MMAP_VALID |
+#ifdef CONFIG_PM
+					  SNDRV_PCM_INFO_RESUME |
+#endif
+					  SNDRV_PCM_INFO_SYNC_START),
+				 .formats = SNDRV_PCM_FMTBIT_S16_LE,
+				 .rates = SNDRV_PCM_RATE_KNOT,
+				 .rate_min = 44100,
+				 .rate_max = 44100,
+				 .channels_min = 2,
+				 .channels_max = 2,
+				 .buffer_bytes_max = 60000,
+				 .period_bytes_min = 64,
+				 .period_bytes_max = 8192,
+				 .periods_min = 1,
+				 .periods_max = 1024},
+	.snd_line6_rates = {
+			    .nrats = 1,
+			    .rats = &toneport_ratden},
+	.bytes_per_frame = 4
+};
+
+/*
+	For the led on Guitarport.
+	Brightness goes from 0x00 to 0x26. Set a value above this to have led
+	blink.
+	(void cmd_0x02(byte red, byte green)
+*/
+static int led_red = 0x00;
+static int led_green = 0x26;
+
+struct ToneportSourceInfo {
+	const char *name;
+	int code;
+};
+
+static const struct ToneportSourceInfo toneport_source_info[] = {
+	{"Microphone", 0x0a01},
+	{"Line", 0x0801},
+	{"Instrument", 0x0b01},
+	{"Inst & Mic", 0x0901}
+};
+
+static bool toneport_has_led(short product)
+{
+	return
+	    (product == LINE6_DEVID_GUITARPORT) ||
+	    (product == LINE6_DEVID_TONEPORT_GX);
+	/* add your device here if you are missing support for the LEDs */
+}
+
+static void toneport_update_led(struct device *dev)
+{
+	struct usb_interface *interface = to_usb_interface(dev);
+	struct usb_line6_toneport *tp = usb_get_intfdata(interface);
+	struct usb_line6 *line6;
+
+	if (!tp)
+		return;
+
+	line6 = &tp->line6;
+	if (line6)
+		toneport_send_cmd(line6->usbdev, (led_red << 8) | 0x0002,
+				  led_green);
+}
+
+static ssize_t toneport_set_led_red(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int retval;
+	long value;
+
+	retval = strict_strtol(buf, 10, &value);
+	if (retval)
+		return retval;
+
+	led_red = value;
+	toneport_update_led(dev);
+	return count;
+}
+
+static ssize_t toneport_set_led_green(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	int retval;
+	long value;
+
+	retval = strict_strtol(buf, 10, &value);
+	if (retval)
+		return retval;
+
+	led_green = value;
+	toneport_update_led(dev);
+	return count;
+}
+
+static DEVICE_ATTR(led_red, S_IWUSR | S_IRUGO, line6_nop_read,
+		   toneport_set_led_red);
+static DEVICE_ATTR(led_green, S_IWUSR | S_IRUGO, line6_nop_read,
+		   toneport_set_led_green);
+
+static int toneport_send_cmd(struct usb_device *usbdev, int cmd1, int cmd2)
+{
+	int ret;
+
+	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
+			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			      cmd1, cmd2, NULL, 0, LINE6_TIMEOUT * HZ);
+
+	if (ret < 0) {
+		dev_err(&usbdev->dev, "send failed (error %d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/* monitor info callback */
+static int snd_toneport_monitor_info(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_info *uinfo)
+{
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = 1;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = 256;
+	return 0;
+}
+
+/* monitor get callback */
+static int snd_toneport_monitor_get(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+	ucontrol->value.integer.value[0] = line6pcm->volume_monitor;
+	return 0;
+}
+
+/* monitor put callback */
+static int snd_toneport_monitor_put(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+
+	if (ucontrol->value.integer.value[0] == line6pcm->volume_monitor)
+		return 0;
+
+	line6pcm->volume_monitor = ucontrol->value.integer.value[0];
+
+	if (line6pcm->volume_monitor > 0)
+		line6_pcm_acquire(line6pcm, LINE6_BITS_PCM_MONITOR);
+	else
+		line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
+
+	return 1;
+}
+
+/* source info callback */
+static int snd_toneport_source_info(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_info *uinfo)
+{
+	const int size = ARRAY_SIZE(toneport_source_info);
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
+	uinfo->count = 1;
+	uinfo->value.enumerated.items = size;
+
+	if (uinfo->value.enumerated.item >= size)
+		uinfo->value.enumerated.item = size - 1;
+
+	strcpy(uinfo->value.enumerated.name,
+	       toneport_source_info[uinfo->value.enumerated.item].name);
+
+	return 0;
+}
+
+/* source get callback */
+static int snd_toneport_source_get(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+	struct usb_line6_toneport *toneport =
+	    (struct usb_line6_toneport *)line6pcm->line6;
+	ucontrol->value.enumerated.item[0] = toneport->source;
+	return 0;
+}
+
+/* source put callback */
+static int snd_toneport_source_put(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+	struct usb_line6_toneport *toneport =
+	    (struct usb_line6_toneport *)line6pcm->line6;
+
+	if (ucontrol->value.enumerated.item[0] == toneport->source)
+		return 0;
+
+	toneport->source = ucontrol->value.enumerated.item[0];
+	toneport_send_cmd(toneport->line6.usbdev,
+			  toneport_source_info[toneport->source].code, 0x0000);
+	return 1;
+}
+
+static void toneport_start_pcm(unsigned long arg)
+{
+	struct usb_line6_toneport *toneport = (struct usb_line6_toneport *)arg;
+	struct usb_line6 *line6 = &toneport->line6;
+	line6_pcm_acquire(line6->line6pcm, LINE6_BITS_PCM_MONITOR);
+}
+
+/* control definition */
+static struct snd_kcontrol_new toneport_control_monitor = {
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "Monitor Playback Volume",
+	.index = 0,
+	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info = snd_toneport_monitor_info,
+	.get = snd_toneport_monitor_get,
+	.put = snd_toneport_monitor_put
+};
+
+/* source selector definition */
+static struct snd_kcontrol_new toneport_control_source = {
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "PCM Capture Source",
+	.index = 0,
+	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info = snd_toneport_source_info,
+	.get = snd_toneport_source_get,
+	.put = snd_toneport_source_put
+};
+
+/*
+	Toneport destructor.
+*/
+static void toneport_destruct(struct usb_interface *interface)
+{
+	struct usb_line6_toneport *toneport = usb_get_intfdata(interface);
+
+	if (toneport == NULL)
+		return;
+	line6_cleanup_audio(&toneport->line6);
+}
+
+/*
+	Setup Toneport device.
+*/
+static void toneport_setup(struct usb_line6_toneport *toneport)
+{
+	int ticks;
+	struct usb_line6 *line6 = &toneport->line6;
+	struct usb_device *usbdev = line6->usbdev;
+
+	/* sync time on device with host: */
+	ticks = (int)get_seconds();
+	line6_write_data(line6, 0x80c6, &ticks, 4);
+
+	/* enable device: */
+	toneport_send_cmd(usbdev, 0x0301, 0x0000);
+
+	/* initialize source select: */
+	switch (usbdev->descriptor.idProduct) {
+	case LINE6_DEVID_TONEPORT_UX1:
+	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_DEVID_PODSTUDIO_UX1:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+		toneport_send_cmd(usbdev,
+				  toneport_source_info[toneport->source].code,
+				  0x0000);
+	}
+
+	if (toneport_has_led(usbdev->descriptor.idProduct))
+		toneport_update_led(&usbdev->dev);
+}
+
+/*
+	 Try to init Toneport device.
+*/
+static int toneport_try_init(struct usb_interface *interface,
+			     struct usb_line6_toneport *toneport)
+{
+	int err;
+	struct usb_line6 *line6 = &toneport->line6;
+	struct usb_device *usbdev = line6->usbdev;
+
+	if ((interface == NULL) || (toneport == NULL))
+		return -ENODEV;
+
+	/* initialize audio system: */
+	err = line6_init_audio(line6);
+	if (err < 0)
+		return err;
+
+	/* initialize PCM subsystem: */
+	err = line6_init_pcm(line6, &toneport_pcm_properties);
+	if (err < 0)
+		return err;
+
+	/* register monitor control: */
+	err = snd_ctl_add(line6->card,
+			  snd_ctl_new1(&toneport_control_monitor,
+				       line6->line6pcm));
+	if (err < 0)
+		return err;
+
+	/* register source select control: */
+	switch (usbdev->descriptor.idProduct) {
+	case LINE6_DEVID_TONEPORT_UX1:
+	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_DEVID_PODSTUDIO_UX1:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+		err =
+		    snd_ctl_add(line6->card,
+				snd_ctl_new1(&toneport_control_source,
+					     line6->line6pcm));
+		if (err < 0)
+			return err;
+	}
+
+	/* register audio system: */
+	err = line6_register_audio(line6);
+	if (err < 0)
+		return err;
+
+	line6_read_serial_number(line6, &toneport->serial_number);
+	line6_read_data(line6, 0x80c2, &toneport->firmware_version, 1);
+
+	if (toneport_has_led(usbdev->descriptor.idProduct)) {
+		CHECK_RETURN(device_create_file
+			     (&interface->dev, &dev_attr_led_red));
+		CHECK_RETURN(device_create_file
+			     (&interface->dev, &dev_attr_led_green));
+	}
+
+	toneport_setup(toneport);
+
+	init_timer(&toneport->timer);
+	toneport->timer.expires = jiffies + TONEPORT_PCM_DELAY * HZ;
+	toneport->timer.function = toneport_start_pcm;
+	toneport->timer.data = (unsigned long)toneport;
+	add_timer(&toneport->timer);
+
+	return 0;
+}
+
+/*
+	 Init Toneport device (and clean up in case of failure).
+*/
+int line6_toneport_init(struct usb_interface *interface,
+			struct usb_line6_toneport *toneport)
+{
+	int err = toneport_try_init(interface, toneport);
+
+	if (err < 0)
+		toneport_destruct(interface);
+
+	return err;
+}
+
+/*
+	Resume Toneport device after reset.
+*/
+void line6_toneport_reset_resume(struct usb_line6_toneport *toneport)
+{
+	toneport_setup(toneport);
+}
+
+/*
+	Toneport device disconnected.
+*/
+void line6_toneport_disconnect(struct usb_interface *interface)
+{
+	struct usb_line6_toneport *toneport;
+
+	if (interface == NULL)
+		return;
+
+	toneport = usb_get_intfdata(interface);
+	del_timer_sync(&toneport->timer);
+
+	if (toneport_has_led(toneport->line6.usbdev->descriptor.idProduct)) {
+		device_remove_file(&interface->dev, &dev_attr_led_red);
+		device_remove_file(&interface->dev, &dev_attr_led_green);
+	}
+
+	if (toneport != NULL) {
+		struct snd_line6_pcm *line6pcm = toneport->line6.line6pcm;
+
+		if (line6pcm != NULL) {
+			line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
+			line6_pcm_disconnect(line6pcm);
+		}
+	}
+
+	toneport_destruct(interface);
+}
diff --git a/sound/usb/line6/toneport.h b/sound/usb/line6/toneport.h
new file mode 100644
index 0000000..8576b72
--- /dev/null
+++ b/sound/usb/line6/toneport.h
@@ -0,0 +1,52 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef TONEPORT_H
+#define TONEPORT_H
+
+#include <linux/usb.h>
+#include <sound/core.h>
+
+#include "driver.h"
+
+struct usb_line6_toneport {
+	/**
+		Generic Line6 USB data.
+	*/
+	struct usb_line6 line6;
+
+	/**
+		Source selector.
+	*/
+	int source;
+
+	/**
+		Serial number of device.
+	*/
+	int serial_number;
+
+	/**
+		Firmware version (x 100).
+	*/
+	int firmware_version;
+
+	/**
+		 Timer for delayed PCM startup.
+	*/
+	struct timer_list timer;
+};
+
+extern void line6_toneport_disconnect(struct usb_interface *interface);
+extern int line6_toneport_init(struct usb_interface *interface,
+			       struct usb_line6_toneport *toneport);
+extern void line6_toneport_reset_resume(struct usb_line6_toneport *toneport);
+
+#endif
diff --git a/sound/usb/line6/usbdefs.h b/sound/usb/line6/usbdefs.h
new file mode 100644
index 0000000..353d59d
--- /dev/null
+++ b/sound/usb/line6/usbdefs.h
@@ -0,0 +1,107 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2005-2008 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef USBDEFS_H
+#define USBDEFS_H
+
+#define LINE6_VENDOR_ID  0x0e41
+
+#define USB_INTERVALS_PER_SECOND 1000
+
+/*
+	Device ids.
+*/
+#define LINE6_DEVID_BASSPODXT     0x4250
+#define LINE6_DEVID_BASSPODXTLIVE 0x4642
+#define LINE6_DEVID_BASSPODXTPRO  0x4252
+#define LINE6_DEVID_GUITARPORT    0x4750
+#define LINE6_DEVID_POCKETPOD     0x5051
+#define LINE6_DEVID_PODHD300      0x5057
+#define LINE6_DEVID_PODHD500      0x414D
+#define LINE6_DEVID_PODSTUDIO_GX  0x4153
+#define LINE6_DEVID_PODSTUDIO_UX1 0x4150
+#define LINE6_DEVID_PODSTUDIO_UX2 0x4151
+#define LINE6_DEVID_PODX3         0x414a
+#define LINE6_DEVID_PODX3LIVE     0x414b
+#define LINE6_DEVID_PODXT         0x5044
+#define LINE6_DEVID_PODXTLIVE     0x4650
+#define LINE6_DEVID_PODXTPRO      0x5050
+#define LINE6_DEVID_TONEPORT_GX   0x4147
+#define LINE6_DEVID_TONEPORT_UX1  0x4141
+#define LINE6_DEVID_TONEPORT_UX2  0x4142
+#define LINE6_DEVID_VARIAX        0x534d
+
+#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
+
+enum {
+	LINE6_INDEX_BASSPODXT,
+	LINE6_INDEX_BASSPODXTLIVE,
+	LINE6_INDEX_BASSPODXTPRO,
+	LINE6_INDEX_GUITARPORT,
+	LINE6_INDEX_POCKETPOD,
+	LINE6_INDEX_PODHD300,
+	LINE6_INDEX_PODHD500,
+	LINE6_INDEX_PODSTUDIO_GX,
+	LINE6_INDEX_PODSTUDIO_UX1,
+	LINE6_INDEX_PODSTUDIO_UX2,
+	LINE6_INDEX_PODX3,
+	LINE6_INDEX_PODX3LIVE,
+	LINE6_INDEX_PODXT,
+	LINE6_INDEX_PODXTLIVE,
+	LINE6_INDEX_PODXTPRO,
+	LINE6_INDEX_TONEPORT_GX,
+	LINE6_INDEX_TONEPORT_UX1,
+	LINE6_INDEX_TONEPORT_UX2,
+	LINE6_INDEX_VARIAX,
+
+	LINE6_BIT(BASSPODXT),
+	LINE6_BIT(BASSPODXTLIVE),
+	LINE6_BIT(BASSPODXTPRO),
+	LINE6_BIT(GUITARPORT),
+	LINE6_BIT(POCKETPOD),
+	LINE6_BIT(PODHD300),
+	LINE6_BIT(PODHD500),
+	LINE6_BIT(PODSTUDIO_GX),
+	LINE6_BIT(PODSTUDIO_UX1),
+	LINE6_BIT(PODSTUDIO_UX2),
+	LINE6_BIT(PODX3),
+	LINE6_BIT(PODX3LIVE),
+	LINE6_BIT(PODXT),
+	LINE6_BIT(PODXTLIVE),
+	LINE6_BIT(PODXTPRO),
+	LINE6_BIT(TONEPORT_GX),
+	LINE6_BIT(TONEPORT_UX1),
+	LINE6_BIT(TONEPORT_UX2),
+	LINE6_BIT(VARIAX),
+
+	LINE6_BITS_PRO = LINE6_BIT_BASSPODXTPRO | LINE6_BIT_PODXTPRO,
+	LINE6_BITS_LIVE = LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_PODXTLIVE | LINE6_BIT_PODX3LIVE,
+	LINE6_BITS_PODXTALL = LINE6_BIT_PODXT | LINE6_BIT_PODXTLIVE | LINE6_BIT_PODXTPRO,
+	LINE6_BITS_PODX3ALL = LINE6_BIT_PODX3 | LINE6_BIT_PODX3LIVE,
+	LINE6_BITS_PODHDALL = LINE6_BIT_PODHD300 | LINE6_BIT_PODHD500,
+	LINE6_BITS_BASSPODXTALL	= LINE6_BIT_BASSPODXT |	LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_BASSPODXTPRO
+};
+
+/* device supports settings parameter via USB */
+#define LINE6_BIT_CONTROL (1 << 0)
+/* device supports PCM input/output via USB */
+#define LINE6_BIT_PCM (1 << 1)
+/* device support hardware monitoring */
+#define LINE6_BIT_HWMON (1 << 2)
+
+#define LINE6_BIT_CONTROL_PCM_HWMON	(LINE6_BIT_CONTROL |	\
+					 LINE6_BIT_PCM |	\
+					 LINE6_BIT_HWMON)
+
+#define LINE6_FALLBACK_INTERVAL 10
+#define LINE6_FALLBACK_MAXPACKETSIZE 16
+
+#endif
diff --git a/sound/usb/line6/variax.c b/sound/usb/line6/variax.c
new file mode 100644
index 0000000..f97416b
--- /dev/null
+++ b/sound/usb/line6/variax.c
@@ -0,0 +1,719 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#include <linux/slab.h>
+
+#include "audio.h"
+#include "control.h"
+#include "driver.h"
+#include "variax.h"
+
+#define VARIAX_SYSEX_CODE 7
+#define VARIAX_SYSEX_PARAM 0x3b
+#define VARIAX_SYSEX_ACTIVATE 0x2a
+#define VARIAX_MODEL_HEADER_LENGTH 7
+#define VARIAX_MODEL_MESSAGE_LENGTH 199
+#define VARIAX_OFFSET_ACTIVATE 7
+
+/*
+	This message is sent by the device during initialization and identifies
+	the connected guitar model.
+*/
+static const char variax_init_model[] = {
+	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x69, 0x02,
+	0x00
+};
+
+/*
+	This message is sent by the device during initialization and identifies
+	the connected guitar version.
+*/
+static const char variax_init_version[] = {
+	0xf0, 0x7e, 0x7f, 0x06, 0x02, 0x00, 0x01, 0x0c,
+	0x07, 0x00, 0x00, 0x00
+};
+
+/*
+	This message is the last one sent by the device during initialization.
+*/
+static const char variax_init_done[] = {
+	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x6b
+};
+
+static const char variax_activate[] = {
+	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x2a, 0x01,
+	0xf7
+};
+
+static const char variax_request_bank[] = {
+	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x6d, 0xf7
+};
+
+static const char variax_request_model1[] = {
+	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x3c, 0x00,
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x03, 0x05, 0x03,
+	0x00, 0x00, 0x00, 0xf7
+};
+
+static const char variax_request_model2[] = {
+	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x3c, 0x00,
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x03, 0x07, 0x03,
+	0x00, 0x00, 0x00, 0xf7
+};
+
+/* forward declarations: */
+static int variax_create_files2(struct device *dev);
+static void variax_startup2(unsigned long data);
+static void variax_startup4(unsigned long data);
+static void variax_startup5(unsigned long data);
+
+/*
+	Decode data transmitted by workbench.
+*/
+static void variax_decode(const unsigned char *raw_data, unsigned char *data,
+			  int raw_size)
+{
+	for (; raw_size > 0; raw_size -= 6) {
+		data[2] = raw_data[0] | (raw_data[1] << 4);
+		data[1] = raw_data[2] | (raw_data[3] << 4);
+		data[0] = raw_data[4] | (raw_data[5] << 4);
+		raw_data += 6;
+		data += 3;
+	}
+}
+
+static void variax_activate_async(struct usb_line6_variax *variax, int a)
+{
+	variax->buffer_activate[VARIAX_OFFSET_ACTIVATE] = a;
+	line6_send_raw_message_async(&variax->line6, variax->buffer_activate,
+				     sizeof(variax_activate));
+}
+
+/*
+	Variax startup procedure.
+	This is a sequence of functions with special requirements (e.g., must
+	not run immediately after initialization, must not run in interrupt
+	context). After the last one has finished, the device is ready to use.
+*/
+
+static void variax_startup1(struct usb_line6_variax *variax)
+{
+	CHECK_STARTUP_PROGRESS(variax->startup_progress, VARIAX_STARTUP_INIT);
+
+	/* delay startup procedure: */
+	line6_start_timer(&variax->startup_timer1, VARIAX_STARTUP_DELAY1,
+			  variax_startup2, (unsigned long)variax);
+}
+
+static void variax_startup2(unsigned long data)
+{
+	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
+	struct usb_line6 *line6 = &variax->line6;
+
+	/* schedule another startup procedure until startup is complete: */
+	if (variax->startup_progress >= VARIAX_STARTUP_LAST)
+		return;
+
+	variax->startup_progress = VARIAX_STARTUP_VERSIONREQ;
+	line6_start_timer(&variax->startup_timer1, VARIAX_STARTUP_DELAY1,
+			  variax_startup2, (unsigned long)variax);
+
+	/* request firmware version: */
+	line6_version_request_async(line6);
+}
+
+static void variax_startup3(struct usb_line6_variax *variax)
+{
+	CHECK_STARTUP_PROGRESS(variax->startup_progress, VARIAX_STARTUP_WAIT);
+
+	/* delay startup procedure: */
+	line6_start_timer(&variax->startup_timer2, VARIAX_STARTUP_DELAY3,
+			  variax_startup4, (unsigned long)variax);
+}
+
+static void variax_startup4(unsigned long data)
+{
+	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
+	CHECK_STARTUP_PROGRESS(variax->startup_progress,
+			       VARIAX_STARTUP_ACTIVATE);
+
+	/* activate device: */
+	variax_activate_async(variax, 1);
+	line6_start_timer(&variax->startup_timer2, VARIAX_STARTUP_DELAY4,
+			  variax_startup5, (unsigned long)variax);
+}
+
+static void variax_startup5(unsigned long data)
+{
+	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
+	CHECK_STARTUP_PROGRESS(variax->startup_progress,
+			       VARIAX_STARTUP_DUMPREQ);
+
+	/* current model dump: */
+	line6_dump_request_async(&variax->dumpreq, &variax->line6, 0,
+				 VARIAX_DUMP_PASS1);
+	/* passes 2 and 3 are performed implicitly before entering variax_startup6 */
+}
+
+static void variax_startup6(struct usb_line6_variax *variax)
+{
+	CHECK_STARTUP_PROGRESS(variax->startup_progress,
+			       VARIAX_STARTUP_WORKQUEUE);
+
+	/* schedule work for global work queue: */
+	schedule_work(&variax->startup_work);
+}
+
+static void variax_startup7(struct work_struct *work)
+{
+	struct usb_line6_variax *variax =
+	    container_of(work, struct usb_line6_variax, startup_work);
+	struct usb_line6 *line6 = &variax->line6;
+
+	CHECK_STARTUP_PROGRESS(variax->startup_progress, VARIAX_STARTUP_SETUP);
+
+	/* ALSA audio interface: */
+	line6_register_audio(&variax->line6);
+
+	/* device files: */
+	line6_variax_create_files(0, 0, line6->ifcdev);
+	variax_create_files2(line6->ifcdev);
+}
+
+/*
+	Process a completely received message.
+*/
+void line6_variax_process_message(struct usb_line6_variax *variax)
+{
+	const unsigned char *buf = variax->line6.buffer_message;
+
+	switch (buf[0]) {
+	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
+		switch (buf[1]) {
+		case VARIAXMIDI_volume:
+			variax->volume = buf[2];
+			break;
+
+		case VARIAXMIDI_tone:
+			variax->tone = buf[2];
+		}
+
+		break;
+
+	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
+	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
+		variax->model = buf[1];
+		line6_dump_request_async(&variax->dumpreq, &variax->line6, 0,
+					 VARIAX_DUMP_PASS1);
+		break;
+
+	case LINE6_RESET:
+		dev_info(variax->line6.ifcdev, "VARIAX reset\n");
+		break;
+
+	case LINE6_SYSEX_BEGIN:
+		if (memcmp(buf + 1, variax_request_model1 + 1,
+			   VARIAX_MODEL_HEADER_LENGTH - 1) == 0) {
+			if (variax->line6.message_length ==
+			    VARIAX_MODEL_MESSAGE_LENGTH) {
+				switch (variax->dumpreq.in_progress) {
+				case VARIAX_DUMP_PASS1:
+					variax_decode(buf +
+						      VARIAX_MODEL_HEADER_LENGTH,
+						      (unsigned char *)
+						      &variax->model_data,
+						      (sizeof
+						       (variax->model_data.
+							name) +
+						       sizeof(variax->
+							      model_data.
+							      control)
+						       / 2) * 2);
+					line6_dump_request_async
+					    (&variax->dumpreq, &variax->line6,
+					     1, VARIAX_DUMP_PASS2);
+					break;
+
+				case VARIAX_DUMP_PASS2:
+					/* model name is transmitted twice, so skip it here: */
+					variax_decode(buf +
+						      VARIAX_MODEL_HEADER_LENGTH,
+						      (unsigned char *)
+						      &variax->
+						      model_data.control +
+						      sizeof(variax->model_data.
+							     control)
+						      / 2,
+						      sizeof(variax->model_data.
+							     control)
+						      / 2 * 2);
+					line6_dump_request_async
+					    (&variax->dumpreq, &variax->line6,
+					     2, VARIAX_DUMP_PASS3);
+				}
+			} else {
+				DEBUG_MESSAGES(dev_err
+					       (variax->line6.ifcdev,
+						"illegal length %d of model data\n",
+						variax->line6.message_length));
+				line6_dump_finished(&variax->dumpreq);
+			}
+		} else if (memcmp(buf + 1, variax_request_bank + 1,
+				  sizeof(variax_request_bank) - 2) == 0) {
+			memcpy(variax->bank,
+			       buf + sizeof(variax_request_bank) - 1,
+			       sizeof(variax->bank));
+			line6_dump_finished(&variax->dumpreq);
+			variax_startup6(variax);
+		} else if (memcmp(buf + 1, variax_init_model + 1,
+				  sizeof(variax_init_model) - 1) == 0) {
+			memcpy(variax->guitar,
+			       buf + sizeof(variax_init_model),
+			       sizeof(variax->guitar));
+		} else if (memcmp(buf + 1, variax_init_version + 1,
+				  sizeof(variax_init_version) - 1) == 0) {
+			variax_startup3(variax);
+		} else if (memcmp(buf + 1, variax_init_done + 1,
+				  sizeof(variax_init_done) - 1) == 0) {
+			/* notify of complete initialization: */
+			variax_startup4((unsigned long)variax);
+		}
+
+		break;
+
+	case LINE6_SYSEX_END:
+		break;
+
+	default:
+		DEBUG_MESSAGES(dev_err
+			       (variax->line6.ifcdev,
+				"Variax: unknown message %02X\n", buf[0]));
+	}
+}
+
+/*
+	"read" request on "volume" special file.
+*/
+static ssize_t variax_get_volume(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	return sprintf(buf, "%d\n", variax->volume);
+}
+
+/*
+	"write" request on "volume" special file.
+*/
+static ssize_t variax_set_volume(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	if (line6_transmit_parameter(&variax->line6, VARIAXMIDI_volume,
+				     value) == 0)
+		variax->volume = value;
+
+	return count;
+}
+
+/*
+	"read" request on "model" special file.
+*/
+static ssize_t variax_get_model(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	return sprintf(buf, "%d\n", variax->model);
+}
+
+/*
+	"write" request on "model" special file.
+*/
+static ssize_t variax_set_model(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	if (line6_send_program(&variax->line6, value) == 0)
+		variax->model = value;
+
+	return count;
+}
+
+/*
+	"read" request on "active" special file.
+*/
+static ssize_t variax_get_active(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	return sprintf(buf, "%d\n",
+		       variax->buffer_activate[VARIAX_OFFSET_ACTIVATE]);
+}
+
+/*
+	"write" request on "active" special file.
+*/
+static ssize_t variax_set_active(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	variax_activate_async(variax, value ? 1 : 0);
+	return count;
+}
+
+/*
+	"read" request on "tone" special file.
+*/
+static ssize_t variax_get_tone(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	return sprintf(buf, "%d\n", variax->tone);
+}
+
+/*
+	"write" request on "tone" special file.
+*/
+static ssize_t variax_set_tone(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	if (line6_transmit_parameter(&variax->line6, VARIAXMIDI_tone,
+				     value) == 0)
+		variax->tone = value;
+
+	return count;
+}
+
+static ssize_t get_string(char *buf, const char *data, int length)
+{
+	int i;
+	memcpy(buf, data, length);
+
+	for (i = length; i--;) {
+		char c = buf[i];
+
+		if ((c != 0) && (c != ' '))
+			break;
+	}
+
+	buf[i + 1] = '\n';
+	return i + 2;
+}
+
+/*
+	"read" request on "name" special file.
+*/
+static ssize_t variax_get_name(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	line6_dump_wait_interruptible(&variax->dumpreq);
+	return get_string(buf, variax->model_data.name,
+			  sizeof(variax->model_data.name));
+}
+
+/*
+	"read" request on "bank" special file.
+*/
+static ssize_t variax_get_bank(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	line6_dump_wait_interruptible(&variax->dumpreq);
+	return get_string(buf, variax->bank, sizeof(variax->bank));
+}
+
+/*
+	"read" request on "dump" special file.
+*/
+static ssize_t variax_get_dump(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	int retval;
+	retval = line6_dump_wait_interruptible(&variax->dumpreq);
+	if (retval < 0)
+		return retval;
+	memcpy(buf, &variax->model_data.control,
+	       sizeof(variax->model_data.control));
+	return sizeof(variax->model_data.control);
+}
+
+/*
+	"read" request on "guitar" special file.
+*/
+static ssize_t variax_get_guitar(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	return sprintf(buf, "%s\n", variax->guitar);
+}
+
+#ifdef CONFIG_LINE6_USB_RAW
+
+static char *variax_alloc_sysex_buffer(struct usb_line6_variax *variax,
+				       int code, int size)
+{
+	return line6_alloc_sysex_buffer(&variax->line6, VARIAX_SYSEX_CODE, code,
+					size);
+}
+
+/*
+	"write" request on "raw" special file.
+*/
+static ssize_t variax_set_raw2(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct usb_line6_variax *variax =
+	    usb_get_intfdata(to_usb_interface(dev));
+	int size;
+	int i;
+	char *sysex;
+
+	count -= count % 3;
+	size = count * 2;
+	sysex = variax_alloc_sysex_buffer(variax, VARIAX_SYSEX_PARAM, size);
+
+	if (!sysex)
+		return 0;
+
+	for (i = 0; i < count; i += 3) {
+		const unsigned char *p1 = buf + i;
+		char *p2 = sysex + SYSEX_DATA_OFS + i * 2;
+		p2[0] = p1[2] & 0x0f;
+		p2[1] = p1[2] >> 4;
+		p2[2] = p1[1] & 0x0f;
+		p2[3] = p1[1] >> 4;
+		p2[4] = p1[0] & 0x0f;
+		p2[5] = p1[0] >> 4;
+	}
+
+	line6_send_sysex_message(&variax->line6, sysex, size);
+	kfree(sysex);
+	return count;
+}
+
+#endif
+
+/* Variax workbench special files: */
+static DEVICE_ATTR(model, S_IWUSR | S_IRUGO, variax_get_model,
+		   variax_set_model);
+static DEVICE_ATTR(volume, S_IWUSR | S_IRUGO, variax_get_volume,
+		   variax_set_volume);
+static DEVICE_ATTR(tone, S_IWUSR | S_IRUGO, variax_get_tone, variax_set_tone);
+static DEVICE_ATTR(name, S_IRUGO, variax_get_name, line6_nop_write);
+static DEVICE_ATTR(bank, S_IRUGO, variax_get_bank, line6_nop_write);
+static DEVICE_ATTR(dump, S_IRUGO, variax_get_dump, line6_nop_write);
+static DEVICE_ATTR(active, S_IWUSR | S_IRUGO, variax_get_active,
+		   variax_set_active);
+static DEVICE_ATTR(guitar, S_IRUGO, variax_get_guitar, line6_nop_write);
+
+#ifdef CONFIG_LINE6_USB_RAW
+static DEVICE_ATTR(raw, S_IWUSR, line6_nop_read, line6_set_raw);
+static DEVICE_ATTR(raw2, S_IWUSR, line6_nop_read, variax_set_raw2);
+#endif
+
+/*
+	Variax destructor.
+*/
+static void variax_destruct(struct usb_interface *interface)
+{
+	struct usb_line6_variax *variax = usb_get_intfdata(interface);
+
+	if (variax == NULL)
+		return;
+	line6_cleanup_audio(&variax->line6);
+
+	del_timer(&variax->startup_timer1);
+	del_timer(&variax->startup_timer2);
+	cancel_work_sync(&variax->startup_work);
+
+	/* free dump request data: */
+	line6_dumpreq_destructbuf(&variax->dumpreq, 2);
+	line6_dumpreq_destructbuf(&variax->dumpreq, 1);
+	line6_dumpreq_destruct(&variax->dumpreq);
+
+	kfree(variax->buffer_activate);
+}
+
+/*
+	Create sysfs entries.
+*/
+static int variax_create_files2(struct device *dev)
+{
+	int err;
+	CHECK_RETURN(device_create_file(dev, &dev_attr_model));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_volume));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_tone));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_bank));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_active));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_guitar));
+#ifdef CONFIG_LINE6_USB_RAW
+	CHECK_RETURN(device_create_file(dev, &dev_attr_raw));
+	CHECK_RETURN(device_create_file(dev, &dev_attr_raw2));
+#endif
+	return 0;
+}
+
+/*
+	 Try to init workbench device.
+*/
+static int variax_try_init(struct usb_interface *interface,
+			   struct usb_line6_variax *variax)
+{
+	int err;
+
+	init_timer(&variax->startup_timer1);
+	init_timer(&variax->startup_timer2);
+	INIT_WORK(&variax->startup_work, variax_startup7);
+
+	if ((interface == NULL) || (variax == NULL))
+		return -ENODEV;
+
+	/* initialize USB buffers: */
+	err = line6_dumpreq_init(&variax->dumpreq, variax_request_model1,
+				 sizeof(variax_request_model1));
+
+	if (err < 0) {
+		dev_err(&interface->dev, "Out of memory\n");
+		return err;
+	}
+
+	err = line6_dumpreq_initbuf(&variax->dumpreq, variax_request_model2,
+				    sizeof(variax_request_model2), 1);
+
+	if (err < 0) {
+		dev_err(&interface->dev, "Out of memory\n");
+		return err;
+	}
+
+	err = line6_dumpreq_initbuf(&variax->dumpreq, variax_request_bank,
+				    sizeof(variax_request_bank), 2);
+
+	if (err < 0) {
+		dev_err(&interface->dev, "Out of memory\n");
+		return err;
+	}
+
+	variax->buffer_activate = kmemdup(variax_activate,
+					  sizeof(variax_activate), GFP_KERNEL);
+
+	if (variax->buffer_activate == NULL) {
+		dev_err(&interface->dev, "Out of memory\n");
+		return -ENOMEM;
+	}
+
+	/* initialize audio system: */
+	err = line6_init_audio(&variax->line6);
+	if (err < 0)
+		return err;
+
+	/* initialize MIDI subsystem: */
+	err = line6_init_midi(&variax->line6);
+	if (err < 0)
+		return err;
+
+	/* initiate startup procedure: */
+	variax_startup1(variax);
+	return 0;
+}
+
+/*
+	 Init workbench device (and clean up in case of failure).
+*/
+int line6_variax_init(struct usb_interface *interface,
+		      struct usb_line6_variax *variax)
+{
+	int err = variax_try_init(interface, variax);
+
+	if (err < 0)
+		variax_destruct(interface);
+
+	return err;
+}
+
+/*
+	Workbench device disconnected.
+*/
+void line6_variax_disconnect(struct usb_interface *interface)
+{
+	struct device *dev;
+
+	if (interface == NULL)
+		return;
+	dev = &interface->dev;
+
+	if (dev != NULL) {
+		/* remove sysfs entries: */
+		line6_variax_remove_files(0, 0, dev);
+		device_remove_file(dev, &dev_attr_model);
+		device_remove_file(dev, &dev_attr_volume);
+		device_remove_file(dev, &dev_attr_tone);
+		device_remove_file(dev, &dev_attr_name);
+		device_remove_file(dev, &dev_attr_bank);
+		device_remove_file(dev, &dev_attr_dump);
+		device_remove_file(dev, &dev_attr_active);
+		device_remove_file(dev, &dev_attr_guitar);
+#ifdef CONFIG_LINE6_USB_RAW
+		device_remove_file(dev, &dev_attr_raw);
+		device_remove_file(dev, &dev_attr_raw2);
+#endif
+	}
+
+	variax_destruct(interface);
+}
diff --git a/sound/usb/line6/variax.h b/sound/usb/line6/variax.h
new file mode 100644
index 0000000..e2999ab
--- /dev/null
+++ b/sound/usb/line6/variax.h
@@ -0,0 +1,132 @@
+/*
+ * Line6 Linux USB driver - 0.9.1beta
+ *
+ * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ *
+ */
+
+#ifndef VARIAX_H
+#define VARIAX_H
+
+#include <linux/spinlock.h>
+#include <linux/usb.h>
+#include <linux/wait.h>
+#include <sound/core.h>
+
+#include "driver.h"
+#include "dumprequest.h"
+
+#define VARIAX_STARTUP_DELAY1 1000
+#define VARIAX_STARTUP_DELAY3 100
+#define VARIAX_STARTUP_DELAY4 100
+
+/*
+	Stages of Variax startup procedure
+*/
+enum {
+	VARIAX_STARTUP_INIT = 1,
+	VARIAX_STARTUP_VERSIONREQ,
+	VARIAX_STARTUP_WAIT,
+	VARIAX_STARTUP_ACTIVATE,
+	VARIAX_STARTUP_DUMPREQ,
+	VARIAX_STARTUP_WORKQUEUE,
+	VARIAX_STARTUP_SETUP,
+	VARIAX_STARTUP_LAST = VARIAX_STARTUP_SETUP - 1
+};
+
+enum {
+	VARIAX_DUMP_PASS1 = LINE6_DUMP_CURRENT,
+	VARIAX_DUMP_PASS2,
+	VARIAX_DUMP_PASS3
+};
+
+/**
+	Binary Variax model dump
+*/
+struct variax_model {
+	/**
+		Header information (including program name).
+	*/
+	unsigned char name[18];
+
+	/**
+		Model parameters.
+	*/
+	unsigned char control[78 * 2];
+};
+
+struct usb_line6_variax {
+	/**
+		Generic Line6 USB data.
+	*/
+	struct usb_line6 line6;
+
+	/**
+		Dump request structure.
+		Append two extra buffers for 3-pass data query.
+	*/
+	struct line6_dump_request dumpreq;
+	struct line6_dump_reqbuf extrabuf[2];
+
+	/**
+		Buffer for activation code.
+	*/
+	unsigned char *buffer_activate;
+
+	/**
+		Model number.
+	*/
+	int model;
+
+	/**
+		Current model settings.
+	*/
+	struct variax_model model_data;
+
+	/**
+		Name of connected guitar.
+	*/
+	unsigned char guitar[18];
+
+	/**
+		Name of current model bank.
+	*/
+	unsigned char bank[18];
+
+	/**
+		Position of volume dial.
+	*/
+	int volume;
+
+	/**
+		Position of tone control dial.
+	*/
+	int tone;
+
+	/**
+		Handler for device initializaton.
+	*/
+	struct work_struct startup_work;
+
+	/**
+		Timers for device initializaton.
+	*/
+	struct timer_list startup_timer1;
+	struct timer_list startup_timer2;
+
+	/**
+		Current progress in startup procedure.
+	*/
+	int startup_progress;
+};
+
+extern void line6_variax_disconnect(struct usb_interface *interface);
+extern int line6_variax_init(struct usb_interface *interface,
+			     struct usb_line6_variax *variax);
+extern void line6_variax_process_message(struct usb_line6_variax *variax);
+
+#endif
-- 
1.7.12.1

