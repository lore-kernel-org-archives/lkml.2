Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2FTWKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:10:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50777 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758123Ab2FTWKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:10:06 -0400
Message-ID: <1340230206.29885.25.camel@joe2Laptop>
Subject: [PATCH] scripts/get_maintainer.pl: Test for non-standard signatures
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 15:10:06 -0700
In-Reply-To: <20120620143959.394b9930.akpm@linux-foundation.org>
References: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com>
	 <1340209526.29885.14.camel@joe2Laptop>
	 <20120620143959.394b9930.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn on non-standard signature styles.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 630319a..3e04f80 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1600,13 +1600,17 @@ sub process {
 
 # Check signature styles
 		if (!$in_header_lines &&
-		    $line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
+		    $line =~ /^(\s*)([a-z0-9_-]+by:|$signature_tags)(\s*)(.*)/i) {
 			my $space_before = $1;
 			my $sign_off = $2;
 			my $space_after = $3;
 			my $email = $4;
 			my $ucfirst_sign_off = ucfirst(lc($sign_off));
 
+			if ($sign_off !~ /$signature_tags/) {
+				WARN("BAD_SIGN_OFF",
+				     "Non-standard signature: $sign_off\n" . $herecurr);
+			}
 			if (defined $space_before && $space_before ne "") {
 				WARN("BAD_SIGN_OFF",
 				     "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);


