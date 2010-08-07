Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab0HGM1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 08:27:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:36979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab0HGM1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 08:27:02 -0400
Message-ID: <4C5D50FD.1060505@kernel.org>
Date: Sat, 07 Aug 2010 14:26:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: add __percpu notations to UP allocator
References: <1281119187-12640-2-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281119187-12640-2-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 12:27:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 94cb121c9483f1ec9b1ef0c249fbfc49c628fa6b Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@gmail.com>
Date: Sat, 7 Aug 2010 03:26:24 +0900

Add __percpu notations to UP percpu allocator.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to percpu#for-linus w/ slight commit description updates.

Thanks.

 mm/percpu_up.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/percpu_up.c b/mm/percpu_up.c
index c4351c7..db884fa 100644
--- a/mm/percpu_up.c
+++ b/mm/percpu_up.c
@@ -14,13 +14,13 @@ void __percpu *__alloc_percpu(size_t size, size_t align)
 	 * percpu sections on SMP for which this path isn't used.
 	 */
 	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return kzalloc(size, GFP_KERNEL);
+	return (void __percpu __force *)kzalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(__alloc_percpu);

 void free_percpu(void __percpu *p)
 {
-	kfree(p);
+	kfree(this_cpu_ptr(p));
 }
 EXPORT_SYMBOL_GPL(free_percpu);

-- 
1.7.1

