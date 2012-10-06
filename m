Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab2JFNxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:53:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60083 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2JFNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:53:40 -0400
Subject: Re: [REGRESSION] Kernel 3.6 drops network packets instead of
 forwarding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <B3A09DD14C7DC341B8B4D309FE5DD1BE1513FA4B@G2W2525.americas.hpqcorp.net>
References: <B3A09DD14C7DC341B8B4D309FE5DD1BE1513FA4B@G2W2525.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Oct 2012 15:53:36 +0200
Message-ID: <1349531616.21172.1069.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-06 at 11:52 +0000, Chini, Georg (HP App Services) wrote:
> Hello,
> 
> I have a network issue with kernel 3.6. My machine is set
> up as router and with 3.6 it sometimes silently drops reply
> packets instead of forwarding.
> Example tcpdump on the router for ping www.heise.de from a
> machine in my network (NAT is done elsewhere):
> 
> 12:37:54.746627 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16414, seq 1, length 64 (eth0)
> 12:37:54.746681 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16414, seq 1, length 64 (GRE tunnel)
> 12:37:54.782195 IP 193.99.144.85 > 192.168.255.150: ICMP echo reply, id 16414, seq 1, length 64 (GRE tunnel)
> 12:37:54.782335 IP 193.99.144.85 > 192.168.255.150: ICMP echo reply, id 16414, seq 1, length 64 (eth0)
> 12:37:55.785974 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16416, seq 1, length 64 (eth0)
> 12:37:55.786023 IP 192.168.255.150 > 193.99.144.85: ICMP echo request, id 16416, seq 1, length 64 (GRE tunnel)
> 12:37:55.822529 IP 193.99.144.85 > 192.168.255.150: ICMP echo reply, id 16416, seq 1, length 64 (GRE tunnel)
> NO forwarded packet on eth0
> 
> Then this goes on for an arbitrary period (between a few seconds and
> more then half an hour) and suddenly returns to normal. During that
> time no communication is possible between a host on my network and
> any external host. Connections from the router itself still work.
> With kernel 3.4.3 everything works fine. Had the same issue with
> -rc6 and -rc7.
> 
> There are no messages in the logs. Any idea what might cause this
> or how I can debug it any further?
> I will supply more details on my setup if needed. Please CC me in
> your reply as I am not subscribed to the list.

Looks like the bug fixed by : 

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=f4ef85bbda96324785097356336bc79cdd37db0a

(David Miller will send it to stable team shortly)



