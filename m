Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0IKORi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:17:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50581 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab0IKORe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TmX6ZdaHFVUS6t8KyOoxY4BXZqxa5ZdkUbJ2VMQtlsuDeg3uc6KxX/5XVZApmkK6po
         H3E1Iv9fPL592i8JXD1pG5u60fomZixbiMZU9aeK5hci9dluM/dxJeHR9R7TTlk70+qe
         UeHwX1JsO+dfmqVBVxru5X829MM4pQ5BTWZBE=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 03/10] staging: brcm80211: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:06 +0300
Message-Id: <09659e2f288f6c602b0e584e2b2ef871bab03637.1284214460.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/util/bcmutils.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 364f837..58bbddc 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -792,10 +792,7 @@ int BCMROMFN(bcm_ether_atoe) (char *p, struct ether_addr * ea) {
 
 char *bcm_ether_ntoa(const struct ether_addr *ea, char *buf)
 {
-	static const char template[] = "%02x:%02x:%02x:%02x:%02x:%02x";
-	snprintf(buf, 18, template,
-		 ea->octet[0] & 0xff, ea->octet[1] & 0xff, ea->octet[2] & 0xff,
-		 ea->octet[3] & 0xff, ea->octet[4] & 0xff, ea->octet[5] & 0xff);
+	snprintf(buf, 18, "%pM", &ea->octet[0]);
 	return (buf);
 }
 
-- 
1.7.2.2

