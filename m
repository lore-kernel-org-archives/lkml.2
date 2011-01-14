Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1ANKKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:10:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42791 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1ANKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:10:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 14 Jan 2011 19:04:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>, hannes@cmpxchg.org,
        aarcange@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/4] [BUGFIX] thp vs memcg fix.
Message-Id: <20110114190412.73362cd7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, memcg is broken when used with THP in -mm. I thought I had more time but it's
now merged....so, I made a quick fix. I'm sorry for my laziness.

All patches are onto mmotm-Jan07. 

The issues are mainly on statistics accounting.
 - the number of anon pages in memcg.
 - the number of pages on LRU.
 - rmdir() will leak some accounts. etc.

Please see each patches for details. 

I don't have enough test time before positing, so please take this as quick
trial and give me strict review. And if you find another issues, please
notify me.

Testeres shoulld make CONFIG_TRANSPARENT_HUGEPAGE=y and
use 'always'. giving memory pressure, create/remove memory cgroup,
move tasks without account move. And see memory.stat file.

Thanks,
-Kame

