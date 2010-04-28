Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0D1Bx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:53:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:40907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab0D1Bw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:52:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ian Munsie <imunsie@au.ibm.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] perf tools: Create $(OUTPUT)arch/$(ARCH)/util/ directory
Date: Tue, 27 Apr 2010 22:52:40 -0300
Message-Id: <1272419560-4332-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272419560-4332-1-git-send-email-acme@infradead.org>
References: <1272419560-4332-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that "make -C tools/perf O=/tmp/some/path" works again.

Problem introduced in:

cd932c5 "perf: Move arch specific code into separate arch director"

Cc: Ian Munsie <imunsie@au.ibm.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3ac6b67..b86f2ad 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -187,6 +187,8 @@ ifeq ($(ARCH),x86_64)
         ARCH := x86
 endif
 
+$(shell sh -c 'mkdir -p $(OUTPUT)arch/$(ARCH)/util/' 2> /dev/null)
+
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
-- 
1.6.2.5

