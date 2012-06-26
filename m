Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab2FZPVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:21:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab2FZPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:21:06 -0400
Date: Tue, 26 Jun 2012 08:20:50 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-1b6b7c9ff3514772958c075f8c89e42dddf6a4d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        khali@linux-fr.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        khali@linux-fr.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20120626143246.0c9bf301@endymion.delvare>
References: <20120626143246.0c9bf301@endymion.delvare>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpufeature: Remove stray %s,
  add -w to mkcapflags.pl
Git-Commit-ID: 1b6b7c9ff3514772958c075f8c89e42dddf6a4d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 26 Jun 2012 08:20:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b6b7c9ff3514772958c075f8c89e42dddf6a4d8
Gitweb:     http://git.kernel.org/tip/1b6b7c9ff3514772958c075f8c89e42dddf6a4d8
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 26 Jun 2012 07:58:23 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 26 Jun 2012 08:02:48 -0700

x86, cpufeature: Remove stray %s, add -w to mkcapflags.pl

There was a stray %s left from testing, remove it.

Add -w to the #! line (which is parsed by Perl even if the Perl
interpreter is invoked explicitly on the command line) to catch these
kinds of errors in the future.

Reported-by: Jean Delvare <khali@linux-fr.org>
Link: http://lkml.kernel.org/r/20120626143246.0c9bf301@endymion.delvare
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mkcapflags.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mkcapflags.pl b/arch/x86/kernel/cpu/mkcapflags.pl
index 0c5b549..c7b3fe2 100644
--- a/arch/x86/kernel/cpu/mkcapflags.pl
+++ b/arch/x86/kernel/cpu/mkcapflags.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
 #
 # Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
 #
@@ -29,7 +29,7 @@ while (defined($line = <IN>)) {
 			print STDERR "$in: duplicate feature name: $feature\n";
 			$err++;
 		}
-		printf OUT "\t%-32s = \"%s\",%s\n", "[$macro]", $feature;
+		printf OUT "\t%-32s = \"%s\",\n", "[$macro]", $feature;
 	}
 }
 print OUT "};\n";
