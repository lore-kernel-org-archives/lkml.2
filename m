Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1CEGHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 01:07:55 -0500
Received: from relais.videotron.ca ([24.201.245.36]:23925 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab1CEGHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 01:07:54 -0500
Content-transfer-encoding: 7BIT
From: Nicholas Niro <nik_89@neuroponic.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] sound: Added missing conditionnal for OSS function prototypes
Date: Sat, 05 Mar 2011 01:07:52 -0500
Message-id: <1299305272-15861-1-git-send-email-nik_89@neuroponic.com>
X-Mailer: git-send-email 1.7.4.1.107.g394f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the source file sound/sound_core.c, the function prototypes
register_sound_special, register_sound_special_device et al, are
all prototypes that are only compiled when the flag
CONFIG_SOUND_OSS_CORE is set. But regardless of if
it is set, those prototypes are still all
available in linux/sound.h.

This bug was found when trying to compile standalone alsa.
In order to check for the function register_sound_special_device
availability, it looks for it's prototype in linux/sound.h and of course
it finds it because of the bug (even if it's not, actually, compiled in),
creating unknown symbol errors when loading snd.ko et al.

Signed-off-by: Nicholas Niro <nik_89@neuroponic.com>
Cc: Takashi Iwai <tiwai@suse.de>
---
 include/linux/sound.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/sound.h b/include/linux/sound.h
index 44dcf05..7e49712 100644
--- a/include/linux/sound.h
+++ b/include/linux/sound.h
@@ -30,6 +30,7 @@
  *	Sound core interface functions
  */
  
+#ifdef CONFIG_SOUND_OSS_CORE
 struct device;
 extern int register_sound_special(const struct file_operations *fops, int unit);
 extern int register_sound_special_device(const struct file_operations *fops, int unit, struct device *dev);
@@ -41,4 +42,5 @@ extern void unregister_sound_special(int unit);
 extern void unregister_sound_mixer(int unit);
 extern void unregister_sound_midi(int unit);
 extern void unregister_sound_dsp(int unit);
+#endif /* CONFIG_SOUND_OSS_CORE */
 #endif /* __KERNEL__ */
-- 
1.7.4.1.107.g394f

