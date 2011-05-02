Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab1EBOjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:39:10 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:42968 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759491Ab1EBOjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=P2+WkxMrCL1eFakDa7tSHkGDq2L7uQBv298ScuV5mYReOmhggVzrcuHHRrOWqckV06
         VJ6ln2zVJckD/oPkqTvHv3+yHo2+JnA1xP6OX+U6sR8b0euO+e+vGxT2j6kUc2/DRfGP
         +r63xvOTf7GZq7aDRaU0FwDdMovTxoqNQHTls=
Date: Mon, 2 May 2011 22:38:49 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, randy.dunlap@oracle.com, joe@perches.com,
        akpm@linux-foundation.org
Subject: [PATCH]Remove a warning for drivers/staging/wlan-ng/cfg80211.c
Message-ID: <20110502143845.GA4952@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, greg@kroah.com,
	randy.dunlap@oracle.com, joe@perches.com, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>
  
	When i was compiling kernel, a warning happened to me.
  The warning said like following.

drivers/staging/wlan-ng/cfg80211.c:709: warning: initialization from
incompatible pointer type.

See http://s1202.photobucket.com/albums/bb364/harrywei/?action=view&current=patched2.png
for more details.

So i patch like following.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
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

