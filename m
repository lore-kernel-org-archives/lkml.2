Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936094Ab1KJDrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:47:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933796Ab1KJDrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:06 2011
Message-Id: <20111109213205.941095162@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joern Engel <joern@logfs.org>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [233/264] target: Fix wrong se_tmr being added to drain_tmr_list
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Engel <joern@logfs.org>

commit 6eb40b2af4908e9aee71e43e7a384243128c56dd upstream.

This patch fixes another bug from LUN_RESET re-org fallout in
core_tmr_drain_tmr_list() that was adding the wrong se_tmr_req
into the local drain_tmr_list to be walked + released.

Signed-off-by: Joern Engel <joern@logfs.org>
Cc: Joern Engel <joern@logfs.org>
Reviewed-by: Roland Dreier <roland@purestorage.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_tmr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -148,7 +148,7 @@ static void core_tmr_drain_tmr_list(
 		}
 		spin_unlock(&cmd->t_state_lock);
 
-		list_move_tail(&tmr->tmr_list, &drain_tmr_list);
+		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
 	}
 	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
 


