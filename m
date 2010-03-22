Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0CVVeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:34:09 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:61810 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab0CVVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UM2rOujdONbwyN/pxYxdO2k3X9qhNw9kXsIpdpiDTmD2Q5tKchutGmUcqySwmEmeKL
         YZgWLJSQFREbUdyphV0hk4AQrZH4tmtz0eVxB277hPQRZwWJZpLBfgM9f0Lq5TVc/M8O
         6dIkt/cagqnmlpfdozBB9366anEZoke2UnHXg=
Message-ID: <4BA7E2D4.3090308@gmail.com>
Date: Mon, 22 Mar 2010 22:36:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, forest@alittletooquiet.net
Subject: [PATCH] vt6655: CGI/CSI confusion in device_ioctl()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong messages were printed

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/vt6655/device_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1d64365..16cfd30 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3327,7 +3327,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 	case SIOCSIWTXPOW:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW \n");
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWTXPOW \n");
         rc = -EOPNOTSUPP;
 		break;
 
@@ -3405,7 +3405,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		// Get the spy list
 	case SIOCGIWSPY:
 
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY \n");
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSPY \n");
 		rc = -EOPNOTSUPP;
 		break;
 
