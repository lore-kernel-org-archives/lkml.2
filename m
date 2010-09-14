Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0INUYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:24:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58718 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab0INUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/15] mac80211: disallow seeks in minstrel debug code
Date: Tue, 14 Sep 2010 22:22:39 +0200
Message-Id: <1284495763-7506-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:z1U3fR0Q+fK9MqsqGlrOqzzTEfhFqxjqftyxpl1Fnrc
 yHmRMHoaZ4WZ8IYBG+gAvU+GKBGeY80GblAqeCF5ueIp6ySdfV
 lmG9Xi47b93p8EPr3SjaYG23QuzVtZ0BiyDkW4tpLNsBWBEOYb
 mGVtZxChsuXKc4Wti9uaHcwn7nQE6+r+70/MGZmnwa9CorWWq/
 xU76AIP1YOt4jcELSas5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for seek here, so let's just use nonseekable_open.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/mac80211/rc80211_minstrel_ht_debugfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 4a5a4b3..cefcb5d 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -90,7 +90,7 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 		MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
 	ms->len = p - ms->buf;
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static const struct file_operations minstrel_ht_stat_fops = {
@@ -98,6 +98,7 @@ static const struct file_operations minstrel_ht_stat_fops = {
 	.open = minstrel_ht_stats_open,
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
+	.llseek = no_llseek,
 };
 
 void
-- 
1.7.1

