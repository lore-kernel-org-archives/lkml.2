Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2GWPDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:03:22 -0400
Received: from mail.vyatta.com ([76.74.103.46]:55342 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab2GWPDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:03:21 -0400
Date: Mon, 23 Jul 2012 08:02:55 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Michael Leun <lkml20120218@newton.leun.net>
Cc: bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.5 regression / bridge] constantly toggeling between disabled
 and forwarding
Message-ID: <20120723080255.361bfe04@nehalam.linuxnetplumber.net>
In-Reply-To: <20120723091504.2d035d28@xenia.leun.net>
References: <20120723091504.2d035d28@xenia.leun.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012 09:15:04 +0200
Michael Leun <lkml20120218@newton.leun.net> wrote:

> Hi,
> 
> when I use my usb ethernet adapter
> 
> # > lsusb
> [...]
> Bus 002 Device 009: ID 9710:7830 MosChip Semiconductor MCS7830 10/100 Mbps Ethernet adapter
> [...]
> 
> as port of an bridge
> 
> > # brctl addbr br0
> > # brctl addif br0 eth0
> > # brctl addif br0 ue5
> > # ifconfig ue5 up
> > # ifconfig br0 up
> 
> (Also does happen when eth0 is not part of the bridge, but the logs I
> had available were from that situation...)
> 
> I constantly get messages showing the interface toggeling between
> disabled and forwarding state:
> 
> Jul 23 07:40:50 elektra kernel: [ 1539.497337] br0: port 2(ue5) entered disabled state
> Jul 23 07:40:50 elektra kernel: [ 1539.554992] br0: port 2(ue5) entered forwarding state
> Jul 23 07:40:50 elektra kernel: [ 1539.555005] br0: port 2(ue5) entered forwarding state
> Jul 23 07:40:51 elektra kernel: [ 1540.496242] br0: port 2(ue5) entered disabled state
> Jul 23 07:40:51 elektra kernel: [ 1540.552534] br0: port 2(ue5) entered forwarding state
> Jul 23 07:40:51 elektra kernel: [ 1540.552548] br0: port 2(ue5) entered forwarding state
> Jul 23 07:40:52 elektra kernel: [ 1541.550413] br0: port 2(ue5) entered forwarding state
> Jul 23 07:40:53 elektra kernel: [ 1542.529672] br0: port 2(ue5) entered disabled state
> Jul 23 07:40:53 elektra kernel: [ 1542.587162] br0: port 2(ue5) entered forwarding state
> Jul 23 07:40:53 elektra kernel: [ 1542.587175] br0: port 2(ue5) entered forwarding state
> Jul 23 07:40:54 elektra kernel: [ 1543.585309] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:00 elektra kernel: [ 1549.360600] br0: port 2(ue5) entered disabled state
> Jul 23 07:41:00 elektra kernel: [ 1549.442998] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:00 elektra kernel: [ 1549.443011] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:01 elektra kernel: [ 1550.357686] br0: port 2(ue5) entered disabled state
> Jul 23 07:41:01 elektra kernel: [ 1550.408208] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:01 elektra kernel: [ 1550.408222] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:02 elektra kernel: [ 1551.407656] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:03 elektra kernel: [ 1552.401578] br0: port 2(ue5) entered disabled state
> Jul 23 07:41:03 elektra kernel: [ 1552.474773] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:03 elektra kernel: [ 1552.474786] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:04 elektra kernel: [ 1553.472487] br0: port 2(ue5) entered forwarding state
> Jul 23 07:41:05 elektra kernel: [ 1554.356138] br0: port 2(ue5) entered disabled state
> [...]
> 
> This does (in the same situation, nothing else than the kernel changed)
> not happen with 3.4.5.
> 
> Does anybody have an idea what the issue might be or do I need to bisect?

Probably not a bridge issue, but rather an issue with link status reporting
on the device. The bridge changes state when the attached ethernet
device raises/lowers carrier.

An independent way to observe link changes is to use a tool like:
  ip monitor
which will show carrier up/down events.
