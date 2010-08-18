Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0HRPtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:49:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51882 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0HRPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:11 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 05/16] checkpatch: handle casts better fixing false categorisation of : as binary
Date: Wed, 18 Aug 2010 16:46:38 +0100
Message-Id: <1282146409-30544-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following incantation is triggering categorisation of its colon (:)
as a binary form, which it is not:

	return foo ? (s8)bar : baz;

Handle casts differently from types in the categoriser, allowing us
to better track (s8)bar as a value and not a declaration.

Reported-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8d010ac..3cec299 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -845,6 +845,11 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
+		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/) {
+			print "CAST($1)\n" if ($dbg_values > 1);
+			push(@av_paren_type, $type);
+			$type = 'C';
+
 		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\(|\s*$)/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
-- 
1.7.0.4

