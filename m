Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1F1QEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:04:48 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34698 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756237Ab1F1QCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:02:18 -0400
X-Sasl-enc: XkPisQ5sVEdVoK7VCr59Vh+fDgcgrKY7I5siCVdniX17 1309276937
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: J Freyensee <james_p_freyensee@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/9] pti: PTI semantics fix in pti_tty_cleanup.
Date: Tue, 28 Jun 2011 09:02:04 -0700
Message-Id: <1309276926-1327-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309276926-1327-1-git-send-email-gregkh@suse.de>
References: <20110628153911.GD32710@kroah.com>
 <1309276926-1327-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch fixes a semantics issue in the pti_tty_cleanup()
routine.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/pti.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index e74e7d2..374dfcf 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -498,7 +498,7 @@ static void pti_tty_cleanup(struct tty_struct *tty)
 	if (pti_tty_data == NULL)
 		return;
 	pti_release_masterchannel(pti_tty_data->mc);
-	kfree(tty->driver_data);
+	kfree(pti_tty_data);
 	tty->driver_data = NULL;
 }
 
-- 
1.7.5.4

