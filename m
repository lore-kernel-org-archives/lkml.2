Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2G0Nx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:53:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60098 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2G0NxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:53:25 -0400
MIME-Version: 1.0
Date: Fri, 27 Jul 2012 21:53:24 +0800
Message-ID: <CAJd=RBDQ1J9UTWOK1x6XNYunFz36RsMnr1Om9HsQQ_Kp8P7RKQ@mail.gmail.com>
Subject: [RFC patch] vm: clear swap entry before copying pte
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If swap entry is cleared, we can see the reason that copying pte is
interrupted. If due to page table lock held long enough, no need to
increase swap count.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/memory.c	Fri Jul 27 21:33:32 2012
+++ b/mm/memory.c	Fri Jul 27 21:35:24 2012
@@ -971,6 +971,7 @@ again:
 		if (add_swap_count_continuation(entry, GFP_KERNEL) < 0)
 			return -ENOMEM;
 		progress = 0;
+		entry.val = 0;
 	}
 	if (addr != end)
 		goto again;
--
