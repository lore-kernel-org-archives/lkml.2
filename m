Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab1FPOF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:05:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:52002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab1FPOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:05:23 -0400
Date: Thu, 16 Jun 2011 14:05:08 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-bde66c3f45d777082a0df01e64870f47ba2a5055@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, jreiser@bitwagon.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, jreiser@bitwagon.com, tglx@linutronix.de
In-Reply-To: <20110421023737.743350547@goodmis.org>
References: <20110421023737.743350547@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Add .kprobe.text section to whitelist for recordmcount.c
Git-Commit-ID: bde66c3f45d777082a0df01e64870f47ba2a5055
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 14:05:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bde66c3f45d777082a0df01e64870f47ba2a5055
Gitweb:     http://git.kernel.org/tip/bde66c3f45d777082a0df01e64870f47ba2a5055
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 6 Apr 2011 14:10:22 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 17 May 2011 10:41:36 -0400

ftrace: Add .kprobe.text section to whitelist for recordmcount.c

The .kprobe.text section is safe to modify mcount to nop and tracing.
Add it to the whitelist in recordmcount.c and recordmcount.pl.

Cc: John Reiser <jreiser@bitwagon.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20110421023737.743350547@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c  |    1 +
 scripts/recordmcount.pl |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 4ebd839..37c5965 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -211,6 +211,7 @@ is_mcounted_section_name(char const *const txtname)
 		strcmp(".sched.text",    txtname) == 0 ||
 		strcmp(".spinlock.text", txtname) == 0 ||
 		strcmp(".irqentry.text", txtname) == 0 ||
+		strcmp(".kprobes.text", txtname) == 0 ||
 		strcmp(".text.unlikely", txtname) == 0;
 }
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 4be0dee..a871cd4 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -134,6 +134,7 @@ my %text_sections = (
      ".sched.text" => 1,
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
+     ".kprobes.text" => 1,
      ".text.unlikely" => 1,
 );
 
