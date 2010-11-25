Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0KYTJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 14:09:54 -0500
Received: from webmail10.mail.sp.isp-net.nl ([217.149.192.62]:61265 "EHLO
	webmail10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab0KYTJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 14:09:53 -0500
Message-ID: <4CEEB4A9.3090808@xmsnet.nl>
Date: Thu, 25 Nov 2010 20:10:33 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Caoco <caoco2002@yahoo.com>
CC: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Unplug ethernet cable, the route persists.  Why?
References: <242082.99180.qm@web63407.mail.re1.yahoo.com>
In-Reply-To: <242082.99180.qm@web63407.mail.re1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 08:48 PM, Mike Caoco wrote:
> Hello,
>
> This may have been discussed, but all search engines couldn't give me a good answer...
>
> I notice that when an interface is up/running, a local route is in the routing table:
>
> $ ifconfig eth1
> eth1      Link encap:Ethernet  HWaddr 00:13:20:0e:2f:ed
>            inet addr:192.168.1.125  Bcast:192.168.1.255  Mask:255.255.255.0
>            inet6 addr: fe80::213:20ff:fe0e:2fed/64 Scope:Link
>            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>            RX packets:35984995 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:7409151 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:3252413825 (3.2 GB)  TX bytes:1340077250 (1.3 GB)
>
> $ ip route
> 192.168.20.0/24 dev eth0  proto kernel  scope link  src 192.168.20.120
> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.125
> default via 192.168.20.254 dev eth1  metric 100
>
> After I unplug the cable from eth1, the RUNNING flag disappears, but the route is still there:
>
> $ ifconfig eth1
> eth1      Link encap:Ethernet  HWaddr 00:13:20:0e:2f:ed
>            inet addr:192.168.1.125  Bcast:192.168.1.255  Mask:255.255.255.0
>            inet6 addr: fe80::213:20ff:fe0e:2fed/64 Scope:Link
>            UP BROADCAST MULTICAST  MTU:1500  Metric:1
>            RX packets:35985023 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:7409151 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:3252415633 (3.2 GB)  TX bytes:1340077250 (1.3 GB)
>
> $ ip route
> 192.168.20.0/24 dev eth0  proto kernel  scope link  src 192.168.20.120
> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.125
> default via 192.168.20.254 dev eth1  metric 100
>
> And that *prevents* from using the default route to reach 192.168.1/24 subnet after eth1 is out.

Well suppose the default route is used, and the source address is of the 
packets stay 192.168.1.125, then there is no way for the peers to 
respond to the packets. I do not know wat sets the source address in 
linux, but on windows it will allway's be the one you do not want.

-- 
Hans


