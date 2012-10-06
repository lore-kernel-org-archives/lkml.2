Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2JFLxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 07:53:24 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:32634 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2JFLxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 07:53:23 -0400
From: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] Kernel 3.6 drops network packets instead of forwarding
Thread-Topic: [REGRESSION] Kernel 3.6 drops network packets instead of
 forwarding
Thread-Index: Ac2juQFVn+V67GgiRmOwkCLDpckQtQ==
Date: Sat, 6 Oct 2012 11:52:06 +0000
Message-ID: <B3A09DD14C7DC341B8B4D309FE5DD1BE1513FA4B@G2W2525.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.26]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a network issue with kernel 3.6. My machine is set
up as router and with 3.6 it sometimes silently drops reply
packets instead of forwarding.
Example tcpdump on the router for ping www.heise.de from a
machine in my network (NAT is done elsewhere):

12:37:54.746627 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16414, seq 1, length 64 (eth0)
12:37:54.746681 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16414, seq 1, length 64 (GRE tunnel)
12:37:54.782195 IP 193.99.144.85 > 192.168.255.150: ICMP echo reply, id 16414, seq 1, length 64 (GRE tunnel)
12:37:54.782335 IP 193.99.144.85 > 192.168.255.150: ICMP echo reply, id 16414, seq 1, length 64 (eth0)
12:37:55.785974 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16416, seq 1, length 64 (eth0)
12:37:55.786023 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16416, seq 1, length 64 (GRE tunnel)
12:37:55.822529 IP 193.99.144.85 > 192.168.255.150: ICMP echo reply, id 16416, seq 1, length 64 (GRE tunnel)
NO forwarded packet on eth0

Then this goes on for an arbitrary period (between a few seconds and
more then half an hour) and suddenly returns to normal. During that
time no communication is possible between a host on my network and
any external host. Connections from the router itself still work.
With kernel 3.4.3 everything works fine. Had the same issue with
-rc6 and -rc7.

There are no messages in the logs. Any idea what might cause this
or how I can debug it any further?
I will supply more details on my setup if needed. Please CC me in
your reply as I am not subscribed to the list.

Thanks in advance
                 Georg Chini
