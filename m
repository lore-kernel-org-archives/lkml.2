Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1AGCn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:43:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55343 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1AGCn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:43:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dcyMeYh1l1sykvMUQoECvMJSkmyDXyRnC+JbuVBAZ/y8TlbfaoWPE60A7XRDE1bHOS
         8NDJ0GJqkp+VwSBDKCetRTSdeU1BZGtblLkHvExXuIedr6L35F9zFYpJqxL3ggu7lYwI
         vAUl/CQl+cnSXxlnhmiwWITeMNYZ+lGyD9dTA=
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not
 used
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Jesse Gross <jesse@nicira.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <1294368071.2704.49.camel@edumazet-laptop>
References: <AANLkTinLMCzKz7n45HdeAwNxsWjCADAkgfK+MjXVcFqh@mail.gmail.com>
	 <20101213224510.GB17400@mcarlson.broadcom.com>
	 <AANLkTi=9BYt=vkNkAiTBxnfnCjCX7AqCG=ML6coc4vdZ@mail.gmail.com>
	 <20101214191500.GD19951@mcarlson.broadcom.com>
	 <1293901393.2535.49.camel@edumazet-laptop>
	 <AANLkTinq9ABi0prxe0m1Ma6rno4UnAOzuW-b5L362ij9@mail.gmail.com>
	 <1293984348.2535.101.camel@edumazet-laptop>
	 <AANLkTincX-wPQE9gs16v53E4=Skivzc4ZSJS43oNBLD_@mail.gmail.com>
	 <1294356887.2704.13.camel@edumazet-laptop>
	 <1294363201.2704.19.camel@edumazet-laptop>
	 <20110107022912.GA17757@mcarlson.broadcom.com>
	 <1294368071.2704.49.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 03:43:22 +0100
Message-ID: <1294368202.2704.50.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 07 janvier 2011 à 03:41 +0100, Eric Dumazet a écrit :
> Le jeudi 06 janvier 2011 à 18:29 -0800, Matt Carlson a écrit :
> 
> > Hi Eric.  Sorry for the delay.  I was under the impression that your
> > problems were software related and that you just needed a revised
> > version of these VLAN patches I was sending to Michael.  Is this not
> > true?
> > 
> > Having a hardware stat increment suggests this is a new problem.
> > Maybe I missed it, but I didn't see what hardware you are working
> > with and whether or not management firmware was enabled.  Could you tell
> > me that info?
> > 
> 
> Hi Matt
> 
> I started a bisection, because I couldnt sleep tonight anyway :(
> 
> 14:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5715S
> Gigabit Ethernet (rev a3)
> 	Subsystem: Hewlett-Packard Company NC326m PCIe Dual Port Adapter
> 	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 43
> 	Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
> 	Memory at fdfe0000 (64-bit, non-prefetchable) [size=64K]
> 	[virtual] Expansion ROM at fdbe0000 [disabled] [size=128K]
> 	Capabilities: [40] PCI-X non-bridge device
> 	Capabilities: [48] Power Management version 2
> 	Capabilities: [50] Vital Product Data
> 	Capabilities: [58] MSI: Enable+ Count=1/8 Maskable- 64bit+
> 	Kernel driver in use: tg3
> 	Kernel modules: tg3
> 
> 

$ ethtool -i eth2
driver: tg3
version: 3.115
firmware-version: 5715s-v3.28
bus-info: 0000:14:04.0
$ dmesg | grep ASF
[    6.220577] tg3 0000:14:04.0: eth2: RXcsums[1] LinkChgREG[0] MIirq[0]
ASF[0] TSOcap[1]
[    6.228586] tg3 0000:14:04.1: eth3: RXcsums[1] LinkChgREG[0] MIirq[0]
ASF[0] TSOcap[1]



