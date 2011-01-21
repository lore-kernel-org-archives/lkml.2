Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1AUGkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:40:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36539 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1AUGke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:40:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 15:34:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/7] memcg : more fixes and clean up for 2.6.28-rc
Message-Id: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a set of patches which I'm now testing, and it seems it passed
small test. So I post this.

Some are bug fixes and other are clean ups but I think these are for 2.6.38.

Brief decription

[1/7] remove buggy comment and use better name for mem_cgroup_move_parent()
      The fixes for mem_cgroup_move_parent() is already in mainline, this is
      an add-on.

[2/7] a bug fix for a new function mem_cgroup_split_huge_fixup(),
      which was recently merged.

[3/7] prepare for fixes in [4/7],[5/7]. This is an enhancement of function
      which is used now.

[4/7] fix mem_cgroup_charge() for THP. By this, memory cgroup's charge function
      will handle THP request in sane way.

[5/7] fix khugepaged scan condition for memcg.
      This is a fix for hang of processes under small/buzy memory cgroup.

[6/7] rename vairable names to be page_size, nr_pages, bytes rather than
      ambiguous names.

[7/7] some memcg function requires the caller to initialize variable
      before call. It's ugly and fix it.


I think patch 1,2,3,4,5 is urgent ones. But I think patch "5" needs some
good review. But without "5", stress-test on small memory cgroup will not
run succesfully.

Thanks,
-Kame

