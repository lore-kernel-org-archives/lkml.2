Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab2LHOwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:52:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2LHOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:52:07 -0500
Date: Sat, 8 Dec 2012 06:51:20 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-zgcldbjno41jn02b15760k4p@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Stop using 'self' in pstack
Git-Commit-ID: 61e945150fe0ec4c20b7a3663b90c7ab705a88b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:51:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61e945150fe0ec4c20b7a3663b90c7ab705a88b4
Gitweb:     http://git.kernel.org/tip/61e945150fe0ec4c20b7a3663b90c7ab705a88b4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 10 Nov 2012 19:41:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:50:38 -0300

perf tools: Stop using 'self' in pstack

As suggested by tglx long ago.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zgcldbjno41jn02b15760k4p@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pstack.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index 13d36fa..daa17ae 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -17,59 +17,59 @@ struct pstack {
 
 struct pstack *pstack__new(unsigned short max_nr_entries)
 {
-	struct pstack *self = zalloc((sizeof(*self) +
-				     max_nr_entries * sizeof(void *)));
-	if (self != NULL)
-		self->max_nr_entries = max_nr_entries;
-	return self;
+	struct pstack *pstack = zalloc((sizeof(*pstack) +
+				       max_nr_entries * sizeof(void *)));
+	if (pstack != NULL)
+		pstack->max_nr_entries = max_nr_entries;
+	return pstack;
 }
 
-void pstack__delete(struct pstack *self)
+void pstack__delete(struct pstack *pstack)
 {
-	free(self);
+	free(pstack);
 }
 
-bool pstack__empty(const struct pstack *self)
+bool pstack__empty(const struct pstack *pstack)
 {
-	return self->top == 0;
+	return pstack->top == 0;
 }
 
-void pstack__remove(struct pstack *self, void *key)
+void pstack__remove(struct pstack *pstack, void *key)
 {
-	unsigned short i = self->top, last_index = self->top - 1;
+	unsigned short i = pstack->top, last_index = pstack->top - 1;
 
 	while (i-- != 0) {
-		if (self->entries[i] == key) {
+		if (pstack->entries[i] == key) {
 			if (i < last_index)
-				memmove(self->entries + i,
-					self->entries + i + 1,
+				memmove(pstack->entries + i,
+					pstack->entries + i + 1,
 					(last_index - i) * sizeof(void *));
-			--self->top;
+			--pstack->top;
 			return;
 		}
 	}
 	pr_err("%s: %p not on the pstack!\n", __func__, key);
 }
 
-void pstack__push(struct pstack *self, void *key)
+void pstack__push(struct pstack *pstack, void *key)
 {
-	if (self->top == self->max_nr_entries) {
-		pr_err("%s: top=%d, overflow!\n", __func__, self->top);
+	if (pstack->top == pstack->max_nr_entries) {
+		pr_err("%s: top=%d, overflow!\n", __func__, pstack->top);
 		return;
 	}
-	self->entries[self->top++] = key;
+	pstack->entries[pstack->top++] = key;
 }
 
-void *pstack__pop(struct pstack *self)
+void *pstack__pop(struct pstack *pstack)
 {
 	void *ret;
 
-	if (self->top == 0) {
+	if (pstack->top == 0) {
 		pr_err("%s: underflow!\n", __func__);
 		return NULL;
 	}
 
-	ret = self->entries[--self->top];
-	self->entries[self->top] = NULL;
+	ret = pstack->entries[--pstack->top];
+	pstack->entries[pstack->top] = NULL;
 	return ret;
 }
