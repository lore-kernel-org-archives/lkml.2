Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab2C2B0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:26:39 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46457 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758714Ab2C2B0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:26:17 -0400
Message-ID: <4F73BA39.5020509@xenotime.net>
Date: Wed, 28 Mar 2012 18:26:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH] sound: fix isa/opti9xx module param type
References: <20120328171401.354ddb56727a26fe64b35ddf@canb.auug.org.au>
In-Reply-To: <20120328171401.354ddb56727a26fe64b35ddf@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix module parameter data type to eliminate build warnings.

sound/isa/opti9xx/opti92x-ad1848.c:87:1: warning: return from incompatible pointer type
sound/isa/opti9xx/opti92x-ad1848.c:87:1: warning: return from incompatible pointer type

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 sound/isa/opti9xx/opti92x-ad1848.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120328.orig/sound/isa/opti9xx/opti92x-ad1848.c
+++ linux-next-20120328/sound/isa/opti9xx/opti92x-ad1848.c
@@ -65,7 +65,7 @@ static int index = SNDRV_DEFAULT_IDX1;	/
 static char *id = SNDRV_DEFAULT_STR1;		/* ID for this card */
 //static bool enable = SNDRV_DEFAULT_ENABLE1;	/* Enable this card */
 #ifdef CONFIG_PNP
-static int isapnp = 1;			/* Enable ISA PnP detection */
+static bool isapnp = true;			/* Enable ISA PnP detection */
 #endif
 static long port = SNDRV_DEFAULT_PORT1; 	/* 0x530,0xe80,0xf40,0x604 */
 static long mpu_port = SNDRV_DEFAULT_PORT1;	/* 0x300,0x310,0x320,0x330 */
