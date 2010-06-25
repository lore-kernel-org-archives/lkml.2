Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0FYN7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:59:40 -0400
Received: from [18.85.46.34] ([18.85.46.34]:57130 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0FYN7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:59:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] perf scripts perl: Makefile fix
Date: Fri, 25 Jun 2010 10:59:21 -0300
Message-Id: <1277474366-7958-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1277474366-7958-1-git-send-email-acme@infradead.org>
References: <1277474366-7958-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

Fix a typo introduced by recent Makefile changes, in f9af3a4.  Without it, Perl
scripting support won't get compiled in.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1276836006.7762.15.camel@tropicana>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6aa2fe3..17a3692 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -577,7 +577,7 @@ ifdef NO_LIBPERL
 else
 	PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
 	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
-	PERL_EMBED_FLAGS=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
 	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPERL
-- 
1.6.2.5

