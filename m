Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036Ab2IOEPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 00:15:19 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56843 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2IOEPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 00:15:16 -0400
Date: Sat, 15 Sep 2012 13:15:14 +0900
From: Norbert Preining <preining@logic.at>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: rtl8192se: ping router gives mdev of 25387.102???
Message-ID: <20120915041513.GF30623@gamma.logic.tuwien.ac.at>
References: <505251FD.2090901@lwfinger.net> <5051EF3C.3020401@lwfinger.net> <20120913222850.GA438@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913222850.GA438@gandalf.dynalias.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry, hi all,

On Fr, 14 Sep 2012,  wrote:
> I am running on top of default kernel git, will try wireless-testing, too.

I tried now with wireless-testing from yesterday, and had the same problem.
Actually, I got even *better* results:
64 bytes from 192.168.0.1: icmp_req=75 ttl=255 time=137856 ms
64 bytes from 192.168.0.1: icmp_req=76 ttl=255 time=136848 ms
64 bytes from 192.168.0.1: icmp_req=78 ttl=255 time=134943 ms

...
rtt min/avg/max/mdev = 1.110/46967.879/137856.232/49666.671 ms, pipe 138


So now we are mdev of 50secs sometimes ;-)


Another interesting things:
At home I have the problems with the NEC router, but I am now at
the university. I am writing this email over a very very stable 
ssh link to another server.

Here is the output iof ifconfig:
$ ifconfig
eth0      Link encap:Ethernet  HWaddr 60:eb:69:c9:0c:ea  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:20418 errors:0 dropped:0 overruns:0 frame:0
          TX packets:20418 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1950587 (1.8 MiB)  TX bytes:1950587 (1.8 MiB)

wlan0     Link encap:Ethernet  HWaddr 88:9f:fa:f9:07:28  
          inet addr:150.65.206.200  Bcast:150.65.207.255  Mask:255.255.252.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:232640 errors:0 dropped:1 overruns:0 frame:0
          TX packets:69798 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:85599897 (81.6 MiB)  TX bytes:8925832 (8.5 MiB)


But the kernel is convinced that I am not connected ...:
$ iw dev wlan0 link
Not connected.
$ iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:off


And no, I guarantee you there is no ethernet cable plugged in ;-)

I can only assume that is a problem with iwconfig/iw being too old,
although according to the output of iwconfig it is fine:
# iw --version
iw version 3.4
# iwconfig --version
iwconfig  Wireless-Tools version 30
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

wlan0     Recommend Wireless Extension v21 or later,
          Currently compiled with Wireless Extension v22.

#  uname -a
Linux tofuschnitzel 3.6.0-rc5-wl+ #19 SMP PREEMPT Fri Sep 14 13:14:15 JST 2012 x86_64 GNU/Linux


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CHICAGO (n.)
The foul-smelling wind which precedes an underground railway train.
			--- Douglas Adams, The Meaning of Liff
