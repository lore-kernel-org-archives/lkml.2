Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2KRVEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 16:04:51 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:63407 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2KRVEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 16:04:49 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Nov 2012 16:04:49 EST
From: pefoley2@verizon.net
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Cc: Peter Foley <pefoley2@verizon.net>
Subject: [PATCH 1/5] kbuild: remove deprecated use of defined in timeconst.pl
Date: Sun, 18 Nov 2012 15:05:13 -0500
Message-id: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Foley <pefoley2@verizon.net>

Fix this warning by removing a unneeded use of defined

TIMEC   kernel/timeconst.h
defined(@array) is deprecated at kernel/timeconst.pl line 373.
  	(Maybe you should just omit the defined()?)

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 kernel/timeconst.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
index eb51d76..0461239 100644
--- a/kernel/timeconst.pl
+++ b/kernel/timeconst.pl
@@ -370,7 +370,7 @@ if ($hz eq '--can') {
 	}
 
 	@val = @{$canned_values{$hz}};
-	if (!defined(@val)) {
+	if (!@val) {
 		@val = compute_values($hz);
 	}
 	output($hz, @val);
-- 
1.8.0

