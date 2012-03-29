Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2C2WMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:12:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2C2WMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:12:31 -0400
Date: Thu, 29 Mar 2012 18:12:20 -0400 (EDT)
Message-Id: <20120329.181220.1671496234086192108.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: wpan@redhat.com, netdev@vger.kernel.org, andy@greyhouse.net,
        lwang@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] bonding: emit event when bonding changes MAC
From: David Miller <davem@davemloft.net>
In-Reply-To: <15892.1333041584@death.nxdomain>
References: <5e96194e81e0540ebd35cf0bb1b407aa15a20613.1332910907.git.wpan@redhat.com>
	<15892.1333041584@death.nxdomain>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Mar 2012 15:12:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Thu, 29 Mar 2012 10:19:44 -0700

> Weiping Pan <wpan@redhat.com> wrote:
> 
>>When a bonding device is configured with fail_over_mac=active,
>>we expect to see the MAC address of the new active slave as the source MAC
>>address after failover. But we see that the source MAC address is the MAC
>>address of previous active slave.
>>
>>Emit NETDEV_CHANGEADDR event when bonding changes its MAC address, in order
>>to let arp_netdev_event flush neighbour cache and route cache.
>>
>>How to reproduce this bug ?
>>
>>                       -----------hostB----------------
>>hostA ----- switch ---|-- eth0--bond0(192.168.100.2/24)|
>>(192.168.100.1/24  \--|-- eth1-/                       |
>>                       --------------------------------
>>
>>1 on hostB,
>>modprobe bonding mode=1 miimon=500 fail_over_mac=active downdelay=1000
>>num_grat_arp=1
>>ifconfig bond0 192.168.100.2/24 up
>>ifenslave bond0 eth0
>>ifenslave bond0 eth1
>>
>>then eth0 is the active slave, and MAC of bond0 is MAC of eth0.
>>
>>2 on hostA, ping 192.168.100.2
>>
>>3 on hostB,
>>tcpdump -i bond0 -p icmp -XXX
>>you will see bond0 uses MAC of eth0 as source MAC in icmp reply.
>>
>>4 on hostB,
>>ifconfig eth0 down
>>tcpdump -i bond0 -p icmp -XXX (just keep it running in step 3)
>>you will see first bond0 uses MAC of eth1 as source MAC in icmp
>>reply, then it will use MAC of eth0 as source MAC.
>>
>>Signed-off-by: Weiping Pan <wpan@redhat.com>
> 
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied, thanks everyone.
