Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab1DMAgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:36:51 -0400
Received: from mail.perches.com ([173.55.12.10]:4669 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab1DMAgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:36:50 -0400
Subject: [PATCH] checkpatch: Add check for line continuations in quoted
 strings
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110412163743.1d7353c4.akpm@linux-foundation.org>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC209@KCINPUNHJCMS01.kpit.com>
	 <20110412163743.1d7353c4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 17:36:48 -0700
Message-ID: <1302655008.11415.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a warning for unterminated quoted strings with line continuations
as these frequently add unwanted whitespace.

Signed-off-by: Joe Perches <joe@perches.com>

---

 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..f3f907b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2748,6 +2748,11 @@ sub process {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# check for line continuations in quoted strings with odd counts of "
+		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
+			WARN("Avoid line continuations in quoted strings\n" . $herecurr);
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)


