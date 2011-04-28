Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab1D1BaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:30:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65495 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab1D1BaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=USiKvmp0JZU95gmm4X9NB/uWF6HZPOmYr43xNYN2Shzot3u2XfgNeWGHGVq7AQfpZn
         M9kNlpu4+Y4pno1mB6hNJpenOvp0AvSpk3K614iwJilblWtGUjk/tV/5jzrFWuD38goG
         rwfoABh1lLBCmG+5AbkPkJtISWPmonRbe78wc=
Date: Thu, 28 Apr 2011 09:30:01 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: greg@kroah.com
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, joe@perches.com,
        akpm@linux-foundation.org
Subject: [PATCH]Remove a warning for drivers/staging/wlan-ng/cfg80211.c
Message-ID: <20110428012958.GA2176@gmail.com>
Mail-Followup-To: greg@kroah.com, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, joe@perches.com,
	akpm@linux-foundation.org
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



