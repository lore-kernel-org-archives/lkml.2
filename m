Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab2JKAM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:12:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54997 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757677Ab2JKAMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:12:54 -0400
X-Sasl-enc: wejiFBgdUIFp14HM654DgnYAWHSxiG5W/uh8GmmEHBfl 1349914372
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 078/133] ASoC: wm_hubs: Ensure volume updates are handled during class W startup
Date: Thu, 11 Oct 2012 07:51:44 +0900
Message-Id: <20121010224908.513184542@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit eb4d5fc1f0ce89e3d5b072c594a1e213a0e05881 upstream.

In some circumstances we may need to flush volume updates to the device
after switching to class W mode. Do this unconditionally to ensure that
these situations are handled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_hubs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -634,6 +634,11 @@ void wm_hubs_update_class_w(struct snd_s
 
 	snd_soc_update_bits(codec, WM8993_CLASS_W_0,
 			    WM8993_CP_DYN_V | WM8993_CP_DYN_FREQ, enable);
+
+	snd_soc_write(codec, WM8993_LEFT_OUTPUT_VOLUME,
+		      snd_soc_read(codec, WM8993_LEFT_OUTPUT_VOLUME));
+	snd_soc_write(codec, WM8993_RIGHT_OUTPUT_VOLUME,
+		      snd_soc_read(codec, WM8993_RIGHT_OUTPUT_VOLUME));
 }
 EXPORT_SYMBOL_GPL(wm_hubs_update_class_w);
 


