Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0KWOPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:15:21 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40710 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0KWOPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:15:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=CSpdxIBb4I6YeUII1YREhLii8b9zaWwXy/OQFRXrxUuURH7TaBDzqmM8mPsngvGIOx
         ftDX7xbllAJuWHL85jK9W4Cxc1aCCzxsTNwXeKfEHpspCpCHtHmnHd3NzXKlGmy4FExO
         vkagaQderF4cCRT/9bzeelIz8l0WalvhO1DSI=
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jreiser@BitWagon.com, Rabin Vincent <rabin@rab.in>
Subject: [PATCHv2 1/2] ftrace: ignore any ftrace.o in C version of recordmcount
Date: Tue, 23 Nov 2010 19:44:50 +0530
Message-Id: <1290521691-5101-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290454387.30543.304.camel@gandalf.stny.rr.com>
References: <1290454387.30543.304.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/kernel/ftrace.c references mcount like kernel/tracing/ftrace.c,
so change the exclusion filter to match any ftrace.o.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 scripts/recordmcount.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index f2f32ee..ac6e51c 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -357,7 +357,7 @@ do_file(char const *const fname)
 int
 main(int argc, char const *argv[])
 {
-	const char ftrace[] = "kernel/trace/ftrace.o";
+	const char ftrace[] = "/ftrace.o";
 	int ftrace_size = sizeof(ftrace) - 1;
 	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
 
-- 
1.7.2.3

