Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2L1XSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 18:18:25 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65374 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab2L1XSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 18:18:23 -0500
Date: Fri, 28 Dec 2012 18:18:18 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 18.5/24] blkcg: export __blkg_prfill_rwstat() take#2
Message-ID: <20121228231818.GL3062@mtj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hierarchical stats for cfq-iosched will need __blkg_prfill_rwstat().
Export it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
Fengguang's build test discovered that cfq now uses
__blkg_prfill_rwstat() which isn't exported leading to build failures
when cfq is built as a module.  Export it.  This doesn't affect
!module builds.  Git branch updated accordingly.

Thanks.

 block/blk-cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -552,6 +552,7 @@ u64 __blkg_prfill_rwstat(struct seq_file
 	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
 	return v;
 }
+EXPORT_SYMBOL_GPL(__blkg_prfill_rwstat);
 
 /**
  * blkg_prfill_stat - prfill callback for blkg_stat
