Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1DNRrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:38493 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab1DNRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Steven J. Magnani" <steve@digidescorp.com>,
        Greg Ungerer <gerg@snapgear.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 093/209] nommu: yield CPU while disposing VM
Date: Thu, 14 Apr 2011 13:42:03 -0400
Message-Id: <1302803039-9400-94-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven J. Magnani <steve@digidescorp.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 04c3496152394d17e3bc2316f9731ee3e8a026bc upstream.

Depending on processor speed, page size, and the amount of memory a
process is allowed to amass, cleanup of a large VM may freeze the system
for many seconds.  This can result in a watchdog timeout.

Make sure other tasks receive some service when cleaning up large VMs.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/nommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 28994ee..1fc13c0 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1669,6 +1669,7 @@ void exit_mmap(struct mm_struct *mm)
 		mm->mmap = vma->vm_next;
 		delete_vma_from_mm(vma);
 		delete_vma(mm, vma);
+		cond_resched();
 	}
 
 	kleave("");
-- 
1.7.4.4

