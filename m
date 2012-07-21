Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2GUAac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:30:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43863 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2GUAa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:30:29 -0400
Date: Fri, 20 Jul 2012 17:28:25 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 4/4] kdb: Switch to nolock variants of kmsg_dump functions
Message-ID: <20120721002825.GD2213@lizard>
References: <20120721002529.GA20567@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120721002529.GA20567@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locked variants are prone to deadlocks (suppose we got to the
debugger w/ the logbuf lock held), so let's switch to nolock
variants.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/debug/kdb/kdb_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index df17c93..1f91413 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2072,8 +2072,8 @@ static int kdb_dmesg(int argc, const char **argv)
 		kdb_set(2, setargs);
 	}
 
-	kmsg_dump_rewind(&dumper);
-	while (kmsg_dump_get_line(&dumper, 1, NULL, 0, NULL))
+	kmsg_dump_rewind_nolock(&dumper);
+	while (kmsg_dump_get_line_nolock(&dumper, 1, NULL, 0, NULL))
 		n++;
 
 	if (lines < 0) {
@@ -2105,8 +2105,8 @@ static int kdb_dmesg(int argc, const char **argv)
 	if (skip >= n || skip < 0)
 		return 0;
 
-	kmsg_dump_rewind(&dumper);
-	while (kmsg_dump_get_line(&dumper, 1, buf, sizeof(buf), &len)) {
+	kmsg_dump_rewind_nolock(&dumper);
+	while (kmsg_dump_get_line_nolock(&dumper, 1, buf, sizeof(buf), &len)) {
 		if (skip) {
 			skip--;
 			continue;
-- 
1.7.10.4
