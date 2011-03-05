Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1CESte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 13:49:34 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:42884 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1CEStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 13:49:33 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] mm: remove inline from scan_swap_map
Date: Sat,  5 Mar 2011 15:49:16 -0300
Message-Id: <1299350956-5614-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scan_swap_map is a large function (224 lines), with several loops and a
complex control flow involving several gotos.

Given all that, it is a bit silly that is is marked as inline. The
compiler agrees with me: on a x86-64 compile, it did not inline the
function.

Remove the "inline" and let the compiler decide instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 mm/swapfile.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0341c57..8ed42e7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -212,8 +212,8 @@ static int wait_for_discard(void *word)
 #define SWAPFILE_CLUSTER	256
 #define LATENCY_LIMIT		256
 
-static inline unsigned long scan_swap_map(struct swap_info_struct *si,
-					  unsigned char usage)
+static unsigned long scan_swap_map(struct swap_info_struct *si,
+				   unsigned char usage)
 {
 	unsigned long offset;
 	unsigned long scan_base;
-- 
1.7.4

