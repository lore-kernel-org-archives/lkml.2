Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1AFAjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:39:15 -0500
Received: from kroah.org ([198.145.64.141]:36009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab1AFAbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:18 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002307.980524129@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Chris Ball <cjb@laptop.org>
Subject: [119/152] mmc: Fix re-probing with PM_POST_RESTORE notification
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 274476f8fe0b6ac9bac542cc39de12c3dd0f43f6 upstream.

In the error-path where PM notifies PM_POST_RESTORE, the rescan-blockage
should be cleared as well.  Otherwise it'll be never re-probed.

Also, as a bonus, this fixes a bug in S4 with user-mode suspend in the
current code, as it sends PM_POST_RESTORE instead of
PM_POST_HIBERNATION wrongly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1720,6 +1720,7 @@ int mmc_pm_notify(struct notifier_block
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
 
 		spin_lock_irqsave(&host->lock, flags);
 		host->rescan_disable = 0;


