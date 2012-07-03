Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab2GCRSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:18:55 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:48300 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:18:53 -0400
Message-ID: <4FF32972.6020604@genband.com>
Date: Tue, 03 Jul 2012 11:18:42 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: David Miller <davem@davemloft.net>, vincent.sanders@collabora.co.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
References: <4FF1BBD5.8080804@collabora.co.uk> <4FF32352.5040800@genband.com>
In-Reply-To: <4FF32352.5040800@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2012 17:18:43.0270 (UTC) FILETIME=[E58DCE60:01CD593F]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19016.000
X-TM-AS-Result: No--19.155600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 10:52 AM, Chris Friesen wrote:

> To be fair, since it was implemented as a separate protocol family the
> maintenance burden actually hasn't been large--it's been fairly simple
> to port between versions. Also, we do embedded telecom stuff and don't
> jump kernel versions all that often. (It's a big headache, requires
> coordinating between multiple vendors, etc.)
>
> In our case we typically send small (100-200 byte) messages to a
> smallish (1-10) number of listeners, though there are exceptions of
> course. Back before I started the original implementation used a
> userspace daemon, but it had a number of issues. Originally I was
> focussed on the performance gains but I must admit that since then other
> factors have made that less of an issue.

I should point out that some of the other factors that have been 
discussed for AF_BUS also hold true for our implementation:

--strict ordering
--reliable (in our case, if the sender has space in the tx buffer then 
messages get to all recipients with buffer space, there are kernel logs 
if recipients don't have space)

Also, the fact that it's in the kernel rather than a userspace daemon 
reduces priority inversion type issues.  Presumably this would apply to 
an IP-multicast based solution as well.

One problem that I ran into back when I was experimenting with this 
stuff was trying to isolate host-local IP multicast from the rest of the 
network.  It would be suboptimal to need to set up filtering and such 
before being able to use the communication protocol.

Chris
