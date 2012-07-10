Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2GJVse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:48:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2GJVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:48:31 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/4] perf kvm: limit repetitive guestmount message to once
Date: Tue, 10 Jul 2012 15:48:13 -0600
Message-Id: <1341956894-69284-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1341956894-69284-1-git-send-email-dsahern@gmail.com>
References: <1341956894-69284-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 7ed97ad use of the guestmount option without a subdir for each
VM generates an error message for *each* sample related to that VM. Once
is enough.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/map.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 8668569..641377e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -8,6 +8,7 @@
 #include <unistd.h>
 #include "map.h"
 #include "thread.h"
+#include "asm/bug.h"
 
 const char *map_type__name[MAP__NR_TYPES] = {
 	[MAP__FUNCTION] = "Functions",
@@ -695,7 +696,7 @@ struct machine *machines__findnew(struct rb_root *self, pid_t pid)
 	    (symbol_conf.guestmount)) {
 		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
 		if (access(path, R_OK)) {
-			pr_err("Can't access file %s\n", path);
+			WARN_ONCE(1, "Can't access file %s\n", path);
 			machine = NULL;
 			goto out;
 		}
-- 
1.7.10.1

