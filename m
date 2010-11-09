Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0KIJZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:25:20 -0500
Received: from smtp-out.google.com ([74.125.121.35]:4926 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0KIJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:25:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=hnAZZN1KhFINyDUnw+bXtNuckqgUpC7Bli1ksdpjNfBq480J/K775CODtgXpU1mVM
	NReRfLmkHFluR2xCl7Bqw==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH 0/6] *** memcg: make throttle_vm_writeout() cgroup aware ***
Date: Tue,  9 Nov 2010 01:24:25 -0800
Message-Id: <1289294671-6865-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series aims to:
- Make throttle_vm_writeout() cgroup aware.  Prior to this patch, cgroup reclaim
  would consider global dirty limits when deciding to throttle.  Now cgroup
  limits are used if the cgroup being reclaimed has dirty limits.

- Part of making throttle_vm_writeout() cgroup aware involves fixing a negative
  value signaling error in mem_cgroup_page_stat().  Previously,
  mem_cgroup_page_stat() could falsely return a negative value if a per-cpu
  counter sum was negative.  Calling routines considered negative a special
  "cgroup does not have limits" value.

Greg Thelen (6):
  memcg: add mem_cgroup parameter to mem_cgroup_page_stat()
  memcg: pass mem_cgroup to mem_cgroup_dirty_info()
  memcg: make throttle_vm_writeout() memcg aware
  memcg: simplify mem_cgroup_page_stat()
  memcg: simplify mem_cgroup_dirty_info()
  memcg: make mem_cgroup_page_stat() return value unsigned

 include/linux/memcontrol.h |    8 +++-
 include/linux/writeback.h  |    2 +-
 mm/memcontrol.c            |   92 ++++++++++++++++++++++---------------------
 mm/page-writeback.c        |   40 ++++++++++---------
 mm/vmscan.c                |    2 +-
 5 files changed, 77 insertions(+), 67 deletions(-)

-- 
1.7.3.1

