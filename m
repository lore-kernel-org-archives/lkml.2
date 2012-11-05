Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2KEXYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:24:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964927Ab2KEXYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:24:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,718,1344236400"; 
   d="scan'208";a="213808715"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mtk.manpages@gmail.com
Subject: Updated MMAP/SHMGET 1GB patchkit
Date: Mon,  5 Nov 2012 15:24:07 -0800
Message-Id: <1352157848-29473-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the updated patchkit to allow to use 1GB pages for mmap/shmget
directly. This is needed for various software and makes it far more
convenient to use 1GB pages.

There were a lot of discussions on the ABI of v6 due to a conflict of
the new bits with the NOMMU only feature MAP_UNINITIALIZED.

However I don't think this matters at all because this feature
only works with HUGETLBFS and HUGETLBFS and NOMMU are mutually
exclusive. So any architecture which suppors HUGETLBFS will
never do MAP_UNINITIALIZED and vice versa. So there's no 
actual conflict in these flags.

Based on that I don't think any changes are needed.

So I decided to just repost with a rebase. 

Please consider applying,

Thanks,
-Andi

