Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1CaMl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:41:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:56783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1CaMlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:41:24 -0400
Date: Thu, 31 Mar 2011 12:41:03 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1301535209-9679-1-git-send-email-fweisbec@gmail.com>
References: <1301535209-9679-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Rebase max unprivileged mlock threshold on top of page size
Message-ID: <tip-20443384fe090c5f8aeb016e7e85659c5bbdd69f@git.kernel.org>
Git-Commit-ID: 20443384fe090c5f8aeb016e7e85659c5bbdd69f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 12:41:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20443384fe090c5f8aeb016e7e85659c5bbdd69f
Gitweb:     http://git.kernel.org/tip/20443384fe090c5f8aeb016e7e85659c5bbdd69f
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 31 Mar 2011 03:33:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 13:02:54 +0200

perf: Rebase max unprivileged mlock threshold on top of page size

Ensure we allow 512 kiB + 1 page for user control without
assuming a 4096 bytes page size.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: <stable@kernel.org>
LKML-Reference: <1301535209-9679-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..2616909 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -145,8 +145,8 @@ static struct srcu_struct pmus_srcu;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-/* Minimum for 128 pages + 1 for the user control page */
-int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
+/* Minimum for 512 kiB + 1 user control page */
+int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
 
 /*
  * max perf event sample rate
