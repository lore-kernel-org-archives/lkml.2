Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab0EKQak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:30:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0EKQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:30:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf improvements
Date: Tue, 11 May 2010 13:29:47 -0300
Message-Id: <1273595390-6486-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	Tested Kyle's patch and it works as advertised:

[acme@doppio linux-2.6-tip]$ nm /tmp/perf.before | grep bfd_ | head -5
00000000004a5810 t MY_bfd_copy_private_section_data
000000000045a2e0 T _bfd_abort
00000000004c89a0 T _bfd_add_bfd_to_archive_cache
00000000004d1b30 T _bfd_add_merge_section
00000000004c7310 T _bfd_ar_spacepad
[acme@doppio linux-2.6-tip]$ nm /tmp/perf.before | grep cplus_demangle | head -2
00000000004d5500 T cplus_demangle
000000000071ce60 D cplus_demangle_builtin_types
[acme@doppio linux-2.6-tip]$ nm ~/bin/perf | grep bfd_ | head -5
[acme@doppio linux-2.6-tip]$ nm ~/bin/perf | grep cplus_demangle | head -2
000000000045c210 T cplus_demangle
000000000067ff60 D cplus_demangle_builtin_types
[acme@doppio linux-2.6-tip]$

	But I guess we should make the autodetection better and not require
passing that define explicitely? Anyway, for now it solves Fedora's srpm problem,
so should go in now.

Regards,

Arnaldo Carvalho de Melo (1):
  perf hist: Adopt filter by dso and by thread methods from the newt browser

Kyle McMartin (1):
  perf symbols: allow forcing use of cplus_demangle

Masami Hiramatsu (1):
  perf probe: Check older elfutils and set NO_DWARF

 tools/perf/Makefile         |    7 +++-
 tools/perf/builtin-report.c |    5 +--
 tools/perf/util/hist.c      |   59 +++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |   15 ++++++++
 tools/perf/util/newt.c      |   80 +++++++-----------------------------------
 tools/perf/util/session.h   |   15 --------
 6 files changed, 94 insertions(+), 87 deletions(-)

