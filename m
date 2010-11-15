Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0KOBCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:02:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab0KOBCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:02:40 -0500
Message-ID: <4CE086A9.8060306@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 09:02:33 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [RFC] [PATCH 7/8] cfq-iosched: Enable deep hierarchy in CGgroup
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 09:03:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 09:03:04,
	Serialize complete at 2010-11-15 09:03:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currenlty, only level 0 and 1 CGroup directory is allowed to be created.
This patch enables deep hierarchy in CGgroup.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b1febd0..455768a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1452,10 +1452,6 @@ blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		goto done;
 	}
 
-	/* Currently we do not support hierarchy deeper than two level (0,1) */
-	if (parent != cgroup->top_cgroup)
-		return ERR_PTR(-EPERM);
-
 	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
 	if (!blkcg)
 		return ERR_PTR(-ENOMEM);
-- 
1.6.5.2
