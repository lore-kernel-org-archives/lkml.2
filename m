Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1COJeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1COJeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:03 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/15] GFS2: Fix glock queue trace point
Date: Tue, 15 Mar 2011 09:11:33 +0000
Message-Id: <1300180305-5993-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow this tracepoint landed up in the wrong place. This moves it
to where it should be.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c75d499..ddc3e1e 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -972,13 +972,13 @@ fail:
 			insert_pt = &gh2->gh_list;
 	}
 	set_bit(GLF_QUEUED, &gl->gl_flags);
+	trace_gfs2_glock_queue(gh, 1);
 	if (likely(insert_pt == NULL)) {
 		list_add_tail(&gh->gh_list, &gl->gl_holders);
 		if (unlikely(gh->gh_flags & LM_FLAG_PRIORITY))
 			goto do_cancel;
 		return;
 	}
-	trace_gfs2_glock_queue(gh, 1);
 	list_add_tail(&gh->gh_list, insert_pt);
 do_cancel:
 	gh = list_entry(gl->gl_holders.next, struct gfs2_holder, gh_list);
-- 
1.7.4

