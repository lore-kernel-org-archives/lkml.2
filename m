Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1DMTAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:00:21 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:35919 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370Ab1DMTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:00:19 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Apr 2011 15:00:19 EDT
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
Date: Wed, 13 Apr 2011 20:44:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.6.2; x86_64; ; )
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com>
In-Reply-To: <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104132044.51087.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Ivo,

Am Mittwoch 13 April 2011, um 17:59:07 schrieb Ivo Van Doorn:
> Hi,
> 
> > I recall using this driver in staging and it crashing my machine, now
> > thats its no longer in staging, I thought I'd give it another try..
> >  Using the
> 
> The rt2800usb was not in staging but has been inside the main kernel
> tree for quite
> some time already, the alternative rt2870sta was in staging and will
> be removed very soon.
> 
> > following wireless usb adapter, I'm seeing very high latency when using
> > the device in Linux, (with Windows, there are no problems).  Using Debian
> 
> > Testing + wpa_supplicant, using the following USB adapter:
> Can you try disabling powersaving?
> iwconfig wlan0 power off

this doesn't helps with the ping times here and it also doesn't prevent the 
network traffic to stall from time to time (e.g. using apt-get install <some 
package>). 

Additionaly I found the following in the log:

[ 2701.455472] phy0 -> rt2x00usb_watchdog_tx_dma: Warning - TX queue 0 DMA timed 
out, invoke forced forced reset
[ 2701.655222] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed to 
flush
[ 2702.461590] phy0 -> rt2x00usb_watchdog_tx_dma: Warning - TX queue 0 DMA timed 
out, invoke forced forced reset
[ 2702.655224] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed to 
flush
[ 2703.455119] phy0 -> rt2x00usb_watchdog_tx_dma: Warning - TX queue 0 DMA timed 
out, invoke forced forced reset
[ 2703.655072] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed to 
flush
[ 2704.454070] phy0 -> rt2x00usb_watchdog_tx_dma: Warning - TX queue 0 DMA timed 
out, invoke forced forced reset
[ 2704.645024] phy0 -> rt2x00queue_flush_queue: Warning - Queue 0 failed to 
flush

This is with latest driver (rt2x00 master from today) backported to 2.6.37. The 
machine is arm tegra and the chip is a rt3070. Output of ping with "power off":

marc@ac100:~$ sudo ping -i 0.01 -s 1400 192.168.10.1
PING 192.168.10.1 (192.168.10.1) 1400(1428) bytes of data.
1408 bytes from 192.168.10.1: icmp_req=1 ttl=64 time=10.9 ms
1408 bytes from 192.168.10.1: icmp_req=2 ttl=64 time=24.4 ms
1408 bytes from 192.168.10.1: icmp_req=3 ttl=64 time=6.72 ms
1408 bytes from 192.168.10.1: icmp_req=4 ttl=64 time=25.7 ms
1408 bytes from 192.168.10.1: icmp_req=5 ttl=64 time=7.01 ms
1408 bytes from 192.168.10.1: icmp_req=6 ttl=64 time=22.7 ms
1408 bytes from 192.168.10.1: icmp_req=7 ttl=64 time=9.07 ms
1408 bytes from 192.168.10.1: icmp_req=8 ttl=64 time=25.7 ms
1408 bytes from 192.168.10.1: icmp_req=9 ttl=64 time=6.07 ms

1408 bytes from 192.168.10.1: icmp_req=10 ttl=64 time=1931 ms
1408 bytes from 192.168.10.1: icmp_req=11 ttl=64 time=1920 ms
1408 bytes from 192.168.10.1: icmp_req=12 ttl=64 time=1917 ms
1408 bytes from 192.168.10.1: icmp_req=13 ttl=64 time=1897 ms
1408 bytes from 192.168.10.1: icmp_req=14 ttl=64 time=1878 ms
1408 bytes from 192.168.10.1: icmp_req=15 ttl=64 time=1858 ms

