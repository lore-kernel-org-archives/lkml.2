Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1DMShg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:37:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39488 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab1DMShe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:37:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
 <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan>
 <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com> <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com>
 <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 13 Apr 2011 11:37:12 -0700
Message-ID: <BANLkTinLRVyKwBA7ZbEXKqa18V=+a6+cZg@mail.gmail.com>
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:57 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> When powersave is enabled, it is very jumpy, I've used satellite comms
> before
> and (~600ms-1200ms was more smooth) as it did not jump around as much.  The
> application is just a standalone desktop with minimal activity for the
> majority
> of the time, maybe thats why..
>
> With powersave disabled, I now see 0% packet loss (802.11n) and low ping
> times, this looks like the proper solution for the wireless USB device I
> am using.  By the way, is it possible/are there wireless USB devices out
> there
> that support wake on wireless lan (WOWL?
>
> Your ping command with power off:
> 1408 bytes from server (192.168.1.2): icmp_req=539 ttl=64 time=1.07 ms
> 1408 bytes from server (192.168.1.2): icmp_req=540 ttl=64 time=1.31 ms
> 1408 bytes from server (192.168.1.2): icmp_req=541 ttl=64 time=1.07 ms
> 1408 bytes from server (192.168.1.2): icmp_req=542 ttl=64 time=1.26 ms
>
> Your ping command with power on:
> 1408 bytes from server (192.168.1.2): icmp_req=649 ttl=64 time=1.80 ms
> 1408 bytes from server (192.168.1.2): icmp_req=650 ttl=64 time=1.85 ms
> 1408 bytes from server (192.168.1.2): icmp_req=651 ttl=64 time=2.86 ms
> 1408 bytes from server (192.168.1.2): icmp_req=652 ttl=64 time=1.46 ms
>
> You are correct, if there is a lot of traffic, its good, but if the system
> is relatively idle and all that's going on is an SSH session, there is
> horrible
> latency.

Gotcha. I might still look around in the network stack and/or driver
and see what the time constants are. For instance:

(1) What is the AP's beacon period and DTIM? Typical values are 100
TUs for beacons (102.4 ms) and 2 for DTIM (2 beacons per power-save
wakeup) which should imply a mean of 100 and max of 200 ms delay even
on pings.

(2) How long does the client wait after waking up to go back to sleep?
It should be at least a few seconds. For ssh, then, you should see
something like a 100-200 ms delay for the first key and then nothing
at all unless you stop typing for a bit.

I'm SSHing over a Wi-Fi link that uses power save right this second,
and have for years. It's not generally an issue, I suspect something
worse is going on.

Dan
