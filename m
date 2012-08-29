Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2H2Pzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:55:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43621 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2H2Pzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:55:38 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf: remove unneeded include of network header files
Date: Wed, 29 Aug 2012 09:55:32 -0600
Message-Id: <1346255732-93246-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf does not have networking related functionality, and the inclusion of
these headers is one of the causes of compile failures for Android:
  https://lkml.org/lkml/2012/8/23/316
  https://lkml.org/lkml/2012/8/28/293

So, remove them.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/util.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 00a93a9..67a3713 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -69,11 +69,6 @@
 #include <sys/poll.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
-#include <sys/select.h>
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-#include <arpa/inet.h>
-#include <netdb.h>
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 #include "types.h"
-- 
1.7.10.1

