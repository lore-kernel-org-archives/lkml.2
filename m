Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2LSBbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:31:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:50636 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755029Ab2LSBbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:31:02 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH V2] checkpatch: Warn on uapi #includes that #include <uapi/...
Date: Tue, 18 Dec 2012 17:30:58 -0800
Message-Id: <836be70329567778096e6a5b9e898a85238b382c.1355879564.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <28860.1355870146@warthog.procyon.org.uk>
References: <28860.1355870146@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid specifying internal uapi #include paths with uapi/...
as userspace should not use and never see that.

Neaten message line wrapping above.

Signed-off-by: Joe Perches <joe@perches.com>
cc: David Howells <dhowells@redhat.com>
---
 scripts/checkpatch.pl |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 054a293..5eab67e 100755
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
+			if ($path =~ "^uapi/" && $realfile =~ m@\binclude/uapi/@) {
+				ERROR("UAPI_INCLUDE",
+				      "No #include in ...include/uapi/... should use a uapi/ path prefix\n" . $herecurr);
 			}
 		}
 
-- 
1.7.8.112.g3fd21

