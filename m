Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1DNFjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 01:39:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1DNFjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 01:39:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=o+l3NmXiJngHTIBhcwho/UWSRDeDgmJZZehqBa7C07gX0BXreMGm9ZiUpvGWyQIag9
         YuKy1Ujb+VmqA2ajwFsp8nrb6I28LZP1dT8p8Dx1rCmHigi8e9kwUb1rUBhvSGiCbFAL
         krPjFajYvibMBXV440pymcYWpK+BVldtHVBk8=
Message-ID: <4DA68870.7090109@gmail.com>
Date: Thu, 14 Apr 2011 09:38:56 +0400
From: Igor Plyatov <plyatov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, Ivo Van Doorn <ivdoorn@gmail.com>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan> <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com> <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com> <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan> <BANLkTinLRVyKwBA7ZbEXKqa18V=+a6+cZg@mail.gmail.com> <alpine.DEB.2.02.1104131605010.10727@p34.internal.lan> <BANLkTin5VwUryoMK=jYpbNTudPLufZ+RDw@mail.gmail.com>
In-Reply-To: <BANLkTin5VwUryoMK=jYpbNTudPLufZ+RDw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Daniel,
> On Wed, Apr 13, 2011 at 1:13 PM, Justin Piszcz<jpiszcz@lucidpixels.com>  wrote:
>>> (1) What is the AP's beacon period and DTIM? Typical values are 100
>>> TUs for beacons (102.4 ms) and 2 for DTIM (2 beacons per power-save
>>> wakeup) which should imply a mean of 100 and max of 200 ms delay even
>>> on pings.
>> I am using a WNDR3700 with default settings in terms of beacons/etc.  No
>> issues with any device (laptop, computer, etc (in windows)), I have two
>> wireless USB adapters (bought two) and in Windows, no problems, I don't
>> think
>> it is the WNDR3700.  As far as linux/wpa-supplicant, using default settings.
> Not enough info. What does "iw dev wlan1 scan dump"  (it might not be
> wlan1 for you) say for "beacon interval"?
>
> Does anyone know how to get the DTIM period out of iw?
>
# iw dev wlan0 scan dump
BSS 74:ea:3a:e4:fa:6e (on wlan0) -- associated
     TSF: 499843461 usec (0d, 00:08:19)
     freq: 2442
     beacon interval: 100
     capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
     signal: -51.00 dBm
     last seen: 510 ms ago
     Information elements from Probe Response frame:
     SSID: mynet2
     Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
     DS Parameter set: channel 7
     RSN:     * Version: 1
          * Group cipher: CCMP
          * Pairwise ciphers: CCMP
          * Authentication suites: PSK
          * Capabilities: (0x0000)
     ERP: <no flags>
     Extended supported rates: 24.0 36.0 48.0 54.0
     WMM:     * Parameter version 1
          * u-APSD
          * BE: CW 15-1023, AIFSN 3
          * BK: CW 15-1023, AIFSN 7
          * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
          * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
     HT capabilities:
         Capabilities: 0x104e
             HT20/HT40
             SM Power Save disabled
             RX HT40 SGI
             No RX STBC
             Max AMSDU length: 3839 bytes
             DSSS/CCK HT40
         Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
         Minimum RX AMPDU time spacing: 8 usec (0x06)
         HT RX MCS rate indexes supported: 0-15
         HT TX MCS rate indexes are undefined
     WPS:     * Version: 1.0
          * Wi-Fi Protected Setup State: 2 (Configured)
          * Response Type: 3 (AP)
          * Unknown TLV (0x1047, 16 bytes): 00 00 00 00 00 00 10 00 00 
00 74 ea 3a e4 fa 6e
          * Manufacturer: TP-LINK
          * Model: TL-WR1043N
          * Model Number: 1.0
          * Serial Number: 1.0
          * Primary Device Type: 6-0050f204-1
          * Device name: Wireless Router TL-WR1043N
          * Config methods: Ethernet, Label, PBC
          * RF Bands: 0x1

>>> (2) How long does the client wait after waking up to go back to sleep?
>>> It should be at least a few seconds. For ssh, then, you should see
>>> something like a 100-200 ms delay for the first key and then nothing
>>> at all unless you stop typing for a bit.
>> It lags with each word I type, it is terrible.  If I run something like
>> dmesg or ps auxww, the entire session freezes for 5-10 seconds before it
>> comes back.
> Sorry; I meant what is the software stack configured to do? Do some
> looking around.
What do you mean here?

Best regards!
--
Igor Plyatov
