Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2AYVBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:01:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33653 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2AYVBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:01:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120125085712.524b65a8@nehalam.linuxnetplumber.net>
References: <18947389.2811326843064500.JavaMail.root@5-MeO-DMT.ynet.sk>
 <3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk> <20120125085712.524b65a8@nehalam.linuxnetplumber.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Wed, 25 Jan 2012 22:01:08 +0100
X-Google-Sender-Auth: KFcTb9YUsKgpKlO6LxejT8rahMA
Message-ID: <CAGsizzKAvAV771vSo0TGx_sU5qXgjOOqVRooK9vOf=XEi1NtXA@mail.gmail.com>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/25 Stephen Hemminger <shemminger@vyatta.com>:
> On Wed, 18 Jan 2012 00:33:14 +0100 (CET)
> Stefan Gula <steweg@ynet.sk> wrote:
>
>> From: Stefan Gula <steweg@gmail.com>
>>
>> This patch is an extension for current Ethernet over GRE
>> implementation, which allows user to create virtual bridge (multipoint
>> VPN) and forward traffic based on Ethernet MAC address information in
>> it. It simulates the Bridge behavior learning mechanism, but instead
>> of learning port ID from which given MAC address comes, it learns IP
>> address of peer which encapsulated given packet. Multicast, Broadcast
>> and unknown-multicast traffic is send over network as multicast
>> encapsulated GRE packet, so one Ethernet multipoint GRE tunnel can be
>> represented as one single virtual switch on logical level and be also
>> represented as one multicast IPv4 address on network level.
>>
>> Signed-off-by: Stefan Gula <steweg@gmail.com>
>
> Will this break normal usages of GRE?
> Compile time options are not acceptable for a standard distribution if
> it will break it for the other case. It is fine to add the additional data
> structure elements, but the code in the receive path might get broken?
>
>
No, if you don't decide to compile with given kernel option.. nothing
happens and original GRE code is leaved intact.
