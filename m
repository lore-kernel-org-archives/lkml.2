Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1DNFRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 01:17:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40418 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1DNFRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 01:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CUKNH6TncAeJyyzSFFeYUjS5NAdwAjSYNTexVhNuWOZlSxmc0JYRiYGYVETEYo07rP
         MKSf4rbHcu649Afuk/RkwEYr3olJh2vBfkKRhBEbRyuSC17ZoVySaBVNvJjZlFWck4nY
         668QdaWj5/YR/2BAXJzFHjIeOeotK/TWKy3IA=
Message-ID: <4DA68354.4060603@gmail.com>
Date: Thu, 14 Apr 2011 09:17:08 +0400
From: Igor Plyatov <plyatov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Daniel Halperin <dhalperi@cs.washington.edu>,
        Ivo Van Doorn <ivdoorn@gmail.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan> <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com> <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com> <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan> <BANLkTinLRVyKwBA7ZbEXKqa18V=+a6+cZg@mail.gmail.com> <alpine.DEB.2.02.1104131605010.10727@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1104131605010.10727@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Wed, 13 Apr 2011, Daniel Halperin wrote:
>
>> On Wed, Apr 13, 2011 at 10:57 AM, Justin Piszcz 
>> <jpiszcz@lucidpixels.com> wrote:
>>> Hi,
>>>
>>> When powersave is enabled, it is very jumpy, I've used satellite comms
>>> before
>>> and (~600ms-1200ms was more smooth) as it did not jump around as 
>>> much.  The
>>> application is just a standalone desktop with minimal activity for the
>>> majority
>>> of the time, maybe thats why..
>>>
>>> With powersave disabled, I now see 0% packet loss (802.11n) and low 
>>> ping
>>> times, this looks like the proper solution for the wireless USB 
>>> device I
>>> am using.  By the way, is it possible/are there wireless USB devices 
>>> out
>>> there
>>> that support wake on wireless lan (WOWL?
>>>
>>> Your ping command with power off:
>>> 1408 bytes from server (192.168.1.2): icmp_req=539 ttl=64 time=1.07 ms
>>> 1408 bytes from server (192.168.1.2): icmp_req=540 ttl=64 time=1.31 ms
>>> 1408 bytes from server (192.168.1.2): icmp_req=541 ttl=64 time=1.07 ms
>>> 1408 bytes from server (192.168.1.2): icmp_req=542 ttl=64 time=1.26 ms
>>>
>>> Your ping command with power on:
>>> 1408 bytes from server (192.168.1.2): icmp_req=649 ttl=64 time=1.80 ms
>>> 1408 bytes from server (192.168.1.2): icmp_req=650 ttl=64 time=1.85 ms
>>> 1408 bytes from server (192.168.1.2): icmp_req=651 ttl=64 time=2.86 ms
>>> 1408 bytes from server (192.168.1.2): icmp_req=652 ttl=64 time=1.46 ms
>>>
>>> You are correct, if there is a lot of traffic, its good, but if the 
>>> system
>>> is relatively idle and all that's going on is an SSH session, there is
>>> horrible
>>> latency.
>>
>> Gotcha. I might still look around in the network stack and/or driver
>> and see what the time constants are. For instance:
>>
>> (1) What is the AP's beacon period and DTIM? Typical values are 100
>> TUs for beacons (102.4 ms) and 2 for DTIM (2 beacons per power-save
>> wakeup) which should imply a mean of 100 and max of 200 ms delay even
>> on pings.
> I am using a WNDR3700 with default settings in terms of beacons/etc.  No
> issues with any device (laptop, computer, etc (in windows)), I have two
> wireless USB adapters (bought two) and in Windows, no problems, I 
> don't think
> it is the WNDR3700.  As far as linux/wpa-supplicant, using default 
> settings.
>
>
>>
>> (2) How long does the client wait after waking up to go back to sleep?
>> It should be at least a few seconds. For ssh, then, you should see
>> something like a 100-200 ms delay for the first key and then nothing
>> at all unless you stop typing for a bit.
> It lags with each word I type, it is terrible.  If I run something like
> dmesg or ps auxww, the entire session freezes for 5-10 seconds before it
> comes back.

Yes, it's terrible. I have the same problems with ping and ssh with 
latest GIT
linux on my ARM platform and two different USB Wi-Fi adapters based on
RT3070 chipset ("D-Link DWA-125" and "Qcom LR802UKN3").

>
>>
>> I'm SSHing over a Wi-Fi link that uses power save right this second,
>> and have for years. It's not generally an issue, I suspect something
>> worse is going on.
> Maybe the wireless usb adapters do not function well in Linux with 
> power save
> on.
>
> I bought them awhile ago, they had the highest reviews, and in Windows,
> they did do 10-15MiB/s, in Linux, I see ~4.6MiB/s (but that was with 
> power save on) about the same, 4.5MiB/s.
> http://www.amazon.com/Medialink-Wireless-Adapter-802-11n-Compatible/dp/B002RM08RE 
>
>
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 23.2803 s, 4.5 MB/s
>
> Justin.

Best regards!
--
Igor Plyatov
