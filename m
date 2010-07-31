Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0GaQ1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 12:27:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45215 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0GaQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 12:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qd1UlwHtqi9hNZFZ4MEGcgEh9p/xgqlg4mhZwJl2ze0pZjmYb0IY0BGbLSnPEnbkHS
         hubhYlyJWMkePv49LGWMHfsta9Ia0zCv93LTS1EVUZKrMu42ZHcfoUzwzed+s8Qe6LF5
         m0c3dH+BnHgIbvitQW8r/sxPvpv0n0NFUspDw=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH] Staging: wlan-ng: remove typedef in p80211ioctl.h
Date: Sat, 31 Jul 2010 13:29:22 -0300
Message-Id: <1280593762-23120-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches removes the only typedef in p80211ioctl.h

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/p80211ioctl.h  |    4 ++--
 drivers/staging/wlan-ng/p80211netdev.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211ioctl.h b/drivers/staging/wlan-ng/p80211ioctl.h
index 64ca7f9..0d47765 100644
--- a/drivers/staging/wlan-ng/p80211ioctl.h
+++ b/drivers/staging/wlan-ng/p80211ioctl.h
@@ -78,12 +78,12 @@
 /*  argument to the ioctl system call when issuing a request to */
 /*  the p80211 module. */
 
-typedef struct p80211ioctl_req {
+struct p80211ioctl_req {
 	char name[WLAN_DEVNAMELEN_MAX];
 	caddr_t data;
 	u32 magic;
 	u16 len;
 	u32 result;
-} __attribute__ ((packed)) p80211ioctl_req_t;
+} __attribute__ ((packed));
 
 #endif /* _P80211IOCTL_H */
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 5b68af0..a57ac52 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -560,7 +560,7 @@ static int p80211netdev_ethtool(wlandevice_t *wlandev, void __user *useraddr)
 static int p80211knetdev_do_ioctl(netdevice_t *dev, struct ifreq *ifr, int cmd)
 {
 	int result = 0;
-	p80211ioctl_req_t *req = (p80211ioctl_req_t *) ifr;
+	struct p80211ioctl_req *req = (struct p80211ioctl_req *) ifr;
 	wlandevice_t *wlandev = dev->ml_priv;
 	u8 *msgbuf;
 
-- 
1.7.0.4

