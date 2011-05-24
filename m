Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab1EXUCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:02:31 -0400
Received: from mail.perches.com ([173.55.12.10]:1983 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933391Ab1EXUC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:02:28 -0400
Subject: [PATCH] checkpatch: Add warning for uses of printk_ratelimit
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110524123433.0b74f33e.akpm@linux-foundation.org>
References: <1306075716-20042-1-git-send-email-richard@nod.at>
	 <1306075716-20042-5-git-send-email-richard@nod.at>
	 <20110524123433.0b74f33e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 13:02:26 -0700
Message-ID: <1306267346.2298.58.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn about uses of printk_ratelimit because it uses a
global state and can hide subsequent useful messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..d1a9adc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1943,6 +1943,11 @@ sub process {
 			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
 		}
 
+# check for uses of printk_ratelimit
+		if ($line =~ /\bprintk_ratelimit\s*\(/) {
+			WARN("Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
+		}
+
 # printk should use KERN_* levels.  Note that follow on printk's on the
 # same line do not need a level, so we use the current block context
 # to try and find and validate the current printk.  In summary the current


