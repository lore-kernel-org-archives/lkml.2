Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2AYVwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:52:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53000 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2AYVw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:52:29 -0500
Date: Wed, 25 Jan 2012 16:49:39 -0500 (EST)
Message-Id: <20120125.164939.1360578908839469758.davem@davemloft.net>
To: steweg@ynet.sk
Cc: shemminger@vyatta.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGsizzKAvAV771vSo0TGx_sU5qXgjOOqVRooK9vOf=XEi1NtXA@mail.gmail.com>
References: <3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk>
	<20120125085712.524b65a8@nehalam.linuxnetplumber.net>
	<CAGsizzKAvAV771vSo0TGx_sU5qXgjOOqVRooK9vOf=XEi1NtXA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Jan 2012 13:49:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ¦tefan Gula <steweg@ynet.sk>
Date: Wed, 25 Jan 2012 22:01:08 +0100

> 2012/1/25 Stephen Hemminger <shemminger@vyatta.com>:
>> On Wed, 18 Jan 2012 00:33:14 +0100 (CET)
>> Stefan Gula <steweg@ynet.sk> wrote:
>>
>>> From: Stefan Gula <steweg@gmail.com>
>>>
>>> This patch is an extension for current Ethernet over GRE
>>> implementation, which allows user to create virtual bridge (multipoint
>>> VPN) and forward traffic based on Ethernet MAC address information in
>>> it. It simulates the Bridge behavior learning mechanism, but instead
>>> of learning port ID from which given MAC address comes, it learns IP
>>> address of peer which encapsulated given packet. Multicast, Broadcast
>>> and unknown-multicast traffic is send over network as multicast
>>> encapsulated GRE packet, so one Ethernet multipoint GRE tunnel can be
>>> represented as one single virtual switch on logical level and be also
>>> represented as one multicast IPv4 address on network level.
>>>
>>> Signed-off-by: Stefan Gula <steweg@gmail.com>
>>
>> Will this break normal usages of GRE?
>> Compile time options are not acceptable for a standard distribution if
>> it will break it for the other case. It is fine to add the additional data
>> structure elements, but the code in the receive path might get broken?
>>
>>
> No, if you don't decide to compile with given kernel option.. nothing
> happens and original GRE code is leaved intact.

Every distribution is going to want to turn the option on to provide
the feature to their users, so this line of reasoning is not
acceptable.
