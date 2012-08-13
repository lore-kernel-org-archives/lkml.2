Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2HMLRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:17:46 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47480 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2HMLRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:17:45 -0400
Message-ID: <5028E251.1070007@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:17:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 12/12] thp: remove unnecessary set_recommended_min_free_kbytes
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-1396-0000-0000-000001B4496C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is called in start_khugepaged

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6becf6c..6533956 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -225,9 +225,6 @@ static ssize_t enabled_store(struct kobject *kobj,
 			ret = err;
 	}

-	if (ret > 0 && khugepaged_enabled())
-		set_recommended_min_free_kbytes();
-
 	return ret;
 }
 static struct kobj_attribute enabled_attr =
@@ -562,8 +559,6 @@ static int __init hugepage_init(void)

 	start_khugepaged();

-	set_recommended_min_free_kbytes();
-
 	return 0;
 out:
 	hugepage_exit_sysfs(hugepage_kobj);
-- 
1.7.7.6

