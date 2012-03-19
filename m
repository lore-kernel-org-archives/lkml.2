Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2CSWGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:06:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39760 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab2CSWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:06:33 -0400
Date: Mon, 19 Mar 2012 18:06:27 -0400 (EDT)
Message-Id: <20120319.180627.188597318051406465.davem@davemloft.net>
To: panweiping3@gmail.com
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V4] bonding: send igmp report for its master
From: David Miller <davem@davemloft.net>
In-Reply-To: <07f6298b0c2dca06856e6dcdab7f684447b6f199.1332040061.git.panweiping3@gmail.com>
References: <31016.1331869399@death.nxdomain>
	<07f6298b0c2dca06856e6dcdab7f684447b6f199.1332040061.git.panweiping3@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 15:06:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weiping Pan <panweiping3@gmail.com>
Date: Sun, 18 Mar 2012 11:23:27 +0800

> Liang Zheng(lzheng@redhat.com) found that in the following topo,
> bonding does not send igmp report when we trigger a fail-over of bonding.
> 
> eth0--
>       |-- bond0 -- br0
> eth1--
> 
> modprobe bonding mode=1 miimon=100 resend_igmp=10
> ifconfig bond0 up
> ifenslave bond0 eth0 eth1
> 
> brctl addbr br0
> ifconfig br0 192.168.100.2/24 up
> brctl addif br0 bond0
> 
> Add 192.168.100.2(br0) into a multicast group, like 224.10.10.10,
> then trigger a fali-over in bonding.
> You can see that parameter "resend_igmp" does not work.
> 
> The reason is that when we add br0 into a multicast group,
> it does not propagate multicast knowledge down to its ports.
> 
> If we choose to propagate multicast knowledge down to all ports for bridge,
> then we have to track every change that is done to bridge, and keep a backup
> for all ports. It is hard to track, I think.
> 
> Instead I choose to modify bonding to send igmp report for its master.
> 
> Changelog:
> V2: correct comments
> V3: move this check into bond_resend_igmp_join_requests()
> V4: only send igmp reports if bond is enslaved to a bridge
> 
> Signed-off-by: Weiping Pan <panweiping3@gmail.com>

Applied.
