Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2JIWO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:14:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43374 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2JIWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:14:57 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sf.net>
Cc: <support@Supermicro.com>, <ap@solarrain.com>
Subject: X9SCM-F/82574L/e1000e lag / high latency (e1000e/Intel bug)
Date: Tue, 9 Oct 2012 18:14:54 -0400
Message-ID: <003901cda66b$836a5db0$8a3f1910$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac2ma3S7jmQjWoseT+2f/eUO1Z4hFA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Good news: Supermicro 2.0b fixes an unrelated problem where only 16GB is
addressed in the BIOS when you have 32GB on the system, with 2.0b that is
resolved.

Bad news: This bug still remains (E1000): When you transfer a file/files
over Samba, the latency shoots up really high (this also affects other
applications!)

This bug has been bothering me for months (random lag) during high network
I/O on my X9SCM-F motherboard.
There is a lot of discussion about this problem here:
http://sourceforge.net/p/e1000/bugs/27/?page=4

I tried the EEPROM fix but it did not work:
http://sourceforge.net/projects/e1000/files/e1000e%20stable/eeprom_fix_82574
_or_82583/

"The value at offset 0x001e (58) has bit 1 unset. This enables the
problematic
power saving feature. In this case, the EEPROM needs to read "5a" at offset
0x001e."

# ethtool -e eth4 |grep 0x0010
0x0010:         ff ff ff ff 6b 02 00 00 d9 15 d3 10 ff ff 5a a5

Yes I did reboot.

Here is what the problem looks like, during a SAMBA copy from A->B where
B=X9SCM running Linux:

(ONBOARD Intel eth0 / 82574L )

$ ping windowspc
PING windowspc (192.168.0.1) 56(84) bytes of data.
64 bytes from windowspc (192.168.0.1): icmp_req=1 ttl=128 time=0.544 ms
64 bytes from windowspc (192.168.0.1): icmp_req=2 ttl=128 time=0.193 ms
64 bytes from windowspc (192.168.0.1): icmp_req=3 ttl=128 time=0.619 ms
64 bytes from windowspc (192.168.0.1): icmp_req=4 ttl=128 time=0.642 ms
64 bytes from windowspc (192.168.0.1): icmp_req=5 ttl=128 time=0.426 ms
64 bytes from windowspc (192.168.0.1): icmp_req=6 ttl=128 time=0.464 ms
64 bytes from windowspc (192.168.0.1): icmp_req=7 ttl=128 time=0.696 ms
64 bytes from windowspc (192.168.0.1): icmp_req=8 ttl=128 time=1353 ms
64 bytes from windowspc (192.168.0.1): icmp_req=9 ttl=128 time=353 ms
64 bytes from windowspc (192.168.0.1): icmp_req=10 ttl=128 time=0.492 ms
64 bytes from windowspc (192.168.0.1): icmp_req=11 ttl=128 time=0.618 ms
64 bytes from windowspc (192.168.0.1): icmp_req=12 ttl=128 time=0.474 ms
64 bytes from windowspc (192.168.0.1): icmp_req=13 ttl=128 time=0.542 ms
64 bytes from windowspc (192.168.0.1): icmp_req=14 ttl=128 time=0.471 ms
64 bytes from windowspc (192.168.0.1): icmp_req=15 ttl=128 time=0.645 ms
64 bytes from windowspc (192.168.0.1): icmp_req=16 ttl=128 time=0.394 ms
64 bytes from windowspc (192.168.0.1): icmp_req=17 ttl=128 time=0.537 ms
64 bytes from windowspc (192.168.0.1): icmp_req=18 ttl=128 time=0.706 ms
64 bytes from windowspc (192.168.0.1): icmp_req=19 ttl=128 time=0.465 ms
64 bytes from windowspc (192.168.0.1): icmp_req=20 ttl=128 time=0.707 ms
64 bytes from windowspc (192.168.0.1): icmp_req=21 ttl=128 time=348 ms
64 bytes from windowspc (192.168.0.1): icmp_req=22 ttl=128 time=0.703 ms
64 bytes from windowspc (192.168.0.1): icmp_req=23 ttl=128 time=0.560 ms
64 bytes from windowspc (192.168.0.1): icmp_req=24 ttl=128 time=0.554 ms
64 bytes from windowspc (192.168.0.1): icmp_req=25 ttl=128 time=0.585 ms
64 bytes from windowspc (192.168.0.1): icmp_req=26 ttl=128 time=0.508 ms
64 bytes from windowspc (192.168.0.1): icmp_req=27 ttl=128 time=345 ms
64 bytes from windowspc (192.168.0.1): icmp_req=28 ttl=128 time=0.374 ms
64 bytes from windowspc (192.168.0.1): icmp_req=29 ttl=128 time=0.728 ms
64 bytes from windowspc (192.168.0.1): icmp_req=30 ttl=128 time=0.537 ms
64 bytes from windowspc (192.168.0.1): icmp_req=31 ttl=128 time=0.190 ms
64 bytes from windowspc (192.168.0.1): icmp_req=32 ttl=128 time=0.204 ms
64 bytes from windowspc (192.168.0.1): icmp_req=33 ttl=128 time=0.239 ms

