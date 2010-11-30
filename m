Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0K3WMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:12:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0K3WMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:12:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: acme@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/2] perf:  remove dep on -lelf during libaudit check
Date: Tue, 30 Nov 2010 17:12:12 -0500
Message-Id: <1291155133-3499-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If your machine does not have the elfutils-devel installed on it,
then the check of libaudit will fail even though the machine has
the audit-libs-devel package installed.

The check for -lelf is unneeded.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b3e6bc6..78ca0b5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -518,7 +518,7 @@ PERFLIBS = $(LIB_FILE)
 -include config.mak
 
 ifndef NO_AUDIT
-FLAGS_AUDIT=$(ALL_CFLAGS) -laudit $(ALL_LDFLAGS) $(EXTLIBS)
+FLAGS_AUDIT=$(ALL_CFLAGS) -laudit $(ALL_LDFLAGS)
 ifneq ($(call try-cc,$(SOURCE_AUDIT),$(FLAGS_AUDIT)),y)
 	msg := $(error No libaudit found. Please install audit-libs-dev/audit-libs-devel);
 	NO_AUDIT := 1
-- 
1.7.3.2

