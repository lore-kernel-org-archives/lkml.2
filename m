Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1LSSjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:39:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1LSSiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:38:16 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [RFC][PATCH 3/3] pagemap: document KPF_THP and show make page-types aware of it
Date: Mon, 19 Dec 2011 13:38:39 -0500
Message-Id: <1324319919-31720-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page-types, which is a common user of pagemap, gets aware of thp
with this patch. This helps system admins and kernel hackers to know
about how thp works.
Here is a sample output of page-types over a thp:

  voffset offset  len     flags
  ...
  7f9d40200       3fd200  1       ___U_lA____Ma_b_______t____________
  7f9d40201       3fd201  1ff     ______________________t____________
  ...

  flags      page-count       MB  symbolic-flags                     long-symbolic-flags
  0x0000000000400000             511        1  ______________________t____________        thp
  0x0000000000405868               1        0  ___U_lA____Ma_b_______t____________        uptodate,lru,active,mmap,anonymous,swapbacked,thp

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 Documentation/vm/page-types.c |    2 ++
 Documentation/vm/pagemap.txt  |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git 3.2-rc5.orig/Documentation/vm/page-types.c 3.2-rc5/Documentation/vm/page-types.c
index 7445caa..0b13f02 100644
--- 3.2-rc5.orig/Documentation/vm/page-types.c
+++ 3.2-rc5/Documentation/vm/page-types.c
@@ -98,6 +98,7 @@
 #define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
 #define KPF_KSM			21
+#define KPF_THP			22
 
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
@@ -147,6 +148,7 @@ static const char *page_flag_names[] = {
 	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
 	[KPF_KSM]		= "x:ksm",
+	[KPF_THP]		= "t:thp",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
diff --git 3.2-rc5.orig/Documentation/vm/pagemap.txt 3.2-rc5/Documentation/vm/pagemap.txt
index df09b96..666d12b 100644
--- 3.2-rc5.orig/Documentation/vm/pagemap.txt
+++ 3.2-rc5/Documentation/vm/pagemap.txt
@@ -60,6 +60,7 @@ There are three components to pagemap:
     19. HWPOISON
     20. NOPAGE
     21. KSM
+    22. THP
 
 Short descriptions to the page flags:
 
@@ -97,6 +98,9 @@ Short descriptions to the page flags:
 21. KSM
     identical memory pages dynamically shared between one or more processes
 
+22. THP
+    continuous pages which construct transparent hugepages
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
-- 
1.7.7.3

