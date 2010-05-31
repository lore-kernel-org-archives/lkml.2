Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0EaFx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 01:53:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab0EaFx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 01:53:27 -0400
Message-ID: <4C034FA4.5000401@redhat.com>
Date: Mon, 31 May 2010 13:56:52 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Flavio Leitner <fbl@sysclose.org>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       Andy Gospodarek <gospo@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and bonding
 devices
References: <20100505081514.5157.83783.sendpatchset@localhost.localdomain> <20100527180545.GA2345@sysclose.org> <4BFF2EA5.9090008@redhat.com> <20100528194041.GC2345@sysclose.org>
In-Reply-To: <20100528194041.GC2345@sysclose.org>
Content-Type: multipart/mixed;
 boundary="------------080108050002040107090202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080108050002040107090202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Flavio,

Please use the attached patch instead, try to see if it solves
all your problems.

Thanks a lot!


--------------080108050002040107090202
Content-Type: text/x-patch;
 name="drivers-net-bonding-fix-activebackup-deadlock.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="drivers-net-bonding-fix-activebackup-deadlock.diff"

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index ca142c4..2d1d594 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -666,7 +666,8 @@ static int netconsole_netdev_event(struct notifier_block *this,
 	struct net_device *dev = ptr;
 
 	if (!(event == NETDEV_CHANGENAME || event == NETDEV_UNREGISTER ||
-	      event == NETDEV_BONDING_DESLAVE || event == NETDEV_GOING_DOWN))
+	      event == NETDEV_BONDING_DESLAVE || event == NETDEV_GOING_DOWN ||
+	      event == NETDEV_BONDING_FAILOVER))
 		goto done;
 
 	spin_lock_irqsave(&target_list_lock, flags);
@@ -682,6 +683,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 				/* Fall through */
 			case NETDEV_GOING_DOWN:
 			case NETDEV_BONDING_DESLAVE:
+			case NETDEV_BONDING_FAILOVER:
 				nt->enabled = 0;
 				break;
 			}

--------------080108050002040107090202--
