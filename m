Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1JSAow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:44:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48115 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1JSAov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:44:51 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, fweisbec@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: add prelink suggestion to dso update message
Date: Tue, 18 Oct 2011 18:44:45 -0600
Message-Id: <1318985085-20776-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a prelink run mapped files for long running processes
can show as deleted. The current message suggests restarting
long running processes. Add to that a suggestion that prelink
might be the cause.

Old message:
/lib64/libc-2.14.so was updated, restart the long running
 apps that use it!

New message:
/lib64/libc-2.14.so was updated (is prelink enabled?).
  Restart the long running apps that use it!

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/map.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9cf0d43..78284b1 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -139,8 +139,8 @@ int map__load(struct map *self, symbol_filter_t filter)
 
 		if (len > sizeof(DSO__DELETED) &&
 		    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
-			pr_warning("%.*s was updated, restart the long "
-				   "running apps that use it!\n",
+			pr_warning("%.*s was updated (is prelink enabled?). "
+				"Restart the long running apps that use it!\n",
 				   (int)real_len, name);
 		} else {
 			pr_warning("no symbols found in %s, maybe install "
-- 
1.7.6.4

