Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab1IAOwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:52:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42810 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628Ab1IAOwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:52:15 -0400
Message-ID: <4E5F9C14.1040108@gmail.com>
Date: Thu, 01 Sep 2011 22:52:04 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dev_ioctl should return -EINVAL for unknown ioctl instead
 of -ENOTTY
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.1-rc3.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 net/core/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 17d67b5..de6033c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5092,7 +5092,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 		/* Take care of Wireless Extensions */
 		if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST)
 			return wext_handle_ioctl(net, &ifr, cmd, arg);
-		return -ENOTTY;
+		return -EINVAL;
 	}
 }
 
-- 
1.7.1
