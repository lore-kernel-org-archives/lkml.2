Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1CENxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 08:53:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61297 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1CENxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 08:53:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qt0rgWvyr6tmjzDYIE9yWi1hVdAQXPcA3eclUVA6hDzghGfhyq0odWzPDU56R2xyZX
         xRnvsFfohPyLLvZuRXj8oDoKpTGdEJAt251bjoQ/Jnx6X0+uWHUxtkUSZTr5J1RtlJb1
         QkG1GpOzTbz9vzvJRwZ0GaYdnXMkOVhiGnnqw=
Message-ID: <4D72406B.6090504@gmail.com>
Date: Sat, 05 Mar 2011 14:53:47 +0100
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: Xiaotian Feng <dfeng@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>
Subject: Re: [RFC PATCH] net/core: fix skb handling on netif serves for both
 bridge and vlan
References: <1299149713-18740-1-git-send-email-dfeng@redhat.com> <20110305103613.GB7799@psychotron.redhat.com>
In-Reply-To: <20110305103613.GB7799@psychotron.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/03/2011 11:36, Jiri Pirko a écrit :
> Thu, Mar 03, 2011 at 11:55:13AM CET, dfeng@redhat.com wrote:
>> Consider network topology as follows:
>>
>> eth0  eth1
>> |_____|
>>     |
>>   bond0 --- br0
>>     |
>>   vlan0 --- br1
>>
>> bond0 serves for both br0 and vlan0, if a vlan tagged packet was sent
>> to br1 through bond0, bridge handling code is seeing the packet on bond0
>> and handing it off to my "legacy" bridge before vlan_tx_tag_present
>> and vlan_hwaccel_do_receive even haven't a chance to look at it.
>>
>> Moving the vlan_tx_tag_present before bridge/macvlan handling code could
>> cure this.
>
> Wouldn't this break "eth0 - br0 - br0.5"?

I think it would. One more reason to build a single interface stacking framework...

	Nicolas.
