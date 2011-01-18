Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1ARUaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:30:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34854 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1ARUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:30:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mHDmm3RoDmms2aHDTW0eMxdMUDMe63n+tK/fsT9rxmwTBFWVWAZus681MVbnrDJ71s
         DR7yLvgDVLY+3iBxiAn+oZUkNfdo0FN9KC2vrnLYsdi3RBldB7zNQMAhT7h86BIDx+yo
         6P0w+i1xnhHVQ+uOWwfpfIf4FdGsDBHL6bMeE=
Subject: Re: WARNING in module rt2870sta stable kernel 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTi=HsE+h9GU8rM6zW2BVtoayEGfKOmPCsrrNHiz5@mail.gmail.com>
References: <AANLkTi=HsE+h9GU8rM6zW2BVtoayEGfKOmPCsrrNHiz5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 21:30:16 +0100
Message-ID: <1295382616.3194.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 janvier 2011 à 21:16 +0100, Giangiacomo Mariotti a écrit :
> Hi, the following message was logged on a 2.6.37 kernel(it says
> tainted, but it's actually a micro patch I wrote and applied on top of
> current 2.6.37 vanilla, patch appended, but it should be irrelevant, I
> just shut up a bunch of useless debug output for this staging driver):

Thats a known problem

Please try following patch

[PATCH] staging, rt2860: fix panic

Its now illegal to call netif_stop_queue() before register_netdev()
(commit e6484930d7 ("net: allocate tx queues inregister_netdevice")
    
Reported-by: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/staging/rt2860/rt_main_dev.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index 701561d..236dd36 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -484,8 +484,6 @@ struct net_device *RtmpPhyNetDevInit(struct rt_rtmp_adapter *pAd,
 	net_dev->ml_priv = (void *)pAd;
 	pAd->net_dev = net_dev;
 
-	netif_stop_queue(net_dev);
-
 	return net_dev;
 
 }


