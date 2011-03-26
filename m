Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1CZS3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:29:44 -0400
Received: from unix.wroclaw.pl ([94.23.28.62]:56354 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab1CZS3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:29:42 -0400
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Sage Weil <sage@newdream.net>
Cc: "David S. Miller" <davem@davemloft.net>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] ceph: fix possible NULL pointer dereference
Date: Sat, 26 Mar 2011 19:29:34 +0100
Message-Id: <1301164174-8597-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 'event_work' dereference before it is checked for NULL.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 net/ceph/osd_client.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 02212ed..b6776cb 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1602,11 +1602,11 @@ void handle_watch_notify(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 	     cookie, ver, event);
 	if (event) {
 		event_work = kmalloc(sizeof(*event_work), GFP_NOIO);
-		INIT_WORK(&event_work->work, do_event_work);
 		if (!event_work) {
 			dout("ERROR: could not allocate event_work\n");
 			goto done_err;
 		}
+		INIT_WORK(&event_work->work, do_event_work);
 		event_work->event = event;
 		event_work->ver = ver;
 		event_work->notify_id = notify_id;
-- 
1.7.0.4

