Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409Ab0EEADh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:03:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32987 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760394Ab0EEADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=QkeWMNSNVUx+enpERJhuSdM3G/jRPMATAkpHzYdu57+Jd3ObZomUX5Kqp2t4SzhelT
         LNBKnQaBotfO8AwU+9ITc6FEROFgVCR1q6ASeXYdVTLEZ9SqI2nGrwAlF9K0SU5dMN45
         /Eh7LG63ZG435uc8NUfWp01GfKkB5KrDrSCFY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/2] perf: Redesign trace events reordering
Date: Wed,  5 May 2010 02:03:29 +0200
Message-Id: <1273017811-16880-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently noticed that the new reordering design is broken
when it deals with tons of events.

This patchset provides another algorithm to deal with that,
tested without any problem.

And since it involves more frequent flushes, I guess it could
plug nicely with the live mode.

Frederic Weisbecker (2):
  perf: Introduce a new "round of buffers read" pseudo event
  perf: Provide a new deterministic events reordering algorithm

 tools/perf/builtin-record.c |   34 ++++++++++----
 tools/perf/util/event.h     |    3 +-
 tools/perf/util/session.c   |  106 +++++++++++++++++++++++++++++++------------
 tools/perf/util/session.h   |   36 +++++++++------
 4 files changed, 123 insertions(+), 56 deletions(-)

