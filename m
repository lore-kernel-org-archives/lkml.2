Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1KUO4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:56:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44762 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1KUO4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:56:09 -0500
Message-Id: <20111121145337.440663994@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 15:51:15 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/6] perf: Update the mmap control page on mmap()
References: <20111121145114.049265181@chello.nl>
Content-Disposition: inline; filename=perf-fix-userpage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently we didn't update the mmap control page right after mmap(),
which leads to surprises when userspace wants to use it.

Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/core.c |    2 ++
 1 file changed, 2 insertions(+)
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -3463,6 +3463,8 @@ static int perf_mmap(struct file *file, 
 	event->mmap_user = get_current_user();
 	vma->vm_mm->pinned_vm += event->mmap_locked;
 
+	perf_event_update_userpage(event);
+
 unlock:
 	if (!ret)
 		atomic_inc(&event->mmap_count);


