Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1AXWbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:31:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57422
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab1AXWbH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:31:07 -0500
Date: Mon, 24 Jan 2011 14:31:41 -0800 (PST)
Message-Id: <20110124.143141.104045281.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: runningdoglackey@yahoo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Problems with /proc/net/tcp6 - possible bug - ipv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295732444.2651.68.camel@edumazet-laptop>
References: <115440.16148.qm@web63902.mail.re1.yahoo.com>
	<1295731235.2651.66.camel@edumazet-laptop>
	<1295732444.2651.68.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 22 Jan 2011 22:40:44 +0100

> Le samedi 22 janvier 2011 à 22:20 +0100, Eric Dumazet a écrit :
>> Le samedi 22 janvier 2011 à 11:42 -0800, PK a écrit :
>> > Eric Dumazet wrote:
>> > > 
>> > > I had some incidents, after hours of testing...
>> > >
>> > > After following patch, I could not reproduce it.
>> > 
>> > 
>> > Looks like that patch solved the /proc/net/tcp6 problem.  The causal commit was 
>> > the one you identified... confirmed with bisect.
>> > 
>> > These warnings show up when I run the script (or I presume any tcp6 connection 
>> > flooder) with /proc/sys/net/tcp/ipv4/tcp_tw_recycle enabled.  There's textual 
>> > corruption of the traces a lot of the time.  Here's a sample trace that doesn't 
>> > appear to be corrupt.  All the warnings I've seen are from route.c:209, and I 
>> > don't see how that would cause memory corruption.
>> 
>> Thats a different isse, already reported, under investigation.
>> 
>> David did some changes recently
>> 
>> http://comments.gmane.org/gmane.linux.network/179874
>> 
>> 
>> 
> 
> In my testings, I even have crashes in cleanup_once() if I
> enable /proc/sys/net/ipv4/tcp_tw_recycle 

I'm looking into this, thanks guys.
