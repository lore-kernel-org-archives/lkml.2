Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab1AMKUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:20:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35612 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1AMKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:20:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=f9r749U55Ly19PLNtLOiGlQjcHT+nEad5dkUWXK+qXdYOkrJtoiZp3xkW8ALBPbZeJ
         +4aNNTxBQ24oyIHM2WiDyBcIxyM060C1ggM9z1r0wNJbTnhIHwkMonk9O+7lskar8Hla
         ph2AE0AFNDYcroGimzM0BY+Fdl94Aft06VSmc=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf-probe: make "perf-probe -L <function>" display the absolute path and absolute line number
Date: Thu, 13 Jan 2011 11:20:24 +0100
Message-ID: <m38vyp85qv.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

It should be more usefull to get the full location of the function
(absolute line number + full path) instead of repeating the name of
the function and the start line number given by the command line.

So we had before:

   $ perf probe -L schedule | head -n3
   <schedule:0>
         0  asmlinkage void __sched schedule(void)
         1  {

and now we get:

   $ perf probe -L schedule | head -n3
   </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3813>
         0  asmlinkage void __sched schedule(void)
         1  {

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index fcbb543..bd09b87 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -382,11 +382,7 @@ int show_line_range(struct line_range *lr, const char *module)
 
 	setup_pager();
 
-	if (lr->function)
-		fprintf(stdout, "<%s:%d>\n", lr->function,
-			lr->start - lr->offset);
-	else
-		fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
+	fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
 
 	fp = fopen(lr->path, "r");
 	if (fp == NULL) {
-- 
1.7.3.2
