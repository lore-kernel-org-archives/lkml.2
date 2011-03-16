Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1CPN7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:59:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:36009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1CPN7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:59:42 -0400
Date: Wed, 16 Mar 2011 13:59:17 GMT
From: tip-bot for Richard Kennedy <richard@rsk.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, richard@rsk.demon.co.uk, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, richard@rsk.demon.co.uk,
        mingo@elte.hu
In-Reply-To: <1299512819.2039.5.camel@castor.rsk>
References: <1299512819.2039.5.camel@castor.rsk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Reorder & optimize perf_event_context to remove alignment padding on 64 bit builds
Message-ID: <tip-ee643c4179c3a18b018de3a4c07a7bb3a75c8e4e@git.kernel.org>
Git-Commit-ID: ee643c4179c3a18b018de3a4c07a7bb3a75c8e4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:59:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee643c4179c3a18b018de3a4c07a7bb3a75c8e4e
Gitweb:     http://git.kernel.org/tip/ee643c4179c3a18b018de3a4c07a7bb3a75c8e4e
Author:     Richard Kennedy <richard@rsk.demon.co.uk>
AuthorDate: Mon, 7 Mar 2011 15:46:59 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:04:14 +0100

perf: Reorder & optimize perf_event_context to remove alignment padding on 64 bit builds

Remove 8 bytes of alignment padding from perf_event_context on 64 bit
builds which shrinks its size to 192 bytes allowing it to fit into one
fewer cache lines and into a smaller slab.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299512819.2039.5.camel@castor.rsk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 614615b..f495c01 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -878,8 +878,8 @@ enum perf_event_context_type {
  * Used as a container for task events and CPU events as well:
  */
 struct perf_event_context {
-	enum perf_event_context_type	type;
 	struct pmu			*pmu;
+	enum perf_event_context_type	type;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
