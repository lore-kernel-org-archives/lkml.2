Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935000Ab1KJD2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:28:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934208Ab1KJD2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:12 2011
Message-Id: <20111109212712.878820377@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [122/262] /proc/self/numa_maps: restore "huge" tag for hugetlb vmas
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit fc360bd9cdcf875639a77f07fafec26699c546f3 upstream.

The display of the "huge" tag was accidentally removed in 29ea2f698 ("mm:
use walk_page_range() instead of custom page table walking code").

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Tested-by: Stephen Hemminger <shemminger@vyatta.com>
Reviewed-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1039,6 +1039,9 @@ static int show_numa_map(struct seq_file
 		seq_printf(m, " stack");
 	}
 
+	if (is_vm_hugetlb_page(vma))
+		seq_printf(m, " huge");
+
 	walk_page_range(vma->vm_start, vma->vm_end, &walk);
 
 	if (!md->pages)


