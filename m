Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0KIUXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:23:48 -0500
Received: from smtp-out.google.com ([74.125.121.35]:26898 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0KIUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:23:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Z0d9CbefxdyYWY4W2VpuYUkhW8XbgiwqumIOb4Z80OOrPM8O58sw8gO0EHep+k5D7
	De+iuuUddyJXAjfC1MDjw==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: mark mem_cgroup_page_stat() underflow unlikely
Date: Tue,  9 Nov 2010 12:21:58 -0800
Message-Id: <1289334118-4448-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add unlikely() to indicate that underflow of per-cpu counter
sum is not expected.

The underflow is already handled, but should have been
marked unlikely.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ed070d0..e8fbade 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1393,7 +1393,7 @@ unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
 	 * value.  This function returns an unsigned value, so round it up to
 	 * zero to avoid returning a very large value.
 	 */
-	if (value < 0)
+	if (unlikely(value < 0))
 		value = 0;
 
 	put_online_cpus();
-- 
1.7.3.1

