Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1AGC7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:59:48 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:1283 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab1AGC7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:59:46 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Thu, 6 Jan 2011 18:59:30 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
        "Jesse Gross" <jesse@nicira.com>,
        "Michael Leun" <lkml20101129@newton.leun.net>,
        "Michael Chan" <mchan@broadcom.com>,
        "David Miller" <davem@davemloft.net>,
        "Ben Greear" <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid
 not used
Message-ID: <20110107025930.GA17808@mcarlson.broadcom.com>
References: <20101214191500.GD19951@mcarlson.broadcom.com>
 <1293901393.2535.49.camel@edumazet-laptop>
 <AANLkTinq9ABi0prxe0m1Ma6rno4UnAOzuW-b5L362ij9@mail.gmail.com>
 <1293984348.2535.101.camel@edumazet-laptop>
 <AANLkTincX-wPQE9gs16v53E4=Skivzc4ZSJS43oNBLD_@mail.gmail.com>
 <1294356887.2704.13.camel@edumazet-laptop>
 <1294363201.2704.19.camel@edumazet-laptop>
 <20110107022912.GA17757@mcarlson.broadcom.com>
 <1294368071.2704.49.camel@edumazet-laptop>
 <1294368202.2704.50.camel@edumazet-laptop>
MIME-Version: 1.0
In-Reply-To: <1294368202.2704.50.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 61385E595L813444216-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 06:43:22PM -0800, Eric Dumazet wrote:
> Le vendredi 07 janvier 2011 ?? 03:41 +0100, Eric Dumazet a ??crit :
> > Le jeudi 06 janvier 2011 ?? 18:29 -0800, Matt Carlson a ??crit :
> > 
> > > Hi Eric.  Sorry for the delay.  I was under the impression that your
> > > problems were software related and that you just needed a revised
> > > version of these VLAN patches I was sending to Michael.  Is this not
> > > true?
> > > 
> > > Having a hardware stat increment suggests this is a new problem.
> > > Maybe I missed it, but I didn't see what hardware you are working
> > > with and whether or not management firmware was enabled.  Could you tell
> > > me that info?
> > > 
> > 
> > Hi Matt
> > 
> > I started a bisection, because I couldnt sleep tonight anyway :(
> > 
> > 14:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5715S
> > Gigabit Ethernet (rev a3)
> > 	Subsystem: Hewlett-Packard Company NC326m PCIe Dual Port Adapter
> > 	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 43
> > 	Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
> > 	Memory at fdfe0000 (64-bit, non-prefetchable) [size=64K]
> > 	[virtual] Expansion ROM at fdbe0000 [disabled] [size=128K]
> > 	Capabilities: [40] PCI-X non-bridge device
> > 	Capabilities: [48] Power Management version 2
> > 	Capabilities: [50] Vital Product Data
> > 	Capabilities: [58] MSI: Enable+ Count=1/8 Maskable- 64bit+
> > 	Kernel driver in use: tg3
> > 	Kernel modules: tg3
> > 
> > 
> 
> $ ethtool -i eth2
> driver: tg3
> version: 3.115
> firmware-version: 5715s-v3.28
> bus-info: 0000:14:04.0
> $ dmesg | grep ASF
> [    6.220577] tg3 0000:14:04.0: eth2: RXcsums[1] LinkChgREG[0] MIirq[0]
> ASF[0] TSOcap[1]
> [    6.228586] tg3 0000:14:04.1: eth3: RXcsums[1] LinkChgREG[0] MIirq[0]
> ASF[0] TSOcap[1]

Thanks.  So management firmware is disabled.  This should be
straightforward case.

I'm wondering if I'm misunderstanding something though.  You said earlier
that VLAN tagging doesn't work unless you applied my patch.  Is this no
longer true?

