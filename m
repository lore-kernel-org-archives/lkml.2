Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab0GVQ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:58:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVQ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QkVmr2YWuk8jajH3i8WGXtTkol3FEE7zd5Ai3Rm4F2na+fBcNWCaWpikYq/PacIinK
         2afVUCH2o3sx8DXDU55kVk3WIKepZJDmQ1f/hCg0bjhOIpuoTqVB3KfPUnzz3xFiKLiY
         C4Eaf8yAkr2SXNiG/RAMOd4QSXu56hcDP8dk8=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/5] staging: remove unused methods
Date: Thu, 22 Jul 2010 19:57:07 +0300
Message-Id: <425abf06a3fceaab7d00ea5d4d5b28e5db4f2002.1279817399.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20100722151545.GA6696@suse.de>
References: <20100722151545.GA6696@suse.de>
In-Reply-To: <cover.1279817399.git.andy.shevchenko@gmail.com>
References: <cover.1279817399.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is rebased version of the patch [1] which was mysteriously not
pushed anywhere but acked.

Here are two methods to convert hex value to binary format. These
certain methods aren't used anywhere in kernel.

[1] http://lkml.org/lkml/2010/2/18/267

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/otus/apdbg.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
index 32c26e5..09415a6 100644
--- a/drivers/staging/otus/apdbg.c
+++ b/drivers/staging/otus/apdbg.c
@@ -90,28 +90,6 @@ struct zdap_ioctl {
 
 #endif
 
-static char hex(char v)
-{
-	if (isdigit(v))
-		return v - '0';
-	else if (isxdigit(v))
-		return tolower(v) - 'a' + 10;
-	else
-		return 0;
-}
-
-static unsigned char asctohex(char *str)
-{
-	unsigned char value;
-
-	value = hex(*str) & 0x0f;
-	value = value << 4;
-	str++;
-	value |= hex(*str) & 0x0f;
-
-	return value;
-}
-
 char *prgname;
 
 int set_ioctl(int sock, struct ifreq *req)
-- 
1.7.1.1

