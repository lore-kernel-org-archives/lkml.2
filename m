Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0JRXYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:24:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61155 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0JRXYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:24:01 -0400
MIME-Version: 1.0
X-Originating-IP: [196.201.218.251]
Date: Tue, 19 Oct 2010 02:24:00 +0300
Message-ID: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
Subject: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
From: Brian Gitonga Marete <marete@toshnix.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes compilation of the perf user-space tools on,
for example, gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) . It should not
break anything else.

Signed-off-by: Brian Gitonga Marete <marete@toshnix.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1950e19..64eb2ea 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -288,7 +288,7 @@ endif
 -include feature-tests.mak

 ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
-	CFLAGS := $(CFLAGS) -fstack-protector-all
+	CFLAGS := $(CFLAGS) -fstack-protector-all --param ssp-buffer-size=1
 endif

-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
