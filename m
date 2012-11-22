Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2KVSjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:39:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:49355 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab2KVSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mukund Navada <navada@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 29/83] ASoC: core: Double control update err for snd_soc_put_volsw_sx
Date: Wed, 21 Nov 2012 16:41:51 -0800
Message-Id: <20121122004215.816436063@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukund Navada <navada@ti.com>

commit d055852ee86703d48b0c571e94bd2eb33aa9b91d upstream.

snd_soc_put_volsw_sx function fails to update second control
if first control is updated by snd_soc_update_bits_locked.

Signed-off-by: Mukund Navada <navada@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2776,8 +2776,9 @@ int snd_soc_put_volsw_sx(struct snd_kcon
 	val = (ucontrol->value.integer.value[0] + min) & mask;
 	val = val << shift;
 
-	if (snd_soc_update_bits_locked(codec, reg, val_mask, val))
-			return err;
+	err = snd_soc_update_bits_locked(codec, reg, val_mask, val);
+	if (err < 0)
+		return err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		val_mask = mask << rshift;


