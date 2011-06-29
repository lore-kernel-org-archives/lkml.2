Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1F2FIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:08:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1F2FH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:07:58 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/12] Synaptics image sensor support
Date: Wed, 29 Jun 2011 13:07:10 +0800
Message-Id: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Hello,

This patch set (against next) is intended to add support for synaptics
"image sensor" touchpads.

Patches 1-8 clean up the current driver slightly and prepare for the image
sensor patches which follow.

Patches 9-11 add up to 3 finger support for image sensor touchpads.
Image sensors do not suffer from the finger tracking issues that plagued
the earlier "profile sensors", and which required the invention of "semi-mt"
(which reports a bounding box around two fingers instead of the fingers
themselves).  Instead, the image sensors report the actual positions of two
fingers using the same "Advanced Gesture Mode". Unfortunately, the limitations
of the Synaptics PS/2 protocol make it difficult to keep track of which two
fingers are being reported at any given time.

Patch 12 adds up to 5 finger support.
In fact, the image sensor touchpads actually track 5 fingers while reporting
just 2 finger positions.  This patch tracks which fingers are being reported,
and passes them up to userspace using 5 MT-B slots.

These patches are similar to, and inspired by, a similar patchset recently
submitted by Derek Foreman and Daniel Stone.  However, it is not directly built
upon, nor is it compatible with, those patches.

Thanks,
Daniel

Daniel Kurtz (12):
  Input: synaptics - cleanup 0x0c query documentation
  Input: synaptics - do not invert y if 0
  Input: synaptics - fix minimum reported ABS_TOOL_WIDTH
  Input: synaptics - set resolution for MT_POSITION_X/Y axes
  Input: synaptics - process button bits in AGM packets
  Input: synaptics - fuzz position if touchpad reports reduced
    filtering
  Input: synaptics - rename synaptics_data.mt to agm
  Input: synaptics - rename set_slot to be more descriptive
  Input: synaptics - add image sensor support
  Input: synaptics - decode AGM packet types
  Input: synaptics - process finger (<=3) transitions
  Input: synaptics - process finger (<=5) transitions

 drivers/input/mouse/synaptics.c |  442 +++++++++++++++++++++++++++++++++++----
 drivers/input/mouse/synaptics.h |   41 +++-
 include/linux/input.h           |    1 +
 3 files changed, 440 insertions(+), 44 deletions(-)

-- 
1.7.3.1

