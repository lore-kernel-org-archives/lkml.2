Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1DRM1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:27:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53948 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1DRM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tDlY9rOuJS9kixs+hW5t5+WpCjSrpqA6TBA1Lha/uQTBSjnl26trXLzxBCcobhHy2R
         OBRz4BMuvKJpkeedczABAftskJIBjJrnvxSEZ2RWpitl7XCa0XgX4Whtc9Hf6Ftx7rqp
         SB8He/IbQonfOpDX/iB3JcYEsvBJmvIxnWV9A=
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 20:27:32 +0800
Message-ID: <BANLkTi=kEvVCwxd=g65jBGTzmZD_KtT92w@mail.gmail.com>
Subject: [PATCH] sched: remove hrtick_enabled()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function, hrtick_enabled(), could be removed, since it is not used
anywhere, though defined.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
+++ b/kernel/sched.c	2011-04-18 20:28:22.000000000 +0800
@@ -994,20 +994,6 @@ static struct rq *this_rq_lock(void)
  * rq->lock.
  */

-/*
- * Use hrtick when:
- *  - enabled by features
- *  - hrtimer is actually high res
- */
-static inline int hrtick_enabled(struct rq *rq)
-{
-	if (!sched_feat(HRTICK))
-		return 0;
-	if (!cpu_active(cpu_of(rq)))
-		return 0;
-	return hrtimer_is_hres_active(&rq->hrtick_timer);
-}
-
 static void hrtick_clear(struct rq *rq)
 {
 	if (hrtimer_active(&rq->hrtick_timer))
