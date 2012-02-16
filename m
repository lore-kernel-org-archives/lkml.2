Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2BPNuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:50:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab2BPNqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:46:48 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 01/11] perf: Push file_update_time() into perf_mmap_fault()
Date: Thu, 16 Feb 2012 14:46:09 +0100
Message-Id: <1329399979-3647-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1329399979-3647-1-git-send-email-jack@suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Paul Mackerras <paulus@samba.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/events/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba36013..61a67f3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3316,8 +3316,10 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int ret = VM_FAULT_SIGBUS;
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
-		if (vmf->pgoff == 0)
+		if (vmf->pgoff == 0) {
 			ret = 0;
+			file_update_time(vma->vm_file);
+		}
 		return ret;
 	}
 
-- 
1.7.1

