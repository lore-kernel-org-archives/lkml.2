Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422692Ab2JLKWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:22:24 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37519 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422665Ab2JLKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:22:23 -0400
Date: Fri, 12 Oct 2012 03:19:32 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH] mm: vmevent: Report number of used swap pages, not total
 amount of swap
Message-ID: <20121012101932.GA30179@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the actual intent was to report the number of used swap pages, not
just total swap size.

This patch fixes the issue.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 mm/vmevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmevent.c b/mm/vmevent.c
index 1c2e72e..a059bed 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -46,7 +46,7 @@ static u64 vmevent_attr_swap_pages(struct vmevent_watch *watch,
 
 	si_swapinfo(&si);
 
-	return si.totalswap;
+	return si.totalswap - si.freeswap;
 #else
 	return 0;
 #endif
-- 
1.7.12.1
