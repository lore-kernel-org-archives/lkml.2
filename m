Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0J3N6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:58:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab0J3N6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:58:31 -0400
Message-ID: <4CCC2480.70303@kernel.org>
Date: Sat, 30 Oct 2010 15:58:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] percpu: zero memory more efficiently in mm/percpu.c::pcpu_mem_alloc()
References: <alpine.LNX.2.00.1010292354060.24561@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1010292354060.24561@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 13:58:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't do vmalloc() + memset() when vzalloc() will do.

tj: dropped unnecessary temp variable ptr.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied with slight modification.  Thank you.

 mm/percpu.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..9e16d1c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -293,12 +293,8 @@ static void *pcpu_mem_alloc(size_t size)

 	if (size <= PAGE_SIZE)
 		return kzalloc(size, GFP_KERNEL);
-	else {
-		void *ptr = vmalloc(size);
-		if (ptr)
-			memset(ptr, 0, size);
-		return ptr;
-	}
+	else
+		return vzalloc(size);
 }

 /**
-- 
1.7.1

