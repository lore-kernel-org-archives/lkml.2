Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1EYDNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:13:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40996 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab1EYDNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:13:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDC73B7.1050409@jp.fujitsu.com>
Date: Wed, 25 May 2011 12:12:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com
Subject: [PATCH 2/3] swap-token: makes global variables to function local
References: <4DD480DD.2040307@jp.fujitsu.com>	<4DD481A7.3050108@jp.fujitsu.com> <20110520123004.e81c932e.akpm@linux-foundation.org> <4DDB1388.2080102@jp.fujitsu.com>
In-Reply-To: <4DDB1388.2080102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

global_faults and last_aging are only used in grab_swap_token().
Then, they can be moved into grab_swap_token().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/thrash.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/thrash.c b/mm/thrash.c
index 0d41ff0..0504e8a 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -30,14 +30,14 @@
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
 struct mem_cgroup *swap_token_memcg;
-static unsigned int global_faults;
-static unsigned int last_aging;

 void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
 	unsigned int old_prio = mm->token_priority;
 	struct mem_cgroup *memcg;
+	static unsigned int global_faults;
+	static unsigned int last_aging;

 	global_faults++;

-- 
1.7.3.1



