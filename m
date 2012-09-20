Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2ITRHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:07:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2ITRHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:07:01 -0400
Date: Thu, 20 Sep 2012 10:06:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jongman Heo <jongman.heo@samsung.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.7] workqueue: remove spurious
 WARN_ON_ONCE(in_irq()) from try_to_grab_pending()
Message-ID: <20120920170656.GB28934@google.com>
References: <20120920132548.GA26189@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920132548.GA26189@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7c6e72e46c9ea4a88f3f8ba96edce9db4bd48726 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 20 Sep 2012 10:03:19 -0700

e0aecdd874 ("workqueue: use irqsafe timer for delayed_work") made
try_to_grab_pending() safe to use from irq context but forgot to
remove WARN_ON_ONCE(in_irq()).  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 kernel/workqueue.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4f5c61f..143fd8c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1070,8 +1070,6 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 {
 	struct global_cwq *gcwq;
 
-	WARN_ON_ONCE(in_irq());
-
 	local_irq_save(*flags);
 
 	/* try to steal the timer if it exists */
-- 
1.7.7.3

