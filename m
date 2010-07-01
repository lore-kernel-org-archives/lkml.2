Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0GAPfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:35:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33063 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0GAPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=UcS5ozEeM+hUEI30wvFtwJzGO/gfw5f1+PS3w70O//alcjLvuh3FYNaxejc+wJ/pj3
         ZDinooe8G8YeslqBgU9L4ptvRD/jj2d2G37i3STvXjlMr11+oSHAZvpVUf3ovw7LsebO
         3uLTH+p9Nu8VBsGLg0HzhQiJLc887X2wA+AB4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC PATCH 0/6] perf: cleanup and fixes
Date: Thu,  1 Jul 2010 17:35:56 +0200
Message-Id: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanups and fixes for perf core, although the last one could
go to perf/urgent.

It has only been tested in x86.

Frederic Weisbecker (6):
  perf: Drop unappropriate tests on arch callchains
  perf: Generalize callchain_store()
  perf: Generalize some arch callchain code
  perf: Factorize callchain context handling
  perf: Fix race in callchains
  perf: Fix double put_ctx

 arch/arm/kernel/perf_event.c         |   62 +--------
 arch/powerpc/kernel/perf_callchain.c |   86 ++++---------
 arch/sh/kernel/perf_callchain.c      |   50 +-------
 arch/sparc/kernel/perf_event.c       |   69 ++++-------
 arch/x86/kernel/cpu/perf_event.c     |   82 +++----------
 include/linux/perf_event.h           |   16 +++-
 kernel/perf_event.c                  |  228 +++++++++++++++++++++++++++++-----
 7 files changed, 289 insertions(+), 304 deletions(-)

