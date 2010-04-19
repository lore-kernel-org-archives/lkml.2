Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0DSMrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:47:53 -0400
Received: from 60-242-66-41.static.tpgi.com.au ([60.242.66.41]:38782 "EHLO
	fs.beware.dropbear.id.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753974Ab0DSMrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:47:51 -0400
X-Greylist: delayed 2207 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 08:47:51 EDT
Subject: [1/1] w1: w1 temp. Fix negative termperature calculation.
From: Ian Dall <ian@beware.dropbear.id.au>
To: Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 19 Apr 2010 21:40:26 +0930
Message-Id: <1271679026.4679.26.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (fs.beware.dropbear.id.au [10.0.0.1]); Mon, 19 Apr 2010 21:40:33 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug 12646 has been outstanding for a long time. Is it possible to get
this fix committed?


Log:
From: Ian Dall <ian@beware.dropbear.id.au>

Fix regression caused by commit
507e2fbaaacb6f164b4125b87c5002f95143174b,
whereby negative temperatures for the DS18B20 are not converted
properly. Fixes bug 12646.

Signed-of-by: Ian Dall <ian@beware.dropbear.id.au>


diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 1ed3d55..17726a0 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -115,9 +115,8 @@ static struct w1_therm_family_converter w1_therm_families[] = {
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	int t = ((s16)rom[1] << 8) | rom[0];
-	t = t*1000/16;
-	return t;
+	s16 t = le16_to_cpup((__le16 *)rom);
+	return t*1000/16;
 }
 
 static inline int w1_DS18S20_convert_temp(u8 rom[9])


-- 
Ian Dall <ian@beware.dropbear.id.au>

