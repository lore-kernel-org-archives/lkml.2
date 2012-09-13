Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2IMVhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:37:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59486 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2IMVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:37:05 -0400
Message-ID: <505251FD.2090901@lwfinger.net>
Date: Thu, 13 Sep 2012 16:37:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: rtl8192se: ping router gives mdev of 25387.102???
References: <20120913101828.GA3309@gandalf.dynalias.org>
In-Reply-To: <20120913101828.GA3309@gandalf.dynalias.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 05:18 AM, Norbert Preining wrote:
> Hi everyone,
>
> (please cc)
>
> see $subject ...
>
> No warning, nothing in the logs, but pinging my router I get
> things like:
> --- 192.168.0.1 ping statistics ---
> 376 packets transmitted, 315 received, +33 errors, 16% packet loss, time 405164ms
> rtt min/avg/max/mdev = 0.873/10077.793/95935.698/25387.102 ms, pipe 68
>
> or
> --- 192.168.0.1 ping statistics ---
> 1252 packets transmitted, 1225 received, 2% packet loss, time 1252976ms
> rtt min/avg/max/mdev = 0.941/764.171/19929.265/2758.225 ms, pipe 20
>
>
> Has anyone *ever* seen a mdev of 25387.102 ms ???

No, but packets that are not returned for 19+ or 95+ seconds are usually counted 
as lost.

I have 4 different cards that use rtl8192se. With the current wireless-testing 
git, I get the following:

Card 1: Antenna config not known
--------------------------------
Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless 
LAN Controller [10ec:8172] (rev 10)

100 packets transmitted, 100 received, 0% packet loss, time 99138ms
rtt min/avg/max/mdev = 1.106/2.824/107.634/10.684 ms

Card 2: Labeled 1x1
-------------------
Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wireless 
LAN Controller [10ec:8171] (rev 10)

100 packets transmitted, 100 received, 0% packet loss, time 99139ms
rtt min/avg/max/mdev = 0.986/1.954/26.982/3.005 ms

Card 3: Labeled 1x2
-------------------
Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless 
LAN Controller [10ec:8172] (rev 10)

100 packets transmitted, 100 received, 0% packet loss, time 99141ms
rtt min/avg/max/mdev = 0.996/2.507/50.636/5.989 ms

Card 4: Labeled 2x2
-------------------
Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8192SE Wireless 
LAN Controller [10ec:8174] (rev 10)

100 packets transmitted, 99 received, 1% packet loss, time 99146ms
rtt min/avg/max/mdev = 0.974/1.768/31.183/3.016 ms

My AP is a Netgear WNDR3300 with a max rate of 270 Mbps in the 2.4 GHz band. The 
distance between my laptop and the AP is about 2m. The card is on an Express 
Card PCIe extender, and I have 2 7 dBi antennas connected. They likely boost the 
signal more than the ordinary laptop antennas would. The iwconfig output for 
card 4 is

wlan26    IEEE 802.11bgn  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=270 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-35 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

 From what you posted earlier, I think your card is like my Cards 1 & 3, but the 
PCI ID will tell for sure. These tests were run with commit 0a92aec2f22d of 
wireless-testing. There are some test patches installed, but non of them affect 
rtl8192se.

Larry


