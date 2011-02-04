Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1BDUjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:39:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63306 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1BDUjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:39:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=up8kp1MsV0qNlcs81CtGaemBH8h//eC2clkh6w2YbGbx/MGmSTY770sWei5D8x1MrW
         w5PgTIJzNpju4S/4re3l7Hy4SWJ78tia9vI2fcuXdn1K0cgV561tk5y8sPujMAA1csgu
         q3oPukQgsH5nK2OYWKw0/DL549yfu7athMq9c=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH] sysctl: fix binary sysctl overflow
Date: Fri,  4 Feb 2011 22:38:55 +0200
Message-Id: <1296851935-6909-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocated a vector of CTL_MAXNAME elements and considered
[0, CTL_MAXNAME] as valid indexes in the vector.

This fixes valid index range to be [0, CTL_MAXNAME).

I guess this should be backported to stable trees too.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 kernel/sysctl_binary.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index b875bed..e2f377c 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1446,7 +1446,7 @@ static ssize_t do_sysctl(int __user *args_name, int nlen,
 	int i;
 
 	/* Check args->nlen. */
-	if (nlen < 0 || nlen > CTL_MAXNAME)
+	if (nlen < 0 || nlen >= CTL_MAXNAME)
 		return -ENOTDIR;
 	/* Read in the sysctl name for simplicity */
 	for (i = 0; i < nlen; i++)
-- 
1.7.4.rc1.7.g2cf08.dirty

