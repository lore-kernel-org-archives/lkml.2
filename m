Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0DDOhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:37:23 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53038 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0DDOg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q+1FdMITEIUEwLX3h5MadkZKEuIWSPlPTbaHdKruf+PA8X5Yxy9hruTaYwH6YYj0Xi
         m2mu/AjioCOxx1HWKuoRSWx5O8Yj1YJippv/jb1KgKqP61izkzaqfYpURJ/vo5D6IuaV
         w4HKuuzut7dUl6UwAAnIyTZj4CoJK4xlGlv/s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/4] perf_event: Make perf fd non seekable
Date: Sun,  4 Apr 2010 16:36:43 +0200
Message-Id: <1270391804-6552-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
References: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

Perf_event does not need seeking, so prevent it in order to
get rid of default_llseek, which uses the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
[drop the nonseekable_open, not needed for anon inodes]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 63fbce1..4aa50ff 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2645,6 +2645,7 @@ static int perf_fasync(int fd, struct file *filp, int on)
 }
 
 static const struct file_operations perf_fops = {
+	.llseek			= no_llseek,
 	.release		= perf_release,
 	.read			= perf_read,
 	.poll			= perf_poll,
-- 
1.6.2.3

