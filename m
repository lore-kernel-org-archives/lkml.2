Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1D0A3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:29:31 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57978 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab1D0A33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=LRAjmIr90Akd0XR9lIi3Z+bLWQrxPLNsFdJQfnZZNa30POGXDIPl52yv7ZIE/tb0a6
         bx51632P1apE+/7Xbv06N6lcx4gsDAjgf4JyLUB59DFeZmw3fk3htc9sOBec0xj2WQCj
         FzNw4mlnWdkzUBrjJJVftVhCrs99xptCP5pTI=
Message-ID: <4DB76363.4080303@gmail.com>
Date: Wed, 27 Apr 2011 02:29:23 +0200
From: Jano <jano.ita@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan> <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan> <4DB74788.2000908@lwfinger.net> <alpine.DEB.2.02.1104261923390.3894@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1104261923390.3894@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz ha scritto:
>
>
> On Tue, 26 Apr 2011, Larry Finger wrote:
>
>>>
>>> I am trying a different driver now: rt2870sta
>>> I've read a few reports this may be the 'proper' one to use.
>>> So far so good, no lag or anything and I did not have to set power off
>>> either.
>>
>> Driver rtl2870sta is not the proper one to use. In fact, a patch to 
>> delete rt2860sta and rt2870sta from the kernel was queued yesterday, 
>> and they will be gone by the time 2.6.40 is released.
>>
>> New firmware for rt2800usb was just accepted into the linux-firmware 
>> git tree. Please obtain a copy and try it.
>>
>> Larry
>>
>
> Hello,
>
> With latest rt2800usb (and firmware from the git tree ~5 minutes ago)
>
> Without wlan0 power off:
>
> PING atomw (192.168.0.2) 56(84) bytes of data.
> 64 bytes from atomw (192.168.0.2): icmp_req=1 ttl=64 time=103 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=2 ttl=64 time=106 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=3 ttl=64 time=99.7 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=4 ttl=64 time=102 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=5 ttl=64 time=98.5 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=6 ttl=64 time=9.74 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=7 ttl=64 time=217 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=8 ttl=64 time=141 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=11 ttl=64 time=13.2 ms
> ^C
> --- atomw ping statistics ---
> 11 packets transmitted, 9 received, 18% packet loss, time 10003ms
> rtt min/avg/max/mdev = 9.744/99.095/217.349/58.880 ms
>
> With latest rt2800usb (and firmware from the git tree ~5 minutes ago)
>
> With wlan0 power off:
>
> PING atomw (192.168.0.2) 56(84) bytes of data.
> 64 bytes from atomw (192.168.0.2): icmp_req=3 ttl=64 time=40.6 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=4 ttl=64 time=0.894 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=5 ttl=64 time=0.735 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=6 ttl=64 time=0.693 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=7 ttl=64 time=0.680 ms
> ^C
> -- atomw ping statistics ---
> 7 packets transmitted, 5 received, 28% packet loss, time 6005ms
> rtt min/avg/max/mdev = 0.680/8.723/40.615/15.946 ms
>
> Switching back to rt2870sta, rt2800usb is unusable for me at this time.
>
> With rt2870sta and the Media Link 150 / USB stick, (I have two, the 
> problems
> occur on both, using different USB ports as well using the rt2800usb 
> driver)
>
> $ ping atomw
> PING atomw (192.168.0.2) 56(84) bytes of data.
> 64 bytes from atomw (192.168.0.2): icmp_req=1 ttl=64 time=1.07 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=2 ttl=64 time=0.709 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=3 ttl=64 time=0.921 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=4 ttl=64 time=0.723 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=5 ttl=64 time=0.752 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=6 ttl=64 time=0.718 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=7 ttl=64 time=0.745 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=8 ttl=64 time=0.787 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=9 ttl=64 time=0.835 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=10 ttl=64 time=0.878 ms
> 64 bytes from atomw (192.168.0.2): icmp_req=11 ttl=64 time=0.704 ms
> ^C
> --- atomw ping statistics ---
> 11 packets transmitted, 11 received, 0% packet loss, time 10010ms
> rtt min/avg/max/mdev = 0.704/0.804/1.074/0.111 ms
>
> Flawless, I hope the issues can be worked out with the rt2800usb 
> driver, or
> someone keeps a backport of the rt2870sta driver, thanks!
>
> Here is some debug output from when I was using rt2800usb:
>
> [  102.432319] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 0
> [  102.913430] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 1
> [  103.876437] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 2
> [  103.918554] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 3
> [  103.924421] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 5
> [  103.939051] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 7
> [  103.944339] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 8
> [  103.959539] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 9
> [  103.964800] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 10
> [  103.973788] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 13
> [  103.978632] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 14
> [  103.984294] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 16
> [  103.989152] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 17
> [  104.249186] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 19
> [  104.254079] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 20
> [  104.259670] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 23
> [  116.706277] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 0 status timed out, invoke forced tx handler
> [  116.845043] phy0 -> rt2800_txdone_entry_check: Warning - TX status 
> report missed for queue 2 entry 24
> [  122.706346] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 0 status timed out, invoke forced tx handler
> [  123.706360] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 2 status timed out, invoke forced tx handler
> [  124.706329] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 0 status timed out, invoke forced tx handler
> [  126.706328] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 0 status timed out, invoke forced tx handler
> [  128.706301] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 0 status timed out, invoke forced tx handler
> [  129.706281] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 2 status timed out, invoke forced tx handler
> [  130.706403] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 2 status timed out, invoke forced tx handler
> [  153.706296] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 0 status timed out, invoke forced tx handler
> [  162.706335] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX 
> queue 2 status timed out, invoke forced tx handler
>
> Justin.
---------------------------------------------------------------------------------------------------------------------------------------------------------------
Hi Justin,
- I do not have this issue with rt2800usb:
:~$ modinfo rt2800usb
filename:       
/lib/modules/2.6.38-5-generic/updates/drivers/net/wireless/rt2x00/rt2800usb.ko
license:        GPL
firmware:       rt2870.bin
description:    Ralink RT2800 USB Wireless LAN driver.
version:        2.3.0
author:         http://rt2x00.serialmonkey.com
srcversion:     8A52B052043FF2C7E5A8B14
----------------------------------------------------------------------------------------
:~$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=10.04
DISTRIB_CODENAME=lucid
DISTRIB_DESCRIPTION="Ubuntu 10.04.2 LTS"
-----------------------------------------------------------------------------------------
jano:~$ ls -l /lib/firmware/rt2870.bin
-rw-r--r-- 1 root root 4096 2010-11-18 22:20 /lib/firmware/rt2870.bin
-----------------------------------------------------------------------------------------
:~$ ping -c 5 www.google.it
PING www.l.google.com (74.125.232.116) 56(84) bytes of data.
64 bytes from 74.125.232.116: icmp_seq=1 ttl=54 time=29.8 ms
64 bytes from 74.125.232.116: icmp_seq=2 ttl=54 time=36.0 ms
64 bytes from 74.125.232.116: icmp_seq=3 ttl=53 time=36.1 ms
64 bytes from 74.125.232.116: icmp_seq=4 ttl=54 time=38.6 ms
64 bytes from 74.125.232.116: icmp_seq=5 ttl=54 time=34.1 ms

--- www.l.google.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 20355ms
rtt min/avg/max/mdev = 29.821/34.965/38.603/2.937 ms

-----------------------------------------------------------------------------------
:~$ ping -c 5 www.google.it
PING www.l.google.com (74.125.232.112) 56(84) bytes of data.
64 bytes from 74.125.232.112: icmp_seq=1 ttl=54 time=39.5 ms
64 bytes from 74.125.232.112: icmp_seq=2 ttl=53 time=36.8 ms
64 bytes from 74.125.232.112: icmp_seq=3 ttl=53 time=35.4 ms
64 bytes from 74.125.232.112: icmp_seq=4 ttl=53 time=38.6 ms
64 bytes from 74.125.232.112: icmp_seq=5 ttl=53 time=34.3 ms

--- www.l.google.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 20385ms
rtt min/avg/max/mdev = 34.302/36.943/39.525/1.945 ms
----------------------------------------------------------------------------------

Bye Jano
