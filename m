Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1DMCWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:22:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43765 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1DMCWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:22:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/3] procfs: convert vm_flags to unsigned long long
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <20110413112002.41E8.A69D9226@jp.fujitsu.com>
References: <20110413084047.41DD.A69D9226@jp.fujitsu.com> <20110413112002.41E8.A69D9226@jp.fujitsu.com>
Message-Id: <20110413112120.41F0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 11:21:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d8bbb29c55e449a8f7e87e2b6ef529b1162aeba0 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 13 Apr 2011 09:39:13 +0900
Subject: [PATCH 3/3] procfs: convert vm_flags to unsigned long long

int is crazy mistake. ;-)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/task_mmu.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8caf687..51b9d98 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -211,7 +211,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
-	int flags = vma->vm_flags;
+	unsigned long long vm_flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
 	unsigned long start;
@@ -234,10 +234,10 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			start,
 			vma->vm_end,
-			flags & VM_READ ? 'r' : '-',
-			flags & VM_WRITE ? 'w' : '-',
-			flags & VM_EXEC ? 'x' : '-',
-			flags & VM_MAYSHARE ? 's' : 'p',
+			vm_flags & VM_READ ? 'r' : '-',
+			vm_flags & VM_WRITE ? 'w' : '-',
+			vm_flags & VM_EXEC ? 'x' : '-',
+			vm_flags & VM_MAYSHARE ? 's' : 'p',
 			pgoff,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
-- 
1.7.3.1



