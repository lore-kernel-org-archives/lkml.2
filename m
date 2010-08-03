Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0HCKiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:38:09 -0400
Received: from saarni.dnainternet.net ([83.102.40.136]:50167 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab0HCKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:38:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.36
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ALSA: hda - support HDMI HBR passthrough
Date: Tue,  3 Aug 2010 13:28:56 +0300
Message-Id: <1280831338-4596-1-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

This patchset adds support for passing through IEC 61937 encapsulated
compressed audio at high bitrates (i.e. those over 6.144Mbps).
At least TrueHD and DTS-HD are such formats.

I've tested this using an NVIDIA hdmi codec and the following ffmpeg
patch which adds support for TrueHD in its IEC 61937 muxer:
http://lists.mplayerhq.hu/pipermail/ffmpeg-devel/2010-August/094317.html

One needs to set the AES0 & 0x02 (non-audio) bit during playback so that
the data is not transmitted as normal 8 channel PCM audio.

---
Anssi Hannula (2):
      ALSA: hda - Set Stream Type in Stream Format according to AES0
      ALSA: hda - Add support for HDMI HBR passthrough

 sound/pci/hda/hda_codec.c       |    6 ++++-
 sound/pci/hda/hda_codec.h       |    6 ++++-
 sound/pci/hda/hda_intel.c       |    3 +-
 sound/pci/hda/patch_hdmi.c      |   40 ++++++++++++++++++++++++++++++++++++++-
 sound/pci/hda/patch_intelhdmi.c |    3 +-
 sound/pci/hda/patch_nvhdmi.c    |    3 +-
 6 files changed, 53 insertions(+), 8 deletions(-)

