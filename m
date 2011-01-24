Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1AXVN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:13:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36185
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab1AXVN1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:13:27 -0500
Date: Mon, 24 Jan 2011 13:14:02 -0800 (PST)
Message-Id: <20110124.131402.226784705.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jamie@audible.transient.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: 2.6.38-rc1: arp triggers RTNL assertion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295903498.2924.17.camel@edumazet-laptop>
References: <1295635976.2609.23.camel@edumazet-laptop>
	<20110121.130657.106806953.davem@davemloft.net>
	<1295903498.2924.17.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 24 Jan 2011 22:11:38 +0100

> Le vendredi 21 janvier 2011 à 13:06 -0800, David Miller a écrit :
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Fri, 21 Jan 2011 19:52:56 +0100
>> 
>> > Here is how I fixed this, thanks again Jamie !
>> > 
>> > [PATCH] net: neighbour: pneigh_lookup() doesnt need RTNL
>> 
>> Eric, I don't think we can do this.
>> 
>> Fundamentally, any time a user operation changes the configuration
>> of the networking, we must hold the RTNL.
>> 
>> Eliding the RTNL for lookups is fine, but for things that change
>> state it is not.
>> 
>> I therefore think you'll need to rework the arp_ioctl() portions
>> of the commit that introduced this regression.
>> 
> 
> Here is a second try of the fix, thanks !
> 
> Note : Tested with CONFIG_PROVE_RCU=y
> 
> [PATCH] net: arp_ioctl() must hold RTNL

Thanks Eric, this one looks a lot better.  I'll apply this later
tonight.
