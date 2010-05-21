Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0EUKse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:48:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0EUKsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :mime-version:content-type:content-transfer-encoding;
        b=M/02raAGDOg9Jepxt72AgD7eyzy3E48xVRmADKTMMMG4VfquRBS0wds6z0XrsdCE5K
         ftaXJ1XLdwtX4vlKjYImP6alzhzg92cpmeIX8McRXDvVXkLdLFzpHOMmupROjpwQ3j5P
         eT8s40qu42pLjXtMUEi/01P0KldcOvvspa4O8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Fix getline undeclared
Date: Fri, 21 May 2010 12:48:39 +0200
Message-Id: <1274438919-5104-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to have stdio.h included with _GNU_SOURCEfopr getline, which
is broken with the inclusion of build-id.h.

Keep util.h included first in hist.c

Fixes:
	util/hist.c: Dans la fonction «hist_entry__parse_objdump_line» :
	util/hist.c:938: attention : déclaration implicite de la fonction « «getline» »
	util/hist.c:938: attention : nested extern declaration of «getline»
	make: *** [util/hist.o] Erreur 1

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/hist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 739c39f..009ad76 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,5 +1,5 @@
-#include "build-id.h"
 #include "util.h"
+#include "build-id.h"
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
-- 
1.6.2.3

