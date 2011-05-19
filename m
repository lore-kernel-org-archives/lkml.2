Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab1ESRXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:23:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46014 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESRXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=d9CA5svgLl3m7uEO2JKtUAYXALFQikYfzR2zLOvcJwr63w27T19KInIAv17zT1g+ry
         U2PojfFc7IdhUf6vbtPPoro8dlTaqV4xS6VDssGXcn8vVb+slSoVWWSQ4ul7PbuBo+rK
         ZN7zg6GeVaNxeCup5oznKrkZ9+QPMSpZkpwvA=
Subject: PATCH] patch to generate warning when signed-of line in patch in
 not proper
From: anish <anish198519851985@gmail.com>
To: apw@canonical.com, greg@kroah.com, man.k1983@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 22:53:29 +0530
Message-ID: <1305825809.2336.110.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This patch generates warning when there is no space between the
patch submitter name and successive mail-id.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 scripts/checkpatch.pl |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..437c6d4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1373,10 +1373,16 @@ sub process {
 				WARN("Signed-off-by: is the preferred form\n" .
 					$herecurr);
 			}
-			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("space required after Signed-off-by:\n" .
+			if ($line =~ /^\s*signed-off-by:(.*)/i) {
+			 if($1 !~ /^(\s[a-zA-Z].*)/i) {
+				WARN("Space required after Signed-off-by:\n" .
 					$herecurr);
 			}
+			if($1 !~ /[\sa-zA-Z]+\s<.*>/i) {
+				WARN("Space required between Full Name & Mail-id:\n" .
+					$herecurr);
+				}
+			}
 		}
 
 # Check for wrappage within a valid hunk of the file
-- 
1.7.0.4


