Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2LTTPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:15:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49178 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2LTTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:21 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Jason Wessel <jason.wessel@windriver.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] kdb: use DIV_ROUND_UP where possible
Date: Thu, 20 Dec 2012 14:11:37 -0500
Message-Id: <1356030701-16284-29-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/debug/kdb/kdb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 18ce064..199abdc 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1670,7 +1670,7 @@ static int kdb_md(int argc, const char **argv)
 			    num, repeat, phys);
 		addr += bytesperword * n;
 		repeat -= n;
-		z = (z + num - 1) / num;
+		z = DIV_ROUND_UP(z, num);
 		if (z > 2) {
 			int s = num * (z-2);
 			kdb_printf(kdb_machreg_fmt0 "-" kdb_machreg_fmt0
-- 
1.8.0

