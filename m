Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab0HNIxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:53:33 -0400
Received: from mx0.vr-web.de ([195.200.35.198]:39825 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985Ab0HNIxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:53:32 -0400
From: Andreas <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: Re: rt61pci - bad performance
Date: Sat, 14 Aug 2010 10:55:17 +0200
Organization: privat
Message-ID: <4C6659F5.9080706@01019freenet.de>
References: <ffaPE-58l-5@gated-at.bofh.it> <fgPe2-2X7-19@gated-at.bofh.it> <fgXXY-KJ-1@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: abuse@arcor.de
To: Helmut Schaa <helmut.schaa@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.3a6pre) Gecko/20100803 SeaMonkey/2.1a2
In-Reply-To: <fgXXY-KJ-1@gated-at.bofh.it>
To: linux-kernel@vger.kernel.org
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf103, sigver: 7.28621
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helmut Schaa wrote:
> Hi Andreas,
>
> Am Freitag 13 August 2010 schrieb Andrew Morton:
>> (cc's added)
>>
>> On Sun, 08 Aug 2010 11:49:49 +0200
>> Andreas<andihartmann@01019freenet.de>  wrote:
>
> [...]
>
>>> wlan0     IEEE 802.11bg  ESSID:"--------"
>>>             Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
>>>             Bit Rate=1 Mb/s   Tx-Power=5 dBm
>>>             Retry  long limit:7   RTS thr:off   Fragment thr:off
>>>             Encryption key:off
>>>             Power Management:off
>>>             Link Quality=38/70  Signal level=-72 dBm
>>>             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>>
>>> The throughput is measured with ping -f -s 7000 and xosview -n.
>
> This doesn't look like an appropriate way to measure the throughput. You
> should use something like iperf [1] or netperf [2] for your measurements
> to get more accurate results.
>
>>> If I'm using ndiswrapper with the windows driver, first of all, I can
>>> see additional information in iwconfig:
>>>
>>> wlan0     IEEE 802.11g  ESSID:"--------"
>>>             Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
>>>             Bit Rate=54 Mb/s   Tx-Power:20 dBm   Sensitivity=-121 dBm
>>>             RTS thr=2347 B   Fragment thr=2346 B
>>>             Encryption key:some key   Security mode:restricted
>>>             Power Management:off
>>>             Link Quality:62/100  Signal level:-56 dBm  Noise level:-96 dBm
>>>             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>>
>>>
>>> There is a switch for sensitivity (which is not supported with rt61pci)
>>> and the link quality compared with ndiswrapper is worse (38% to 62%).
>
> I wouldn't trust the link quality values that much, the calculation in rt61pi
> is most likely different from what the windows driver does. So it is not
> really comparable.

I detected the problem using tunneled ssh-x-sessions and during copying 
of data. I'm not really interested in the link-quality - I just need a 
high performance :-).

>>> The following is remarkably too:
>>> ndiswrapper uses a Tx-Power of 20 dBm, rt61pci only 5 dBm. I don't know,
>>> why rt61pci uses 5 dBm. It's a hard limit and I can't set it on a value
>>> higher than 5 unless the driver is patched. Nevertheless, setting a
>>> higher value (of 20 dBm) by patch does not mean to get a better performance.
>
> Could you elaborate please? Did you actually try to patch it or is this just
> an assumption?

see my other mail!

>>> Ndiswrapper shows an encryption key, rt61pci not. Does it mean, that
>>> rt61pci doesn't use hardware encryption?
>
> hw crypto should be enabled by default in rt61pci, however, I don't know
> if it is actually working ;)

How can I see if it's working?

>>> With ndiswrapper, the rt61pci-chip achieves a throughput of 2,6 MBytes/s
>>> - that's about 1 MByte/s more than rt61pci.
>>>
>>> I have to say, that the difference between rt61pci and ndiswrapper gets
>>> worse if the link quality is getting more badly. Or in other words:
>>> ndiswrapper handles bad connections better then rt61pci.
>>>
>>>
>>> Do you have any idea to get rt61pci working as fast as ndiswrapper?
>
> Please run proper measurements first and post the results again.

I did some measurements with netperf (TCP_STREAM):


ndiswrapper
===========

(OpenSuSE 11.2 2.6.31.13-21):
download
average        min        max
20,88        19,02        22,19 MBit/s    (6 runs)

upstream
average        min        max
21,46        18,84        22,26 MBits/s    (7 runs)


OpenSuSE 11.3 (2.6.34-12-desktop)
download
average        min        max
21,41        20,51        22,51 MBit/s    (16 runs)


upstream
average        min        max
error


rt61pci (patched - compat-wireless-2010-07-20)
==============================================

OpenSuSE 11.3 (2.6.34-12-desktop)
download
average        min        max
15,54        12,4        17,19 MBit/s    (25 runs)

upstream
average        min        max
13,54        12,1        14,04 MBits/s    (7 runs)


rt61pci (original (unpatched) from OpenSuSE 11.3)
==============================================

download
0,7 MBit/s

upstream
error (interrupted system call)


If you compare ndiswrapper with rt61pci patched, there is a difference 
of about 6 MBits/s. The unpatched version can't be used at all.

Another point is the upstream issue with ndiswrapper with 
2.6.34-kernels, which appears under some conditions (under "normal" 
conditions, I didn't see this problem yet).

Do you need some special tests? Please ask for them - I'll try to 
provide them!


Thanks for you help,
kind regards,
Andreas
