Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab0HEShn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:37:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59282 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0HEShm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:37:42 -0400
Date: Thu, 5 Aug 2010 20:37:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: n-horiguchi@ah.jp.nec.com, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        fengguang.wu@intel.com
Subject: Please pull hwpoison updates for 2.6.36
Message-ID: <20100805183734.GA9523@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the hwpoison updates for 2.6.36. This adds basic support for 
uncorrected memory MCA recovery for huge pages. I have some more stuff
(like better handling for slab errors) but it needs a bit more cooking, 
so currently only Horiguchi-san's code is included.

The rmap/hugetlb changes have been reviewed and blessed by the usual
suspects.  The rmap changes largely use existing infrastructure 
with just a few tweaks. There is no additional significant overhead for
the non error case.

-Andi

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison

Naoya Horiguchi (10):
      hugetlb: move definition of is_vm_hugetlb_page() to hugepage_inline.h
      hugetlb, rmap: add reverse mapping for hugepage
      HWPOISON, hugetlb: enable error handling path for hugepage
      HWPOISON, hugetlb: set/clear PG_hwpoison bits on hugepage
      HWPOISON, hugetlb: maintain mce_bad_pages in handling hugepage error
      HWPOISON, hugetlb: isolate corrupted hugepage
      HWPOISON, hugetlb: detect hwpoison in hugetlb code
      HWPOISON, hugetlb: support hwpoison injection for hugepage
      hwpoison: rename CONFIG
      hugetlb: add missing unlock in avoidcopy path in hugetlb_cow()

 include/linux/hugetlb.h        |   14 +---
 include/linux/hugetlb_inline.h |   22 +++++++
 include/linux/pagemap.h        |    9 +++-
 include/linux/poison.h         |    9 ---
 include/linux/rmap.h           |    5 ++
 mm/hugetlb.c                   |  104 ++++++++++++++++++++++++++++++++++-
 mm/hwpoison-inject.c           |   15 +++--
 mm/memory-failure.c            |  120 ++++++++++++++++++++++++++++++----------
 mm/rmap.c                      |   59 ++++++++++++++++++++
 9 files changed, 299 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/hugetlb_inline.h

-- 
ak@linux.intel.com -- Speaking for myself only.
