Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0LTOSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:18:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab0LTOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:18:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mHJTYIzYsKOWKKxtoJMkXSwjFhTFvhI03YU3yhwcsHLD7ZEImxB2sNH3T5pD3nxt/x
         OTy9X/1DAfDYUc+hZ+VXho2iYOSkzIFhg3/CBfWjn3GO4pgMY0mJ3qgiQ/2flwC0tj6x
         cLlRnsVX9nf4LBEkUUMwCrC0wXpCnXsnUf47A=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] perf-tools: make perf-probe -L display the absolute path of the dumped file
Date: Mon, 20 Dec 2010 15:18:00 +0100
Message-Id: <1292854685-8230-2-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

The actual file used by 'perf probe -L sched.c' is reported in the
ouput of the command.

But it's simply displayed as it has been given to the command (simply
sched.c) which is too ambiguous to be really usefull since several
sched.c files can be found into the same project and we also don't
know which search path has been used.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 558545e..6fa0403 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -381,7 +381,7 @@ int show_line_range(struct line_range *lr, const char *module)
 		fprintf(stdout, "<%s:%d>\n", lr->function,
 			lr->start - lr->offset);
 	else
-		fprintf(stdout, "<%s:%d>\n", lr->file, lr->start);
+		fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
 
 	fp = fopen(lr->path, "r");
 	if (fp == NULL) {
-- 
1.7.3.2

