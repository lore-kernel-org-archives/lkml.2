Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab1EYMnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:43:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47406 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab1EYMnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ubZjHX2Fj+BieLw/DLTbEZQvFhxoXB8VONqJuNMW0w/niblFFFCJHnmIzNboyP7rQF
         583Nu1UUD6SBZH8KG85M1pN1gBfzx5P/9UUuy2RQZ+0Y9h1YOFIPN7Fz0+DcxdILzJ2r
         mfvLQUkw++bRx+Q/UKiuJsAQvvA0gcABDdVdU=
MIME-Version: 1.0
Date: Wed, 25 May 2011 20:42:59 +0800
Message-ID: <BANLkTimT+Tut-3TshCDm-NiLLXrOznibNA@mail.gmail.com>
Subject: [PATCH] sched: remove noop in lowest_flag_domain()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for the validity of sd is removed, since it is already
checked by the for_each_domain macro.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/kernel/sched_fair.c	Sat May 14 15:21:56 2011
+++ sched_fair.c	Wed May 25 20:15:34 2011
@@ -3652,7 +3652,7 @@ static inline struct sched_domain *lowes
 	struct sched_domain *sd;

 	for_each_domain(cpu, sd)
-		if (sd && (sd->flags & flag))
+		if (sd->flags & flag)
 			break;

 	return sd;
