Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2DCIrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:47:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44907 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab2DCIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:46:59 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Dmitry Kozlov <xeb@mail.ru>,
        netdev@vger.kernel.org
Subject: [PATCH 4/4] ppp: use for_each_set_bit_from
Date: Tue,  3 Apr 2012 17:47:16 +0900
Message-Id: <1333442836-9947-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com>
References: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_set_bit_from to iterate over all the set bit in a memory
region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Kozlov <xeb@mail.ru>
Cc: netdev@vger.kernel.org
---
 drivers/net/ppp/pptp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 885dbdd..72b50f5 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -116,8 +116,8 @@ static int lookup_chan_dst(u16 call_id, __be32 d_addr)
 	int i;
 
 	rcu_read_lock();
-	for (i = find_next_bit(callid_bitmap, MAX_CALLID, 1); i < MAX_CALLID;
-	     i = find_next_bit(callid_bitmap, MAX_CALLID, i + 1)) {
+	i = 1;
+	for_each_set_bit_from(i, callid_bitmap, MAX_CALLID) {
 		sock = rcu_dereference(callid_sock[i]);
 		if (!sock)
 			continue;
-- 
1.7.4.4

