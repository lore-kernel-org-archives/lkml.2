Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0HRPsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51923 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0HRPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:13 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 13/16] checkpatch: clean up structure definition macro handline
Date: Wed, 18 Aug 2010 16:46:46 +0100
Message-Id: <1282146409-30544-14-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle definitions such as the following correctly, it is not
a complex statement:

    #define PREALLOC(NAME, START, END, FLAGS) {     \
		    .name = (NAME),                 \
		    .start = (START),               \
		    .end = (END),                   \
		    .flags = (FLAGS)                \
	    },

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 53b2eae..d5361e4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2476,8 +2476,8 @@ sub process {
 				\.$Ident\s*=\s*|
 				^\"|\"$
 			}x;
-			#print "REST<$rest> dstat<$dstat>\n";
-			if ($rest ne '') {
+			#print "REST<$rest> dstat<$dstat> ctx<$ctx>\n";
+			if ($rest ne '' && $rest ne ',') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
 				{
-- 
1.7.0.4

