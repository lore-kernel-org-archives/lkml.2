Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab0EZVbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:31:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:43398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab0EZVbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:31:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf tui fix and annotate improvement
Date: Wed, 26 May 2010 18:30:47 -0300
Message-Id: <1274909449-10977-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
LKML-Reference: <new-submission>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	I still have to make it cache vmlinux files instead of always caching
kallsyms, so that users can select it via .perfconfig the tradeof .debug/ disk
space versus offline/precise (build-id verified) annotate ability for kernel
symbols.

	But one can use another seldom used perf command to workaround this
situation, buildid-cache, by doing:

perf buildid-cache -r /path/to/vmlinux
perf buildid-cache -a /path/to/vmlinux

	The first one will read the build-id in /path/to/vmlinux, and remove
the symlink from the cache, the second will add the vmlinux file to the cache
and make the symlink to it, so that 'perf archive' will package the right
vmlinux and then offline annotation should work as expected.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf tui: Reset use_browser if stdout is not a tty
  perf symbols: Add the build id cache to the vmlinux path

 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/newt.c        |    1 +
 tools/perf/util/symbol.c      |   27 +++++++++++++++++++++++----
 tools/perf/util/symbol.h      |    2 +-
 5 files changed, 27 insertions(+), 7 deletions(-)

