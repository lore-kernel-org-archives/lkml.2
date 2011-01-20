Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1ATVh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:37:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23420 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab1ATVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:37:25 -0500
Date: Thu, 20 Jan 2011 22:37:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH][RFC] Sound, Xonar, CS43xx: Don't overrun static array
Message-ID: <alpine.LNX.2.00.1101202228370.11854@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'cs4398_regs' in 'struct xonar_cs43xx' is an array of 'u8' with a size of 
8. So, this code in sound/pci/oxygen/xonar_cs43xx.c::dump_d1_registers()

    		for (i = 2; i <= 8; ++i)
	  			snd_iprintf(buffer, " %02x", data->cs4398_regs[i]);

will overrun the array when 'i == 8'.

I guess that what's needed to fix it is the trivial patch below, but I 
must admit that I have no idea about this code, so I may very well be 
wrong. Additionally, I have no way to actually test this, so all I know is 
that the below compiles. Someone who actually knows this code should take 
a look before anything is comitted - consider the below (not much more 
than) a bug report.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 xonar_cs43xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/oxygen/xonar_cs43xx.c b/sound/pci/oxygen/xonar_cs43xx.c
index 9f72d42..2527191 100644
--- a/sound/pci/oxygen/xonar_cs43xx.c
+++ b/sound/pci/oxygen/xonar_cs43xx.c
@@ -392,7 +392,7 @@ static void dump_d1_registers(struct oxygen *chip,
 	unsigned int i;
 
 	snd_iprintf(buffer, "\nCS4398: 7?");
-	for (i = 2; i <= 8; ++i)
+	for (i = 2; i < 8; ++i)
 		snd_iprintf(buffer, " %02x", data->cs4398_regs[i]);
 	snd_iprintf(buffer, "\n");
 	dump_cs4362a_registers(data, buffer);

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

