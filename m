Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab0GEIqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:46:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:47251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0GEIqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:46:15 -0400
Date: Mon, 5 Jul 2010 08:45:39 GMT
From: tip-bot for Thavidu Ranatunga <tharan@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       tharan@au1.ibm.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, imunsie@au1.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, tharan@au1.ibm.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, imunsie@au1.ibm.com,
       mingo@elte.hu
In-Reply-To: <1278316815-6099-1-git-send-email-tharan@au1.ibm.com>
References: <1278316815-6099-1-git-send-email-tharan@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Version String fix, using kernel version
Message-ID: <tip-2190de2f59b3a371f7a5bf8dcc7a0c3f71723679@git.kernel.org>
Git-Commit-ID: 2190de2f59b3a371f7a5bf8dcc7a0c3f71723679
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Jul 2010 08:45:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2190de2f59b3a371f7a5bf8dcc7a0c3f71723679
Gitweb:     http://git.kernel.org/tip/2190de2f59b3a371f7a5bf8dcc7a0c3f71723679
Author:     Thavidu Ranatunga <tharan@au1.ibm.com>
AuthorDate: Mon, 5 Jul 2010 18:00:14 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Jul 2010 10:42:58 +0200

perf: Version String fix, using kernel version

Changes the Perf --version string such that it shows the kernel
version as suggested by Ingo as follows:

That way the perf that comes with v2.6.34 will be:

  perf version v2.6.34

while interim versions will have the version of the interim
kernel - for example:

 perf version v2.6.35-rc4-70-g39ef13a

This functionality was already in the perf version generator
file except that it was looking for a .git in the perf directory
instead of the kernel directory.

Signed-off-by: Thavidu Ranatunga <tharan@au1.ibm.com>
Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1278316815-6099-1-git-send-email-tharan@au1.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/PERF-VERSION-GEN |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 49ece79..1b32e8c 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -15,7 +15,7 @@ LF='
 if test -f version
 then
 	VN=$(cat version) || VN="$DEF_VER"
-elif test -d .git -o -f .git &&
+elif test -d ../../.git -o -f ../../.git &&
 	VN=$(git describe --abbrev=4 HEAD 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
