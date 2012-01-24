Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2AXJIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:08:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44836 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab2AXJH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:07:58 -0500
MIME-Version: 1.0
In-Reply-To: <1327362739.2587.15.camel@edumazet-laptop>
References: <29378065.3471327360294412.JavaMail.root@5-MeO-DMT.ynet.sk> <1327362739.2587.15.camel@edumazet-laptop>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Tue, 24 Jan 2012 10:07:37 +0100
X-Google-Sender-Auth: E11etW8QoFGHV6-zFVRH2TskDS0
Message-ID: <CAGsizzLD=0t_J5m=CdZn8+1j6ZD_Nmz352kydDKDqQKDK5nxSw@mail.gmail.com>
Subject: Re: [patch v2, kernel version 3.2.1] Source mode for macvlan interface
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/24 Eric Dumazet <eric.dumazet@gmail.com>:
> Le mardi 24 janvier 2012 à 00:11 +0100, Stefan Gula a écrit :
>> From: Stefan Gula <steweg@gmail.com>
>>
>> New mode of macvlan interface called "source" allows one to specify,
>> which  frames are allowed to be received by given macvlan interface.
>> This logic is used only on received frames on underlying interface.
>> The ability to send frames from macvlan interface through underlying
>> interface is not modified. This feature allows one to simulate 802.1x
>> mac based VLAN behavior by using proper netlink message to configure
>> this behavior with utility such as "ip link" from iproute2 suite.
>> This feature allows to create MAC based VLAN associations instead of
>> standard port or tag based, to be able to associate several different
>> clients/users behind one common port based on their MAC addresses.
>>
>
> Still obscure changelog...
>
>> Signed-off-by: Stefan Gula <steweg@gmail.com>
>>
>
> Please include next time
>
> V3: list of changes
>
>
>
> Why GFP_ATOMIC here ?
changed to GFP_KERNEL

>
> How many 'sources' are expected per port ?
>
> Above a certain (small) threshold, macvlan_fill_info() will 'overflow'
> skb capacity and return an error.
>
> Take a look at macvlan_get_size() ?
There should be no defined limits on how many MAC addresses you can
put under one macvlan interface - it should be fully dynamic. You are
right about the function, but I have a difficulty with fixing that. It
is no problem to calculate the space needed to dump all mac-address,
but I tried to check how many times is macvlan_get_size called and it
is called only once per macvlan interface initialization, which is
obviously wrong in my case as I need that number to be changed each
time before fill_info is called. I tried to find and example how to
managed that from other drivers, but I was unsuccessful. Do you have
any idea?
