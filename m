Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031139Ab2CAOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:25:58 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:44109 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030277Ab2CAOZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:25:57 -0500
X-AuditID: c1b4fb39-b7bf2ae0000069a1-21-4f4f86f3b605
From: Erik Hugne <erik.hugne@ericsson.com>
To: "netdev-owner@vger.kernel.org" <netdev-owner@vger.kernel.org>
CC: "rodrigo.moya@collabora.co.uk" <rodrigo.moya@collabora.co.uk>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "javier@collabora.co.uk" <javier@collabora.co.uk>,
        "lennart@poettering.net" <lennart@poettering.net>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "alban.crequy@collabora.co.uk" <alban.crequy@collabora.co.uk>,
        "bart.cerneels@collabora.co.uk" <bart.cerneels@collabora.co.uk>,
        "sjoerd.simons@collabora.co.uk" <sjoerd.simons@collabora.co.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Date: Thu, 1 Mar 2012 15:25:53 +0100
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
Thread-Topic: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
Thread-Index: AQHM97c1/7aJiabM4Uu77xZZ02Sb6w==
Message-ID: <A1249B08688639468D1CB181445EE79D5A61B30431@ESESSCMS0355.eemea.ericsson.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Have you considered using TIPC instead?
It already provides multicast messaging with guaranteed ordering, and reliable delivery  (SOCK _RDM)

//E
 

--Original message---
Sender: "netdev-owner@vger.kernel.org" <netdev-owner@vger.kernel.org>
Sent time: Thu Mar 01 14:56:00 CET 2012
To: eric.dumazet@gmail.com
Cc: rodrigo.moya@collabora.co.uk, David.Laight@ACULAB.COM, davem@davemloft.net, javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org, alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk, sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to AF_UNIX

On 03/01/2012 01:59 PM, Eric Dumazet wrote:
> Le jeudi 01 mars 2012 à 13:50 +0100, Rodrigo Moya a écrit :
>> the main problem in D-Bus we are trying to solve is the context
>> switches, since right now, there is a daemon, which listens on a UNIX
>> socket, and all traffic in the bus goes through it, and then the daemon
>> has to route the messages it gets on that socket to the corresponding
>> place(s). So, every time someone sends a message to D-Bus, since all
>> traffic goes through the daemon, dbus-daemon gets waked-up, which is one
>> of the biggest bottlenecks we are trying to fix.
>> 
>> That's why we are thinking about using multicast with socket filters, so
>> that the daemon only gets traffic it cares about and thus is not waked
>> up and context switches don't happen when not needed.
>> 
>> Using message queues, AFAICS, we would have the same problem, as the
>> daemon would create the message queue and would get all traffic, right?
>> 
> 
> This is why I mentioned extensions.


> 
> Anyway, if you think multicast sockets is the way to go, then you could
> setup a virtual network just to be able to use AF_INET multicast.
> 
> Thats probably doable without kernel patching.
> 

We could use AF_INET multicast on a local machine but we need some
ordering and control flow requirements that are not guaranteed on UDP
multicast over IP. That's why we thought to add a new address family
AF_MCAST.

To make it a general local multicast solution and not being too specific
we added some flags to control its behavior like
MCAST_MREQ_DROP_WHEN_FULL to decide to either block the sender or drop
the packet when one receiver has its queue full.

Regards,
Javier
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html