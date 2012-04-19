Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2DSIzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:55:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58137 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2DSIzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:55:20 -0400
From: Sha Zhengju <handai.szj@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH RESEND] memcg: Free spare array to avoid memory leak
Date: Thu, 19 Apr 2012 16:54:50 +0800
Message-Id: <1334825690-9065-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

When the last event is unregistered, there is no need to keep the spare
array anymore. So free it to avoid memory leak.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>

---
Hi, Andrew

This patch has been reviewed days ago. Do you have any comments about it?

Thanks,
Sha
 
 mm/memcontrol.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22d94f5..3c09a84 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
 swap_buffers:
 	/* Swap primary and spare array */
 	thresholds->spare = thresholds->primary;
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare = NULL;
+	}
+
 	rcu_assign_pointer(thresholds->primary, new);
 
 	/* To be sure that nobody uses thresholds */
-- 
1.7.4.1

