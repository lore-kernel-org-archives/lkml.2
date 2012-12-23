Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2LWBtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 20:49:12 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41858 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2LWBtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 20:49:11 -0500
Message-ID: <50D66313.3000208@lwfinger.net>
Date: Sat, 22 Dec 2012 19:49:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dire state of rtl8192se driver in 3.7
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at> <50D5E194.3050503@lwfinger.net> <20121222225543.GA21544@gamma.logic.tuwien.ac.at>
In-Reply-To: <20121222225543.GA21544@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 04:55 PM, Norbert Preining wrote:
> Hi Larry,, hi all
>
> On Sa, 22 Dez 2012, Larry Finger wrote:
>> It is not that no one cares; however, your attitude does nothing to
>> induce me to work on this problem. The facts are not needed "to make
>
> Aehm, ... after my initial report you asked me several more questions,
> which I answered within a few hours. After that no as in 0 response,
> although I pinged back a few times.
>
> So am I supposed to deduce from 0 reactions that anyone is interested?
>
>> people happy", they are necessary to try to reproduce the problem. If I
>> cannot make it happen here, then I cannot fix it. Also, remember that I
>
> Disagree. I am involved in tracking down a nasty regression in the intel
> drm driver, which the intel people can *not* reproduce, but several
> other people, and after long trials and patches and converse it is
> starting to look much better.
>
>> am a volunteer. I get nothing from Realtek but starting code of varying
>> quality and some sample chips. At least my versions do not crash your
>
> Ok, that is a problem I understand. If this is the case, that it is
> a single volunteer caring for the code, then I see a real problem.
> (And I also will try to stay away from rtl wlan cards on my next laptop)
>
>> I have never tested forcing a reset on the chip the way you did. I am not
>> surprised that bad things happen.
>
> But the DMAR item I also reported points to a real problem I guess.

Yes, I would agree.

>>  From some of the material that you report, it appears that you have an
>> 802.11n connection using WPA1 encryption. (More of those pesky details!)
>
> WPA PSK, yes. I don't know the difference between WPA2 and WPA, though.

WPA2 is AES and WPA(1) is TKIP.

My device is the same as yours. The command 'lspci -nn' shows:

0e:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB 
Wireless LAN Controller [10ec:8172] (rev 10)

The B variety is a 1x2 configuration.

My signal strength is essentially the same as yours.

wlan0     IEEE 802.11bgn  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=18 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-35 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:1943   Missed beacon:0

A throughput test with netperf shows the following for 3 second samples:

TCP_MAERTS Test:  23.73 20.80 20.87 20.62 20.50 20.62 20.19 20.67 20.70 20.75
RX Results: max 23.73, min 20.19. Mean 20.95(0.95)

TCP_STREAM Test:  20.82 26.36 25.77 25.89 26.36 26.31 26.19 26.50 26.16 25.93
TX Results: max 26.50, min 20.82. Mean 25.63(1.62)

My router does not let me change the TKIP interval, which I think means 3600 
seconds. Running a ping for ~4000 seconds results in

--- 192.168.1.1 ping statistics ---
4004 packets transmitted, 4002 received, 0% packet loss, time 4007793ms
rtt min/avg/max/mdev = 0.782/1.605/77.929/4.310 ms

Only 2 packets lost in 4000 is pretty good, and my longest return time of 77 ms 
is certainly not like you get.

My router is a Netgear WNDR3300 running firmware version V1.0.45_1.0.45NA.

These results are representative of what I have always gotten. I have no idea 
why your system is so different.

One thing to try is loading the module with option "ips=0".

Larry

