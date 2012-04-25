Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab2DYBTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:19:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45425 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab2DYBT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:19:29 -0400
Message-ID: <1335316761.4634.5.camel@smoke>
Subject: [PATCH] drivers/ps3: Fix checkpatch warnings in ps3av.c
From: Geoff Levand <geoff@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Valentin Ilie <valentin.ilie@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Apr 2012 18:19:21 -0700
In-Reply-To: <CAMuHMdUQmTzjVfb=fwKJCmov+OuFYDHU-wW4T2kEXigpVxeGPg@mail.gmail.com>
References: <1334661361-3699-1-git-send-email-valentin.ilie@gmail.com>
	 <CAMuHMdUQmTzjVfb=fwKJCmov+OuFYDHU-wW4T2kEXigpVxeGPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Valentin Ilie <valentin.ilie@gmail.com>

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Geoff Levand <geoff@infradead.org>
---

Hi Geert,

Here's what I queued for v3.5, let me know if you have any concerns.

-Geoff

 drivers/ps3/ps3av.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/ps3/ps3av.c b/drivers/ps3/ps3av.c
index a409fa0..93d0a8b 100644
--- a/drivers/ps3/ps3av.c
+++ b/drivers/ps3/ps3av.c
@@ -338,7 +338,7 @@ int ps3av_do_pkt(u32 cid, u16 send_len, size_t usr_buf_size,
 	mutex_unlock(&ps3av->mutex);
 	return 0;
 
-      err:
+err:
 	mutex_unlock(&ps3av->mutex);
 	printk(KERN_ERR "%s: failed cid:%x res:%d\n", __func__, cid, res);
 	return res;
@@ -477,7 +477,6 @@ int ps3av_set_audio_mode(u32 ch, u32 fs, u32 word_bits, u32 format, u32 source)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ps3av_set_audio_mode);
 
 static int ps3av_set_videomode(void)
@@ -501,7 +500,7 @@ static void ps3av_set_videomode_packet(u32 id)
 
 	video_mode = &video_mode_table[id & PS3AV_MODE_MASK];
 
-	avb_param.num_of_video_pkt = PS3AV_AVB_NUM_VIDEO;	/* num of head */
+	avb_param.num_of_video_pkt = PS3AV_AVB_NUM_VIDEO; /* num of head */
 	avb_param.num_of_audio_pkt = 0;
 	avb_param.num_of_av_video_pkt = ps3av->av_hw_conf.num_of_hdmi +
 					ps3av->av_hw_conf.num_of_avmulti;
@@ -521,7 +520,7 @@ static void ps3av_set_videomode_packet(u32 id)
 #ifndef PS3AV_HDMI_YUV
 		if (ps3av->av_port[i] == PS3AV_CMD_AVPORT_HDMI_0 ||
 		    ps3av->av_port[i] == PS3AV_CMD_AVPORT_HDMI_1)
-			av_video_cs = RGB8;	/* use RGB for HDMI */
+			av_video_cs = RGB8; /* use RGB for HDMI */
 #endif
 		len += ps3av_cmd_set_av_video_cs(&avb_param.buf[len],
 						 ps3av->av_port[i],
@@ -590,8 +589,8 @@ static void ps3avd(struct work_struct *work)
 #define SHIFT_VESA	8
 
 static const struct {
-	unsigned mask : 19;
-	unsigned id :  4;
+	unsigned mask:19;
+	unsigned id:4;
 } ps3av_preferred_modes[] = {
 	{ PS3AV_RESBIT_WUXGA      << SHIFT_VESA, PS3AV_MODE_WUXGA   },
 	{ PS3AV_RESBIT_1920x1080P << SHIFT_60,   PS3AV_MODE_1080P60 },
@@ -667,7 +666,8 @@ static enum ps3av_mode_num ps3av_hdmi_get_id(struct ps3av_info_monitor *info)
 	return id;
 }
 
-static void ps3av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *monitor_info)
+static void ps3av_monitor_info_dump(
+	const struct ps3av_pkt_av_get_monitor_info *monitor_info)
 {
 	const struct ps3av_info_monitor *info = &monitor_info->info;
 	const struct ps3av_info_audio *audio = info->audio;
@@ -717,8 +717,8 @@ static void ps3av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *
 
 	/* audio block */
 	for (i = 0; i < info->num_of_audio_block; i++) {
-		pr_debug("audio[%d] type: %02x max_ch: %02x fs: %02x sbit: "
-			 "%02x\n",
+		pr_debug(
+			"audio[%d] type: %02x max_ch: %02x fs: %02x sbit: %02x\n",
 			 i, audio->type, audio->max_num_of_ch, audio->fs,
 			 audio->sbit);
 		audio++;
@@ -870,21 +870,18 @@ int ps3av_set_video_mode(int id)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ps3av_set_video_mode);
 
 int ps3av_get_auto_mode(void)
 {
 	return ps3av_auto_videomode(&ps3av->av_hw_conf);
 }
-
 EXPORT_SYMBOL_GPL(ps3av_get_auto_mode);
 
 int ps3av_get_mode(void)
 {
 	return ps3av ? ps3av->ps3av_mode : 0;
 }
-
 EXPORT_SYMBOL_GPL(ps3av_get_mode);
 
 /* get resolution by video_mode */
@@ -902,7 +899,6 @@ int ps3av_video_mode2res(u32 id, u32 *xres, u32 *yres)
 	*yres = video_mode_table[id].y;
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ps3av_video_mode2res);
 
 /* mute */
@@ -911,7 +907,6 @@ int ps3av_video_mute(int mute)
 	return ps3av_set_av_video_mute(mute ? PS3AV_CMD_MUTE_ON
 					    : PS3AV_CMD_MUTE_OFF);
 }
-
 EXPORT_SYMBOL_GPL(ps3av_video_mute);
 
 /* mute analog output only */
@@ -935,7 +930,6 @@ int ps3av_audio_mute(int mute)
 	return ps3av_set_audio_mute(mute ? PS3AV_CMD_MUTE_ON
 					 : PS3AV_CMD_MUTE_OFF);
 }
-
 EXPORT_SYMBOL_GPL(ps3av_audio_mute);
 
 static int __devinit ps3av_probe(struct ps3_system_bus_device *dev)
-- 
1.7.9.5



