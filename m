Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab1DMUcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:32:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51063 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1DMUcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:32:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1104131605010.10727@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
 <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan>
 <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com> <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com>
 <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan> <BANLkTinLRVyKwBA7ZbEXKqa18V=+a6+cZg@mail.gmail.com>
 <alpine.DEB.2.02.1104131605010.10727@p34.internal.lan>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 13 Apr 2011 13:31:40 -0700
Message-ID: <BANLkTin5VwUryoMK=jYpbNTudPLufZ+RDw@mail.gmail.com>
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 1:13 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> (1) What is the AP's beacon period and DTIM? Typical values are 100
>> TUs for beacons (102.4 ms) and 2 for DTIM (2 beacons per power-save
>> wakeup) which should imply a mean of 100 and max of 200 ms delay even
>> on pings.
>
> I am using a WNDR3700 with default settings in terms of beacons/etc.  No
> issues with any device (laptop, computer, etc (in windows)), I have two
> wireless USB adapters (bought two) and in Windows, no problems, I don't
> think
> it is the WNDR3700.  As far as linux/wpa-supplicant, using default settings.

Not enough info. What does "iw dev wlan1 scan dump"  (it might not be
wlan1 for you) say for "beacon interval"?

Does anyone know how to get the DTIM period out of iw?

>> (2) How long does the client wait after waking up to go back to sleep?
>> It should be at least a few seconds. For ssh, then, you should see
>> something like a 100-200 ms delay for the first key and then nothing
>> at all unless you stop typing for a bit.
>
> It lags with each word I type, it is terrible.  If I run something like
> dmesg or ps auxww, the entire session freezes for 5-10 seconds before it
> comes back.

Sorry; I meant what is the software stack configured to do? Do some
looking around.

>> I'm SSHing over a Wi-Fi link that uses power save right this second,
>> and have for years. It's not generally an issue, I suspect something
>> worse is going on.
>
> Maybe the wireless usb adapters do not function well in Linux with power
> save
> on.
>
> I bought them awhile ago, they had the highest reviews, and in Windows,
> they did do 10-15MiB/s, in Linux, I see ~4.6MiB/s (but that was with power
> save on) about the same, 4.5MiB/s.
> http://www.amazon.com/Medialink-Wireless-Adapter-802-11n-Compatible/dp/B002RM08RE

Yeah, these might indicate a fairly sizable problem in the Linux drivers IMO.

Dan
