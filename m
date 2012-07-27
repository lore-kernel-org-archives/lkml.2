Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2G0Mj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:39:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61394 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2G0MjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:39:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        sameo@linux.intel.com, alsa-devel@alsa-project.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/7] ASoC: dapm: If one widget fails, do not force all subsequent widgets to fail too
Date: Fri, 27 Jul 2012 13:38:48 +0100
Message-Id: <1343392734-11805-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
References: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
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

