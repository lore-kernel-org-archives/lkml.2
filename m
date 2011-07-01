Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1GAKOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:14:34 -0400
Received: from mail.perches.com ([173.55.12.10]:3415 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab1GAKOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:14:32 -0400
Subject: [PATCH] checkpatch: Make utf-8 test --strict
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110630225925.278e2471.akpm@linux-foundation.org>
References: <20110628145623.65567b78.akpm@linux-foundation.org>
	 <1309410138.1726.21.camel@Joe-Laptop>
	 <20110629231056.1b5d20a9.akpm@linux-foundation.org>
	 <1309491411.7277.23.camel@Joe-Laptop>
	 <20110630225925.278e2471.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 03:14:30 -0700
Message-ID: <1309515270.7277.36.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some patches are sent in using ISO-8859 or even Windows codepage 1252.

Make checkpatch accept these by default and only emit the "Invalid UTF-8"
message when using --strict.

Signed-off-by: Joe Perches <joe@perches.com>

---

 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b0aa2c6..313ee88 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1408,7 +1408,7 @@ sub process {
 			my $ptr = substr($blank, 0, length($utf8_prefix)) . "^";
 			my $hereptr = "$hereline$ptr\n";
 
-			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
+			CHK("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
 # ignore non-hunk lines and lines being removed


