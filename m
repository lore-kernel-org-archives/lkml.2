Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1HCSf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:35:58 -0400
Received: from lucidpixels.com ([72.73.18.11]:57799 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1HCSfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:35:53 -0400
Date: Wed, 3 Aug 2011 14:35:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <20110803183349.GA5956@redhat.com>
Message-ID: <alpine.DEB.2.02.1108031433570.9421@p34.internal.lan>
References: <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan> <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
 <4E341DC4.9010107@01019freenet.de> <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan> <20110803160050.GA18882@redhat.com> <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan> <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
 <20110803183349.GA5956@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Aug 2011, Stanislaw Gruszka wrote:

> On Wed, Aug 03, 2011 at 01:44:10PM -0400, Justin Piszcz wrote:
>> Tested that patch:
>>
>> 1. The driver no longer automatically loads, I had to manually modprobe it.
> This must be some other problem not related with patch.
Yes, will check this again shortly.

>
>> 2. After loading, I get this (keep getting these)
>>
>> [  384.054538] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.072773] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.096545] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.117301] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.537586] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.555716] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.573903] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.599465] phy0 -> rt2800_txdone: Error - Data pending
>> [  384.618523] phy0 -> rt2800_txdone: Error - Data pending
> You can remove line
>
> ERROR(rt2x00dev, "Data pending\n");
>
> from rt2800_txdone to stop seeing this. It's kinda interesting
> how frequent this happens.
It seems to happen somewhat often; e.g. if you apt-get install pkg, it
will popup 3-4 times.

>
>> No crash yet, but bad ping again too (always with the rt2800usb) driver:
>>
>> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=1 ttl=64 time=53.1 ms
>> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=285 ms
>> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=89.6 ms
>> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=120 ms
>> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=42.2 ms
>> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=156 ms
>> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=7 ttl=64 time=77.2 ms
>
> I think patch could have site effect to not run tx queue while we have pending
> data on it. Do you have such ping times always (i.e. after a 5 minutes, 10
> minutes, 20  ... ) or just randomly?

Randomly.

64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=1 ttl=64 time=203 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=27.6 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=159 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=80.3 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=194 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=114 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=7 ttl=64 time=34.0 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=8 ttl=64 time=162 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=9 ttl=64 time=83.1 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=10 ttl=64 time=214 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=11 ttl=64 time=134 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=12 ttl=64 time=149 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=13 ttl=64 time=70.3 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=14 ttl=64 time=201 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=15 ttl=64 time=122 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=16 ttl=64 time=42.7 ms

34 packets transmitted, 34 received, 0% packet loss, time 33047ms
rtt min/avg/max/mdev = 23.620/117.755/216.279/62.033 ms

Still working so far though, at least the box has not crashed yet, but I'll
give it some more time.

Justin.
