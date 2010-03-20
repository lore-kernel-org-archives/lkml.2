Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0CTEx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:53:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54920 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0CTEx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:53:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PKnuWlDGubnu3ScVLUlxiKKbG4fl/AWPsHk5boN+fJUshxmMOhQJjfZP2iP86S4vQE
         teHyUG/HI2xsj/jhaJbbsumRGuRrVAw0ou7VJ7BfeTXvZyVNqoIqxsD7bOLLinPTwm8E
         Y9CgmmQK5ZOx6QijpJEpvzjHC40zLknj2S52A=
Date: Sat, 20 Mar 2010 12:53:52 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [PATCH] Wireless: Make cfg80211_dev_rename() check sscanf return value in net/wireless/core.c
Message-ID: <20100320045352.GA2949@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make cfg80211_dev_rename() check sscanf return value.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/wireless/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 80afacd..8e815b4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -146,7 +146,9 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 	int idx, taken = -1, result, digits;
 
 	/* prohibit calling the thing phy%d when %d is not its number */
-	sscanf(newname, PHY_NAME "%d%n", &idx, &taken);
+	if (sscanf(newname, PHY_NAME "%d%n", &idx, &taken) != 2)
+		return -EINVAL;
+
 	if (taken == strlen(newname) && idx != rdev->idx) {
 		/* count number of places needed to print idx */
 		digits = 1;
-- 
1.6.5.3

