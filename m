Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1ECMqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:46:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46631 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1ECMqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:46:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=UoN5ecci8BORkI8QFaW/ickWzcVhnw0OzUB9Z3Nu6m/84B4Lqk+7IlFVkVnqIbjInf
         n8hrbT82o9qiVUJHTUnYGI1JbfDFj9nAmOGfeQrwK+QQJFdC5J1B8JHh6hqt2QsjXzz1
         7gKSj5ryFq5Am3b+M+7jakUxlJFBkXJz3ROcA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: tiwai@suse.de, perex@perex.cz
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] SOC: UDA134x: Remove POWER_OFF_ON_STANDBY define.
Date: Tue,  3 May 2011 14:46:32 +0200
Message-Id: <1304426792-23540-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define POWER_OFF_ON_STANDBY cause trobles when trying to get some
sound from codec because code for bias setup was not compiled
(define wasn't defined). This define was removed in commit:
cc3202f5 but again introduced by commit: f0fba2ad1 which then
completely break codec functionality so remove it again.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 sound/soc/codecs/uda134x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index 48ffd40..a7b8f30 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -601,9 +601,7 @@ static struct snd_soc_codec_driver soc_codec_dev_uda134x = {
 	.reg_cache_step = 1,
 	.read = uda134x_read_reg_cache,
 	.write = uda134x_write,
-#ifdef POWER_OFF_ON_STANDBY
 	.set_bias_level = uda134x_set_bias_level,
-#endif
 };
 
 static int __devinit uda134x_codec_probe(struct platform_device *pdev)
-- 
1.7.4.1

