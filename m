Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1IWAyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:54:47 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:9882 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1IWAyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:54:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1316739284!13845810!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/thrash.c: quiet sparse noise
Date: Thu, 22 Sep 2011 17:54:33 -0700
User-Agent: KMail/1.9.9
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <riel@redhat.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221754.34162.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the following sparse noise:

warning: symbol 'swap_token_memcg' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---

diff --git a/mm/thrash.c b/mm/thrash.c
index e53f7d0..57ad495 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -29,7 +29,7 @@
 
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
-struct mem_cgroup *swap_token_memcg;
+static struct mem_cgroup *swap_token_memcg;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
