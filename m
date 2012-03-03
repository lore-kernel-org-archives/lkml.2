Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661Ab2CCAJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:09:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38822 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489Ab2CCAJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:09:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of anton.vorontsov@linaro.org designates 10.205.130.12 as permitted sender) smtp.mail=anton.vorontsov@linaro.org
Date: Sat, 3 Mar 2012 04:09:09 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 1/3] vmevent: Fix build for SWAP=n case
Message-ID: <20120303000909.GA30207@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caught this build failure:

  CC      mm/vmevent.o
mm/vmevent.c:17:6: error: expected identifier or '(' before numeric constant
mm/vmevent.c:18:1: warning: no semicolon at end of struct or union [enabled by default]
mm/vmevent.c: In function 'vmevent_sample':
mm/vmevent.c:84:36: error: expected identifier before numeric constant
make[1]: *** [mm/vmevent.o] Error 1
make: *** [mm/] Error 2

This is because linux/swap.h defines nr_swap_pages to 0L, and so things
break.

Fix this by undefinding it back, as we don't use it anyway.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

The patch is for git://github.com/penberg/linux.git vmevent/core.

 mm/vmevent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmevent.c b/mm/vmevent.c
index 37d2c5f..2342752 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -6,6 +6,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
+#undef nr_swap_pages /* This is defined to a constant for SWAP=n case */
 
 #define VMEVENT_MAX_FREE_THRESHOD	100
 
-- 
1.7.7.6

