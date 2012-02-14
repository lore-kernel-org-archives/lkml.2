Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2BNDFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:05:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56866 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2BNDFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:05:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Feb 2012 12:04:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 0/6 v4] memcg: page cgroup diet
Message-Id: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is v4. I removed RFC and fixed a fatal bug in v3.

This patch series is a preparetion for removing page_cgroup->flags. To remove
it, we need to reduce flags on page_cgroup. In this set, PCG_MOVE_LOCK and
PCG_FILE_MAPPED are remvoed.

After this, we only have 3 bits.
==
enum {
        /* flags for mem_cgroup */
        PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
        PCG_USED, /* this object is in use. */
        PCG_MIGRATION, /* under page migration */
        __NR_PCG_FLAGS,
};
==

I'll make a try to merge this 3bits to lower 3bits of pointer to
memcg. Then, we can make page_cgroup 8(4)bytes per page.


Major changes since v3 are
 - replaced move_lock_page_cgroup() with move_lock_mem_cgroup().
   passes pointer to memcg rather than page_cgroup.

Working on linux-next feb13 and passed several tests.

Thanks,
-Kame

