Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0IFFpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:45:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59239 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab0IFFpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:45:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Sep 2010 14:40:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, andi.kleen@intel.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 0/3] memory hotplug: updates and bugfix for is_removable
Message-Id: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Problem:

/sys/devices/system/memory/memoryX/removable file shows whether the section
can be offlined or not. Returns "1" if it seems removable.

Now, the file uses a similar logic to one offline_pages() uses.
Problem here is.
 
  - removable detection logics of is_removable() and offline_pages() is
    different from each other.
  - The logic, which check MIGRATE_TYPE, tend to be incorrect once fragmented.
    MIGRATE_TYPE of a pageblock is just a hint, no guarantee.

Then, this patch set does.

  - use the same logic between is_removable() and offline_pages().
  - don't use MIGRATE_TYPE, check the memmap itself directly rather than hint.

Brief patch description:
 1. bugfix for is_removable() check. I think this should be back ported.
 2. bugfix for callback at counting immobile pages.
    I think the old logic rarely hits this bug..so, not necessary to backport.
 3. the unified new logic for is_remobable.

Only patch1 is CCed to stable for now and the patch series itself is onto
mmotm-08-27.

Thanks,
-Kame

