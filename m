Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2JOWH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:07:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab2JOWH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:07:27 -0400
Date: Tue, 16 Oct 2012 00:07:25 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] doc: describe memcg swappiness more precisely
 memory.swappiness==0
Message-ID: <20121015220725.GB11682@dhcp22.suse.cz>
References: <20121011085038.GA29295@dhcp22.suse.cz>
 <1349945859-1350-1-git-send-email-mhocko@suse.cz>
 <20121015220354.GA11682@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015220354.GA11682@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And a follow up for memcg.swappiness documentation which is more
specific about spwappiness==0 meaning.
---
>From 1bc3a94fea728107ed108edd42df464b908cd067 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 15 Oct 2012 11:43:56 +0200
Subject: [PATCH] doc: describe memcg swappiness more precisely

since fe35004f (mm: avoid swapping out with swappiness==0) memcg reclaim
stopped swapping out anon pages completely when 0 value is used.
Although this is somehow expected it hasn't been done for a really long
time this way and so it is probably better to be explicit about the
effect. Moreover global reclaim swapps out even when swappiness is 0
to prevent from OOM killer.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index c07f7b4..71c4da4 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -466,6 +466,10 @@ Note:
 5.3 swappiness
 
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Please note that unlike the global swappiness, memcg knob set to 0
+really prevents from any swapping even if there is a swap storage
+available. This might lead to memcg OOM killer if there are no file
+pages to reclaim.
 
 Following cgroups' swappiness can't be changed.
 - root cgroup (uses /proc/sys/vm/swappiness).
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
