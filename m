Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2H0HZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:25:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14063 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2H0HZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:25:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,833,1336320000"; 
   d="scan'208";a="5730526"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 2/5] net:atm:fix up ENOIOCTLCMD error handling
Date: Mon, 27 Aug 2012 15:23:13 +0800
Message-Id: <1346052196-32682-3-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:15,
	Serialize complete at 2012/08/27 15:25:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
translated as ENOTTY to user mode.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 net/atm/resources.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/atm/resources.c b/net/atm/resources.c
index 23f45ce..0447d5d 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -432,7 +432,7 @@ int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat)
 			size = dev->ops->ioctl(dev, cmd, buf);
 		}
 		if (size < 0) {
-			error = (size == -ENOIOCTLCMD ? -EINVAL : size);
+			error = (size == -ENOIOCTLCMD ? -ENOTTY : size);
 			goto done;
 		}
 	}
-- 
1.7.12

