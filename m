Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2DQLoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:44:04 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:42767 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2DQLn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:43:59 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: [PATCH] fs: Move bh_cachep to the __read_mostly section
Date: Tue, 17 Apr 2012 13:11:20 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-40-generic; KDE/4.4.5; i686; ; )
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>, andrea@suse.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171311.21192.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shai Fultheim <shai@scalemp.com>

bh_cachep is only written to once on initialization, so move it to the
__read_mostly section.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
---
 fs/buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 36d6665..a1d82fb 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3151,7 +3151,7 @@ SYSCALL_DEFINE2(bdflush, int, func, long, data)
 /*
  * Buffer-head allocation
  */
-static struct kmem_cache *bh_cachep;
+static struct kmem_cache *bh_cachep __read_mostly;
 
 /*
  * Once the number of bh's in the machine exceeds this level, we start
-- 
1.7.7.6

