Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2EEQsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 12:48:47 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:36337 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2EEQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 12:48:46 -0400
Date: Sat, 5 May 2012 18:48:19 +0200
From: Nico Schottelius <nico-linux-20120419@schottelius.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Francois Rigaut <frigaut@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120505164819.GA21599@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
	Jiang Liu <liuj97@gmail.com>, Francois Rigaut <frigaut@gmail.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com>
 <20120503153547.GD20334@kroah.com>
 <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com>
 <20120503233858.GA13453@kroah.com>
 <4FA358ED.1080705@gmail.com>
 <20120504184851.GB11223@kroah.com>
 <CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com>
 <CAE9FiQWcyRfLKB+YivOfa-GydbhoaMx06n6a4VMDWoTOMkj7ig@mail.gmail.com>
 <4FA4AA3E.1070903@gmail.com>
 <4FA544B1.3070705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA544B1.3070705@gmail.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.3.4-2-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiang,

Jiang Liu [Sat, May 05, 2012 at 11:18:09PM +0800]:
> 	It seems that the PCI topology related to the Thunderbird is:

Thanks for digging into this, I've the feeling we could somehow get
this running in the end...

> [...] 
> According to the acpidump sent out by you, I guess the relationship among PCIe and ACPI is as below:
>         Device (PCI0)	// PCIe host bridge
>         {
>             Name (_HID, EisaId ("PNP0A08"))
>             Device (P0P2)	//00:01.0
>             {
>                 Name (_ADR, 0x00010000)
>                 Device (UPSB)	//03:00.0
>                 {
>                     Name (_ADR, 0x00)
>                     Device (DSB2)	//04:04.0
>                     {
>                         Name (_ADR, 0x00040000)
>                         Method (_RMV, 0, NotSerialized)
>                         {
>                             Return (OSDW ()) // OSDW-> OS is Darwin
>                         }
>                         Device (UPS2)	//37:00.0
>                         {
>                             Name (_ADR, 0x00)
> 			}
> 		    }
> 		}
> 	    }
> 	}
> 
> But _RMV method only returns 1 on iOS or Max OS X. That means ACPI based hotplug is disabled
> on Linux for your system. And as Yinghai has pointed out, all the PCIe downstream ports on 
> the system don't support PCIe hotplug. So need BIOS or hardware changes to support Thunderbolt
> cable hotplug on your system.

I'm not deep into how acpi works, but wondering: Can't we replace that part,
change the tree or emulate a different OSDW() method similar to LD_PRELOAD?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
