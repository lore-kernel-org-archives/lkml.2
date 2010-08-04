Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0HDJ1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:27:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:45961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab0HDJ07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:26:59 -0400
Date: Wed, 4 Aug 2010 09:26:14 GMT
From: tip-bot for Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joe@perches.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ppannuto@codeaurora.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ppannuto@codeaurora.org
In-Reply-To: <1280786467-26999-5-git-send-email-ppannuto@codeaurora.org>
References: <1280786467-26999-5-git-send-email-ppannuto@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] Checkpatch: Warn about unexpectedly long msleep's
Message-ID: <tip-d76db7e68cb9a886056a92c3f0fef56af5ca5ee8@git.kernel.org>
Git-Commit-ID: d76db7e68cb9a886056a92c3f0fef56af5ca5ee8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 09:26:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d76db7e68cb9a886056a92c3f0fef56af5ca5ee8
Gitweb:     http://git.kernel.org/tip/d76db7e68cb9a886056a92c3f0fef56af5ca5ee8
Author:     Patrick Pannuto <ppannuto@codeaurora.org>
AuthorDate: Mon, 2 Aug 2010 15:01:07 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 4 Aug 2010 11:00:45 +0200

Checkpatch: Warn about unexpectedly long msleep's

As explained in Documentation/timers/timers-howto.txt, msleep's
of < 20ms may sleep for as long as 20ms. Caller's of
msleep(1) or msleep(2), etc are likely not to expect this
quirky behavior - warn them.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: apw@canonical.com
Cc: corbet@lwn.net
Cc: arjan@linux.intel.com
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1280786467-26999-5-git-send-email-ppannuto@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1698c63..8536c33 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2578,6 +2578,13 @@ sub process {
 			}
 		}
 
+# warn about unexpectedly long msleep's
+		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
+			if ($1 < 20) {
+				WARN("msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
