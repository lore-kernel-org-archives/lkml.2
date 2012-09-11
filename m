Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab2IKPT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:19:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41585 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759157Ab2IKPT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:19:28 -0400
Message-ID: <1347376767.3985.7.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Update suggested printk conversions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Tue, 11 Sep 2012 08:19:27 -0700
In-Reply-To: <20120911025252.GA28112@kroah.com>
References: <1347331815-7278-1-git-send-email-brucehum@gmail.com>
	 <20120911025252.GA28112@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct conversion of printk(KERN_<LEVEL>... to pr_<level> isn't
the preferred conversion when a struct net_device or struct device
is available.

Hint that using netdev_<level> or dev_<level> is preferred to using
pr_<level>.  Add netdev_dbg and dev_dbg variants too.

Miscellaneous whitespace neatening of a misplaced close brace.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca05ba2..e1f4390 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -421,7 +421,7 @@ sub top_of_kernel_tree {
 		}
 	}
 	return 1;
-    }
+}
 
 sub parse_email {
 	my ($formatted_email) = @_;
@@ -2390,8 +2390,10 @@ sub process {
 			my $orig = $1;
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
+			my $level2 = $level;
+			$level2 = "dbg" if ($level eq "debug");
 			WARN("PREFER_PR_LEVEL",
-			     "Prefer pr_$level(... to printk(KERN_$1, ...\n" . $herecurr);
+			     "Prefer netdev_$level2(netdev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
 		}
 
 		if ($line =~ /\bpr_warning\s*\(/) {


