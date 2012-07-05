Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2GEApo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:45:44 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53367 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab2GEApl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:45:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/11] mm: memcg: charge/uncharge improvements
Date: Thu,  5 Jul 2012 02:44:52 +0200
Message-Id: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the biggest thing is probably #1, no longer trying (and failing) to
charge replacement pages during migration and thus compaction.  The
rest is cleanups and tiny optimizations that move some checks out of
the charge and uncharge core paths that do not apply to all types of
pages alike.

 include/linux/memcontrol.h |   11 +--
 mm/memcontrol.c            |  205 +++++++++++++++++++++++---------------------
 mm/migrate.c               |   27 ++-----
 mm/shmem.c                 |   11 ++-
 mm/swapfile.c              |    3 +-
 5 files changed, 124 insertions(+), 133 deletions(-)

