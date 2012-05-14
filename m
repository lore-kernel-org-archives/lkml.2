Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2ENSBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:01:03 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58817 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab2ENSBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:01:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/6] mm: memcg: statistics implementation cleanups
Date: Mon, 14 May 2012 20:00:45 +0200
Message-Id: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before piling more things (reclaim stats) on top of the current mess,
I thought it'd be better to clean up a bit.

The biggest change is printing statistics directly from live counters,
it has always been annoying to declare a new counter in two separate
enums and corresponding name string arrays.  After this series we are
down to one of each.

 mm/memcontrol.c |  223 +++++++++++++++++------------------------------
 1 file changed, 82 insertions(+), 141 deletions(-)

