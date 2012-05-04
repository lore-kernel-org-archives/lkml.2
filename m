Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2EDTip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:38:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab2EDTio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com>
References: <20120419163800.GB13977@schottelius.org>
	<CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
	<20120502163629.GE928@schottelius.org>
	<20120502202509.GA26798@kroah.com>
	<20120503065003.GB13386@schottelius.org>
	<CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com>
	<20120503153547.GD20334@kroah.com>
	<CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com>
	<20120503233858.GA13453@kroah.com>
	<4FA358ED.1080705@gmail.com>
	<20120504184851.GB11223@kroah.com>
	<CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com>
Date: Fri, 4 May 2012 12:38:43 -0700
X-Google-Sender-Auth: 1eKLLonYHH1iul9XaocfztUq_B8
Message-ID: <CAE9FiQWcyRfLKB+YivOfa-GydbhoaMx06n6a4VMDWoTOMkj7ig@mail.gmail.com>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
From: Yinghai Lu <yinghai@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Francois Rigaut <frigaut@gmail.com>, linux-pci@vger.kernel.org,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 12:37 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, May 4, 2012 at 11:48 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> Ok, it looks like these are the devices that we are missing while
>> "hotplugging":
>> 37:00.0 PCI bridge: Intel Corporation Device 1513
>> 38:00.0 PCI bridge: Intel Corporation Device 1513
>> 38:01.0 PCI bridge: Intel Corporation Device 1513
>> 38:02.0 PCI bridge: Intel Corporation Device 1513
>> 38:03.0 PCI bridge: Intel Corporation Device 1513
>> 38:04.0 PCI bridge: Intel Corporation Device 1513
>> 38:05.0 PCI bridge: Intel Corporation Device 1513
>> 39:00.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
>> 3a:03.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
>> 3b:00.0 USB controller: Pericom Semiconductor Device 400e (rev 01)
>> 3b:00.1 USB controller: Pericom Semiconductor Device 400e (rev 01)
>> 3b:00.2 USB controller: Pericom Semiconductor Device 400f (rev 01)
>> 3c:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57761 Gigabit Ethernet PCIe (rev 10)
>> 3d:00.0 FireWire (IEEE 1394): nee Agere Systems nee Lucent
>> Microelectronics FW643 PCI Express 1394b Controller (PHY/Link) (rev 08)
>>
>> Which is good, I was worried that there was a video controller out there
>> on the end of the thunderbolt link.
>>
>> So, the problem really is two here:
>>  - your video card doesn't detect the new display
>>  - your pci devices do not show up
>>
>> The first one probably needs to be reported to the Intel video driver
>> people, they can help you out the best.
>>
>> The second one means that something is up with the pci hotplug
>> controller.  I've cced the linux-pci list, the people there should be
>> able to help out better than I, as I no longer have any PCI hotplug
>> hardware to work with anymore.
>>
>
> those devices are under 04:04.0, but that does not have slot cap
> enabled by BIOS. So pciehp is going to to help.

should be: pciehp is not going to help.

so acpiphp are involved?

Yinghai
