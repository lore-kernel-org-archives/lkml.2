Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1AZXbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:31:07 -0500
Received: from smtp-out.google.com ([74.125.121.67]:4586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1AZXat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:30:49 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: gregkh@suse.de, rjw@sisk.pl, mingo@redhat.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 6/6] taskstats: use appropriate printk priority level
Date: Wed, 26 Jan 2011 15:29:30 -0800
Message-Id: <1296084570-31453-7-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20110125235700.GR8008@google.com>
References: <20110125235700.GR8008@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk()s without a priority level default to KERN_WARNING. To reduce
noise at KERN_WARNING, this patch set the priority level appriopriately
for unleveled printks()s. This should be useful to folks that look at
dmesg warnings closely.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 kernel/taskstats.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 3971c6b..9ffea36 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -685,7 +685,7 @@ static int __init taskstats_init(void)
 		goto err_cgroup_ops;
 
 	family_registered = 1;
-	printk("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
+	pr_info("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
 	return 0;
 err_cgroup_ops:
 	genl_unregister_ops(&family, &taskstats_ops);
-- 
1.7.3.1

