Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2LRRxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:53:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37780 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752559Ab2LRRxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:53:15 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Warn on #include <uapi/...
Date: Tue, 18 Dec 2012 09:53:11 -0800
Message-Id: <9cfc0861cd3ae0a7d4e72056c00b8bebef1490eb.1355853060.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <6433.1355840610@warthog.procyon.org.uk>
References: <6433.1355840610@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid specifying include paths with uapi/...
as userspace should not use that path.

Neaten message line wrapping above.

Signed-off-by: Joe Perches <joe@perches.com>
cc: David Howells <dhowells@redhat.com>
---
 scripts/checkpatch.pl |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 054a293..d0c11ee 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2238,8 +2238,11 @@ sub process {
 			my $path = $1;
 			if ($path =~ m{//}) {
 				ERROR("MALFORMED_INCLUDE",
-				      "malformed #include filename\n" .
-					$herecurr);
+				      "malformed #include filename\n" . $herecurr);
+			}
+			if ($path =~ "^uapi/") {
+				ERROR("UAPI_INCLUDE",
+				      "#include should not start with uapi/\n" . $herecurr);
 			}
 		}
 
-- 
1.7.8.112.g3fd21

