Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab1LHEfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:35:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1LHEfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:35:23 -0500
Date: Wed, 7 Dec 2011 20:34:56 -0800
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-6340cfed48c478cf67451ddcd2daa3438e642632@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, asharma@fb.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, asharma@fb.com
In-Reply-To: <1322471015-107825-2-git-send-email-avagin@openvz.org>
References: <1322471015-107825-2-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf header: Use event_name() to get an event name
Git-Commit-ID: 6340cfed48c478cf67451ddcd2daa3438e642632
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 07 Dec 2011 20:35:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6340cfed48c478cf67451ddcd2daa3438e642632
Gitweb:     http://git.kernel.org/tip/6340cfed48c478cf67451ddcd2daa3438e642632
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Mon, 28 Nov 2011 12:03:29 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 6 Dec 2011 09:22:48 -0200

perf header: Use event_name() to get an event name

perf_evsel.name may be not initialized

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arun Sharma <asharma@fb.com>
Cc: devel@openvz.org
Link: http://lkml.kernel.org/r/1322471015-107825-2-git-send-email-avagin@openvz.org
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bcd05d0..33c17a2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -388,7 +388,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		/*
 		 * write event string as passed on cmdline
 		 */
-		ret = do_write_string(fd, attr->name);
+		ret = do_write_string(fd, event_name(attr));
 		if (ret < 0)
 			return ret;
 		/*
