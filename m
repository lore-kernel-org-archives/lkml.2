Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0HHMoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:44:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:36362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0HHMoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:44:13 -0400
Message-ID: <4C5EA651.7080009@kernel.org>
Date: Sun, 08 Aug 2010 14:42:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu: fix a memory leak in pcpu_extend_area_map()
References: <1281261197-8816-1-git-send-email-shijie8@gmail.com>
In-Reply-To: <1281261197-8816-1-git-send-email-shijie8@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 08 Aug 2010 12:43:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 206c53730b8b1707becca7a868ea8d14ebee24d2 Mon Sep 17 00:00:00 2001
From: Huang Shijie <shijie8@gmail.com>
Date: Sun, 8 Aug 2010 14:39:07 +0200

The original code did not free the old map.  This patch fixes it.

tj: use @old as memcpy source instead of @chunk->map, and indentation
    and description update

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Patch applied to percpu#for-linus w/ some updates.  Thanks a lot for
catching this.

 mm/percpu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index e61dc2c..a1830d8 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -393,7 +393,9 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk, int new_alloc)
 		goto out_unlock;

 	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
-	memcpy(new, chunk->map, old_size);
+	old = chunk->map;
+
+	memcpy(new, old, old_size);

 	chunk->map_alloc = new_alloc;
 	chunk->map = new;
-- 
1.7.1

