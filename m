Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2JWReW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:34:22 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:40395 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754531Ab2JWReU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:34:20 -0400
Message-ID: <5086D518.7050606@xenotime.net>
Date: Tue, 23 Oct 2012 10:34:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH -next] sound: ice1712 build errors
References: <20121023151951.d5573eb8990a372754f29bf3@canb.auug.org.au>
In-Reply-To: <20121023151951.d5573eb8990a372754f29bf3@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors by using correct kconfig symbol name:

sound/pci/ice1712/psc724.c:417:5: error: 'struct snd_ice1712' has no member named 'pm_resume'
sound/pci/ice1712/psc724.c:418:5: error: 'struct snd_ice1712' has no member named 'pm_suspend_enabled'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc:	Jaroslav Kysela <perex@perex.cz>
Cc:	Takashi Iwai <tiwai@suse.de>
Cc:	alsa-devel@alsa-project.org
---
 sound/pci/ice1712/psc724.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20121023.orig/sound/pci/ice1712/psc724.c
+++ linux-next-20121023/sound/pci/ice1712/psc724.c
@@ -413,7 +413,7 @@ static int __devinit psc724_init(struct
 	snd_wm8776_init(&spec->wm8776);
 	spec->wm8766.ops.write = psc724_wm8766_write;
 	spec->wm8766.card = ice->card;
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	ice->pm_resume = psc724_resume;
 	ice->pm_suspend_enabled = 1;
 #endif
