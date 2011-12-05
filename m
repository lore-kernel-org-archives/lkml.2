Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1LEMgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:36:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1LEMgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:36:23 -0500
Date: Mon, 5 Dec 2011 04:35:45 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-47fbe53bef3b219a365ebf3eca949d6cd4c5291c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, anton@samba.org,
        hpa@zytor.com, mingo@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1321206327-5881-1-git-send-email-dsahern@gmail.com>
References: <1321206327-5881-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Fix crash with invalid CPU list
Git-Commit-ID: 47fbe53bef3b219a365ebf3eca949d6cd4c5291c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:35:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47fbe53bef3b219a365ebf3eca949d6cd4c5291c
Gitweb:     http://git.kernel.org/tip/47fbe53bef3b219a365ebf3eca949d6cd4c5291c
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 13 Nov 2011 10:45:27 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Nov 2011 10:02:26 -0200

perf session: Fix crash with invalid CPU list

commit 5d67be9 added the option to specify a range of CPUs of interest,
but does not catch an invalid CPU list:

$ perf script -c foo
Segmentation fault (core dumped)

Cc: Anton Blanchard <anton@samba.org>
Link: http://lkml.kernel.org/r/1321206327-5881-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 85c1e6b7..0f4555c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1333,6 +1333,10 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 	}
 
 	map = cpu_map__new(cpu_list);
+	if (map == NULL) {
+		pr_err("Invalid cpu_list\n");
+		return -1;
+	}
 
 	for (i = 0; i < map->nr; i++) {
 		int cpu = map->map[i];
