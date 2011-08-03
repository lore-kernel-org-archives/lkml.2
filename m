Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1HCRoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:44:14 -0400
Received: from lucidpixels.com ([72.73.18.11]:59220 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab1HCRoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:44:12 -0400
Date: Wed, 3 Aug 2011 13:44:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan> <4E341DC4.9010107@01019freenet.de> <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan> <20110803160050.GA18882@redhat.com> <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Aug 2011, Justin Piszcz wrote:

>
>
> On Wed, 3 Aug 2011, Stanislaw Gruszka wrote:
>
>> On Sat, Jul 30, 2011 at 01:07:11PM -0400, Justin Piszcz wrote:
>>> Here you go, crash 2:
>>> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p1.jpg
>>> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p2.jpg
>> 
>> Here is next (draw) patch to test:
>
> Thanks,
>
> # patch -p1 < ../patch4
> patching file drivers/net/wireless/rt2x00/rt2800lib.c
> patching file drivers/net/wireless/rt2x00/rt2800lib.h
> patching file drivers/net/wireless/rt2x00/rt2800usb.c
> patching file drivers/net/wireless/rt2x00/rt2x00queue.c
> patching file drivers/net/wireless/rt2x00/rt2x00usb.c
> #
>
> I'll give this driver one more chance (quickly) and let you know if it 
> crashes
> afterwards (usually crashes in 5-10 minutes), but most likely I am going to
> move over to some other wireless usb sticks, got a couple think penguin usb
> wifi sticks that use the carl driver, 'open source' wireless usb sticks, 
> going to give them a try next.
>
> Also got some other ones as well, hopefully one of them will work without
> 900ms of lag.  The rt2870sta was the best driver in 2.6.38.x series that I
> have ever used for wireless USB sticks.
>
> Justin.
>
>

Hi,

Tested that patch:

1. The driver no longer automatically loads, I had to manually modprobe it.
2. After loading, I get this (keep getting these)

[  384.054538] phy0 -> rt2800_txdone: Error - Data pending
[  384.072773] phy0 -> rt2800_txdone: Error - Data pending
[  384.096545] phy0 -> rt2800_txdone: Error - Data pending
[  384.117301] phy0 -> rt2800_txdone: Error - Data pending
[  384.537586] phy0 -> rt2800_txdone: Error - Data pending
[  384.555716] phy0 -> rt2800_txdone: Error - Data pending
[  384.573903] phy0 -> rt2800_txdone: Error - Data pending
[  384.599465] phy0 -> rt2800_txdone: Error - Data pending
[  384.618523] phy0 -> rt2800_txdone: Error - Data pending

No crash yet, but bad ping again too (always with the rt2800usb) driver:

64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=1 ttl=64 time=53.1 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=285 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=89.6 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=120 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=42.2 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=156 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=7 ttl=64 time=77.2 ms

(Have another machine, testing the carl driver kernel 3.0 on it)

Not having too much luck there either.

[586342.990975] carl9170: Unknown symbol __ieee80211_get_tx_led_name (err 0)
[586342.991059] carl9170: Unknown symbol __ieee80211_get_assoc_led_name (err 0)
[586459.214057] carl9170: Unknown symbol __ieee80211_get_tx_led_name (err 0)
[586459.214131] carl9170: Unknown symbol __ieee80211_get_assoc_led_name (err 0)

Justin.

