Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2K3RIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:08:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44489 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2K3RIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:08:21 -0500
Date: Fri, 30 Nov 2012 12:08:13 -0500 (EST)
Message-Id: <20121130.120813.1360888707923955813.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: zheng.x.li@oracle.com, netdev@vger.kernel.org, andy@greyhouse.net,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: rlb mode of bond should not alter ARP
 originating via bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <15005.1354213705@death.nxdomain>
References: <1354096624-22380-1-git-send-email-zheng.x.li@oracle.com>
	<15005.1354213705@death.nxdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Thu, 29 Nov 2012 10:28:25 -0800

> Zheng Li <zheng.x.li@oracle.com> wrote:
> 
>>Do not modify or load balance ARP packets passing through balance-alb
>>mode (wherein the ARP did not originate locally, and arrived via a bridge).
>>
>>Modifying pass-through ARP replies causes an incorrect MAC address 
>>to be placed into the ARP packet, rendering peers unable to communicate 
>>with the actual destination from which the ARP reply originated.
>>
>>Load balancing pass-through ARP requests causes an entry to be
>>created for the peer in the rlb table, and bond_alb_monitor will
>>occasionally issue ARP updates to all peers in the table instrucing them
>>as to which MAC address they should communicate with; this occurs when
>>some event sets rx_ntt.  In the bridged case, however, the MAC address
>>used for the update would be the MAC of the slave, not the actual source
>>MAC of the originating destination.  This would render peers unable to
>>communicate with the destinations beyond the bridge.
>>
>>Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
>>Cc: Jay Vosburgh <fubar@us.ibm.com>
>>Cc: Andy Gospodarek <andy@greyhouse.net>
>>Cc: "David S. Miller" <davem@davemloft.net>
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied.
