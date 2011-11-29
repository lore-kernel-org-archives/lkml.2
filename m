Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1K2Kwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:52:37 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:54477 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1K2Kwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:52:36 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/7] mm: memcg fixlets for 3.3 v2
Date: Tue, 29 Nov 2011 11:51:58 +0100
Message-Id: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2:
o dropped the non-atomic bitops against pc->flags (Hugh et al)
o added VM_BUG_ONs where page sanity checks were removed (Kame)
o made the page_cgroup array checks in lookup_page_cgroup()
  depend on CONFIG_DEBUG_VM, like the only caller that needs 'em
o added ack tags

 include/linux/memcontrol.h |   16 ++++----
 include/linux/oom.h        |    2 +-
 include/linux/rmap.h       |    4 +-
 mm/memcontrol.c            |   96 ++++++++++++++++++--------------------------
 mm/oom_kill.c              |   42 ++++++++++----------
 mm/page_cgroup.c           |   18 +++++++-
 mm/rmap.c                  |   20 +++++-----
 mm/swapfile.c              |    9 ++--
 mm/vmscan.c                |   12 +++---
 9 files changed, 108 insertions(+), 111 deletions(-)

