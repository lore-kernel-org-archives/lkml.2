Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab0EMRrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:47:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49243 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0EMRrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :mime-version:content-type:content-transfer-encoding;
        b=MoFUBlqfNv4bSkKDqaAYC/JIQRWDSv5PWGzXC8Q4IS/uMeVZFHYBdS20zKERoGV1Gk
         kRvgiP4TyG25XOVMxsi+utjNO6uYhB2PmK4xgRZ1md7KMBq9qN8lF2m7m1UOmw5wUmGg
         6f6+VMjvfJNGMLcOoNIySBUvmbSKr9x1hv5SU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Fix missing getline declaration
Date: Thu, 13 May 2010 19:47:16 +0200
Message-Id: <1273772836-11533-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hist.c needs to include util.h so that it gets stdio.h
inclusion with __GNU_SOURCE defined.

Fixes:
	util/hist.c: In function ‘hist_entry__parse_objdump_line’:
	util/hist.c:931: erreur: implicit declaration of function ‘getline’
	util/hist.c:931: erreur: nested extern declaration of ‘getline’

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/hist.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 451d2e4..5dc4f84 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,3 +1,4 @@
+#include "util.h"
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
-- 
1.6.2.3

