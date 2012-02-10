Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab2BJWmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:42:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab2BJWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:38 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.271076046@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 59/86] ASoC: wm8994: Enabling VMID should take a runtime PM reference
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit db966f8abb9ba74f7d5a7230f51572f52c31c4e5 upstream.

We can enable VMID independently of the bias in some use cases so we need
to ensure that the core device is powered up.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -729,6 +729,8 @@ static void vmid_reference(struct snd_so
 {
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
 
+	pm_runtime_get_sync(codec->dev);
+
 	wm8994->vmid_refcount++;
 
 	dev_dbg(codec->dev, "Referencing VMID, refcount is now %d\n",
@@ -796,6 +798,8 @@ static void vmid_dereference(struct snd_
 				    WM8994_VMID_BUF_ENA |
 				    WM8994_VMID_RAMP_MASK, 0);
 	}
+
+	pm_runtime_put(codec->dev);
 }
 
 static int vmid_event(struct snd_soc_dapm_widget *w,


