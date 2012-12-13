Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2LMOF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab2LMOFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mukund Navada <navada@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 084/241] ASoC: core: Double control update err for snd_soc_put_volsw_sx
Date: Thu, 13 Dec 2012 11:57:29 -0200
Message-Id: <1355407206-17100-85-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukund Navada <navada@ti.com>

commit d055852ee86703d48b0c571e94bd2eb33aa9b91d upstream.

snd_soc_put_volsw_sx function fails to update second control
if first control is updated by snd_soc_update_bits_locked.

Signed-off-by: Mukund Navada <navada@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/soc-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index b37ee80..ed038b9 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2692,8 +2692,9 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	val = (ucontrol->value.integer.value[0] + min) & mask;
 	val = val << shift;
 
-	if (snd_soc_update_bits_locked(codec, reg, val_mask, val))
-			return err;
+	err = snd_soc_update_bits_locked(codec, reg, val_mask, val);
+	if (err < 0)
+		return err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		val_mask = mask << rshift;
-- 
1.7.9.5

