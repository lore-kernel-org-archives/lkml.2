Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0IPMLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:11:23 -0400
Received: from mail.perches.com ([173.55.12.10]:2084 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab0IPMLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:11:14 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] scripts/get_maintainer.pl: Don't search MAINTAINERS for keywords or emails
Date: Thu, 16 Sep 2010 05:11:10 -0700
Message-Id: <b40a16676e4b53600faf42d1f4966eacac04ba2c.1284636516.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284636516.git.joe@perches.com>
References: <cover.1284636516.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keyword matching uses K: patterns from MAINTAINERS, so if
looking for the MAINTAINERS maintainer, don't search MAINTAINERS
for pattern matches.  MAINTAINERS also has rather a lot of email
addresses and is easily searched using grep "^M:", so skip it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 65c6acf..36e889f 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -304,7 +304,7 @@ foreach my $file (@ARGV) {
     }
     if ($from_filename) {
 	push(@files, $file);
-	if (-f $file && ($keywords || $file_emails)) {
+	if ($file ne "MAINTAINERS" && -f $file && $file_emails) {
 	    open(my $f, '<', $file)
 		or die "$P: Can't open $file: $!\n";
 	    my $text = do { local($/) ; <$f> };
-- 
1.7.3.rc1

