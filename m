Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab0JFXbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:31:33 -0400
Received: from mail.perches.com ([173.55.12.10]:2710 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab0JFXbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:31:33 -0400
Subject: [PATCH] scripts/checkpatch.pl: Warn on non-executable files
 created with non 100644 file permissions
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 16:31:31 -0700
Message-ID: <1286407891.32241.21.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..6f8a1d4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1346,6 +1346,14 @@ sub process {
 			}
 		}
 
+		if ($rawline =~ /^ create mode (\d+) ([\w\.\/\-]+)$/) {
+			my $mode = $1;
+			my $file = $2;
+			if ($mode ne "100644" && !($file =~ /\.(sh|pl|py|awk)$/)) {
+				WARN("FILE '$file' should probably use file permission 100644 not $mode\n" . $herecurr);
+			}
+		}
+
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("patch seems to be corrupt (line wrapped?)\n" .


