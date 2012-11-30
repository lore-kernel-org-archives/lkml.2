Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2K3PCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:02:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:10715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454Ab2K3PCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:02:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="224784658"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Bob Liu <lliubbo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 0/2] kernel BUG at mm/huge_memory.c:212!
Date: Fri, 30 Nov 2012 17:03:39 +0200
Message-Id: <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <50B52E17.8020205@suse.cz>
References: <50B52E17.8020205@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Hi Jiri,

Sorry for late answer. It took time to reproduce and debug the issue.

Could you test two patches below by thread. I expect it to fix both
issues: put_huge_zero_page() and Bad rss-counter state.

Kirill A. Shutemov (2):
  thp: fix anononymous page accounting in fallback path for COW of HZP
  thp: avoid race on multiple parallel page faults to the same page

 mm/huge_memory.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

-- 
1.7.11.7

