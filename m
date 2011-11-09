Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936183Ab1KJD65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:58:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965941Ab1KJDr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:05 2011
Message-Id: <20111109213205.845999608@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [232/264] target: Fix incorrect se_cmd assignment in core_tmr_drain_tmr_list
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Engel <joern@logfs.org>

commit 80ccbc8e00f7001d79dd503c2781487906b98611 upstream.

This patch fixes a bug in core_tmr_drain_tmr_list() where drain_tmr_list
was using the wrong se_tmr_req for cmd assignment due to a typo during the
LUN_RESET re-org.  This was resulting in general protection faults while
using the leftover bogus *tmr_p pointer from list_for_each_entry_safe().

Signed-off-by: Joern Engel <joern@logfs.org>
Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_tmr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -155,7 +155,7 @@ static void core_tmr_drain_tmr_list(
 	while (!list_empty(&drain_tmr_list)) {
 		tmr = list_entry(drain_tmr_list.next, struct se_tmr_req, tmr_list);
 		list_del(&tmr->tmr_list);
-		cmd = tmr_p->task_cmd;
+		cmd = tmr->task_cmd;
 
 		pr_debug("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
 			" Response: 0x%02x, t_state: %d\n",


