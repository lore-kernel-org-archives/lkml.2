Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1GUKLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:11:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:54094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1GUKL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:11:27 -0400
Date: Thu, 21 Jul 2011 10:11:16 GMT
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-adc4bf9955856f8aa081ba613dbf56ffd664f0b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306768587-15376-1-git-send-email-dsahern@gmail.com>
References: <1306768587-15376-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix display of IP address for non-callchain path
Git-Commit-ID: adc4bf9955856f8aa081ba613dbf56ffd664f0b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:11:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adc4bf9955856f8aa081ba613dbf56ffd664f0b7
Gitweb:     http://git.kernel.org/tip/adc4bf9955856f8aa081ba613dbf56ffd664f0b7
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 30 May 2011 09:16:27 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 10:09:28 +0200

perf script: Fix display of IP address for non-callchain path

Non-callchain path is using al.addr which prints as:
  openssl 14564 17672.003587:       7862d _x86_64_AES_encrypt_compact

This should be sample->ip to print as:
  openssl 14564 17672.003587:  3f7867862d _x86_64_AES_encrypt_compact

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@ghostprotocols.net
Cc: peterz@infradead.org
Cc: paulus@samba.org
Link: http://lkml.kernel.org/r/1306768587-15376-1-git-send-email-dsahern@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a3c13bc..72458d9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1269,7 +1269,7 @@ void perf_session__print_ip(union perf_event *event,
 		}
 
 	} else {
-		printf("%16" PRIx64, al.addr);
+		printf("%16" PRIx64, sample->ip);
 		if (print_sym) {
 			if (al.sym && al.sym->name)
 				symname = al.sym->name;
