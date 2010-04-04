Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0DDOhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:37:41 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53038 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0DDOhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=LhxKOrWHL+LBccqdyeOfPfBIykvgiAijORDCR1CifBOVla2EQe7V/er49/vpptb1SI
         68AzY33Lev+UAm2EbSRbdKR4Tgp+2VLkX6q8WaVo1c0jD0fdBZfMPXcDyPFMDa8NWTfw
         v7fW0NabTZTp9vbQPDmVeNJRa0hfZUxTPUcVk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] Swap inclusion order of util.h and string.h in util/string.c
Date: Sun,  4 Apr 2010 16:36:44 +0200
Message-Id: <1270391804-6552-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
References: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

Currently util/string.c includes headers in this order: string.h, util.h
But this causes a build error because __USE_GNU definition
is needed for strndup() definition:

	% make -j
	touch .perf.dev.null
	    CC util/string.o
	cc1: warnings being treated as errors
	util/string.c: In function ‘argv_split’:
	util/string.c:171: error: implicit declaration of function ‘strndup’
	util/string.c:171: error: incompatible implicit declaration of built-in function ‘strndup’

So this patch swaps the headers inclusion order.
util.h defines _GNU_SOURCE, and /usr/include/features.h defines
__USE_GNU as 1 if _GNU_SOURCE is defined.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1270368798-27232-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/string.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index d438924..0409fc7 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,5 @@
-#include "string.h"
 #include "util.h"
+#include "string.h"
 
 #define K 1024LL
 /*
-- 
1.6.2.3

