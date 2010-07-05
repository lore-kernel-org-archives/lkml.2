Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0GEH7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 03:59:47 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36952 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0GEH7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:59:46 -0400
From: Thavidu Ranatunga <tharan@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thavidu Ranatunga <tharan@au1.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf: Version String fix, using kernel version
Date: Mon,  5 Jul 2010 18:00:14 +1000
Message-Id: <1278316815-6099-1-git-send-email-tharan@au1.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes the Perf --version string such that it shows the kernel version as
suggested by Ingo as follows:

That way the perf that comes with v2.6.34 will be:
perf version v2.6.34

while interim versions will have the version of the interim kernel - for
example:
 perf version v2.6.35-rc4-70-g39ef13a

This functionality was already in the perf version generator file except that it
was looking for a .git in the perf directory instead of the kernel directory.

Signed-off-by: Thavidu Ranatunga <tharan@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
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
-- 
1.6.3.3

