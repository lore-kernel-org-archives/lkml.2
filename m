Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1CEOZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 09:25:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab1CEOZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 09:25:39 -0500
Date: Sat, 5 Mar 2011 15:25:32 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Nicolas de =?iso-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>
Subject: Re: [RFC PATCH] net/core: fix skb handling on netif serves for both
 bridge and vlan
Message-ID: <20110305142530.GA8573@psychotron.redhat.com>
References: <1299149713-18740-1-git-send-email-dfeng@redhat.com>
 <20110305103613.GB7799@psychotron.redhat.com>
 <4D72406B.6090504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D72406B.6090504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sat, Mar 05, 2011 at 02:53:47PM CET, nicolas.2p.debian@gmail.com wrote:
>Le 05/03/2011 11:36, Jiri Pirko a écrit :
>>Thu, Mar 03, 2011 at 11:55:13AM CET, dfeng@redhat.com wrote:
>>>Consider network topology as follows:
>>>
>>>eth0  eth1
>>>|_____|
>>>    |
>>>  bond0 --- br0
>>>    |
>>>  vlan0 --- br1
>>>
>>>bond0 serves for both br0 and vlan0, if a vlan tagged packet was sent
>>>to br1 through bond0, bridge handling code is seeing the packet on bond0
>>>and handing it off to my "legacy" bridge before vlan_tx_tag_present
>>>and vlan_hwaccel_do_receive even haven't a chance to look at it.
>>>
>>>Moving the vlan_tx_tag_present before bridge/macvlan handling code could
>>>cure this.
>>
>>Wouldn't this break "eth0 - br0 - br0.5"?
>
>I think it would. One more reason to build a single interface stacking framework...

I plan to deal with vlans later. This kind of topology would not be
possible after that :)
>
>	Nicolas.
