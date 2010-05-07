Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0EGHHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:07:33 -0400
Received: from ist.d-labs.de ([213.239.218.44]:52593 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0EGHHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:07:31 -0400
X-Greylist: delayed 1931 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 03:07:31 EDT
From: florian@mickler.org
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH] get_maintainer.pl: ignore non-maintainer tags
Date: Fri,  7 May 2010 08:34:55 +0200
Message-Id: <1273214095-23396-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273179148.1537.145.camel@Joe-Laptop.home>
References: <1273179148.1537.145.camel@Joe-Laptop.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using --git to determine who to send a patch to, it is not
reasonable to include people that only reported an issue or tested a
patch. Thus we restrict the candidates to be the one's listed with
Reviewed-By, Signed-Off-By and Acked-By tags.

The Acked-By: is questionable also, but as people listed with this tag
tend to be active linux gatekeepers, false positives are tolerable.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 6f97a13..ad38ed3 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -496,7 +496,7 @@ version: $V
 
 MAINTAINER field selection options:
   --email => print email address(es) if any
-    --git => include recent git \*-by: signers
+    --git => include recent git {Reviewed|Signed-Off|Acked}-by: signers
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
@@ -964,7 +964,7 @@ sub vcs_find_signers {
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
-    @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
+    @lines = grep(/(signed-off|reviewed|acked)-by:.*\@.*$/i, @lines);
     if (!$email_git_penguin_chiefs) {
 	@lines = grep(!/${penguin_chiefs}/i, @lines);
     }
-- 
1.7.0.4

