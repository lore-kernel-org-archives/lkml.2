Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1FIRDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:03:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2673 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1FIRDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:03:46 -0400
Subject: [PATCH] checkpatch: Add a "prefer __aligned" check
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, kamezawa.hiroyu@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20110609094526.1571774c.akpm@linux-foundation.org>
References: <20110601172543.437240675@linux.com>
	 <20110601172614.725685218@linux.com> <4DF0991E.6060907@cs.helsinki.fi>
	 <20110609094526.1571774c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 10:03:44 -0700
Message-ID: <1307639024.13329.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefer the use of __aligned(size) over __attribute__((__aligned___(size)))

Link: http://lkml.kernel.org/r/20110609094526.1571774c.akpm@linux-foundation.org
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
---

On Thu, 2011-06-09 at 09:45 -0700, Andrew Morton wrote:
> I guess we need a "hey, use __aligned" checkpatch rule.

 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
 
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8657f99..352626c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2743,6 +2743,11 @@ sub process {
 			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
 
+# Check for __attribute__ aligned, prefer __aligned
+		if ($line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
+			WARN("__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("sizeof(& should be avoided\n" . $herecurr);



