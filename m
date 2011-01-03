Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1ACRpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:45:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44590 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab1ACRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XS4yCwrlqPK0KoCez/3dXMsiPNBcm4uVTraM1x9nfUpFMWorgWzcPNmqn911OuhXjS
         LpCs41mOVcMIm0Ic+DpRBPxHDrSO6J+xcazI6ZToMMBAC1gm0fdx7fhVLdwDeGrsGeYx
         Q+3P5OpSp6NPzQkNEwCNXtJbbje6SotoTJXEg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf callchain fixlet
Date: Mon,  3 Jan 2011 18:45:02 +0100
Message-Id: <1294076702-4725-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent
	
If you think it's too late to get that into .37, I can still
rebase it to perf/core (or you can cherry-pick that patch
directly).

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      perf: Fix callchain hit bad cast on ascii display


 tools/perf/util/hist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---
commit d425de5436a620de506f9e4119bf8daa1cb93718
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Mon Jan 3 16:13:11 2011 +0100

    perf: Fix callchain hit bad cast on ascii display
    
    ipchain__fprintf_graph() casts the number of hits in a branch as an
    int, which means we lose its highests bits.
    
    This results in meaningless number of callchain hits in perf.data
    that have a high number of hits recorded, typically those that have
    callchain branches hits appearing more than INT_MAX. This happens
    easily as those are pondered by the event period.
    
    Reported-by: Nick Piggin <npiggin@kernel.dk>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2022e87..76bcc35 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -356,7 +356,7 @@ static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
 
 static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 				     int depth, int depth_mask, int period,
-				     u64 total_samples, int hits,
+				     u64 total_samples, u64 hits,
 				     int left_margin)
 {
 	int i;
