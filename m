Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1BYVGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:06:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33516 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1BYVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:06:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=o5zxEoLcyhDoEP3p8v5fxdFZmfDli+PNpKcwNzb0HUCCmcx60ju0gTL9BXq7zmH9t6
         dlIwqTKr+6n5CWSitI7ziNAiyql/YkJmT2Jb/sNjc5xgioIN2djsUqGZQHwORrQKKbF1
         A0uOPInSSG7ainVm9puSStI5CivEzZNFfn1WY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf: Fix missing strndup declaration
Date: Fri, 25 Feb 2011 22:05:56 +0100
Message-Id: <1298667956-20675-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1298667956-20675-1-git-send-email-fweisbec@gmail.com>
References: <1298667956-20675-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<ctype.h> is included first without _GNU_SOURCE, so it ends up
including <string.h> without declaring strndup(). And further
<string.h> declarations, even with _GNU_SOURCE defined, are
of course without effect.

Therefore:

	util/strfilter.c: Dans la fonction «strfilter_node__new» :
	util/strfilter.c:134: attention : déclaration implicite de la fonction « «strndup» »
	util/strfilter.c:134: attention : incompatible implicit declaration of built-in function «strndup»
	make: *** [util/strfilter.o] Erreur 1

Just don't include ctype.h as it doesn't appear to be necessary
anyway.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/strfilter.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/strfilter.c b/tools/perf/util/strfilter.c
index 4064b7d..834c8eb 100644
--- a/tools/perf/util/strfilter.c
+++ b/tools/perf/util/strfilter.c
@@ -1,4 +1,3 @@
-#include <ctype.h>
 #include "util.h"
 #include "string.h"
 #include "strfilter.h"
-- 
1.7.3.2

