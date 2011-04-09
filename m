Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab1DIBup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 21:50:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43844 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab1DIBuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 21:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:date:from:to:cc:message-id:in-reply-to:references;
        b=lklZ0aXHpq0AlAdz3ukTvY5QuSSUpVSBYqn0XBopzzXg5oLreaDKzkTZuUIrKq53y0
         fxjx/0k9FNXz8I6WbXxubakAedzaX3rTDazfXZAYTETf0N/0gvMscqP/ghdbofUtyg0k
         gavo/U2mRVTTdy17cl5osds/mxABm37qNEd5Y=
Subject: [PATCH 1/2] perf tools: Makefile: Clean up `python/perf.so' rule
Date: Sat, 9 Apr 2011 01:12:56 +0000
From: Michael Witten <mfwitten@gmail.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Message-ID: <9d3575a7-7dc7-483d-af65-7c458cc4ac8e-mfwitten@gmail.com>
In-Reply-To: <5f5948dd-2c38-4ed3-8544-99c137204d07-mfwitten@gmail.com>
References: <20110326224408.GA1336@Xye>
            <20110328144721.GB17872@ghostprotocols.net>
            <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
            <20110329181524.GA5140@Xye>
            <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
            <20110329204024.GA20824@ghostprotocols.net>
            <3a97df19-e376-412a-95be-37ffde765cc3-mfwitten@gmail.com>
            <20110408211709.GA5155@Xye>
            <5f5948dd-2c38-4ed3-8544-99c137204d07-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for a subshell or an explicit `export';
as per the POSIX Shell Command Language specification:

  http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_09_01
  http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_10_02

It is only necessary to include the environment variable
assignment just before the command to be run.

Also, it is better to use single-quotes, because GNU make
might expand `$(BASIC_CFLAGS)' into something that the shell
could interpret within double-quotes.

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 tools/perf/Makefile |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 207dee5..aaf4dd3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -165,12 +165,10 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)( \
-		export CFLAGS="$(BASIC_CFLAGS)"; \
-		python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
-			--build-temp='$(OUTPUT)python/temp' \
-	)
-
+	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' python util/setup.py \
+	  --quiet build_ext \
+	  --build-lib='$(OUTPUT)python' \
+	  --build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
 #
-- 
1.7.4.18.g68fe8

