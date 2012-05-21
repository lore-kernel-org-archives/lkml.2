Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2EUIhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:37:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2EUIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:37:30 -0400
From: Alex Hung <alex.hung@canonical.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.hung@canonical.com
Subject: [PATCH] rfkill: Add handling when rfkill's type is RFKILL_TYPE_ALL.
Date: Mon, 21 May 2012 16:37:19 +0800
Message-Id: <1337589439-14605-1-git-send-email-alex.hung@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rfkill type is supposed to be able to toggles the status of all wireless
devices; however, no wireless devices will register itself with type 
RFKILL_TYPE_ALL and thus it was previously ignored in __rfkill_switch_all.

Signed-off-by: Alex Hung <alex.hung@canonical.com>
---
 net/rfkill/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 5be1957..84dd71a 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -324,7 +324,7 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
 
 	rfkill_global_states[type].cur = blocked;
 	list_for_each_entry(rfkill, &rfkill_list, node) {
-		if (rfkill->type != type)
+		if (rfkill->type != type && type != RFKILL_TYPE_ALL)
 			continue;
 
 		rfkill_set_block(rfkill, blocked);
-- 
1.7.0.4

