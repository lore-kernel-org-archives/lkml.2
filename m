Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2ALRhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:37:48 -0500
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:59010 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751860Ab2ALRhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:37:47 -0500
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jan 2012 12:37:46 EST
Date: Fri, 13 Jan 2012 01:30:28 +0800
From: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
To: xfs@oss.sgi.com, elder@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: remove unecessary AIL push wakeups
Message-ID: <20120113013028.6802d878@ustc>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: yia_0ZDrHQR2Fw9PgIQeAA--.9667S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw43Xr1ftFy7GryUtF15XFb_yoWfGFb_Xa
	1vyryxWwnxWrs2yrW8Xrs8Aryjyw4IyrZ7WayUtay5Ka4UWF4ayF98XFZ0qry7CrWYkrn3
	Zr9I9r13Kr92yjkaLaAFLSUrUUUUUbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnRJUUU
	6Sb7IF0VCFI7km07C26c804VAKzcIF0wAYjxAI6xZILanIXVAFwwAYjxAI6IIYrVAFwwAY
	jsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1I0E4x80FVCIwcAKzIAtM7C26IkvcI
	IF6IxKo4kEV4yl1IIY67AEw4v_Jr0_Jr4l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28E
	F7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84
	ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67kvxFCE548m6r1fGryUXwAac4AC648E
	w2Wl57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r
	1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxG
	rwCFI7vE0wC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
	AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8
	ag4DUUUUU==
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In commit 0030807c66("xfs: revert to using a kthread for AIL pushing"),
AIL pushing is revert back to use a kthread. But unfortunately, it
introduced a regression: there are unnecessary AIL push wakeups during
idle, ~20 wakeups/s. This change remove the wakeups by reverting a bit
more: set "tout" value as zero during idle.

Signed-off-by: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
---
 fs/xfs/xfs_trans_ail.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ed9252b..2014387 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -508,7 +508,7 @@ out_done:
 		ailp->xa_last_pushed_lsn = 0;
 		ailp->xa_log_flush = 0;
 
-		tout = 50;
+		tout = 0;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
 		 * We reached the target so wait a bit longer for I/O to
-- 
1.7.8.3


