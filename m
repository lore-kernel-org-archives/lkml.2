Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab1DMQ0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:26:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54664 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab1DMQ0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:26:04 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
 <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan>
 <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 13 Apr 2011 09:25:42 -0700
Message-ID: <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com>
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh! Couldn't you configure the stupid mailing list filter to only
drop rich text mails that have [PATCH or [RFC or [RFT in the subject,
e.g.? Original mail below.

(sorry for the resend, Justin and Ivo).

Dan

On Wed, Apr 13, 2011 at 9:23 AM, Daniel Halperin
<dhalperi@cs.washington.edu> wrote:
>
> On Wed, Apr 13, 2011 at 9:01 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>
>>> Can you try disabling powersaving?
>>> iwconfig wlan0 power off
>>>
>> Wow! That was it, now its interactive again.
>>
>> 64 bytes from wireless-host (192.168.1.2): icmp_req=1 ttl=64 time=0.581 ms
>> 64 bytes from wireless-host (192.168.1.2): icmp_req=2 ttl=64 time=0.647 ms
>>
>> Thanks, so its recommend to keep this off then, can that be set as the driver default?
>>
>
> That's a bad idea, what you're seeing is likely completely a red herring. Wi-Fi power saving mode saves energy by putting the RF hardware most of the time. This is a Good Thing.
> Power save is designed to kick in only when the load is very slow; the client's network stack should automatically disable power save during times of high load, e.g., during a download or a VoIP call. You should run some tests to see if this is actually occurring; there may be a bug in the rtl implementation.
> The real problem here is that your ping test has invalid assumptions. One packet/second is not enough load to disable Wi-Fi power save, so you should not see interactive ping times. Again, this is a good thing and something I doubt you want to disable! (Assuming that RTL's implementation isn't fundamentally broken elsewhere) It certainly should NOT be the driver default.
> Try again with sudo ping -i 0.01 -s 1400 (e.g., to ping with large packets every 10 ms); this should probably trigger the logic that automatically disables the power saving mode. Or try pinging while doing a 1 Mbit UDP transfer (e.g., with iperf).
> Dan
