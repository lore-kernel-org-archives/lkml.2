Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2JXGGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:06:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab2JXGGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:06:22 -0400
Date: Tue, 23 Oct 2012 23:04:29 -0700
From: tip-bot for Luigi Semenzato <semenzato@chromium.org>
Message-ID: <tip-9fdbf671ba7e8adb2cbb93d716232ebcab55f6bd@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, wilsons@start.ca, semenzato@chromium.org,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        robert.richter@amd.com, fweisbec@gmail.com, olofj@chromium.org,
        akpm@linux-foundation.org, dsahern@gmail.com, ak@linux.intel.com,
        oleg@redhat.com, tglx@linutronix.de, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        segoon@openwall.com, lucas.demarchi@profusion.mobi, namhyung@gmail.com,
        ebiederm@xmission.com, tj@kernel.org, sonnyrao@chromium.org,
        paul.gortmaker@windriver.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, semenzato@chromium.org, wilsons@start.ca,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        fweisbec@gmail.com, robert.richter@amd.com, akpm@linux-foundation.org,
        olofj@chromium.org, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com, rjw@sisk.pl, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, segoon@openwall.com,
        namhyung@gmail.com, lucas.demarchi@profusion.mobi,
        ebiederm@xmission.com, tj@kernel.org, sonnyrao@chromium.org,
        mingo@elte.hu, paul.gortmaker@windriver.com
In-Reply-To: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
References: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  do not flush maps on COMM for perf report
Git-Commit-ID: 9fdbf671ba7e8adb2cbb93d716232ebcab55f6bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 23 Oct 2012 23:04:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fdbf671ba7e8adb2cbb93d716232ebcab55f6bd
Gitweb:     http://git.kernel.org/tip/9fdbf671ba7e8adb2cbb93d716232ebcab55f6bd
Author:     Luigi Semenzato <semenzato@chromium.org>
AuthorDate: Tue, 21 Aug 2012 14:52:20 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Oct 2012 13:55:53 -0200

perf tools: do not flush maps on COMM for perf report

This fixes a long-standing bug caused by the lack of separate COMM and EXEC
record types, which makes "perf report" lose track of symbols when a process
renames itself.

With this fix (suggested by Stephane Eranian), a COMM (rename) no longer
flushes the maps, which is the correct behavior.  An EXEC also no longer
flushes the maps, but this doesn't matter because as new mappings are created
(for the executable and the libraries) the old mappings are automatically
removed.  This is not by accident: the functionality is necessary because DLLs
can be explicitly loaded at any time with dlopen(), possibly on top of existing
text, so "perf report" handles correctly the clobbering of new mappings on top
of old ones.

An alternative patch (which I proposed earlier) would be to introduce a
separate PERF_RECORD_EXEC type, but it is a much larger change (about 300
lines) and is not necessary.

Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
Tested-by: Stephane Eranian <eranian@google.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Olof Johansson <olofj@chromium.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Link: http://lkml.kernel.org/r/1345585940-6497-1-git-send-email-semenzato@chromium.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..8b3e593 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -39,7 +39,6 @@ int thread__set_comm(struct thread *self, const char *comm)
 	err = self->comm == NULL ? -ENOMEM : 0;
 	if (!err) {
 		self->comm_set = true;
-		map_groups__flush(&self->mg);
 	}
 	return err;
 }
