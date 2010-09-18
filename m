Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0IRT3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:29:40 -0400
Received: from kroah.org ([198.145.64.141]:43469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab0IRTPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:22 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.586073619@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [061/129] ALSA: hda - patch_nvhdmi.c: Add missing codec IDs, unify names
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 9cf2657d05f9f9e04c3e113d68bf7cef5a942070 upstream.

* Add missing codec IDs.
* Modify some existing codec names for discrete GPUs to match newly
  added IDs. Note: existing names were a mixture of marketing and
  engineering GPU names. Equally, there's no reason that codec IDs
  have to be specific to a particular GPU or board, so identify
  codecs in a less marketing-oriented fashion.
* Reformat codec ID table so it's easier to read, for me at least.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_nvhdmi.c |   61 ++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 20 deletions(-)

--- a/sound/pci/hda/patch_nvhdmi.c
+++ b/sound/pci/hda/patch_nvhdmi.c
@@ -541,26 +541,32 @@ static int patch_nvhdmi_2ch(struct hda_c
  * patch entries
  */
 static struct hda_codec_preset snd_hda_preset_nvhdmi[] = {
-	{ .id = 0x10de0002, .name = "MCP77/78 HDMI",
-	  .patch = patch_nvhdmi_8ch_7x },
-	{ .id = 0x10de0003, .name = "MCP77/78 HDMI",
-	  .patch = patch_nvhdmi_8ch_7x },
-	{ .id = 0x10de0005, .name = "MCP77/78 HDMI",
-	  .patch = patch_nvhdmi_8ch_7x },
-	{ .id = 0x10de0006, .name = "MCP77/78 HDMI",
-	  .patch = patch_nvhdmi_8ch_7x },
-	{ .id = 0x10de0007, .name = "MCP79/7A HDMI",
-	  .patch = patch_nvhdmi_8ch_7x },
-	{ .id = 0x10de000a, .name = "GT220 HDMI",
-	  .patch = patch_nvhdmi_8ch_89 },
-	{ .id = 0x10de000b, .name = "GT21x HDMI",
-	  .patch = patch_nvhdmi_8ch_89 },
-	{ .id = 0x10de000c, .name = "MCP89 HDMI",
-	  .patch = patch_nvhdmi_8ch_89 },
-	{ .id = 0x10de000d, .name = "GT240 HDMI",
-	  .patch = patch_nvhdmi_8ch_89 },
-	{ .id = 0x10de0067, .name = "MCP67 HDMI", .patch = patch_nvhdmi_2ch },
-	{ .id = 0x10de8001, .name = "MCP73 HDMI", .patch = patch_nvhdmi_2ch },
+	{ .id = 0x10de0002, .name = "MCP77/78 HDMI",  .patch = patch_nvhdmi_8ch_7x },
+	{ .id = 0x10de0003, .name = "MCP77/78 HDMI",  .patch = patch_nvhdmi_8ch_7x },
+	{ .id = 0x10de0005, .name = "MCP77/78 HDMI",  .patch = patch_nvhdmi_8ch_7x },
+	{ .id = 0x10de0006, .name = "MCP77/78 HDMI",  .patch = patch_nvhdmi_8ch_7x },
+	{ .id = 0x10de0007, .name = "MCP79/7A HDMI",  .patch = patch_nvhdmi_8ch_7x },
+	{ .id = 0x10de000a, .name = "GPU 0a HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de000b, .name = "GPU 0b HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de000c, .name = "MCP89 HDMI",     .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de000d, .name = "GPU 0d HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0010, .name = "GPU 10 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0011, .name = "GPU 11 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0012, .name = "GPU 12 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0013, .name = "GPU 13 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0014, .name = "GPU 14 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0018, .name = "GPU 18 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0019, .name = "GPU 19 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de001a, .name = "GPU 1a HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de001b, .name = "GPU 1b HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de001c, .name = "GPU 1c HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0040, .name = "GPU 40 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0041, .name = "GPU 41 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0042, .name = "GPU 42 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0043, .name = "GPU 43 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0044, .name = "GPU 44 HDMI/DP", .patch = patch_nvhdmi_8ch_89 },
+	{ .id = 0x10de0067, .name = "MCP67 HDMI",     .patch = patch_nvhdmi_2ch },
+	{ .id = 0x10de8001, .name = "MCP73 HDMI",     .patch = patch_nvhdmi_2ch },
 	{} /* terminator */
 };
 
@@ -573,6 +579,21 @@ MODULE_ALIAS("snd-hda-codec-id:10de000a"
 MODULE_ALIAS("snd-hda-codec-id:10de000b");
 MODULE_ALIAS("snd-hda-codec-id:10de000c");
 MODULE_ALIAS("snd-hda-codec-id:10de000d");
+MODULE_ALIAS("snd-hda-codec-id:10de0010");
+MODULE_ALIAS("snd-hda-codec-id:10de0011");
+MODULE_ALIAS("snd-hda-codec-id:10de0012");
+MODULE_ALIAS("snd-hda-codec-id:10de0013");
+MODULE_ALIAS("snd-hda-codec-id:10de0014");
+MODULE_ALIAS("snd-hda-codec-id:10de0018");
+MODULE_ALIAS("snd-hda-codec-id:10de0019");
+MODULE_ALIAS("snd-hda-codec-id:10de001a");
+MODULE_ALIAS("snd-hda-codec-id:10de001b");
+MODULE_ALIAS("snd-hda-codec-id:10de001c");
+MODULE_ALIAS("snd-hda-codec-id:10de0040");
+MODULE_ALIAS("snd-hda-codec-id:10de0041");
+MODULE_ALIAS("snd-hda-codec-id:10de0042");
+MODULE_ALIAS("snd-hda-codec-id:10de0043");
+MODULE_ALIAS("snd-hda-codec-id:10de0044");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 


