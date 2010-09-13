Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0IMIk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:40:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64767 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0IMIky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RJr/RZZbsMIK9WXAlIdP46fPkDHmmdsC2Jc84Ob6ywUNA25iZyUicS9YubRCuNJxLj
         YIL3cj3ONB7dJIbtuxjkTCGLQo3yo674FWpCoBpEI0lvY8/Mov3TqghJYuYU42AMYHzb
         4dG7IZ1pRiK0cAq+6XU4IP7st64a+yffDU4pU=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org
Subject: [PATCHv2 03/10] staging: brcm80211: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:27 +0300
Message-Id: <a017eca40cf5334b6c38a06c0cf9a831fee0e88d.1284316738.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Nohee Ko <noheek@broadcom.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/staging/brcm80211/util/bcmutils.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 364f837..c6c63a8 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -792,10 +792,7 @@ int BCMROMFN(bcm_ether_atoe) (char *p, struct ether_addr * ea) {
 
 char *bcm_ether_ntoa(const struct ether_addr *ea, char *buf)
 {
-	static const char template[] = "%02x:%02x:%02x:%02x:%02x:%02x";
-	snprintf(buf, 18, template,
-		 ea->octet[0] & 0xff, ea->octet[1] & 0xff, ea->octet[2] & 0xff,
-		 ea->octet[3] & 0xff, ea->octet[4] & 0xff, ea->octet[5] & 0xff);
+	snprintf(buf, 18, "%pM", ea->octet);
 	return (buf);
 }
 
-- 
1.7.2.2

