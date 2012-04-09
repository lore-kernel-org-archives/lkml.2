Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab2DIUwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:52:31 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21395 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2DIUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:52:28 -0400
Date: Mon, 9 Apr 2012 22:52:26 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Matthieu CASTET <castet.matthieu@free.fr>
Subject: [PATCH 25/26] usb/atm/ueagle-atm: Don't test for NULL ptr before
 calling release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092245570.14420@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() deals gracefullt w/ NULL pointers, no need to check
first.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/usb/atm/ueagle-atm.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 01ea5d7..d7e422d 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1357,10 +1357,8 @@ static int uea_stat_e1(struct uea_softc *sc)
 		/* release the dsp firmware as it is not needed until
 		 * the next failure
 		 */
-		if (sc->dsp_firm) {
-			release_firmware(sc->dsp_firm);
-			sc->dsp_firm = NULL;
-		}
+		release_firmware(sc->dsp_firm);
+		sc->dsp_firm = NULL;
 	}
 
 	/* always update it as atm layer could not be init when we switch to
@@ -1496,10 +1494,8 @@ static int uea_stat_e4(struct uea_softc *sc)
 		/* release the dsp firmware as it is not needed until
 		 * the next failure
 		 */
-		if (sc->dsp_firm) {
-			release_firmware(sc->dsp_firm);
-			sc->dsp_firm = NULL;
-		}
+		release_firmware(sc->dsp_firm);
+		sc->dsp_firm = NULL;
 	}
 
 	/* always update it as atm layer could not be init when we switch to
@@ -2240,8 +2236,7 @@ static void uea_stop(struct uea_softc *sc)
 	/* flush the work item, when no one can schedule it */
 	flush_work_sync(&sc->task);
 
-	if (sc->dsp_firm)
-		release_firmware(sc->dsp_firm);
+	release_firmware(sc->dsp_firm);
 	uea_leaves(INS_TO_USBDEV(sc));
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