Same test (copy test) with samba as above but now with an Intel 4-port NIC:
$ ping windowspc
64 bytes from windowspc (192.168.0.1): icmp_req=1 ttl=128 time=0.175 ms
64 bytes from windowspc (192.168.0.1): icmp_req=2 ttl=128 time=0.332 ms
64 bytes from windowspc (192.168.0.1): icmp_req=3 ttl=128 time=0.276 ms
64 bytes from windowspc (192.168.0.1): icmp_req=4 ttl=128 time=0.221 ms
64 bytes from windowspc (192.168.0.1): icmp_req=5 ttl=128 time=0.518 ms
64 bytes from windowspc (192.168.0.1): icmp_req=6 ttl=128 time=0.157 ms
64 bytes from windowspc (192.168.0.1): icmp_req=7 ttl=128 time=0.222 ms
64 bytes from windowspc (192.168.0.1): icmp_req=8 ttl=128 time=0.605 ms
64 bytes from windowspc (192.168.0.1): icmp_req=9 ttl=128 time=0.335 ms
64 bytes from windowspc (192.168.0.1): icmp_req=10 ttl=128 time=0.679 ms
64 bytes from windowspc (192.168.0.1): icmp_req=11 ttl=128 time=0.223 ms
64 bytes from windowspc (192.168.0.1): icmp_req=12 ttl=128 time=0.189 ms
64 bytes from windowspc (192.168.0.1): icmp_req=13 ttl=128 time=0.432 ms
64 bytes from windowspc (192.168.0.1): icmp_req=14 ttl=128 time=0.235 ms
64 bytes from windowspc (192.168.0.1): icmp_req=15 ttl=128 time=0.386 ms
64 bytes from windowspc (192.168.0.1): icmp_req=16 ttl=128 time=0.658 ms
64 bytes from windowspc (192.168.0.1): icmp_req=17 ttl=128 time=0.430 ms
64 bytes from windowspc (192.168.0.1): icmp_req=18 ttl=128 time=0.494 ms
64 bytes from windowspc (192.168.0.1): icmp_req=19 ttl=128 time=0.411 ms
64 bytes from windowspc (192.168.0.1): icmp_req=20 ttl=128 time=0.737 ms
64 bytes from windowspc (192.168.0.1): icmp_req=21 ttl=128 time=0.543 ms
64 bytes from windowspc (192.168.0.1): icmp_req=22 ttl=128 time=0.564 ms
64 bytes from windowspc (192.168.0.1): icmp_req=23 ttl=128 time=0.571 ms
64 bytes from windowspc (192.168.0.1): icmp_req=24 ttl=128 time=0.407 ms
64 bytes from windowspc (192.168.0.1): icmp_req=25 ttl=128 time=0.518 ms
64 bytes from windowspc (192.168.0.1): icmp_req=26 ttl=128 time=0.482 ms
64 bytes from windowspc (192.168.0.1): icmp_req=27 ttl=128 time=0.904 ms
64 bytes from windowspc (192.168.0.1): icmp_req=28 ttl=128 time=0.478 ms
64 bytes from windowspc (192.168.0.1): icmp_req=29 ttl=128 time=1.16 ms
64 bytes from windowspc (192.168.0.1): icmp_req=30 ttl=128 time=0.656 ms
64 bytes from windowspc (192.168.0.1): icmp_req=31 ttl=128 time=0.613 ms
64 bytes from windowspc (192.168.0.1): icmp_req=32 ttl=128 time=0.475 ms
64 bytes from windowspc (192.168.0.1): icmp_req=33 ttl=128 time=0.562 ms

