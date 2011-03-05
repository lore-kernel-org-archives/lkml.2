Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1CEQtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:49:22 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:60609 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1CEQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 05/24] sys_swapon: simplify error return from swap_info allocation
Date: Sat,  5 Mar 2011 13:42:06 -0300
Message-Id: <1299343345-3984-6-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point in sys_swapon, there is nothing to free. Return directly
instead of jumping to the cleanup block at the end of the function.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 91ca0f0..8969b37 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1918,10 +1918,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		return -EPERM;
 
 	p = alloc_swap_info();
-	if (IS_ERR(p)) {
-		error = PTR_ERR(p);
-		goto out;
-	}
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
 	name = getname(specialfile);
 	error = PTR_ERR(name);
-- 
1.7.4

