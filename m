Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2BOVPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:15:08 -0500
Received: from 78-105-5-67.zone3.bethere.co.uk ([78.105.5.67]:53695 "EHLO
	nurket" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750898Ab2BOVPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:15:06 -0500
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Feb 2012 16:15:05 EST
From: =?UTF-8?q?Dagfinn=20Ilmari=20Manns=C3=A5ker?= <ilmari@ilmari.org>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Dagfinn=20Ilmari=20Manns=C3=A5ker?= <ilmari@ilmari.org>
Subject: [PATCH] timeconst.pl: remove deprecated defined(@array)
Date: Wed, 15 Feb 2012 21:06:26 +0000
Message-Id: <1329339986-28591-1-git-send-email-ilmari@ilmari.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of defined() on arrays and hashes has been deprecated since perl
5.6, but until 5.17.6 it only warned on lexicals, not package globals.

Signed-off-by: Dagfinn Ilmari Mannsåker <ilmari@ilmari.org>
---
 kernel/timeconst.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.5.4

