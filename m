Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab1DMUNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:13:08 -0400
Received: from lucidpixels.com ([75.144.35.66]:59483 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab1DMUNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:13:06 -0400
Date: Wed, 13 Apr 2011 16:13:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
In-Reply-To: <BANLkTinLRVyKwBA7ZbEXKqa18V=+a6+cZg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1104131605010.10727@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan> <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com> <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com>
 <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan> <BANLkTinLRVyKwBA7ZbEXKqa18V=+a6+cZg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-585702368-1302725582=:10727"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-585702368-1302725582=:10727
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 13 Apr 2011, Daniel Halperin wrote:

> On Wed, Apr 13, 2011 at 10:57 AM, Justin Piszcz <jpiszcz@lucidpixels.com>=
 wrote:
>> Hi,
>>
>> When powersave is enabled, it is very jumpy, I've used satellite comms
>> before
>> and (~600ms-1200ms was more smooth) as it did not jump around as much. =
=A0The
>> application is just a standalone desktop with minimal activity for the
>> majority
>> of the time, maybe thats why..
>>
>> With powersave disabled, I now see 0% packet loss (802.11n) and low ping
>> times, this looks like the proper solution for the wireless USB device I
>> am using. =A0By the way, is it possible/are there wireless USB devices o=
ut
>> there
>> that support wake on wireless lan (WOWL?
>>
>> Your ping command with power off:
>> 1408 bytes from server (192.168.1.2): icmp_req=3D539 ttl=3D64 time=3D1.0=
7 ms
>> 1408 bytes from server (192.168.1.2): icmp_req=3D540 ttl=3D64 time=3D1.3=
1 ms
>> 1408 bytes from server (192.168.1.2): icmp_req=3D541 ttl=3D64 time=3D1.0=
7 ms
>> 1408 bytes from server (192.168.1.2): icmp_req=3D542 ttl=3D64 time=3D1.2=
6 ms
>>
>> Your ping command with power on:
>> 1408 bytes from server (192.168.1.2): icmp_req=3D649 ttl=3D64 time=3D1.8=
0 ms
>> 1408 bytes from server (192.168.1.2): icmp_req=3D650 ttl=3D64 time=3D1.8=
5 ms
>> 1408 bytes from server (192.168.1.2): icmp_req=3D651 ttl=3D64 time=3D2.8=
6 ms
>> 1408 bytes from server (192.168.1.2): icmp_req=3D652 ttl=3D64 time=3D1.4=
6 ms
>>
>> You are correct, if there is a lot of traffic, its good, but if the syst=
em
>> is relatively idle and all that's going on is an SSH session, there is
>> horrible
>> latency.
>
> Gotcha. I might still look around in the network stack and/or driver
> and see what the time constants are. For instance:
>
> (1) What is the AP's beacon period and DTIM? Typical values are 100
> TUs for beacons (102.4 ms) and 2 for DTIM (2 beacons per power-save
> wakeup) which should imply a mean of 100 and max of 200 ms delay even
> on pings.
I am using a WNDR3700 with default settings in terms of beacons/etc.  No
issues with any device (laptop, computer, etc (in windows)), I have two
wireless USB adapters (bought two) and in Windows, no problems, I don't thi=
nk
it is the WNDR3700.  As far as linux/wpa-supplicant, using default settings=
=2E


>
> (2) How long does the client wait after waking up to go back to sleep?
> It should be at least a few seconds. For ssh, then, you should see
> something like a 100-200 ms delay for the first key and then nothing
> at all unless you stop typing for a bit.
It lags with each word I type, it is terrible.  If I run something like
dmesg or ps auxww, the entire session freezes for 5-10 seconds before it
comes back.


>
> I'm SSHing over a Wi-Fi link that uses power save right this second,
> and have for years. It's not generally an issue, I suspect something
> worse is going on.
Maybe the wireless usb adapters do not function well in Linux with power sa=
ve
on.

I bought them awhile ago, they had the highest reviews, and in Windows,
they did do 10-15MiB/s, in Linux, I see ~4.6MiB/s (but that was with power=
=20
save on) about the same, 4.5MiB/s.
http://www.amazon.com/Medialink-Wireless-Adapter-802-11n-Compatible/dp/B002=
RM08RE

100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 23.2803 s, 4.5 MB/s

Justin.

--655872-585702368-1302725582=:10727--
