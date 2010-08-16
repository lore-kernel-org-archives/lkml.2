Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0HPUsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:48:41 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55925 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab0HPUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=qIRckOn+hCwHaUzxW9tBYEiT+LdAur9QnvRDMOgwrYV7QDHCWdvjSQO14RbO+bTOmy
         p99/7LWcp44Q+vygMO6GjFGOA7c2ubTmSGYY5YoAY1L+hBBKUgM2+VCwTCOYl1zMzurP
         G5sXSBnWbYXf6MVzzInbk6/q2Ja/e/Zy9X0to=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        David Miller <davem@davemloft.net>, Borislav Petkov <bp@amd64.org>
Subject: [RFC PATCH 0/0 v3] callchain fixes and cleanups 
Date: Mon, 16 Aug 2010 22:48:29 +0200
Message-Id: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This set factorizes a lot of callchain code and fixes concurrent
callchain buffers accesses.

The previous set has revealed we can't decently use the per cpu
allocation api for memory that can be accessed from NMI.
Hence this temporary uses a manual per cpu allocation until that
gets fixed up.

Built-tested on PowerPc, Arm and SuperH (can someone point me to
a ready to use sparc cross compiler, like those that can be found
there for other archs: http://www.codesourcery.com/sgpp/lite_edition.html ?)

And runtime tested on x86-64 withiut troubles.

You can test it by pulling that branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/callchains

If you have no comments, I'll propose it to -tip in a few days.

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      perf: Drop unappropriate tests on arch callchains
      perf: Generalize callchain_store()
      perf: Generalize some arch callchain code
      perf: Factorize callchain context handling
      perf: Fix race in callchains
      perf: Humanize the number of contexts


 arch/arm/kernel/perf_event.c         |   62 +---------
 arch/powerpc/kernel/perf_callchain.c |   86 ++++---------
 arch/sh/kernel/perf_callchain.c      |   50 +-------
 arch/sparc/kernel/perf_event.c       |   69 ++++-------
 arch/x86/kernel/cpu/perf_event.c     |   82 +++----------
 include/linux/perf_event.h           |   30 ++++-
 kernel/perf_event.c                  |  226 +++++++++++++++++++++++++++++-----
 7 files changed, 295 insertions(+), 310 deletions(-)
