Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2GaNes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:34:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37555 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2GaNbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:31:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all subsequent widgets to fail too
Date: Tue, 31 Jul 2012 14:31:23 +0100
Message-Id: <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a list of widgets is provided and one of them fails to be added as
a control, the present semantics fail all subsequent widgets. A better
solution would be to only fail that widget, but pursue in attempting
to add the rest of the list.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/soc-dapm.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index eded657..7d9c154 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3095,8 +3095,6 @@ int snd_soc_dapm_new_controls(struct snd_soc_dapm_context *dapm,
 			dev_err(dapm->dev,
 				"ASoC: Failed to create DAPM control %s\n",
 				widget->name);
-			ret = -ENOMEM;
-			break;
 		}
 		widget++;
 	}
-- 
1.7.9.5

