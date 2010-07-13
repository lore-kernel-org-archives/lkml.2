Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0GMCXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:23:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62395 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0GMCXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:23:31 -0400
Message-ID: <4C3BCDA1.5040007@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 10:21:21 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] CFQ: Don't store left slice when slice used up or for a idle
 workload
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make sence to store left time slice for an idle workload
or for the cfqq that uses up its slice.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index eb4086f..d985e38 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3418,7 +3418,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * - when there is a close cooperator
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1);
+			cfq_slice_expired(cfqd, 0);
 		else if (sync && cfqq_empty &&
 			 !cfq_close_cooperator(cfqd, cfqq)) {
 			cfqd->noidle_tree_requires_idle |=
-- 
1.5.4.rc3

