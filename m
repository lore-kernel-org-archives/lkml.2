Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2HUQbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:31:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2HUQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:31:22 -0400
Date: Tue, 21 Aug 2012 09:31:10 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-1c09bf4a79e808c13c02d4ca8221fb2957bf3ccb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@kernel.org, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1345391202-71865-1-git-send-email-dsahern@gmail.com>
References: <1345391202-71865-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: silence GTK2 probing errors
Git-Commit-ID: 1c09bf4a79e808c13c02d4ca8221fb2957bf3ccb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:31:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c09bf4a79e808c13c02d4ca8221fb2957bf3ccb
Gitweb:     http://git.kernel.org/tip/1c09bf4a79e808c13c02d4ca8221fb2957bf3ccb
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 19 Aug 2012 09:46:42 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Aug 2012 09:33:29 -0300

perf: silence GTK2 probing errors

If GTK2 development packages are not installed, make is rather noisy:

  $ make -C tools/perf O=/tmp/pbuild
  Package gtk+-2.0 was not found in the pkg-config search path.
  Perhaps you should add the directory containing `gtk+-2.0.pc'
  to the PKG_CONFIG_PATH environment variable
  No package 'gtk+-2.0' found
  make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
  Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
  PERF_VERSION = 3.6.rc1.205.gdb146f.dirty
  make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
  Package gtk+-2.0 was not found in the pkg-config search path.
  Perhaps you should add the directory containing `gtk+-2.0.pc'
  to the PKG_CONFIG_PATH environment variable
  No package 'gtk+-2.0' found
  make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
  Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
  ...

Silence the pkg-config errors. Aftewards:

  $ make -C tools/perf O=/tmp/pbuild
  make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
  Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
  PERF_VERSION = 3.6.rc1.206.gd43ff9.dirty
  make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
  make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
  Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
  ...

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1345391202-71865-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 75af93d..8beff99 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -587,7 +587,7 @@ endif
 ifdef NO_GTK2
 	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
-	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
+	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
 		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
@@ -595,8 +595,8 @@ else
 		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
 			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
 		endif
-		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
-		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
+		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
