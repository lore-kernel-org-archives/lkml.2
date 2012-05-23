Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2EWGMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:12:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56916 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2EWGMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:12:05 -0400
From: Alex Hung <alex.hung@canonical.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.hung@canonical.com
Subject: [PATCH] rfkill: Add the capability to switch all devices of all type in __rfkill_switch_all().
Date: Wed, 23 May 2012 14:11:52 +0800
Message-Id: <1337753512-10585-1-git-send-email-alex.hung@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__rfkill_switch_all() switches the state of devices of a given type; however,
it does not switch devices of all type (RFKILL_TYPE_ALL). As a result, it
ignores the keycode "KEY_RFKILL" from another module, i.e. eeepc-wmi.

This fix is to make __rfkill_switch_all() to be able to switch not only 
devices of a given type but also all devices.

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

