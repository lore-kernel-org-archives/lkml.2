Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab2EVMst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:48:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42986 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab2EVMsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:48:45 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 20:48:44 +0800
Message-ID: <CAJd=RBDyrLuVYuZsmJ8H_iZ1y1W_-WKqL+=xmn4-sKTfkBMphw@mail.gmail.com>
Subject: Re: BFS 420: add sched_info_dequeued
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corresponding to sched_info_queued when tasks are enqueued, sched_info_dequeued
is added when task is dequeued, just for fair play.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Tue May 22 20:01:36 2012
@@ -3087,6 +3087,7 @@ task_struct *earliest_deadline_task(stru

 out_take:
 	take_task(cpu, edt);
+	sched_info_dequeued(edt);
 	return edt;
 }

--
