Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0GEVfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 17:35:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58902 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0GEVfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 17:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=nyW7PchAI5/Uyf1pUoZlKCgWYjU5mM9oMrjbavdOAH07ym+VsDREh/t/YkDhpvc1zt
         kmVJwSaOCzQfhbyY8EWWP5boF6mDQ01uxkduit9yUpvCWx6ht565WTE3DcV7KqonwQs4
         AlCUTwqFoMzG0AmlkXjca5ovvwSmc53oh6G+4=
Subject: PATCH] Scripts: checkpatch: change externals to globals
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 23:34:43 +0200
Message-ID: <1278365683.5396.55.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9745542c84ef223eec8309a9fb7abf225153419d Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Mon, 5 Jul 2010 23:28:21 +0200
Subject: [PATCH] Scripts: checkpatch: change externals to globals

Made error message say 'ERROR: do not initialise globals to 0 or NULL'
rather than 'ERROR: do not initialise externals to 0 or NULL'.
Makes more sense in the context since there is an extern keyword in C and
that is a global declaration within the scope of the current file.
Signed-off-by: Joe Eloff <kagen101@gmail.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..6b003cf 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1778,9 +1778,9 @@ sub process {
 			WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 		}
 
-# check for external initialisers.
+# check for global initialisers.
 		if ($line =~ /^.$Type\s*$Ident\s*(?:\s+$Modifier)*\s*=\s*(0|NULL|false)\s*;/) {
-			ERROR("do not initialise externals to 0 or NULL\n" .
+			ERROR("do not initialise globals to 0 or NULL\n" .
 				$herecurr);
 		}
 # check for static initialisers.
-- 
1.6.3.3



