Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1DZXba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:31:30 -0400
Received: from lucidpixels.com ([75.144.35.66]:42342 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab1DZXb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:31:29 -0400
Date: Tue, 26 Apr 2011 19:31:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
In-Reply-To: <4DB74788.2000908@lwfinger.net>
Message-ID: <alpine.DEB.2.02.1104261923390.3894@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan> <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan>
 <4DB74788.2000908@lwfinger.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Apr 2011, Larry Finger wrote:

>> 
>> I am trying a different driver now: rt2870sta
>> I've read a few reports this may be the 'proper' one to use.
>> So far so good, no lag or anything and I did not have to set power off
>> either.
>
> Driver rtl2870sta is not the proper one to use. In fact, a patch to delete 
> rt2860sta and rt2870sta from the kernel was queued yesterday, and they will 
> be gone by the time 2.6.40 is released.
>
> New firmware for rt2800usb was just accepted into the linux-firmware git 
> tree. Please obtain a copy and try it.
>
> Larry
>

Hello,

With latest rt2800usb (and firmware from the git tree ~5 minutes ago)

Without wlan0 power off:

PING atomw (192.168.0.2) 56(84) bytes of data.
64 bytes from atomw (192.168.0.2): icmp_req=1 ttl=64 time=103 ms
64 bytes from atomw (192.168.0.2): icmp_req=2 ttl=64 time=106 ms
64 bytes from atomw (192.168.0.2): icmp_req=3 ttl=64 time=99.7 ms
64 bytes from atomw (192.168.0.2): icmp_req=4 ttl=64 time=102 ms
64 bytes from atomw (192.168.0.2): icmp_req=5 ttl=64 time=98.5 ms
64 bytes from atomw (192.168.0.2): icmp_req=6 ttl=64 time=9.74 ms
64 bytes from atomw (192.168.0.2): icmp_req=7 ttl=64 time=217 ms
64 bytes from atomw (192.168.0.2): icmp_req=8 ttl=64 time=141 ms
64 bytes from atomw (192.168.0.2): icmp_req=11 ttl=64 time=13.2 ms
^C
--- atomw ping statistics ---
11 packets transmitted, 9 received, 18% packet loss, time 10003ms
rtt min/avg/max/mdev = 9.744/99.095/217.349/58.880 ms

With latest rt2800usb (and firmware from the git tree ~5 minutes ago)

With wlan0 power off:

PING atomw (192.168.0.2) 56(84) bytes of data.
64 bytes from atomw (192.168.0.2): icmp_req=3 ttl=64 time=40.6 ms
64 bytes from atomw (192.168.0.2): icmp_req=4 ttl=64 time=0.894 ms
64 bytes from atomw (192.168.0.2): icmp_req=5 ttl=64 time=0.735 ms
64 bytes from atomw (192.168.0.2): icmp_req=6 ttl=64 time=0.693 ms
64 bytes from atomw (192.168.0.2): icmp_req=7 ttl=64 time=0.680 ms
^C
-- atomw ping statistics ---
7 packets transmitted, 5 received, 28% packet loss, time 6005ms
rtt min/avg/max/mdev = 0.680/8.723/40.615/15.946 ms

Switching back to rt2870sta, rt2800usb is unusable for me at this time.

With rt2870sta and the Media Link 150 / USB stick, (I have two, the problems
occur on both, using different USB ports as well using the rt2800usb driver)

$ ping atomw
PING atomw (192.168.0.2) 56(84) bytes of data.
64 bytes from atomw (192.168.0.2): icmp_req=1 ttl=64 time=1.07 ms
64 bytes from atomw (192.168.0.2): icmp_req=2 ttl=64 time=0.709 ms
64 bytes from atomw (192.168.0.2): icmp_req=3 ttl=64 time=0.921 ms
64 bytes from atomw (192.168.0.2): icmp_req=4 ttl=64 time=0.723 ms
64 bytes from atomw (192.168.0.2): icmp_req=5 ttl=64 time=0.752 ms
64 bytes from atomw (192.168.0.2): icmp_req=6 ttl=64 time=0.718 ms
64 bytes from atomw (192.168.0.2): icmp_req=7 ttl=64 time=0.745 ms
64 bytes from atomw (192.168.0.2): icmp_req=8 ttl=64 time=0.787 ms
64 bytes from atomw (192.168.0.2): icmp_req=9 ttl=64 time=0.835 ms
64 bytes from atomw (192.168.0.2): icmp_req=10 ttl=64 time=0.878 ms
64 bytes from atomw (192.168.0.2): icmp_req=11 ttl=64 time=0.704 ms
^C
--- atomw ping statistics ---
11 packets transmitted, 11 received, 0% packet loss, time 10010ms
rtt min/avg/max/mdev = 0.704/0.804/1.074/0.111 ms

Flawless, I hope the issues can be worked out with the rt2800usb driver, or
someone keeps a backport of the rt2870sta driver, thanks!

Here is some debug output from when I was using rt2800usb:

[  102.432319] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 0
[  102.913430] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 1
[  103.876437] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 2
[  103.918554] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 3
[  103.924421] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 5
[  103.939051] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 7
[  103.944339] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 8
[  103.959539] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 9
[  103.964800] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 10
[  103.973788] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 13
[  103.978632] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 14
[  103.984294] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 16
[  103.989152] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 17
[  104.249186] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 19
[  104.254079] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 20
[  104.259670] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 23
[  116.706277] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[  116.845043] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 24
[  122.706346] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[  123.706360] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
[  124.706329] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[  126.706328] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[  128.706301] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[  129.706281] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
[  130.706403] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
[  153.706296] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[  162.706335] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler

Justin.

