Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab1C1E3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 00:29:12 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40790 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1C1E3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 00:29:10 -0400
Date: Mon, 28 Mar 2011 13:25:50 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH] memcg: update documentation to describe usage_in_bytes
Message-Id: <20110328132550.08be4389.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110328085508.c236e929.nishimura@mxp.nes.nec.co.jp>
References: <20110318152532.GB18450@tiehlicka.suse.cz>
	<20110321093419.GA26047@tiehlicka.suse.cz>
	<20110321102420.GB26047@tiehlicka.suse.cz>
	<20110322091014.27677ab3.kamezawa.hiroyu@jp.fujitsu.com>
	<20110322104723.fd81dddc.nishimura@mxp.nes.nec.co.jp>
	<20110322073150.GA12940@tiehlicka.suse.cz>
	<20110323092708.021d555d.nishimura@mxp.nes.nec.co.jp>
	<20110323133517.de33d624.kamezawa.hiroyu@jp.fujitsu.com>
	<20110328085508.c236e929.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 08:55:08 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > > Considering more, without these files, we cannot know the actual usage of
> > > a res_counter, although we set a limit to a res_counter. So, I want to keep
> > > these files.
> > > 
> > > If no-one have any objections, I'll prepare a patch to update the documentation.
> > > 
> > 
> > please.
> > 
> I'm sorry for my late response. I've been out of office because of a cold.
> I'll prepare the patch later.
> 
How about this ?

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Update the meaning of *.usage_in_bytes. They doesn't show the actual usage of
RSS+Cache(+Swap). They show the res_counter->usage for memory and memory+swap.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 Documentation/cgroups/memory.txt |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 7781857..ab7d4c1 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -52,8 +52,10 @@ Brief summary of control files.
  tasks				 # attach a task(thread) and show list of threads
  cgroup.procs			 # show list of processes
  cgroup.event_control		 # an interface for event_fd()
- memory.usage_in_bytes		 # show current memory(RSS+Cache) usage.
- memory.memsw.usage_in_bytes	 # show current memory+Swap usage
+ memory.usage_in_bytes		 # show current res_counter usage for memory
+				 (See 5.5 for details)
+ memory.memsw.usage_in_bytes	 # show current res_counter usage for memory+Swap
+				 (See 5.5 for details)
  memory.limit_in_bytes		 # set/show limit of memory usage
  memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
  memory.failcnt			 # show the number of memory usage hits limits
@@ -453,6 +455,16 @@ memory under it will be reclaimed.
 You can reset failcnt by writing 0 to failcnt file.
 # echo 0 > .../memory.failcnt
 
+5.5 usage_in_bytes
+
+As described in 2.1, memory cgroup uses res_counter for tracking and limiting
+the memory usage. memory.usage_in_bytes shows the current res_counter usage for
+memory, and DOESN'T show a actual usage of RSS and Cache. It is usually bigger
+than the actual usage for a performance improvement reason. If you want to know
+the actual usage, you can use memory.stat(see 5.2).
+It's the same for memory.memsw.usage_in_bytes, which shows the current
+res_counter usage for memory+swap.
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
-- 
1.7.1

