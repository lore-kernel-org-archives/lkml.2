Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab2EFDWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 23:22:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47999 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2EFDWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 23:22:23 -0400
Message-ID: <4FA5EE63.1050208@gmail.com>
Date: Sun, 06 May 2012 11:22:11 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        Francois Rigaut <frigaut@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
References: <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com> <20120503153547.GD20334@kroah.com> <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com> <20120503233858.GA13453@kroah.com> <4FA358ED.1080705@gmail.com> <20120504184851.GB11223@kroah.com> <CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com> <CAE9FiQWcyRfLKB+YivOfa-GydbhoaMx06n6a4VMDWoTOMkj7ig@mail.gmail.com> <4FA4AA3E.1070903@gmail.com> <4FA544B1.3070705@gmail.com> <20120505164819.GA21599@schottelius.org>
In-Reply-To: <20120505164819.GA21599@schottelius.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid it won't work by just changing the OSDW() return value.
After analysis the ACPI table, I guess the BIOS ACPI implementation doesn't
confirm to the ACPI specification for hotplug, it needs special support in
OS to enable Thunderbolt cable hotplug on that system. Maybe that's the
reason why it's only enabled on Apple's OSes, not sure it's due to technical
or business considerations.

This PCIe device "05:00.0 System peripheral: Intel Corporation Device 151a
(rev 01)" may play a role in the Thunderbolt cable hotplug operations, but
haven't figured it out yet.

On 05/06/2012 12:48 AM, Nico Schottelius wrote:
> Hey Jiang,
> 
> Jiang Liu [Sat, May 05, 2012 at 11:18:09PM +0800]:
>> 	It seems that the PCI topology related to the Thunderbird is:
> 
> Thanks for digging into this, I've the feeling we could somehow get
> this running in the end...
> 
>> [...] 
>> According to the acpidump sent out by you, I guess the relationship among PCIe and ACPI is as below:
>>         Device (PCI0)	// PCIe host bridge
>>         {
>>             Name (_HID, EisaId ("PNP0A08"))
>>             Device (P0P2)	//00:01.0
>>             {
>>                 Name (_ADR, 0x00010000)
>>                 Device (UPSB)	//03:00.0
>>                 {
>>                     Name (_ADR, 0x00)
>>                     Device (DSB2)	//04:04.0
>>                     {
>>                         Name (_ADR, 0x00040000)
>>                         Method (_RMV, 0, NotSerialized)
>>                         {
>>                             Return (OSDW ()) // OSDW-> OS is Darwin
>>                         }
>>                         Device (UPS2)	//37:00.0
>>                         {
>>                             Name (_ADR, 0x00)
>> 			}
>> 		    }
>> 		}
>> 	    }
>> 	}
>>
>> But _RMV method only returns 1 on iOS or Max OS X. That means ACPI based hotplug is disabled
>> on Linux for your system. And as Yinghai has pointed out, all the PCIe downstream ports on 
>> the system don't support PCIe hotplug. So need BIOS or hardware changes to support Thunderbolt
>> cable hotplug on your system.
> 
> I'm not deep into how acpi works, but wondering: Can't we replace that part,
> change the tree or emulate a different OSDW() method similar to LD_PRELOAD?
> 
> Cheers,
> 
> Nico
> 

