Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2GLFXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:23:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60773 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752313Ab2GLFXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:23:33 -0400
Message-ID: <1342070612.1970.16.camel@joe2Laptop>
Subject: [PATCH V2] checkpatch: Add check for use of sizeof without
 parenthesis
From: Joe Perches <joe@perches.com>
To: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Cc: mm-commits@vger.kernel.org, apw@canonical.com,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jul 2012 22:23:32 -0700
In-Reply-To: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel style uses parenthesis around sizeof.

Signed-off-by: Joe Perches <joe@perches.com>
---
Add check that works for sizeof *foo as well as sizeof foo

 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7190f95..72c1803 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3265,6 +3265,12 @@ sub process {
 			     "sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# check for sizeof without parenthesis
+		if ($line =~ /\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/) {
+			WARN("SIZEOF_PARENTHESIS",
+			     "sizeof $1 should be sizeof($1)\n" . $herecurr);
+		}
+
 # check for line continuations in quoted strings with odd counts of "
 		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
 			WARN("LINE_CONTINUATIONS",


