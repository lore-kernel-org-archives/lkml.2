Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505Ab2CTD1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:27:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45204 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab2CTD1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:27:20 -0400
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 3/4] compat: fix load time issue with kfifo backport
Date: Mon, 19 Mar 2012 20:27:00 -0700
Message-Id: <1332214021-9716-4-git-send-email-mcgrof@frijolero.org>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
In-Reply-To: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

The CONFIG_COMPAT_KFIFO config option must be defined
to CONFIG_COMPAT_KFIFO=y instead of CONFIG_COMPAT_KFIFO=m
as the kfifo object is not a module, its simply part of
the compat module. This should fix users of the kfifo
backport on kernels older than 2.6.36.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 scripts/gen-compat-config.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gen-compat-config.sh b/scripts/gen-compat-config.sh
index 423d595..5d6e34c 100755
--- a/scripts/gen-compat-config.sh
+++ b/scripts/gen-compat-config.sh
@@ -59,5 +59,5 @@ if [[ ${CONFIG_COMPAT_KERNEL_2_6_33} = "y" ]]; then
 fi
 
 if [[ ${CONFIG_COMPAT_KERNEL_2_6_36} = "y" ]]; then
-	echo "CONFIG_COMPAT_KFIFO=m"
+	echo "CONFIG_COMPAT_KFIFO=y"
 fi
-- 
1.7.10.rc1.22.gf5241

