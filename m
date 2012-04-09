Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab2DIUwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:52:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21322 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2DIUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:52:11 -0400
Date: Mon, 9 Apr 2012 22:52:10 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, alsa-devel@alsa-project.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 23/26] ALSA: riptide: remove redundant NULL test before
 release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092241550.14420@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() deals gracefully with NULL pointers, no need to check first.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/riptide/riptide.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 0481d94..cbeb3f7 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1837,8 +1837,7 @@ static int snd_riptide_free(struct snd_riptide *chip)
 	}
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	if (chip->fw_entry)
-		release_firmware(chip->fw_entry);
+	release_firmware(chip->fw_entry);
 	release_and_free_resource(chip->res_port);
 	kfree(chip);
 	return 0;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

