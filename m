Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0HDJ0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:26:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:45948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab0HDJ0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:26:41 -0400
Date: Wed, 4 Aug 2010 09:25:55 GMT
From: tip-bot for Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joe@perches.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ppannuto@codeaurora.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ppannuto@codeaurora.org
In-Reply-To: <1280786467-26999-4-git-send-email-ppannuto@codeaurora.org>
References: <1280786467-26999-4-git-send-email-ppannuto@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] Checkpatch: Prefer usleep_range over udelay
Message-ID: <tip-022d60db2ab6e97f93c98808d08fd883003048c7@git.kernel.org>
Git-Commit-ID: 022d60db2ab6e97f93c98808d08fd883003048c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 09:25:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  022d60db2ab6e97f93c98808d08fd883003048c7
Gitweb:     http://git.kernel.org/tip/022d60db2ab6e97f93c98808d08fd883003048c7
Author:     Patrick Pannuto <ppannuto@codeaurora.org>
AuthorDate: Mon, 2 Aug 2010 15:01:06 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 4 Aug 2010 11:00:45 +0200

Checkpatch: Prefer usleep_range over udelay

When possible, sleeping is (usually) better than delaying;
however, don't bother callers of udelay < 10us, as those
cases are generally not worth the switch to usleep

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: apw@canonical.com
Cc: corbet@lwn.net
Cc: arjan@linux.intel.com
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1280786467-26999-4-git-send-email-ppannuto@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 scripts/checkpatch.pl |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..1698c63 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2570,6 +2570,14 @@ sub process {
 			}
 		}
 
+# prefer usleep_range over udelay
+		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
+			# ignore udelay's < 10, however
+			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
+				CHK("usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
