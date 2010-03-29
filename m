Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0C2P1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:27:37 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:62997 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab0C2P1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:27:35 -0400
Message-ID: <4BB0C6E1.2090606@petalogix.com>
Date: Mon, 29 Mar 2010 17:27:29 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
CC: Eric Dumazet <eric.dumazet@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>, netdev@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       John Linn <John.Linn@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
Subject: Re: Network performance - iperf
References: <4BB09021.6020202@petalogix.com> <1269864994.2164.21.camel@edumazet-laptop> <4BB0BF28.5090505@petalogix.com>
In-Reply-To: <4BB0BF28.5090505@petalogix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> Eric Dumazet wrote:
>> Le lundi 29 mars 2010 à 13:33 +0200, Michal Simek a écrit :
>>
>>> Do you have any idea howto improve TCP/UDP performance in general?
>>> Or tests which can point me on weak places.
>>
>> Could you post "netstat -s" on your receiver, after fresh boot and your
>> iperf session, for 32 MB and 256 MB ram case ?
>>
> 
> I am not sure if is helpful but look below.
> 
Sorry I forget to c&p that second part. :-(

Look below.
Michal

32MB

~ # cat /proc/meminfo | head -n 1
MemTotal:          30024 kB
~ # iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  6] local 192.168.0.10 port 5001 connected with 192.168.0.101 port 43577
[ ID] Interval       Transfer     Bandwidth
[  6]  0.0-50.0 sec  78.0 MBytes  13.1 Mbits/sec
~ # ./netstat -s
Ip:
     56596 total packets received
     0 forwarded
     0 incoming packets discarded
     56596 incoming packets delivered
     15752 requests sent out
Icmp:
     0 ICMP messages received
     0 input ICMP message failed.
     ICMP input histogram:
     0 ICMP messages sent
     0 ICMP messages failed
     ICMP output histogram:
Tcp:
     0 active connections openings
     1 passive connection openings
     0 failed connection attempts
     0 connection resets received
     0 connections established
     56596 segments received
     15752 segments send out
     0 segments retransmited
     0 bad segments received.
     0 resets sent
Udp:
     0 packets received
     0 packets to unknown port received.
     0 packet receive errors
     0 packets sent
     RcvbufErrors: 0
     SndbufErrors: 0
UdpLite:
     InDatagrams: 0
     NoPorts: 0
     InErrors: 0
     OutDatagrams: 0
     RcvbufErrors: 0
     SndbufErrors: 0
error parsing /proc/net/snmp: Success



256MB


~ # cat /proc/meminfo | head -n 1
MemTotal:         257212 kB
~ # iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  6] local 192.168.0.10 port 5001 connected with 192.168.0.101 port 46069
[ ID] Interval       Transfer     Bandwidth
[  6]  0.0-50.2 sec  19.5 MBytes  3.26 Mbits/sec
~ # ./netstat -s
Ip:
     14163 total packets received
     0 forwarded
     0 incoming packets discarded
     14163 incoming packets delivered
     5209 requests sent out
Icmp:
     0 ICMP messages received
     0 input ICMP message failed.
     ICMP input histogram:
     0 ICMP messages sent
     0 ICMP messages failed
     ICMP output histogram:
Tcp:
     0 active connections openings
     1 passive connection openings
     0 failed connection attempts
     0 connection resets received
     0 connections established
     14163 segments received
     5209 segments send out
     0 segments retransmited
     0 bad segments received.
     0 resets sent
Udp:
     0 packets received
     0 packets to unknown port received.
     0 packet receive errors
     0 packets sent
     RcvbufErrors: 0
     SndbufErrors: 0
UdpLite:
     InDatagrams: 0
     NoPorts: 0
     InErrors: 0
     OutDatagrams: 0
     RcvbufErrors: 0
     SndbufErrors: 0
error parsing /proc/net/snmp: Success



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
