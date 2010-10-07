Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0JGUTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:19:09 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57534
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755288Ab0JGUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:19:07 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
From: <alan.tull@freescale.com>
To: <mmarek@suse.cz>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alan Tull <alan.tull@freescale.com>
Subject: [PATCH] Fix LOCALVERSION append plus logic
Date: Thu, 7 Oct 2010 15:18:52 -0500
Message-ID: <1286482732-12087-1-git-send-email-alan.tull@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <alan.tull@freescale.com>

This change fixes the logic to do what the comment says
when CONFIG_LOCALVERSION_AUTO and CONFIG_LOCALVERSION are
both not set.

Also fix a spelling error in the comment.

If the kernel tree is in git, here's the config
permutations (with CONFIG_LOCALVERSION_AUTO turned off)
and the image name resulting:

CONFIG_LOCALVERSION=""
results:
patched   :   Linux-2.6.35.3+
unpatched :   Linux-2.6.35.3

CONFIG_LOCALVERSION="-something"
results:
patched   :   Linux-2.6.35.3-something
unpatched :   Linux-2.6.35.3-something+

Signed-off-by: Alan Tull <alan.tull@freescale.com>
---
 scripts/setlocalversion |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 64a9cb5..4488a33 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -160,9 +160,9 @@ if test "$CONFIG_LOCALVERSION_AUTO" = "y"; then
 	# full scm version string
 	res="$res$(scm_version)"
 else
-	# apped a plus sign if the repository is not in a clean tagged
+	# append a plus sign if the repository is not in a clean tagged
 	# state and  LOCALVERSION= is not specified
-	if test "${LOCALVERSION+set}" != "set"; then
+	if test "$CONFIG_LOCALVERSION" = ""; then
 		scm=$(scm_version --short)
 		res="$res${scm:++}"
 	fi
-- 
1.6.0.4


