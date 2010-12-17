Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0LQM4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:56:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32889 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0LQM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mvkMo3mZxF53K8XRERnxqLhn0qdOuZumX+caonvVF6CNB9SYSHcxpEFrb7DXKye94g
         QXqMIo26f2eRCfhkinKPZndcSNV09npWxpaNjfhTbrZAA2bbslgMjEnrEofSaX3WVSvC
         2K4e2CHUVIBQqogjGdHvCFWyP6N2kV5KgB9gk=
MIME-Version: 1.0
Date: Fri, 17 Dec 2010 20:56:35 +0800
Message-ID: <AANLkTi=8yR1cQOTF5_0xebNAemrrgmqEpuGTyNENUXPm@mail.gmail.com>
Subject: [PATCH] remove noop in workqueue
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking WORKER_NOT_RUNNING in the flags word of worker is unnecessary
if it is set in the flags parameter.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/workqueue.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/workqueue.c	2010-12-17 20:57:00.000000000 +0800
@@ -770,7 +770,6 @@ static inline void worker_clr_flags(stru

 	/* if transitioning out of NOT_RUNNING, increment nr_running */
 	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
-		if (!(worker->flags & WORKER_NOT_RUNNING))
 			atomic_inc(get_gcwq_nr_running(gcwq->cpu));
 }
