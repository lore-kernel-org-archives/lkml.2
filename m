Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2BFQaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:30:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58437 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2BFQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:30:05 -0500
Date: Mon, 6 Feb 2012 20:30:01 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 6/6] staging: android/lowmemorykiller: Do not kill kernel
 threads
Message-ID: <20120206163001.GF5117@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120203163056.GA4190@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LMK should not try killing kernel threads.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 6e800d3..ae38c39 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -138,6 +138,9 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		struct task_struct *p;
 		int oom_adj;
 
+		if (tsk->flags & PF_KTHREAD)
+			continue;
+
 		p = find_lock_task_mm(tsk);
 		if (!p)
 			continue;
-- 
1.7.7.6
