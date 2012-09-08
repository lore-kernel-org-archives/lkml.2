Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab2IHArH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:47:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52347 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab2IHArA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:47:00 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 10/12] tools lib traceevent: replace mempcpy with memcpy
Date: Sat,  8 Sep 2012 03:43:22 +0300
Message-Id: <1347065004-15306-11-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

mempcpy is not supported by bionic in Android
and will lead to compilation errors.

Replacing mempcpy with memcpy so it will work in Android.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/lib/traceevent/event-parse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b5b4d80..c848fc3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4812,8 +4812,8 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
 		msg = strerror_r(errnum, buf, buflen);
 		if (msg != buf) {
 			size_t len = strlen(msg);
-			char *c = mempcpy(buf, msg, min(buflen-1, len));
-			*c = '\0';
+			memcpy(buf, msg, min(buflen - 1, len));
+			*(buf + min(buflen - 1, len)) = '\0';
 		}
 		return 0;
 	}
-- 
1.7.9.5

