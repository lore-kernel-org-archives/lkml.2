Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1DMCUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:20:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43240 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1DMCUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:20:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/3] fremap: convert vm_flags to unsigned long long
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <20110413112002.41E8.A69D9226@jp.fujitsu.com>
References: <20110413084047.41DD.A69D9226@jp.fujitsu.com> <20110413112002.41E8.A69D9226@jp.fujitsu.com>
Message-Id: <20110413112043.41EC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 11:20:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 17ef533fc09249b167f9ff3ec47d92e52c5cfeb3 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 13 Apr 2011 09:29:56 +0900
Subject: [PATCH 2/3] fremap: convert vm_flags to unsigned long long

Anyway, unsigned int is completely wrong type.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/fremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index ec520c7..354031e 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -224,7 +224,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 		/*
 		 * drop PG_Mlocked flag for over-mapped range
 		 */
-		unsigned int saved_flags = vma->vm_flags;
+		unsigned long long saved_flags = vma->vm_flags;
 		munlock_vma_pages_range(vma, start, start + size);
 		vma->vm_flags = saved_flags;
 	}
-- 
1.7.3.1



