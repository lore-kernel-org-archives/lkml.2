Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1KWPm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:42:57 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44786 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab1KWPm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:42:56 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/8] mm: memcg fixlets for 3.3
Date: Wed, 23 Nov 2011 16:42:23 +0100
Message-Id: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some minor memcg-related cleanups and optimizations, nothing
too exciting.  The bulk of the diffstat comes from renaming the
remaining variables to describe a (struct mem_cgroup *) to "memcg".
The rest cuts down on the (un)charge fastpaths, as people start to get
annoyed by those functions showing up in the profiles of their their
non-memcg workloads.  More is to come, but I wanted to get the more
obvious bits out of the way.

 include/linux/memcontrol.h  |   16 ++++----
 include/linux/oom.h         |    2 +-
 include/linux/page_cgroup.h |   20 ++++++---
 include/linux/rmap.h        |    4 +-
 mm/memcontrol.c             |   97 ++++++++++++++++---------------------------
 mm/oom_kill.c               |   42 +++++++++---------
 mm/rmap.c                   |   20 ++++----
 mm/swapfile.c               |    9 ++--
 mm/vmscan.c                 |   12 +++---
 9 files changed, 103 insertions(+), 119 deletions(-)

