Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab1ECJco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:32:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37750 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1ECJcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Tm5spSI3aDbTT/7dkZwQWrTG7bHTdnkJ6ZUcrZnDX/9nW4faXVHmZCtgR7YMvpsCcK
         fsvub2fjhJLfxIt3UJ2u0cct4NIr15F908eLo8yMVym9nCs1H9qcJs1v5Pgcli3EbokU
         4MnDkaxGoXDeIuzXH/bJPA6FPu9dDE25LBjJ4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: tiwai@suse.de, perex@perex.cz
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] SOC: UDA134x: Enable POWER_OFF_ON_STANDBY define.
Date: Tue,  3 May 2011 11:32:29 +0200
Message-Id: <1304415149-19725-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this define we can't get any sound from codec so enable
it by default. This define unlock bias settings which control
power control for DAC and ADC (by default 0 0 which is off off).

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 sound/soc/codecs/uda134x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index 48ffd40..8c6808ad 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -26,6 +26,7 @@
 
 #include "uda134x.h"
 
+#define POWER_OFF_ON_STANDBY
 
 #define UDA134X_RATES SNDRV_PCM_RATE_8000_48000
 #define UDA134X_FORMATS (SNDRV_PCM_FMTBIT_S8 | SNDRV_PCM_FMTBIT_S16_LE | \
-- 
1.7.4.1

