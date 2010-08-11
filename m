Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab0HKCTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:19:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36778 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab0HKCTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=MOMRZWNAJcj3pmNvgFxsaTUV7yLi2lUcI5IS2rZ+2JwHlrqGs/MgNOTuqB8QXuKF1Z
         ofk/O95lCGtoAUQWzrOpIxt//Oh6lrjYa+oXnCk4kA307PEb2xdeQJRcQ1vaLnX35Ez3
         i7YEErf1f/+jjgsUaPyxaSllwu+TfWnHderhs=
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: fix a mismatch between code and comment
Date: Wed, 11 Aug 2010 11:19:19 +0900
Message-Id: <1281493159-2574-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pcpu_build_alloc_info() searches best_upa value, it ignores current value
if the number of waste units exceeds 1/3 of the number of total cpus. But the
comment on the code says that it will ignore if wastage is over 25%.
Modify the comment.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---

 I used -U5 rather than 3 for you to see the mismatch at a glance. :-)

 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 9581f84..5e78131 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1174,11 +1174,11 @@ struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 			allocs += this_allocs;
 			wasted += this_allocs * upa - group_cnt[group];
 		}
 
 		/*
-		 * Don't accept if wastage is over 25%.  The
+		 * Don't accept if wastage is over 1/3.  The
 		 * greater-than comparison ensures upa==1 always
 		 * passes the following check.
 		 */
 		if (wasted > num_possible_cpus() / 3)
 			continue;
-- 
1.7.0.4

