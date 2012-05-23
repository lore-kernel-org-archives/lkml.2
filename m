Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2EWMzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:55:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60654 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EWMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:55:38 -0400
MIME-Version: 1.0
Date: Wed, 23 May 2012 20:55:37 +0800
Message-ID: <CAJd=RBBSn7WfYgUPdDY8eTd2cy-R6uR_YKV39z4rLvu0-BkCfQ@mail.gmail.com>
Subject: Re: BFS 420: fix clear_sticky when breaking sole affinity
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sticky bit is cleared after checking the task with the bit set for
given CPU.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Wed May 23 20:16:18 2012
@@ -5153,7 +5153,8 @@ static void break_sole_affinity(int src_
 				       task_pid_nr(p), p->comm, src_cpu);
 			}
 		}
-		clear_sticky(p);
+		if (task_sticky(p) && task_cpu(p) == src_cpu)
+			clear_sticky(p);
 	} while_each_thread(t, p);
 }

--
