Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0G1QlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:41:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64841 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab0G1QlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jeJORNzTCMucW/ORB8m64ae6DHbcCpslYn4X+2JuwfSor3dRm62QEdm9Ak0Ntsvay1
         OibFWzu/ek/eEAgJvgGiPD1n4WRWsTez0dS6BLqq7OXhq3Bo2YYLRCmpYfnhKaKvQAy8
         nKaFzpHPRTCbCQjfYlV6qFabDNqVsnOTonJwU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] ALSA: sb: check get_user() return value
Date: Wed, 28 Jul 2010 20:40:51 +0400
Message-Id: <1280335251-23385-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/isa/sb/emu8000_pcm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/isa/sb/emu8000_pcm.c b/sound/isa/sb/emu8000_pcm.c
index ccedbfe..ae6fa9f 100644
--- a/sound/isa/sb/emu8000_pcm.c
+++ b/sound/isa/sb/emu8000_pcm.c
@@ -433,7 +433,8 @@ static int emu8k_transfer_block(struct snd_emu8000 *emu, int offset, unsigned sh
 	while (count > 0) {
 		unsigned short sval;
 		CHECK_SCHEDULER();
-		get_user(sval, buf);
+		if (get_user(sval, buf))
+			return -EFAULT;
 		EMU8000_SMLD_WRITE(emu, sval);
 		buf++;
 		count--;
@@ -525,7 +526,8 @@ static int emu8k_pcm_copy(struct snd_pcm_substream *subs,
 	while (count-- > 0) {
 		unsigned short sval;
 		CHECK_SCHEDULER();
-		get_user(sval, buf);
+		if (get_user(sval, buf))
+			return -EFAULT;
 		EMU8000_SMLD_WRITE(emu, sval);
 		buf++;
 		if (rec->voices > 1) {
-- 
1.7.0.4

