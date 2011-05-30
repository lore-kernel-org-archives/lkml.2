Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1E3Euo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 00:50:44 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:44571 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1E3Eun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 00:50:43 -0400
X-RZG-AUTH: :PmMGcFK8W/5pU+Ks2M0NQC5NPKGZSjWcOhfQxYOYwqVGYqoFWDz5FUtWKnE=
X-RZG-CLASS-ID: mo00
Message-ID: <4DE3221E.40508@au-79.de>
Date: Mon, 30 May 2011 06:50:38 +0200
From: Robert Goldner <robert@au-79.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
CC: netdev@vger.kernel.org
Subject: Re: Ooops with 2.6.39
References: <4DE1E013.6010300@au-79.de>	 <20110529154542.add2a308.akpm@linux-foundation.org> <1306722856.30021.28.camel@edumazet-laptop>
In-Reply-To: <1306722856.30021.28.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 30.05.2011 04:34, schrieb Eric Dumazet:
> Le dimanche 29 mai 2011 à 15:45 -0700, Andrew Morton a écrit :
>> (cc netdev)
>>
>> On Sun, 29 May 2011 07:56:35 +0200 Robert Goldner <robert@au-79.de> wrote:
> 
>>> Hi,
>>>
>>> sometimes I got an Ooops while the system is starting:
>>>
>>> [   15.824365] ------------[ cut here ]------------
>>> [   15.824616] WARNING: at net/sched/sch_generic.c:256
>>> dev_watchdog+0x1d6/0x1e0()
>>> [   15.824868] Hardware name:
>>> [   15.825098] NETDEV WATCHDOG: eth0 (sis900): transmit queue 0 timed out
>>> [   15.825333] Modules linked in: coretemp qt1010 af9013 dvb_pll mt2060
>>> dvb_usb_nova_t_usb2 dvb_usb_dibusb_common dib3000mc psmouse
>>> dibx000_common pcspkr dvb_usb_af9015 ohci_hcd
>>> [   15.829066] Pid: 1462, comm: startpar Not tainted 2.6.39-agathe #2
>>> [   15.829301] Call Trace:
>>> [   15.829534]  [<c103c79d>] warn_slowpath_common+0x6d/0xa0
>>> [   15.829948]  [<c13ff216>] ? dev_watchdog+0x1d6/0x1e0
>>> [   15.830183]  [<c13ff216>] ? dev_watchdog+0x1d6/0x1e0
>>> [   15.830417]  [<c103c84e>] warn_slowpath_fmt+0x2e/0x30
>>> [   15.830828]  [<c13ff216>] dev_watchdog+0x1d6/0x1e0
>>> [   15.831241]  [<c104ecc8>] ? __queue_work+0xb8/0x300
>>> [   15.831476]  [<c10048a8>] ? handle_irq+0x18/0x90
>>> [   15.831889]  [<c1041bc7>] ? irq_exit+0x37/0x80
>>> [   15.832127]  [<c10044f6>] ? do_IRQ+0x46/0xb0
>>> [   15.832541]  [<c1080189>] ? rcu_start_gp+0x149/0x1d0
>>> [   15.832954]  [<c1046a24>] run_timer_softirq+0xe4/0x200
>>> [   15.833189]  [<c1041900>] ? local_bh_enable+0x80/0x80
>>> [   15.833426]  [<c151ade9>] ? common_interrupt+0x29/0x30
>>> [   15.833838]  [<c13ff040>] ? qdisc_reset+0x40/0x40
>>> [   15.834250]  [<c1041978>] __do_softirq+0x78/0x100
>>> [   15.834841]  [<c1041900>] ? local_bh_enable+0x80/0x80
>>> [   15.835097]  <IRQ>  [<c1041bfe>] ? irq_exit+0x6e/0x80
>>> [   15.835188]  [<c1019dc6>] ? smp_apic_timer_interrupt+0x56/0x90
>>> [   15.835247]  [<c151a46a>] ? apic_timer_interrupt+0x2a/0x30
>>> [   15.835305]  [<c151a168>] ? resume_userspace+0x14/0x14
>>> [   15.835360] ---[ end trace 519c5412e162986a ]---
>>>
>>>
>>> The level of pain is very low, because the system is still running very
>>> well.
>>>
>>> If somebody needs some more information, please let me know.
>>>
>>
>> Which net device driver is being used?
> 
> Seems to be sis900
> 
> Maybe its TX_TIMEOUT is too low.
> 
> Robert, is your NIC in full or half duplex mode ?
> 
> 
> 

Hello Eric,

the device runs in full duplex mode (as far as I see)

root@agathe:~# ethtool eth0
Settings for eth0:
        Supported ports: [ TP MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Link partner advertised link modes:10baseT/Half 10baseT/Full
                                           100baseT/Half 100baseT/Full
        Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: Yes
        Speed: 100Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 1
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: pg
        Wake-on: g
        Current message level: 0x000000c5 (197)
        Link detected: yes


Yes, it's an sis900, lspci:

00:00.0 Host bridge: Silicon Integrated Systems [SiS] 662 Host (rev 01)
00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SiS AGP Port
(virtual PCI-to-PCI bridge)
00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL
Media IO] (rev 36)
00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev 01)
00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS]
AC'97 Sound Controller (rev a0)
00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f)
00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f)
00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f)
00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller
00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI
Fast Ethernet (rev 91)
00:05.0 IDE interface: Silicon Integrated Systems [SiS] SATA (rev 01)
00:1f.0 PCI bridge: Silicon Integrated Systems [SiS] PCI-to-PCI bridge
01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
661/741/760 PCI/AGP or 662/761Gx PCIE VGA Display Adapter (rev 04)
