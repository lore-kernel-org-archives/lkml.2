Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0IGBdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:33:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49170 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab0IGBdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:33:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 7 Sep 2010 10:28:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, andi.kleen@intel.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 0/3] memory hotplug: updates and bugfix for is_removable v3
Message-Id: <20100907102813.d633b8ef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for review and comments. totally updated.

Problem:

/sys/devices/system/memory/memoryX/removable file shows whether the section
can be offlined or not. Returns "1" if it seems removable.
 
Now, the file uses a similar logic to one offline_pages() uses.
Then, it's better to use unified logic.

The biggest change from previous one is this patch just unifies is_removable()
and offline code's logic. No functional change in offline() code.
(is_removable code is updated to be better.)


Brief patch description:
1. bugfix for is_removable() check. I think this should be back ported. (updated)
2. bugfix for callback at counting immobile pages. (no change)
3. the unified new logic for is_remobable. (updated)

Because I'm moving house, my response may be delayd.

Thanks,
-Kame

