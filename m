Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2EYNdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:33:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35555 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2EYNc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:32:59 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 21:32:58 +0800
Message-ID: <CAJd=RBBXmVUX9b1Y8Lx8Dwt5PL3j_gLoPzkh0apT5pZAuBny6Q@mail.gmail.com>
Subject: [patch 1/4] BFS 420: fix ttwu_post_activation
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If not activated successfully, no need to change task state.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Fri May 25 20:28:00 2012
@@ -1534,6 +1534,8 @@ static inline void ttwu_post_activation(
 					bool success)
 {
 	trace_sched_wakeup(p, success);
+	if (!success)
+		return;
 	p->state = TASK_RUNNING;

 	/*
--
