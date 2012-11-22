Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2KVTtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:49:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54328 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab2KVTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:44 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 00/46] staging: line6: drop MIDI state sysfs attrs
Date: Thu, 22 Nov 2012 20:48:39 +0100
Message-Id: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's put the line6 staging driver on a diet for Thanksgiving! :)

Markus and I have discussed the MIDI processing that currently happens in the
line6 driver.  This stuff really belongs in userspace where a library or
utility can use ALSA MIDI APIs to control the device.  Moving MIDI processing
to userspace has several benefits:

1. The driver only handles PCM and MIDI I/O.  This means less kernel code.

2. A large number of sysfs attributes can be removed.  These attributes exposed
   MIDI state and driver code was necessary to sync and manage this state.

3. It's easier for userspace to control the device, try out new MIDI commands,
   etc when the driver acts as a dumb transport.

This patch series removes the sysfs attributes and then removes the state
behind those attributes.  I have tried to make small incremental changes that
can be reviewed easily.

Testing would be appreciated and especially necessary for POD XT and Variax
devices where the startup process has been modified.  I only have access to a
POD HD300 device which doesn't take these code paths.

The only MIDI processing left are initialization commands and the monitor
volume level, which remains in the kernel because the driver presents an ALSA
volume control.

Stefan Hajnoczi (46):
  staging: line6: drop channel sysfs attr
  staging: line6: drop clip sysfs attr
  staging: line6: drop unused param_dirty bitmap
  staging: line6: drop dirty sysfs attr
  staging: line6: drop dump sysfs attr
  staging: line6: drop dump_buf sysfs attr
  staging: line6: drop monitor_level sysfs attr
  staging: line6: change monitor_level type ValueWait -> int
  staging: line6: drop name sysfs attr
  staging: line6: drop name_buf sysfs attr
  staging: line6: drop retrieve_amp_setup sysfs attr
  staging: line6: drop retrieve_channel sysfs attr
  staging: line6: drop retrieve_effects_setup sysfs attr
  staging: line6: drop store_amp_setup sysfs attr
  staging: line6: drop store_channel sysfs attr
  staging: line6: drop store_effects_setup sysfs attr
  staging: line6: drop routing sysfs attr
  staging: line6: drop tuner_freq sysfs attr
  staging: line6: drop tuner_note sysfs attr
  staging: line6: drop tuner_mute sysfs attr
  staging: line6: drop tuner_pitch sysfs attr
  staging: line6: drop finish sysfs attr
  staging: line6: drop midi_postprocess sysfs attr
  staging: line6: drop midi_mask_receive
  staging: line6: drop midi_mask_transmit
  staging: line6: drop midi_postprocess flag
  staging: line6: drop pod.c raw sysfs attr
  staging: line6: drop tuner param filtering
  staging: line6: drop variax model sysfs attr
  staging: line6: drop variax volume sysfs attr
  staging: line6: drop variax tone sysfs attr
  staging: line6: drop variax name sysfs attr
  staging: line6: drop variax bank sysfs attr
  staging: line6: drop variax dump sysfs attr
  staging: line6: drop variax active sysfs attr
  staging: line6: drop variax guitar sysfs attr
  staging: line6: drop variax raw sysfs attrs
  staging: line6: drop CONFIG_LINE6_USB_RAW
  staging: line6: drop amp/effects dump request triggers
  staging: line6: drop MIDI parameter sysfs attrs
  staging: line6: drop pod prog_data buffers
  staging: line6: drop unused pod atomic_flags field
  staging: line6: drop variax model_data field
  staging: line6: drop dump requests from variax startup
  staging: line6: drop dump requests from pod startup
  staging: line6: drop unused dumprequest code

 drivers/staging/line6/Kconfig       |  11 -
 drivers/staging/line6/Makefile      |   2 -
 drivers/staging/line6/control.c     | 995 ------------------------------------
 drivers/staging/line6/control.h     | 195 -------
 drivers/staging/line6/driver.c      |  20 -
 drivers/staging/line6/dumprequest.c | 135 -----
 drivers/staging/line6/dumprequest.h |  76 ---
 drivers/staging/line6/midi.c        | 120 -----
 drivers/staging/line6/midi.h        |  10 -
 drivers/staging/line6/pod.c         | 846 +-----------------------------
 drivers/staging/line6/pod.h         | 105 +---
 drivers/staging/line6/variax.c      | 480 +----------------
 drivers/staging/line6/variax.h      |  60 ---
 13 files changed, 16 insertions(+), 3039 deletions(-)
 delete mode 100644 drivers/staging/line6/control.c
 delete mode 100644 drivers/staging/line6/control.h
 delete mode 100644 drivers/staging/line6/dumprequest.c
 delete mode 100644 drivers/staging/line6/dumprequest.h

-- 
1.8.0

