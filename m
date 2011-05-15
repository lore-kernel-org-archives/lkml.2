Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815Ab1EOCuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 22:50:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39745 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1EOCuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 22:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aA6hfHDLwyF9Z4fOHQEuoqpp4aCZ4Ac2cagjUM2EUXDbG76ZMFfD/3elVFw4byiAXI
         93Bw00u+dK/6EJi6Y3bo5SeBgE8cQsbc+bgkfnplqkGsna5L1+kKDNT57lS59oML966H
         FqXRuf//PJyIegxgFxBK6c4h7sTTxSeX+PAys=
MIME-Version: 1.0
Date: Sun, 15 May 2011 10:50:48 +0800
Message-ID: <BANLkTinw9LLiGD788+6AvbE+54jyVRUwBg@mail.gmail.com>
Subject: [PATCH] sched: fix how RT task is pulled
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pulling RT task for a given runqueue, if it is already overloaded
with RT tasks, the pull operation could be avoided at the moment.

btw, it looks like a typo?

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 19ecb31..14c764b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1440,7 +1440,7 @@ static int pull_rt_task(struct rq *this_rq)
 	struct task_struct *p;
 	struct rq *src_rq;

-	if (likely(!rt_overloaded(this_rq)))
+	if (unlikely(rt_overloaded(this_rq)))
 		return 0;

 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
