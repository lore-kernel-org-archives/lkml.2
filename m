Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab2FENSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:18:07 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56042 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933634Ab2FENSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:18:06 -0400
MIME-Version: 1.0
Date: Tue, 5 Jun 2012 21:18:04 +0800
Message-ID: <CAJd=RBCnjtgT-2mmGsJsj3Xsv2uJe7xoHbkL-=_Mh+RTM+vTzg@mail.gmail.com>
Subject: [patch] BFS 421: a couple of cleanup cases
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Cc: Manuel Krause <manuelkrause@t-online.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

This is the first patch, namely cleanup, for 421.

I read messages says,

Interactivity: I have a usual work to be done. Loading & using Firefox with
many open tabs, downloading encoded video files, decoding them to shmfs/tmpfs
what is only partially backed by RAM (2GB RAM/ 4GB swap) and cutting,
watching them, office work in libreoffice, seldom DVD burning. In the
background there's always running an instance from worldcommunitygrid,
scheduled as SCHED_IDLE with Con Colivas's schedtool.

yeah, many things for 421 on Tualatin, and I am really glad.

And I want to do/see works,
1, cleanup with s/cpus_xyz/cpumask_xyz/g
2, remove ISO (what advantages for designing/tuning scheduler?)
3, method to measure the temperature of global runqueue lock
4, method to measure the cache affinity for given workload
[please feel free to add your ideas]

in the near future.

Messages welcome:)
Hillf

--- a/kernel/sched/bfs.c	Tue Jun  5 20:37:08 2012
+++ b/kernel/sched/bfs.c	Tue Jun  5 20:44:12 2012
@@ -113,7 +113,6 @@
 #define USER_PRIO(p)		((p) - MAX_RT_PRIO)
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-#define SCHED_PRIO(p)		((p) + MAX_RT_PRIO)
 #define STOP_PRIO		(MAX_RT_PRIO - 1)

 /*
@@ -313,7 +312,6 @@ struct rq {
 };

 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-static DEFINE_MUTEX(sched_hotcpu_mutex);

 #ifdef CONFIG_SMP
 /*
--
