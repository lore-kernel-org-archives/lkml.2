Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1EJJEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:04:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52384 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1EJJEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:04:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 May 2011 17:57:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmotm 2011-05-06-16-39 uploaded
Message-Id: <20110510175746.0a1fbe40.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201105070015.p470FlAR013200@imap1.linux-foundation.org>
References: <201105070015.p470FlAR013200@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 May 2011 16:39:31 -0700
akpm@linux-foundation.org wrote:


> memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
> memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch

I'm very sorry that this fix is required for this logic.
==

next_scan_node_update is the time when scan_nodes nodemask should be updated.
Then, time_after() is correct. Otherwise, next-scan_node_update is intialized
to be 0 and time_before() returns always true, scan_nodes never be updated.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-May6/mm/memcontrol.c
===================================================================
--- mmotm-May6.orig/mm/memcontrol.c
+++ mmotm-May6/mm/memcontrol.c
@@ -1517,7 +1517,7 @@ static void mem_cgroup_may_update_nodema
 {
 	int nid;
 
-	if (time_before(mem->next_scan_node_update, jiffies))
+	if (time_after(mem->next_scan_node_update, jiffies))
 		return;
 
 	mem->next_scan_node_update = jiffies + 10*HZ;

