Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0HRPrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:47:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47659 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0HRPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:10 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 02/16] checkpatch: types may sit on a line on their own
Date: Wed, 18 Aug 2010 16:46:35 +0100
Message-Id: <1282146409-30544-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the following form is used we have a type which fully fills a line.
This means that a type may end at the end of line as well as at the
following identifier.

	int **
	foo;

Reported-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0a87c74..41f59b1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -843,7 +843,7 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\()/) {
+		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\(|\s*$)/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
-- 
1.7.0.4

