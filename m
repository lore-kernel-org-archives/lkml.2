Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0EJErx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:47:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48374 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0EJErO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y+pD+An0N0V0nDVf0GP6HKk2eK5ewB8N66Of5lwOxm7DFNjKhHcbJDT+dtsKqbCFN3
         8djYKHBRXhutEIZ9YtSSEuckMDMweQXCGLdn0eww7d1BThD1nvQrupYel17qJXhc6W0l
         PEHvRPASx06jeQ5n+/bajIVIw29/TuPsRlklc=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 7/9] perf/trace/scripting: failed-syscalls-by-pid script cleanup
Date: Sun,  9 May 2010 23:46:58 -0500
Message-Id: <1273466820-9330-8-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
References: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small fixe for the failed syscalls by pid script:

- silence the match output in the shell script

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
index 8c128ef..3029354 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
@@ -2,7 +2,7 @@
 # description: system-wide failed syscalls, by pid
 # args: [comm]
 if [ $# -gt 0 ] ; then
-    if ! expr match "$1" "-" ; then
+    if ! expr match "$1" "-" > /dev/null ; then
 	comm=$1
 	shift
     fi
-- 
1.6.4.GIT

