Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0CWCLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab0CWCL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:11:29 -0400
Message-ID: <4BA823D7.4010106@redhat.com>
Date: Tue, 23 Mar 2010 10:13:43 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, Andy Gospodarek <gospo@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC Patch 1/3] netpoll: add generic support for bridge and bonding
 devices
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain> <1269297081.3552.19.camel@calx>
In-Reply-To: <1269297081.3552.19.camel@calx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2010-03-22 at 04:17 -0400, Amerigo Wang wrote:
>> This whole patchset is for adding netpoll support to bridge and bonding
>> devices. I already tested it for bridge, bonding, bridge over bonding,
>> and bonding over bridge. It looks fine now.
> 
> Ages ago, Jeff Moyer took a run at this, added him to the cc: on the off
> chance he still cares.
> 
>> Please comment.
>>
>>
>> To make bridge and bonding support netpoll, we need to adjust
>> some netpoll generic code. This patch does the following things:
>>
>> 1) introduce two new priv_flags for struct net_device:
>>    IFF_IN_NETPOLL which identifies we are processing a netpoll;
>>    IFF_DISABLE_NETPOLL is used to disable netpoll support for a device
>>    at run-time;
> 
> This one is a little worrisome. I've tried to keep the netpoll code
> restricted to as tight an area as possible. Adding new flags like these
> that random drivers might try to fiddle with seems like a good way for a
> driver writer to get in trouble. Also flag space is filling up.


Somewhat, but currently I don't have other way to replace this.
Any suggestions?

> 
>> 2) introduce three new methods for netdev_ops:
>>    ->ndo_netpoll_setup() is used to setup netpoll for a device;
>>    ->ndo_netpoll_xmit() is used to transmit netpoll requests;
>>    ->ndo_netpoll_cleanup() is used to clean up netpoll when a device is
>>      removed.
> 
> Seems like a lot of interface for something to be used by only a couple
> core drivers. Hopefully Dave has an opinion here.
> 

Yeah, I worry about this too, maybe we can group those methods
for netpoll together into another struct, and just put a pointer
here?

Thanks!
