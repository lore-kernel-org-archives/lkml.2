Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2LNGtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 01:49:03 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19103 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2LNGtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 01:49:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 13 Dec 2012 22:48:16 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/1] scripts/config: Fix wrong "shift" for --keep-case
Date: Fri, 14 Dec 2012 08:47:59 +0200
Message-ID: <1355467682-17217-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove wrong "shift" for --keep-case. There is always "shift" at
beginning of while-loop. No need "shift" at --keep-case just before
"continue" to process next argument.

Now the following works as expected:

./scripts/config -e aAa -k -e bBb -e cCc && tail -3 .config
CONFIG_AAA=y
CONFIG_bBb=y
CONFIG_cCc=y

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 scripts/config |    1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/config b/scripts/config
index ee35539..bb4d3de 100755
--- a/scripts/config
+++ b/scripts/config
@@ -101,7 +101,6 @@ while [ "$1" != "" ] ; do
 	case "$CMD" in
 	--keep-case|-k)
 		MUNGE_CASE=no
-		shift
 		continue
 		;;
 	--refresh)
-- 
1.7.9.5

