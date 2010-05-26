Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab0EZWal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:30:41 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45178 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab0EZWak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=dL/hTgZVrPpl118dy3IADgwUfC0LWC8Di7HJA/EWmwAVhQzdBnOaKDjoGx7YGJX5Sc
         rPnFIDEcQErxABvxz87yMibadA+XGWdtl7sWSeQg4coMr3hHtnNXbzfgVGGfQKZxsIYF
         hk60TfFPn9zwiOV4bsQIAxxdOGl3DY+Ocg0Zs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing updates
Date: Thu, 27 May 2010 00:30:35 +0200
Message-Id: <1274913037-1126-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

It is based on top of tip:perf/core.

The next that are soon to join the removal list are sysprof and
blktrace (from which we only want to remove the ftrace plugin part,
unused by the userspace app).
And probably the workqueue profiler and ksym tracer too.

Thanks,
	Frederic
---

Américo Wang (1):
      tracing: Remove boot tracer

Li Zefan (1):
      tracing: Remove kmemtrace ftrace plugin


 Documentation/ABI/testing/debugfs-kmemtrace |   71 ----
 Documentation/trace/kmemtrace.txt           |  126 -------
 MAINTAINERS                                 |    7 -
 include/linux/kmemtrace.h                   |   25 --
 include/linux/slab_def.h                    |    3 +-
 include/linux/slub_def.h                    |    3 +-
 include/trace/boot.h                        |   60 ---
 init/main.c                                 |   29 +-
 kernel/trace/Kconfig                        |   37 --
 kernel/trace/Makefile                       |    2 -
 kernel/trace/kmemtrace.c                    |  529 ---------------------------
 kernel/trace/trace.c                        |    3 -
 kernel/trace/trace.h                        |   20 -
 kernel/trace/trace_boot.c                   |  185 ----------
 kernel/trace/trace_entries.h                |   62 ----
 mm/slab.c                                   |    1 -
 mm/slub.c                                   |    1 -
 17 files changed, 14 insertions(+), 1150 deletions(-)
