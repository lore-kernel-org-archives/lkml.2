Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1JBU3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:29:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab1JBU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:29:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] ASoC: codecs/wm8682: use __devexit_p
Date: Sun,  2 Oct 2011 22:27:59 +0200
Message-Id: <1317587284-2776-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317587284-2776-1-git-send-email-arnd@arndb.de>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8Wslig4dGbdmda2P8NOUaxNBc4Bb3mzzFCY4QKnCFJL
 81FPHMXG7pKq8KaF7SsgG7x8AYNRbazhZTLFWAVjkWyERC7DfI
 P2s97auGWBJXLAoHmLAOtXcy3UhvEhtTQZ+Qx3W0ZSwroPnO4p
 A6fR/6YUkW5QJm6HSHPG+93dQEohOSSwZhNVm5hvMjCh5dASMa
 Lhx7tp5uRlk8Q0e9aOkI3ew7mNd+HOYL6f9r9VANdueUuhfag+
 bMIBXsaHPAl8Bo+xuoRXrgFsy23XHdgxX9kUDesnBAGzjh7/97
 44uu3P6bQxT3rRiWAXtbDVg7AQ/CutEg4HP8FYuIJ1bXvSld/x
 2ofnQWziaV37mM+9QhqQeHTomESeGBAeWh7bIdvf7WiN86lrmE
 YZsnSb6T4y2ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build error when CONFIG_HOTPLUG is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm8782.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8782.c b/sound/soc/codecs/wm8782.c
index a2a09f8..f2ced71 100644
--- a/sound/soc/codecs/wm8782.c
+++ b/sound/soc/codecs/wm8782.c
@@ -60,7 +60,7 @@ static struct platform_driver wm8782_codec_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = wm8782_probe,
-	.remove = wm8782_remove,
+	.remove = __devexit_p(wm8782_remove),
 };
 
 static int __init wm8782_init(void)
-- 
1.7.5.4

