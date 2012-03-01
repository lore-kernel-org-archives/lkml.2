Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2CACnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:43:32 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60920 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab2CACnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:43:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.129.162 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Wed, 29 Feb 2012 18:42:57 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH next] memcg: remove PCG_CACHE page_cgroup flag fix2
In-Reply-To: <alpine.LSU.2.00.1202291718450.11821@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1202291841110.14002@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils> <alpine.LSU.2.00.1202282128500.4875@eggly.anvils> <20120229194304.GF1673@cmpxchg.org> <alpine.LSU.2.00.1202291718450.11821@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comment to MEM_CGROUP_CHARGE_TYPE_MAPPED case in
__mem_cgroup_uncharge_common().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
This one incremental to patch already in mm-commits.

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- mm-commits/mm/memcontrol.c	2012-02-28 20:45:43.488100423 -0800
+++ linux/mm/memcontrol.c	2012-02-29 18:21:49.144702180 -0800
@@ -2953,6 +2953,11 @@ __mem_cgroup_uncharge_common(struct page
 
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		/*
+		 * Generally PageAnon tells if it's the anon statistics to be
+		 * updated; but sometimes e.g. mem_cgroup_uncharge_page() is
+		 * used before page reached the stage of being marked PageAnon.
+		 */
 		anon = true;
 		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
