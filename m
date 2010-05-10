Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab0EJErI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:47:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0EJErF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l4Lmzcr45aNq+uGu97Hlq/3MGdE6ARLaNW4aa/nUOhuLpY7vCLN7yPMexlho5pnbcl
         X/NAYtL9ZkhEXhGDCoysqbvH0zc4ST+YE4WmWTjumLwX7XzyAo4Vwg7yXEfBGqEzzL7c
         uKl/MRLxp25o9C6WQ6k39li2n7xRLCSjXbYBQ=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 0/9] perf-trace/scripting: script fixes
Date: Sun,  9 May 2010 23:46:51 -0500
Message-Id: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing the new 'trace events reordering' patches, I noticed
some problems with the current set of scripts, mostly annoying warning
messages, but a couple of real problems too.

Another annoyance, which I moved to verbose mode, was the display of
the script name on each invocation.

Anyway, after testing all the scripts in both normal and live mode, I
haven't seen any problems with the new event reordering patches...

Tom Zanussi (9):
  perf/trace/scripting: failed-syscalls script cleanup
  perf/trace/scripting: rw-by-pid script cleanup
  perf/trace/scripting: rwtop script cleanup
  perf/trace/scripting: wakeup-latency script cleanup
  perf/trace/scripting: workqueue-stats script cleanup
  perf/trace/scripting: don't show script start/stop messages by
    default
  perf/trace/scripting: failed-syscalls-by-pid script cleanup
  perf/trace/scripting: syscall-counts-by-pid script cleanup
  perf/trace/scripting: syscall-counts script cleanup

 tools/perf/builtin-trace.c                         |    3 +
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/failed-syscalls.pl         |    6 ++-
 tools/perf/scripts/perl/rw-by-pid.pl               |   60 ++++++++++++--------
 tools/perf/scripts/perl/rwtop.pl                   |   48 +++++++++++----
 tools/perf/scripts/perl/wakeup-latency.pl          |   12 +++-
 tools/perf/scripts/perl/workqueue-stats.pl         |   12 ++--
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    3 -
 .../util/scripting-engines/trace-event-python.c    |    4 -
 12 files changed, 98 insertions(+), 58 deletions(-)

