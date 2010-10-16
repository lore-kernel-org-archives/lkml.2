Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0JPQct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:32:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:57023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab0JPQcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:32:47 -0400
Date: Sat, 16 Oct 2010 16:32:19 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100929145225.GJ13563@erda.amd.com>
References: <20100929145225.GJ13563@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] oprofile, ARM: Release resources on failure
Message-ID: <tip-81771974ae49bf79aab60c42eac7a6d730a9ef2b@git.kernel.org>
Git-Commit-ID: 81771974ae49bf79aab60c42eac7a6d730a9ef2b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 16:32:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81771974ae49bf79aab60c42eac7a6d730a9ef2b
Gitweb:     http://git.kernel.org/tip/81771974ae49bf79aab60c42eac7a6d730a9ef2b
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Sep 2010 16:52:25 +0200
Committer:  Robert Richter <robert.richter@amd.com>
CommitDate: Mon, 11 Oct 2010 19:27:10 +0200

oprofile, ARM: Release resources on failure

This patch fixes a resource leak on failure, where the
oprofilefs and some counters may not released properly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: <stable@kernel.org> # .35.x
LKML-Reference: <20100929145225.GJ13563@erda.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/oprofile/oprofile_perf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index ebb40cb..f3d3df2 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -84,6 +84,7 @@ static int op_create_counter(int cpu, int event)
 	if (IS_ERR(pevent)) {
 		ret = PTR_ERR(pevent);
 	} else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
+		perf_event_release_kernel(pevent);
 		pr_warning("oprofile: failed to enable event %d "
 				"on CPU %d\n", event, cpu);
 		ret = -EBUSY;
