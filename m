Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120Ab1J3Ok6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 10:40:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46260 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934036Ab1J3Ok5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 10:40:57 -0400
From: Stefan Hajnoczi <stefanha@gmail.com>
To: <grabner@icg.tugraz.at>
Cc: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 0/2] staging: line6: add Pod HD300 support
Date: Sun, 30 Oct 2011 14:40:39 +0000
Message-Id: <1319985641-25648-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add Pod HD300 support to the line6usb driver.  The Pod HD family
is the current generation of devices from Line6.  It works along the same lines
as the Pod xt but introduces new MIDI SysEx messages and is not compatible with
Pod xt messages.

These patches make Pod HD300 work out-of-the-box and provide both MIDI and pcm
interfaces.  I have tested playback and capture successfully with Audacity and
native ALSA applications going through PulseAudio.  I have tested MIDI using
amidi(1) to store SysEx dumps sent from the device and to adjust controller
parameters.

Patch 1 sets a saner default for MIDI masks because the default value drops
messages from the Pod HD300, which operates on Channel 1.

Patch 2 adds the Pod HD300 USB IDs and Pod HD functionality based on stripped
down Pod xt code.

If we moved the hardcoded Pod xt MIDI messages into a userspace library then it
would be possible to unify pod.c and podhd.c.  I don't have a Pod xt device to
test against so it's hard for me to make this change without help.

Stefan Hajnoczi (2):
  staging: line6: accept all MIDI channels by default
  staging: line6: add Pod HD300 support

 drivers/staging/line6/Makefile  |    3 +-
 drivers/staging/line6/driver.c  |   24 ++++++-
 drivers/staging/line6/midi.c    |    4 +-
 drivers/staging/line6/pcm.c     |    1 +
 drivers/staging/line6/podhd.c   |  158 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/line6/podhd.h   |   30 ++++++++
 drivers/staging/line6/usbdefs.h |    2 +
 7 files changed, 218 insertions(+), 4 deletions(-)
 create mode 100644 drivers/staging/line6/podhd.c
 create mode 100644 drivers/staging/line6/podhd.h

-- 
1.7.7

