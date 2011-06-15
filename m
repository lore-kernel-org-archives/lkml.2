Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1FONfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:35:31 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54879 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1FONfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:35:30 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] perf: clear out make flags when calling kernel make kernelver
Date: Wed, 15 Jun 2011 14:35:00 +0100
Message-Id: <1308144900-1945-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When generating the perf version from the kernel version using 'make
kernelver' it is necessary to clear out any MAKEFLAGS otherwise they may
trigger additional output which pollute the contents.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 tools/perf/util/PERF-VERSION-GEN |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 9c5fb4d..ad73300 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -23,7 +23,7 @@ if test -d ../../.git -o -f ../../.git &&
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	VN=$(make -sC ../.. kernelversion)
+	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
 fi
 
 VN=$(expr "$VN" : v*'\(.*\)')
-- 
1.7.4.1

