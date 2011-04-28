Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1D1CPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:15:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50663 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1D1CPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=T4l0oTzOJKECTRVj7mg+rqYQhCUxBZKXspozZ+4hi5QtYW4tWY9NCTNqYOVkGTCVwg
         H5DHj/Dqdrx1ZHx/IXyUqRHPP/AiL584vzemIbHQarbcQkG8fQI/DP4SaMfUN6pjXenG
         HmrrzVrSCQDmyCPszc0sPGFOwDHF5SNVB33jk=
Subject: [PATCH 2.6.38.4] mii: add support of pause frames in mii_get_an
From: artpol <artpol84@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, bhutchings@solarflare.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 09:15:11 +0700
Message-ID: <1303956911.2205.12.camel@artpol-thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support of pause frames advertise in mii_get_an. This provides all
drivers that use mii_ethtool_gset to represent their own and Link
partner flow control abilities in ethtool.

 Signed-off-by: Artem Polyakov <artpol84@gmail.com>

---

--- linux-2.6.38.4/drivers/net/mii.c.orig	2011-04-28 08:46:13.000000000
+0700
+++ linux-2.6.38.4/drivers/net/mii.c	2011-04-25 23:04:20.694981968 +0700
@@ -49,6 +49,10 @@ static u32 mii_get_an(struct mii_if_info
 		result |= ADVERTISED_100baseT_Half;
 	if (advert & ADVERTISE_100FULL)
 		result |= ADVERTISED_100baseT_Full;
+	if (advert & ADVERTISE_PAUSE_CAP)
+		result |= ADVERTISED_Pause;
+	if (advert & ADVERTISE_PAUSE_ASYM)
+		result |= ADVERTISED_Asym_Pause;
 
 	return result;
 }

