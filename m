Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2CBWT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:19:58 -0500
Received: from mail.lang.hm ([64.81.33.126]:60855 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab2CBWT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:19:57 -0500
Date: Fri, 2 Mar 2012 14:19:45 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Miller <davem@davemloft.net>
cc: luiz.dentz@gmail.com, eric.dumazet@gmail.com,
        javier.martinez@collabora.co.uk, rodrigo.moya@collabora.co.uk,
        javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
In-Reply-To: <20120302.035509.1994457175982020283.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1203021405040.7143@asgard.lang.hm>
References: <CABBYNZJ-xxQXAx+ecrkVLqmWFaUVqLcQLj0Jxa3McSLnkLJSJw@mail.gmail.com> <20120301.170848.432407217191581288.davem@davemloft.net> <CABBYNZLwHKd5srzYYzWNL-iaeuH1K31824pY_bjRSbSLkv0QtA@mail.gmail.com>
 <20120302.035509.1994457175982020283.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, David Miller wrote:

> From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Date: Fri, 2 Mar 2012 10:39:24 +0200
>
>> Like I said before there is many projects using AF_UNIX as IPC
>> transport, the documentation actually induces people to use for this
>> purpose, and many would benefit from being able to do multicast.
>
> You can't have it both ways.
>
> If it's useful for many applications, then many applications would
> benefit from a userland library that solved the problem using
> existing facilities such as IP multicast.

I missed the start of this discussion (but did see the lwn.net article on 
it)

as I understand it, they are looking for some features that are not in IP 
multicast (or at least not as I understand it)

1. reliable delivery

2. in-order delivery

3. sender blocking on recipients rather than dropping messages when the 
channel is full.

IP multicast definantly does not do #3, and as far as I understand it, is 
essentially UDP to multiple recipients, and UDP does not provide either #1 
or #2

Yes, this could be done entirely in userspace (with something like 0MQ as 
I see others mentioning), and I don't understand the Android aversion to 
any userspace daemons, but with all of that being said, I do think that a 
kernel-based mechanism that supports having iptables type filters on it 
would be a very nice thing to have (and should be able to re-use a lot of 
existing code that would end up being duplicated if this is done in a 
userspace daemon)

now it may be that some of the requirements may result in error O_PONY or 
O_SANITY (the sender blocking seems like a potential problem, but that 
may possibly make sense as a configurable option)

David Lang
