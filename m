Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2KROgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:36:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36547 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2KROaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/32] perf tools: Stop using 'self' in pstack
Date: Sun, 18 Nov 2012 11:29:38 -0300
Message-Id: <1353248997-30763-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 tools/perf/util/pstack.c |   46 +++++++++++++++++++++++-----------------------
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
-- 
1.7.9.2.358.g22243

