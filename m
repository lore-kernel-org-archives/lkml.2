Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab1CCVmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:42:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58882 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab1CCVm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:42:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VULNGuMnVtoyP6jsFrlS5l17E3CS32NDn7fgeg513kgT8PeSJeHIf86xNNRc8Oveqi
         xOMqpyMiXuMeaTjplOpWtEStNdQ+/3ZM7R9IDVYhL9ZC+R1bGvzYgr67UI+APyjeDISL
         ILuZ9eXJuNmkdIURqh9E/okbKiFBR3Z/7xpAo=
Message-ID: <4D700B40.9010209@gmail.com>
Date: Thu, 03 Mar 2011 22:42:24 +0100
From: =?UTF-8?B?Tmljb2xhcyBkZSBQZXNsb8O8YW4=?= 
	<nicolas.2p.debian@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Xiaotian Feng <dfeng@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Jiri Pirko <jpirko@redhat.com>
Subject: Re: [RFC PATCH] net/core: fix skb handling on netif serves for both
 bridge and vlan
References: <1299149713-18740-1-git-send-email-dfeng@redhat.com> <1299160414.4277.49.camel@localhost>
In-Reply-To: <1299160414.4277.49.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03/03/2011 14:53, Ben Hutchings a écrit :
> On Thu, 2011-03-03 at 18:55 +0800, Xiaotian Feng wrote:
>> Consider network topology as follows:
>>
>> eth0  eth1
>>   |_____|
>>      |
>>    bond0 --- br0
>>      |
>>    vlan0 --- br1
>>
>> bond0 serves for both br0 and vlan0, if a vlan tagged packet was sent
>> to br1 through bond0, bridge handling code is seeing the packet on bond0
>> and handing it off to my "legacy" bridge before vlan_tx_tag_present
>> and vlan_hwaccel_do_receive even haven't a chance to look at it.
> [...]
>
> This used to work if the underlying device (bond0 in your example)
> implemented VLAN tag extraction, because the VLAN group would be checked
> before the bridge.  But it never worked for devices without VLAN tag
> extraction.  Perhaps we should just prevent this configuration.

If Jiri Pirko eventually move vlan processing to rx_handler, then the setup won't be possible, 
because bond0 would require two rx_handlers : one for bridge (-> br0) and one for vlan (-> vlan0).

Or we need several rx_handlers per net_device, if the above setup is a real one.

	Nicolas.
