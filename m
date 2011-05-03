Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1ECNbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:31:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42537 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1ECNb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:31:29 -0400
Date: Tue, 3 May 2011 15:30:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 2/4] perf: Add persistent event facilities
Message-ID: <20110503133057.GD20241@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-3-git-send-email-bp@amd64.org>
 <20110503064046.GD7751@elte.hu>
 <20110503125929.GB1730@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503125929.GB1730@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 08:59:35AM -0400, Frederic Weisbecker wrote:
> On Tue, May 03, 2011 at 08:40:46AM +0200, Ingo Molnar wrote:
> > [ kernel/hw_breakpoint.c could possibly move into kernel/events/hw_breakpoint.c 
> >   file as well - if Frederic acks it. ]
> 
> Makes sense yeah.

Ok, looks trivial enough. Ingo, let me know if I should add it to the
pull request from earlier.

--
>From 48dbb6dc86ca5d1b2224937d774c7ba98bc3a485 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 3 May 2011 15:26:43 +0200
Subject: [PATCH] hw breakpoints: Move to kernel/events/

As part of the events sybsystem unification, relocate hw_breakpoint.c
into its new destination.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 kernel/Makefile                     |    1 -
 kernel/events/Makefile              |    3 ++-
 kernel/{ => events}/hw_breakpoint.c |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename kernel/{ => events}/hw_breakpoint.c (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index 7981530..e9cf191 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -105,7 +105,6 @@ obj-$(CONFIG_IRQ_WORK) += irq_work.o
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
-obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 26c00e4..1ce23d3 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,4 +2,5 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y += core.o
+obj-y := core.o
+obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
similarity index 100%
rename from kernel/hw_breakpoint.c
rename to kernel/events/hw_breakpoint.c
-- 
1.7.4.rc2


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
