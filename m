Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2BFKHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:07:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60828 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab2BFKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:07:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Feb 2012 19:06:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC] [PATCH 0/6 v3] memcg: page cgroup diet
Message-Id: <20120206190627.7313ff82.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is my page_cgroup diet series v3. Since v2, "remove PCG_CACHE" is alread
merged.

This series changes page-stat-accounting per memcg 

from:
	if (change page's state)
		mem_cgroup_update_page_state()

to:
	mem_cgroup_begin_update_page_state()
	if (change page's state)
		mem_cgroup_update_page_state()
	mem_cgroup_end_update_page_state()

(see patch 4 for details.) This allows us not to duplicate page struct's
information in page_cgroup's flag field.

Because above sequence adds 2 extra calls to hot-path, performance will be problem.
Patch 6 is a fix for performance, and I don't see performance regression in my
small test. (see patch 6 for details.)

Thanks,
-Kame






