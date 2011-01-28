Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1A1D3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 22:29:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52172 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1A1D27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 22:28:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 12:22:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][PATCH 0/4] Fixes for memcg with THP
Message-Id: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On recent -mm, when I run make -j 8 under 200M limit of memcg, as
==
# mount -t cgroup none /cgroup/memory -o memory
# mkdir /cgroup/memory/A
# echo 200M > /cgroup/memory/A/memory.limit_in_bytes
# echo $$ > /cgroup/memory/A/tasks
# make -j 8 kernel
==

I see hangs with khugepaged. That's because memcg's memory reclaim
routine doesn't handle HUGE_PAGE request in proper way. And khugepaged
doesn't know about memcg.

This patch set is for fixing above hang. Patch 1-3 seems obvious and
has the same concept as patches in RHEL.

Patch 4 may need discussion. I think this version is much simpler
because I dropped almost all cosmetics. Please review.

This patch is onto mmotm-0125.

Thanks,
-Kame

