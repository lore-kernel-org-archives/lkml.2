Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1DEPBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:44476 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1DEO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:41 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 34/34] checkpatch: Warn about usage of __DATE__, __TIME__ and __TIMESTAMP__
Date: Tue,  5 Apr 2011 16:59:21 +0200
Message-Id: <1302015561-21047-35-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __TIME__ and __DATE__ macros are evil. Every C textbook mentions
them, but forgets to add the tiny detail that they make sure that your
code will never result in the same binary. __TIMESTAMP__ is a bit more
sane, but again produces noise as soon as you switch branches back and
forth, or apply a patch and revert it.

Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4c0383d..dbcdf04 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2804,6 +2804,11 @@ sub process {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
+# check for pointless usage of __TIME__ and friends
+		if ($line =~ /\b__(TIME|DATE|TIMESTAMP)__\b/) {
+			WARN("Usage of __$1__ should be avoided to keep the build deterministic\n" . $herecurr);
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("consider using a completion\n" . $herecurr);
-- 
1.7.4.1