1408 bytes from 192.168.10.1: icmp_req=16 ttl=64 time=23.2 ms
1408 bytes from 192.168.10.1: icmp_req=17 ttl=64 time=11.6 ms
1408 bytes from 192.168.10.1: icmp_req=18 ttl=64 time=23.9 ms
1408 bytes from 192.168.10.1: icmp_req=19 ttl=64 time=7.26 ms
1408 bytes from 192.168.10.1: icmp_req=20 ttl=64 time=22.6 ms
1408 bytes from 192.168.10.1: icmp_req=21 ttl=64 time=4.46 ms
1408 bytes from 192.168.10.1: icmp_req=22 ttl=64 time=25.8 ms
1408 bytes from 192.168.10.1: icmp_req=23 ttl=64 time=10.6 ms
1408 bytes from 192.168.10.1: icmp_req=24 ttl=64 time=23.2 ms
1408 bytes from 192.168.10.1: icmp_req=25 ttl=64 time=4.15 ms
1408 bytes from 192.168.10.1: icmp_req=26 ttl=64 time=21.5 ms
1408 bytes from 192.168.10.1: icmp_req=27 ttl=64 time=6.64 ms
1408 bytes from 192.168.10.1: icmp_req=28 ttl=64 time=21.6 ms

1408 bytes from 192.168.10.1: icmp_req=29 ttl=64 time=1792 ms
1408 bytes from 192.168.10.1: icmp_req=30 ttl=64 time=1811 ms
1408 bytes from 192.168.10.1: icmp_req=31 ttl=64 time=1794 ms
1408 bytes from 192.168.10.1: icmp_req=32 ttl=64 time=1774 ms
1408 bytes from 192.168.10.1: icmp_req=33 ttl=64 time=1755 ms

1408 bytes from 192.168.10.1: icmp_req=34 ttl=64 time=23.4 ms
1408 bytes from 192.168.10.1: icmp_req=35 ttl=64 time=7.42 ms
1408 bytes from 192.168.10.1: icmp_req=36 ttl=64 time=26.1 ms
1408 bytes from 192.168.10.1: icmp_req=37 ttl=64 time=6.85 ms
1408 bytes from 192.168.10.1: icmp_req=38 ttl=64 time=21.9 ms
1408 bytes from 192.168.10.1: icmp_req=39 ttl=64 time=3.21 ms
1408 bytes from 192.168.10.1: icmp_req=40 ttl=64 time=22.5 ms
1408 bytes from 192.168.10.1: icmp_req=41 ttl=64 time=3.93 ms
1408 bytes from 192.168.10.1: icmp_req=42 ttl=64 time=24.3 ms
1408 bytes from 192.168.10.1: icmp_req=43 ttl=64 time=5.07 ms
1408 bytes from 192.168.10.1: icmp_req=44 ttl=64 time=21.8 ms
1408 bytes from 192.168.10.1: icmp_req=45 ttl=64 time=7.76 ms

1408 bytes from 192.168.10.1: icmp_req=46 ttl=64 time=1974 ms
1408 bytes from 192.168.10.1: icmp_req=47 ttl=64 time=1965 ms
1408 bytes from 192.168.10.1: icmp_req=48 ttl=64 time=1976 ms
1408 bytes from 192.168.10.1: icmp_req=49 ttl=64 time=1957 ms
1408 bytes from 192.168.10.1: icmp_req=50 ttl=64 time=1942 ms
1408 bytes from 192.168.10.1: icmp_req=51 ttl=64 time=1923 ms

1408 bytes from 192.168.10.1: icmp_req=52 ttl=64 time=42.9 ms
1408 bytes from 192.168.10.1: icmp_req=53 ttl=64 time=27.1 ms
1408 bytes from 192.168.10.1: icmp_req=54 ttl=64 time=14.0 ms
1408 bytes from 192.168.10.1: icmp_req=55 ttl=64 time=21.2 ms
1408 bytes from 192.168.10.1: icmp_req=56 ttl=64 time=5.41 ms
1408 bytes from 192.168.10.1: icmp_req=57 ttl=64 time=22.1 ms
1408 bytes from 192.168.10.1: icmp_req=58 ttl=64 time=32.3 ms
1408 bytes from 192.168.10.1: icmp_req=59 ttl=64 time=19.2 ms
1408 bytes from 192.168.10.1: icmp_req=60 ttl=64 time=4.30 ms
1408 bytes from 192.168.10.1: icmp_req=61 ttl=64 time=25.7 ms
1408 bytes from 192.168.10.1: icmp_req=62 ttl=64 time=5.91 ms
1408 bytes from 192.168.10.1: icmp_req=63 ttl=64 time=21.7 ms
1408 bytes from 192.168.10.1: icmp_req=64 ttl=64 time=6.75 ms
^C
--- 192.168.10.1 ping statistics ---
70 packets transmitted, 64 received, 8% packet loss, time 6668ms
rtt min/avg/max/mdev = 3.212/513.169/1976.893/826.940 ms, pipe 7

You can see a clear pattern within the ping times.

Hope this helps,

Marc


