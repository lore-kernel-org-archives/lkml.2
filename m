Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2ECDuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:50:08 -0400
Received: from fed1rmfepi101.cox.net ([68.230.241.132]:58864 "EHLO
	fed1rmfepi101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2ECDuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:50:06 -0400
X-Greylist: delayed 1065 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 23:50:05 EDT
X-CT-Class: Clean
X-CT-Score: 0.00
X-CT-RefID: str=0001.0A020205.4FA1FC44.0049,ss=1,re=0.000,fgs=0
X-CT-Spam: 0
X-Authority-Analysis: v=1.1 cv=RVIG98EmAZX5jXArMQd8FxtCZcYhwc9mn7hyf7cAkwU=
 c=1 sm=1 a=mP9BgSo-EEkA:10 a=rcTfVT_afHIA:10 a=zukJ/Oo2bNzQHA4rRbcyFw==:17
 a=R_N1NMmAAAAA:8 a=yDHarTkmhRPoGD_PITYA:9 a=QOiTB_lUNkwA:10
 a=zukJ/Oo2bNzQHA4rRbcyFw==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; none
From: Eric Nelson <eric.nelson@boundarydevices.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, u-boot@lists.denx.de, rylv50@freescale.com,
        marex@denx.de, vapier@gentoo.org,
        Eric Nelson <eric.nelson@boundarydevices.com>
Subject: [PATCH] checkpatch: add check for whitespace before semicolon at end-of-line
Date: Wed,  2 May 2012 20:32:18 -0700
Message-Id: <1336015938-3174-1-git-send-email-eric.nelson@boundarydevices.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <http://lists.denx.de/pipermail/u-boot/2012-May/123595.html>
References: <http://lists.denx.de/pipermail/u-boot/2012-May/123595.html>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tests for a bad habits of mine like this:

	return 0 ;

Signed-off-by: Eric Nelson <eric.nelson@boundarydevices.com>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..0e6977e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3227,6 +3227,12 @@ sub process {
 			 "Statements terminations use 1 semicolon\n" . $herecurr);
 		}
 
+# check for whitespace before semicolon - not allowed at end-of-line
+		if ($line =~ /\s+;$/) {
+		    WARN("SPACEBEFORE_SEMICOLON",
+			 "Whitespace before semicolon\n" . $herecurr);
+		}
+
 # check for gcc specific __FUNCTION__
 		if ($line =~ /__FUNCTION__/) {
 			WARN("USE_FUNC",
-- 
1.7.9

