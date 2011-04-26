Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1DZEjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:39:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1DZEjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=rvbZ8H5M5uFIrJk/6baBM8MxaVM/nhGJwi5WyGw/xTpzCnPQtz7CLd6ih/FZ3CEWEa
         0Y0YdZ8HqXRyuOFnp/wsrEduUujTTp/EP1T4nPjnO1r/QVwVusGT/8x1Q2I8AEpY2TcO
         LneKBpEu25GaXVcTvYD2cpTlyYt1O8ks5Bz+Y=
Date: Tue, 26 Apr 2011 12:38:37 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, joe@perches.com, randy.dunlap@oracle.com,
        akpm@linux-foundation.org
Subject: [PATCH]Remove a warning
Message-ID: <20110426043835.GA4154@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, greg@kroah.com,
	joe@perches.com, randy.dunlap@oracle.com, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
   When i was compiling kernel, a warning happened to me.
The warning said like following.

drivers/staging/wlan-ng/cfg80211.c:709: warning: initialization from 
incompatible pointer type

So i patched like this.

From: Harry Wei <harryxiyou@gmail.com>

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 6a71f52..7637839 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -273,7 +273,7 @@ exit:
 }
 
 int prism2_set_default_key(struct wiphy *wiphy, struct net_device *dev,
-			   u8 key_index)
+			   u8 key_index, bool unicast, bool multicast)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
 
-- 
1.7.0.4



