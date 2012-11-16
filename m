Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab2KPGVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:21:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60290 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751332Ab2KPGVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:21:14 -0500
Message-ID: <1353046873.24310.30.camel@joe-AO722>
Subject: [PATCH] checkpatch: extend line continuation test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Cc: Andy Whitcroft <apw@canonical.com>, peter@hurleysoftware.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Nov 2012 22:21:13 -0800
In-Reply-To: <20121030211530.09F1320004E@hpza10.eem.corp.google.com>
References: <20121030211530.09F1320004E@hpza10.eem.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preprocessor directives and asm statements should be
allowed to have a line continuation.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d2d5ba1..019f9be 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3006,10 +3006,12 @@ sub process {
 				}
 			}
 
-# check for line continuations outside of #defines
+# check for line continuations outside of #defines, preprocessor #, and asm
 
 		} else {
 			if ($prevline !~ /^..*\\$/ &&
+			    $line !~ /^\+\s*\#*.*\\$/ &&	# preprocessor
+			    $line !~ /^\+.*\b(__asm__|asm)\b.*\\$/ &&	# asm
 			    $line =~ /^\+.*\\$/) {
 				WARN("LINE_CONTINUATIONS",
 				     "Avoid unnecessary line continuations\n" . $herecurr);


