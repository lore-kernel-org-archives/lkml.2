Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0LNGcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 01:32:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab0LNGcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 01:32:09 -0500
Message-ID: <4D070F7C.3060503@cn.fujitsu.com>
Date: Tue, 14 Dec 2010 14:32:28 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfq-iosched: don't check cfqg in choose_service_tree()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 14:32:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 14:32:04,
	Serialize complete at 2010-12-14 14:32:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cfq_choose_cfqg() is called in select_queue(), there must be at least one
backlogged CFQ queue waiting for dispatching, hence there must be at least one
backlogged CFQ group on service tree. So we never call choose_service_tree()
with cfqg == NULL.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9b186fd..c19d015 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2103,12 +2103,6 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	unsigned group_slice;
 	enum wl_prio_t original_prio = cfqd->serving_prio;
 
-	if (!cfqg) {
-		cfqd->serving_prio = IDLE_WORKLOAD;
-		cfqd->workload_expires = jiffies + 1;
-		return;
-	}
-
 	/* Choose next priority. RT > BE > IDLE */
 	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
 		cfqd->serving_prio = RT_WORKLOAD;
-- 
1.6.5.2


