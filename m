Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab1DMUgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:36:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:46168 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab1DMUgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:36:06 -0400
Date: Wed, 13 Apr 2011 16:36:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
In-Reply-To: <BANLkTin5VwUryoMK=jYpbNTudPLufZ+RDw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1104131634040.10727@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan> <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com> <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com>
 <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan> <BANLkTinLRVyKwBA7ZbEXKqa18V=+a6+cZg@mail.gmail.com> <alpine.DEB.2.02.1104131605010.10727@p34.internal.lan> <BANLkTin5VwUryoMK=jYpbNTudPLufZ+RDw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1456179645-1302726962=:10727"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1456179645-1302726962=:10727
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 13 Apr 2011, Daniel Halperin wrote:

> On Wed, Apr 13, 2011 at 1:13 PM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>>> (1) What is the AP's beacon period and DTIM? Typical values are 100
>>> TUs for beacons (102.4 ms) and 2 for DTIM (2 beacons per power-save
>>> wakeup) which should imply a mean of 100 and max of 200 ms delay even
>>> on pings.
>>
>> I am using a WNDR3700 with default settings in terms of beacons/etc. =A0=
No
>> issues with any device (laptop, computer, etc (in windows)), I have two
>> wireless USB adapters (bought two) and in Windows, no problems, I don't
>> think
>> it is the WNDR3700. =A0As far as linux/wpa-supplicant, using default set=
tings.
>
> Not enough info. What does "iw dev wlan1 scan dump"  (it might not be
> wlan1 for you) say for "beacon interval"?

# iw dev wlan0 scan dump

BSS (hidden) (on wlan0) -- associated
         TSF: 103430650682 usec (1d, 04:43:50)
         freq: 2417
         beacon interval: 100
         capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
         signal: -59.00 dBm
         last seen: 1345742 ms ago
         SSID: (hidden)
         Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
         DS Parameter set: channel 2
         RSN:     * Version: 1
                  * Group cipher: TKIP
                  * Pairwise ciphers: CCMP TKIP
                  * Authentication suites: PSK
                  * Capabilities: (0x0000)
         WPA:     * Version: 1
                  * Group cipher: TKIP
                  * Pairwise ciphers: CCMP TKIP
                  * Authentication suites: PSK
         ERP: <no flags>
         Extended supported rates: 24.0 36.0 48.0 54.0
         WMM:     * Parameter version 1
                  * u-APSD
                  * BE: CW 15-1023, AIFSN 3
                  * BK: CW 15-1023, AIFSN 7
                  * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                  * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
         HT capabilities:
                 Capabilities: 0x11ce
                         HT20/HT40
                         SM Power Save disabled
                         RX HT40 SGI
                         TX STBC
                         RX STBC 1-stream
                         Max AMSDU length: 7935 bytes
                         DSSS/CCK HT40
                 Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                 Minimum RX AMPDU time spacing: 1/2 usec (0x02)
                 HT RX MCS rate indexes supported: 0-15
                 HT TX MCS rate indexes are undefined
         WPS:     * Version: 1.0
                  * Manufacturer: Netgear, Inc.
                  * Model: WNDR3700
                  * Device name: (hidden)
                  * Config methods: Ethernet, Label, PBC
>
> Does anyone know how to get the DTIM period out of iw?
>
>>> (2) How long does the client wait after waking up to go back to sleep?
>>> It should be at least a few seconds. For ssh, then, you should see
>>> something like a 100-200 ms delay for the first key and then nothing
>>> at all unless you stop typing for a bit.
>>
>> It lags with each word I type, it is terrible. =A0If I run something lik=
e
>> dmesg or ps auxww, the entire session freezes for 5-10 seconds before it
>> comes back.
>
> Sorry; I meant what is the software stack configured to do? Do some
> looking around.
>
>>> I'm SSHing over a Wi-Fi link that uses power save right this second,
>>> and have for years. It's not generally an issue, I suspect something
>>> worse is going on.
>>
>> Maybe the wireless usb adapters do not function well in Linux with power
>> save
>> on.
>>
>> I bought them awhile ago, they had the highest reviews, and in Windows,
>> they did do 10-15MiB/s, in Linux, I see ~4.6MiB/s (but that was with pow=
er
>> save on) about the same, 4.5MiB/s.
>> http://www.amazon.com/Medialink-Wireless-Adapter-802-11n-Compatible/dp/B=
002RM08RE
>
> Yeah, these might indicate a fairly sizable problem in the Linux drivers =
IMO.
>
> Dan
>
--655872-1456179645-1302726962=:10727--
