Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab2HWUwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:52:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38031 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab2HWUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:52:46 -0400
Subject: Re: [REGRESSION] 3.6-rc2 and 3.6-rc3: TCP/IP network connection
 hang
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201208232235.53312.Martin@lichtvoll.de>
References: <201208232235.53312.Martin@lichtvoll.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Aug 2012 22:52:41 +0200
Message-ID: <1345755161.5904.1816.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 22:35 +0200, Martin Steigerwald wrote:
> Hi!
> 
> Its a bit difficult to describe. With 3.6-rc2 and 3.6-rc3 on an Lenovo
> ThinkPad T520 from Linus git, I get occasional network hangs:
> 
> On for example sending a small mail via SMTP to my Debian Squeeze
> based server via a ASUS WL-500gP Router with
> Debian Squeeze and some 2.6.34 kernel KMail hangs.
> 
> It just doesn´t complete sending out the mail.
> 
> I have seen this once with 3.6-rc2 and now also with 3.6-rc3 that I
> tried cause it had quite some network fixes.
> 
> Notebook: 10.0.0.10 (IP and MAC changed)
> Gateway:  10.0.0.1 (IP and MAC changed)
> Server: 194.150.191.11
> 
> 
> Below is a tshark capture of such an occurence.
> 
> I had a network hang with 3.6-rc2 with something else as well, but I do
> not remember what it was and whether it was upload or download.
> 
> This is upload.
> 
> 
> I never seen this with any previous kernel upto 3.5.2 from Greg K.H. git.
> 
> 
> merkaba:~> tshark -ni eth0
> tshark: Lua: Error during loading:
>  [string "/usr/share/wireshark/init.lua"]:45: dofile has been disabled
> Running as user "root" and group "root". This could be dangerous.
> Capturing on eth0
>   0.000000    10.0.0.10 -> 194.150.191.11 TCP 74 58915 > 25 [SYN] Seq=0 Win=14600 Len=0 MSS=1460 SACK_PERM=1 
> TSval=15189797 TSecr=0 WS=128
>   0.025222 194.150.191.11 -> 10.0.0.10    TCP 74 25 > 58915 [SYN, ACK] Seq=0 Ack=1 Win=5792 Len=0 MSS=1460 
> SACK_PERM=1 TSval=108848542 TSecr=15189797 WS=16
>   0.025309    10.0.0.10 -> 194.150.191.11 TCP 66 58915 > 25 [ACK] Seq=1 Ack=1 Win=14720 Len=0 TSval=15189822 
> TSecr=108848542
>   0.066680 194.150.191.11 -> 10.0.0.10    SMTP 116 S: 220 mail.lichtvoll.de ESMTP Postfix (Debian/GNU)
>   0.066745    10.0.0.10 -> 194.150.191.11 TCP 66 58915 > 25 [ACK] Seq=1 Ack=51 Win=14720 Len=0 TSval=15189864 
> TSecr=108848553
>   0.066881    10.0.0.10 -> 194.150.191.11 SMTP 89 C: EHLO merkaba.localnet
>   0.092287 194.150.191.11 -> 10.0.0.10    TCP 66 25 > 58915 [ACK] Seq=51 Ack=24 Win=5792 Len=0 TSval=108848559 
> TSecr=15189864
>   0.092351 194.150.191.11 -> 10.0.0.10    SMTP 206 S: 250-mail.lichtvoll.de | 250-PIPELINING | 250-SIZE 20000000 | 250-VRFY | 
> 250-ETRN | 250-STARTTLS | 250-ENHANCEDSTATUSCODES | 250-8BITMIME | 250 DSN
>   0.092485    10.0.0.10 -> 194.150.191.11 SMTP 76 C: STARTTLS
>   0.118043 194.150.191.11 -> 10.0.0.10    SMTP 96 S: 220 2.0.0 Ready to start TLS
>   0.157589    10.0.0.10 -> 194.150.191.11 TCP 66 58915 > 25 [ACK] Seq=34 Ack=221 Win=15744 Len=0 TSval=15189955 
> TSecr=108848566
>   0.166043    10.0.0.10 -> 194.150.191.11 SSL 292 Client Hello
>   0.214300 194.150.191.11 -> 10.0.0.10    TLSv1 1510 Server Hello, Certificate, Server Key Exchange, Server Hello Done
>   0.214389    10.0.0.10 -> 194.150.191.11 TCP 66 58915 > 25 [ACK] Seq=260 Ack=1665 Win=18688 Len=0 TSval=15190011 
> TSecr=108848589
>   0.218072    10.0.0.10 -> 194.150.191.11 TLSv1 264 Client Key Exchange, Change Cipher Spec, Encrypted Handshake Message
>   0.254985 194.150.191.11 -> 10.0.0.10    TLSv1 316 New Session Ticket, Change Cipher Spec, Encrypted Handshake Message
>   0.258463    10.0.0.10 -> 194.150.191.11 TLSv1 135 Application Data
>   0.285463 194.150.191.11 -> 10.0.0.10    TLSv1 215 Application Data
>   0.287155    10.0.0.10 -> 194.150.191.11 TLSv1 151 Application Data
>   0.313450 194.150.191.11 -> 10.0.0.10    TLSv1 135 Application Data
>   0.313706    10.0.0.10 -> 194.150.191.11 TLSv1 183 Application Data
>   0.347362 194.150.191.11 -> 10.0.0.10    TLSv1 151 Application Data
>   0.349485    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP segment of a reassembled PDU]
>   0.349522    10.0.0.10 -> 194.150.191.11 TLSv1 1327 Application Data
>   0.350700     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>   0.384716 194.150.191.11 -> 10.0.0.10    TCP 78 [TCP Dup ACK 22#1] 25 > 58915 [ACK] Seq=2218 Ack=729 Win=7936 Len=0 
> TSval=108848632 TSecr=15190111 SLE=2177 SRE=3438
>   0.392573    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15190190 TSecr=108848632
>   0.393809     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>   0.624613    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15190422 TSecr=108848632
>   0.625846     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>   1.089586    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15190887 TSecr=108848632
>   1.090836     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>   2.018584    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15191816 TSecr=108848632
>   2.019846     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>   3.878591    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15193676 TSecr=108848632
>   3.879797     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>   5.022069 10:00:00:01:aa:bb -> 10:00:00:10:cc:dd ARP 60 Who has 10.0.0.10?  Tell 10.0.0.1
>   5.022115 10:00:00:10:cc:dd -> 10:00:00:01:aa:bb ARP 42 10.0.0.10 is at 10:00:00:10:cc:dd
>   7.594598    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15197392 TSecr=108848632
>   7.595882     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>  15.034613    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15204832 TSecr=108848632
>  15.035919     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>  29.914590    10.0.0.10 -> 194.150.191.11 TCP 1514 [TCP Retransmission] 58915 > 25 [ACK] Seq=729 Ack=2218 Win=24448 
> Len=1448 TSval=15219712 TSecr=108848632
>  29.915903     10.0.0.1 -> 10.0.0.10    ICMP 590 Destination unreachable (Fragmentation needed)
>  34.922706 10:00:00:10:cc:dd -> 10:00:00:01:aa:bb ARP 42 Who has 10.0.0.1?  Tell 10.0.0.10
>  34.923296 10:00:00:01:aa:bb -> 10:00:00:10:cc:dd ARP 60 10.0.0.1 is at 10:00:00:01:aa:bb
> 
> 
> Thats it. Nothing more is happening.
> 
> 
> Notebook:
> 
> martin@merkaba:~> lspci -nn | grep Ethernet 
> 00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit Network Connection [8086:1502] (rev 04)
> 
> martin@merkaba:~> cat /proc/version
> Linux version 3.5.2-tp520 (martin@merkaba) (gcc version 4.7.1 (Debian 4.7.1-7) ) #1 SMP PREEMPT Sun Aug 19 12:39:04 CEST 2012
> 
> 
> ASUS WL-500gP Premium:
> 
> gayatri:~# lspci -nn
> 00:00.0 Host bridge [0600]: Broadcom Corporation BCM4704 PCI to SB Bridge [14e4:4704] (rev 09)
> 00:02.0 Network controller [0280]: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller 
> [14e4:4318] (rev 02)
> 00:03.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 62)
> 00:03.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 62)
> 00:03.2 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 65)
> 
> gayatri:~# cat /proc/version
> Linux version 2.6.34.5 (amain@amain-laptop) (gcc version 4.3.3 (GCC) ) #1 Sun Sep 26 18:20:27 CEST 2010
> 
> (I tried to compile my own, but it didn´t work out.)
> 
> The ethernet seems to be missing from above. I am using 100 MBit wire based
> ethernet port. Wireless is disabled.
> 
> 
> Server is VMware ESX on some FSC server.
> 
> Thanks,

Fix is under way : 

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=9b04f350057863d1fad1ba071e09362a1da3503e

Thanks