So it appears, at the moment, if you have problems with eth0, try using eth1
or buy another network card.

--

There is also a few other issues with this board:

1) If you plug-in too many PCI-e devices, it will drop some of the boards,
e.g.
   they will not show up if they use too much power.  (USB-3 boards, etc)

  SLOT Bottom => Video
   Slot next one up => empty
   Slot next one up => NIC
   Slot Next one up => empty

   The NIC doesn't show up in Linux, I put it in the first slot (near the
CPU) and it worked.

--

I am happy SM addressed the 16GB/32GB problem (before only 16GB of memory
would show up out of 32GB)!

For this NIC issue I am perplexed, for now I will just use a four-port NIC
but would be curious if there was a proper fix so I could use the on-board
NICs without the high latency as shown above.

With 2.0b, still an issue:

(ONBOARD Intel eth0 / 82574L )

64 bytes from windowspc (192.168.0.1): icmp_req=11 ttl=128 time=0.396 ms
64 bytes from windowspc (192.168.0.1): icmp_req=12 ttl=128 time=0.537 ms
64 bytes from windowspc (192.168.0.1): icmp_req=13 ttl=128 time=0.617 ms
64 bytes from windowspc (192.168.0.1): icmp_req=14 ttl=128 time=2292 ms
64 bytes from windowspc (192.168.0.1): icmp_req=15 ttl=128 time=1292 ms
64 bytes from windowspc (192.168.0.1): icmp_req=16 ttl=128 time=292 ms
64 bytes from windowspc (192.168.0.1): icmp_req=17 ttl=128 time=0.300 ms
64 bytes from windowspc (192.168.0.1): icmp_req=18 ttl=128 time=0.651 ms

(FOUR PORT NIC, EXACT SAME TEST)

64 bytes from windowspc (192.168.0.1): icmp_req=13 ttl=128 time=0.799 ms
64 bytes from windowspc (192.168.0.1): icmp_req=14 ttl=128 time=0.483 ms
64 bytes from windowspc (192.168.0.1): icmp_req=15 ttl=128 time=0.420 ms
64 bytes from windowspc (192.168.0.1): icmp_req=16 ttl=128 time=0.481 ms
64 bytes from windowspc (192.168.0.1): icmp_req=17 ttl=128 time=1.30 ms
64 bytes from windowspc (192.168.0.1): icmp_req=18 ttl=128 time=0.446 ms
64 bytes from windowspc (192.168.0.1): icmp_req=19 ttl=128 time=1.16 ms
64 bytes from windowspc (192.168.0.1): icmp_req=20 ttl=128 time=0.596 ms
64 bytes from windowspc (192.168.0.1): icmp_req=21 ttl=128 time=0.413 ms
64 bytes from windowspc (192.168.0.1): icmp_req=22 ttl=128 time=0.537 ms
64 bytes from windowspc (192.168.0.1): icmp_req=23 ttl=128 time=0.304 ms
64 bytes from windowspc (192.168.0.1): icmp_req=24 ttl=128 time=0.455 ms
64 bytes from windowspc (192.168.0.1): icmp_req=25 ttl=128 time=0.462 ms
64 bytes from windowspc (192.168.0.1): icmp_req=26 ttl=128 time=0.450 ms
64 bytes from windowspc (192.168.0.1): icmp_req=27 ttl=128 time=0.445 ms
64 bytes from windowspc (192.168.0.1): icmp_req=28 ttl=128 time=0.907 ms
64 bytes from windowspc (192.168.0.1): icmp_req=29 ttl=128 time=0.925 ms
64 bytes from windowspc (192.168.0.1): icmp_req=30 ttl=128 time=0.559 ms
64 bytes from windowspc (192.168.0.1): icmp_req=31 ttl=128 time=0.245 ms
64 bytes from windowspc (192.168.0.1): icmp_req=32 ttl=128 time=0.277 ms

Justin.

