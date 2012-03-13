Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab2CMGXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:23:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55821 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754318Ab2CMGXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:23:05 -0400
Message-ID: <1331619783.7100.8.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 12 Mar 2012 23:23:03 -0700
In-Reply-To: <1330667673.1939.22.camel@joe2Laptop>
References: <20120302025554.GA13493@joana>
	 <20120301.221643.881299898523907213.davem@davemloft.net>
	 <20120301.222316.1877216960521396397.davem@davemloft.net>
	 <20120301.222604.1508242694024394849.davem@davemloft.net>
	 <1330661602.1939.13.camel@joe2Laptop> <1330666534.1939.19.camel@joe2Laptop>
	 <1330667673.1939.22.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggest the shorter pr_<level> instead of printk(KERN_<LEVEL>.

Prefer to use pr_<level> over bare printks.
Prefer to use pr_warn over pr_warning.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 04eb9eb..ac2bbea 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2379,6 +2379,19 @@ sub process {
 			}
 		}
 
+		if ($line =~ /\bprintk\s*\(\s*KERN_([A-Z]+)/) {
+			my $orig = $1;
+			my $level = lc($orig);
+			$level = "warn" if ($level eq "warning");
+			WARN("PREFER_PR_LEVEL",
+			     "Prefer pr_$level(... to printk(KERN_$1, ...\n" . $herecurr);
+		}
+
+		if ($line =~ /\bpr_warning\s*\(/) {
+			WARN("PREFER_PR_LEVEL",
+			     "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and


