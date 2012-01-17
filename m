Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2AQQvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:51:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36069 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2AQQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:51:02 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Michal Marek <mmarek@suse.cz>,
        linux-modules@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH] kbuild: do not check for ancient modutils tools
Date: Tue, 17 Jan 2012 14:50:51 -0200
Message-Id: <1326819051-25712-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/depmod.sh checks for the output of '-V' expecting that it has
module-init-tools in it. It's a hack to prevent users from using
modutils instead of module-init-tools, that only works with 2.4.x
kernels. This however prints an annoying warning for kmod tool, that is
currently replacing module-init-tools.

Rather than putting another check for kmod's version, just remove it
since users of 2.4.x kernel are unlikely to upgrade to 3.x, and if they
do, let depmod fail in that case because they should know what they are
doing.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 scripts/depmod.sh |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/scripts/depmod.sh b/scripts/depmod.sh
index a272356..2ae4817 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -9,12 +9,6 @@ fi
 DEPMOD=$1
 KERNELRELEASE=$2
 
-if ! "$DEPMOD" -V 2>/dev/null | grep -q module-init-tools; then
-	echo "Warning: you may need to install module-init-tools" >&2
-	echo "See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt" >&2
-	sleep 1
-fi
-
 if ! test -r System.map -a -x "$DEPMOD"; then
 	exit 0
 fi
-- 
1.7.8.3

