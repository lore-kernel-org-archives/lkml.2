Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993498Ab2K3TcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:32:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:57472 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031646Ab2K3St2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Danny Kukawka <danny.kukawka@bisect.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 04/37] riva/fbdev: fix several -Wuninitialized
Date: Fri, 30 Nov 2012 10:45:51 -0800
Message-Id: <20121130183857.681595778@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kukawka <danny.kukawka@bisect.de>

commit c718a54649475cc397484f96e70f6d0fdd267165 upstream.

Fix several -Wuninitialized compiler warnings by changing the
order of getting modedb in riva_update_default_var() to set
first the fallback and then the prefered timing.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/riva/fbdev.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -1816,6 +1816,8 @@ static void __devinit riva_update_defaul
 			     specs->modedb, specs->modedb_len,
 			     NULL, 8);
 	} else if (specs->modedb != NULL) {
+		/* get first mode in database as fallback */
+		modedb = specs->modedb[0];
 		/* get preferred timing */
 		if (info->monspecs.misc & FB_MISC_1ST_DETAIL) {
 			int i;
@@ -1826,9 +1828,6 @@ static void __devinit riva_update_defaul
 					break;
 				}
 			}
-		} else {
-			/* otherwise, get first mode in database */
-			modedb = specs->modedb[0];
 		}
 		var->bits_per_pixel = 8;
 		riva_update_var(var, &modedb);


