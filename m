Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab2IMW3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:29:00 -0400
Received: from mailrelayi.jaist.ac.jp ([150.65.19.7]:18874 "EHLO
	mailrelayi.jaist.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018Ab2IMW2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:28:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,419,1344178800"; 
   d="scan'208";a="122834196"
Date: Fri, 14 Sep 2012 07:28:51 +0900
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: rtl8192se: ping router gives mdev of 25387.102???
Message-ID: <20120913222850.GA438@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505251FD.2090901@lwfinger.net>
 <5051EF3C.3020401@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

thanks for the answer, here some more information as requested

AP infos:distance: 3m
NEC Aterm WR8600N ATERM-B45459
firmware 1.0.11

Network card is built in into a Lenovo Thinkpad Edge
# lspci -nnv -s  03:00.0
03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:e020]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	I/O ports at 2000 [size=256]
	Memory at f0500000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192se

# iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:"norbujp"  
          Mode:Managed  Frequency:2.442 GHz  Access Point: 00:3A:9D:B4:54:5A   
          Bit Rate=150 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=-35 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:9   Missed beacon:0

at this point there is according to ifconfig/iwconfig a connection 
up and running, but ping tells me:
# ping 192.168.0.1
...
>From 192.168.0.2 icmp_seq=77 Destination Host Unreachable
..

I tried with network-manager as well as without and wpa_supplicant
directly, no change.

Also removing the module and reloading it did not help.


On Thu, 13 Sep 2012, Larry Finger wrote:
> the details of your AP - STA configuration. What is the distance? Is

I think it is pretty standard WPA-PSK, is there anything more I can
tell you, please let me know.

> it 802.11n or 802.11g? What is the signal strength as indicated by
> iwconfig or a scan?

See above.

> From what you posted earlier, I think your card is like my Cards 1 &
> 3, but the PCI ID will tell for sure. These tests were run with
> commit 0a92aec2f22d of wireless-testing. There are some test patches
> installed, but non of them affect rtl8192se.

I am running on top of default kernel git, will try wireless-testing, too.

Thanks a lot and all the best, and let me know what I can provide more!

Norbert

----------------------------------------------------------------------------
Norbert Preining                preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                   TeX Live and Debian Developer
gpg DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
----------------------------------------------------------------------------
IPING (participial vb.)
The increasingly anxious shifting from leg to leg you go through when
you are desperate to go to the lavatory and the person you are talking
to keeps on remembering a few final things he want to mention.
			--- Douglas Adams, The Meaning of Liff
