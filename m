Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0EJErU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:47:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab0EJErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GO1bmfjvEcR2SFYaVnKxMIHY2777dalJdooc5COXdFlxmnS8oKOcZCfEYIX1EBM0MQ
         +FGmkUgvubdH82b2iA/z6Aahd0TvlEs/DjH19Q+jUg6i6/zpaETQJijT14glMciXsgxN
         cz10V2Yog7qQwGPN9BEK9MR30HMXxnAZawZs4=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 9/9] perf/trace/scripting: syscall-counts script cleanup
Date: Sun,  9 May 2010 23:47:00 -0500
Message-Id: <1273466820-9330-10-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
References: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 A small fix for the syscall counts script:

- silence the match output in the shell script

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/scripts/python/bin/syscall-counts-report b/tools/perf/scripts/python/bin/syscall-counts-report
index 8c21552..dc076b6 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-report
@@ -2,7 +2,7 @@
 # description: system-wide syscall counts
 # args: [comm]
 if [ $# -gt 0 ] ; then
-    if ! expr match "$1" "-" ; then
+    if ! expr match "$1" "-" > /dev/null ; then
 	comm=$1
 	shift
     fi
-- 
1.6.4.GIT

