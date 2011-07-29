Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1G2GfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:35:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52879 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1G2GfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5hZGAzc17GApEfuzduvzh6haVLBKRvizcRxGLnh8ebuA@mail.gmail.com>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
	<1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
	<CAErSpo5hZGAzc17GApEfuzduvzh6haVLBKRvizcRxGLnh8ebuA@mail.gmail.com>
Date: Fri, 29 Jul 2011 14:35:12 +0800
Message-ID: <CAOfQC9-0d+W0GyLAtEMEFFAzPpsZxpzZ0UPAqLo2AokF3zdfAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: make pci_claim_resource() work with conflict
 resources as appropriate
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, here are dmesg and /proc/ioports *BEFORE* applying the patch:

...
...
pci 0000:00:0a.0: [8086:7110] type 0 class 0x000601
pci 0000:00:0a.1: [8086:7111] type 0 class 0x000101
pci 0000:00:0a.1: reg 20: [io  0x1240-0x124f]
pci 0000:00:0a.2: [8086:7112] type 0 class 0x000c03
pci 0000:00:0a.2: reg 20: [io  0x1220-0x123f]
pci 0000:00:0a.3: [8086:7113] type 0 class 0x000680
pci 0000:00:0a.3: address space collision: [io  0x1000-0x103f]
conflicts with MSC PCI I/O [io  0x1000-0xffffff]
pci 0000:00:0a.3: address space collision: [io  0x1100-0x110f]
conflicts with MSC PCI I/O [io  0x1000-0xffffff]
pci 0000:00:0b.0: [1022:2000] type 0 class 0x000200
pci 0000:00:0b.0: reg 10: [io  0x1200-0x121f]
pci 0000:00:0b.0: reg 14: [mem 0x10000000-0x1000001f]
pci 0000:00:0b.0: reg 30: [mem 0x00000000-0x000fffff pref]
pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:11.0: [153f:0001] type 0 class 0x000600
pci 0000:00:11.0: reg 10: [mem 0x00000000-0x0fffffff]
pci 0000:00:0a.3: BAR 13: [io  0x1000-0x103f] has bogus alignment
pci 0000:00:0a.3: BAR 14: [io  0x1100-0x110f] has bogus alignment
pci 0000:00:0b.0: BAR 6: assigned [mem 0x10000000-0x100fffff pref]
pci 0000:00:0a.2: BAR 4: assigned [io  0x1000-0x101f]
pci 0000:00:0a.2: BAR 4: set to [io  0x1000-0x101f] (PCI address
[0x1000-0x101f])
pci 0000:00:0b.0: BAR 0: assigned [io  0x1020-0x103f]
pci 0000:00:0b.0: BAR 0: set to [io  0x1020-0x103f] (PCI address
[0x1020-0x103f])
pci 0000:00:0b.0: BAR 1: assigned [mem 0x10100000-0x1010001f]
pci 0000:00:0b.0: BAR 1: set to [mem 0x10100000-0x1010001f] (PCI
address [0x10100000-0x1010001f])
pci 0000:00:0a.1: BAR 4: assigned [io  0x1040-0x104f]
pci 0000:00:0a.1: BAR 4: set to [io  0x1040-0x104f] (PCI address
[0x1040-0x104f])
...
...
pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
pcnet32: No access methods
...
...

-sh-4.0# cat /proc/ioports
00000000-0000001f : dma1
00000020-00000021 : pic1
00000040-0000005f : timer
00000060-0000006f : keyboard
00000070-00000077 : rtc_cmos
00000080-0000008f : dma page reg
000000a0-000000a1 : pic2
000000c0-000000df : dma2
00000170-00000177 : piix
000001f0-000001f7 : piix
000002f8-000002ff : serial
00000376-00000376 : piix
000003f6-000003f6 : piix
000003f8-000003ff : serial
00001000-00ffffff : MSC PCI I/O
  00001000-0000101f : 0000:00:0a.2
  00001020-0000103f : 0000:00:0b.0
  00001040-0000104f : 0000:00:0a.1
    00001040-0000104f : piix

And *AFTER* applying the patch:

...
...
pci 0000:00:0a.0: [8086:7110] type 0 class 0x000601
pci 0000:00:0a.1: [8086:7111] type 0 class 0x000101
pci 0000:00:0a.1: reg 20: [io  0x1240-0x124f]
pci 0000:00:0a.2: [8086:7112] type 0 class 0x000c03
pci 0000:00:0a.2: reg 20: [io  0x1220-0x123f]
pci 0000:00:0a.3: [8086:7113] type 0 class 0x000680
pci 0000:00:0a.3: quirk: [io  0x1000-0x103f] claimed by PIIX4 ACPI
pci 0000:00:0a.3: quirk: [io  0x1100-0x110f] claimed by PIIX4 SMB
pci 0000:00:0b.0: [1022:2000] type 0 class 0x000200
pci 0000:00:0b.0: reg 10: [io  0x1200-0x121f]
pci 0000:00:0b.0: reg 14: [mem 0x10000000-0x1000001f]
pci 0000:00:0b.0: reg 30: [mem 0x00000000-0x000fffff pref]
pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:11.0: [153f:0001] type 0 class 0x000600
pci 0000:00:11.0: reg 10: [mem 0x00000000-0x0fffffff]
pci 0000:00:0b.0: BAR 6: assigned [mem 0x10000000-0x100fffff pref]
pci 0000:00:0a.2: BAR 4: assigned [io  0x1040-0x105f]
pci 0000:00:0a.2: BAR 4: set to [io  0x1040-0x105f] (PCI address
[0x1040-0x105f])
pci 0000:00:0b.0: BAR 0: assigned [io  0x1060-0x107f]
pci 0000:00:0b.0: BAR 0: set to [io  0x1060-0x107f] (PCI address
[0x1060-0x107f])
pci 0000:00:0b.0: BAR 1: assigned [mem 0x10100000-0x1010001f]
pci 0000:00:0b.0: BAR 1: set to [mem 0x10100000-0x1010001f] (PCI
address [0x10100000-0x1010001f])
pci 0000:00:0a.1: BAR 4: assigned [io  0x1080-0x108f]
pci 0000:00:0a.1: BAR 4: set to [io  0x1080-0x108f] (PCI address
[0x1080-0x108f])
...
...
pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
pcnet32: PCnet/FAST III 79C973 at 0x1060, 00:d0:a0:00:06:72 assigned IRQ 10
pcnet32: Found PHY 0000:6b60 at address 30
pcnet32: eth0: registered as PCnet/FAST III 79C973
pcnet32: 1 cards_found
...
...

-sh-4.0# cat /proc/ioports
00000000-0000001f : dma1
00000020-00000021 : pic1
00000040-0000005f : timer
00000060-0000006f : keyboard
00000070-00000077 : rtc_cmos
00000080-0000008f : dma page reg
000000a0-000000a1 : pic2
000000c0-000000df : dma2
00000170-00000177 : piix
000001f0-000001f7 : piix
000002f8-000002ff : serial
00000376-00000376 : piix
000003f6-000003f6 : piix
000003f8-000003ff : serial
00001000-00ffffff : MSC PCI I/O
  00001000-0000103f : 0000:00:0a.3
  00001040-0000105f : 0000:00:0a.2
  00001060-0000107f : 0000:00:0b.0
    00001060-0000107f : pcnet32_probe_pci
  00001080-0000108f : 0000:00:0a.1
    00001080-0000108f : piix
  00001100-0000110f : 0000:00:0a.3

> Did something change the order in which we claim resources, so things that
> used to work now cause conflicts?

It used to work (as I see on 2.6.29) because the function insert_resource() was
used. The /proc/ioports of 2.6.29 has exactly the same contents as that of the
patched kernel.

> I think insert_resource() (where the newly-inserted resource can become the
> parent of something that was previously inserted) is sort of a hack...

Yes, agree, though in this case the newly-inserted resource actually becomes the
child of a previously inserted one, the MIPS System Controller's PCI I/O. So,
talking about sticking to using request_resource_conflict() as apposed to
insert_resource_conflict(), the problem is, like what I mentioned in my reply to
Ralf, why pci_find_parent_resource() does not return MSC PCI I/O but return the
root. If MSC PCI I/O is supposed to be the parent of PCI quirks, then something
is wrong somewhere else. Or else, the start point of MSC PCI I/O might be
raised to avoid the collisions.


Deng-Cheng

2011/7/28 Bjorn Helgaas <bhelgaas@google.com>:
> On Thu, Jul 28, 2011 at 5:28 AM, Deng-Cheng Zhu <dengcheng.zhu@gmail.com> wrote:
>> In resolving a network driver issue with the MIPS Malta platform, the root
>> cause was traced into pci_claim_resource():
>>
>> MIPS System Controller's PCI I/O resources stay in 0x1000-0xffffff. When
>> PCI quirks start claiming resources using request_resource_conflict(),
>> collisions happen and -EBUSY is returned, thereby rendering the onboard AMD
>> PCnet32 NIC unaware of quirks' region and preventing the NIC from functioning.
>> For PCI quirks, PIIX4 ACPI is expected to claim 0x1000-0x103f, and PIIX4 SMB to
>> claim 0x1100-0x110f, both of which fall into the MSC I/O range. Certainly, we
>> can increase the start point of this range in arch/mips/mti-malta/malta-pci.c to
>> avoid the collisions. But a fix in here looks more justified, though it seems to
>> have a wider impact. Using insert_xxx as opposed to request_xxx will register
>> PCI quirks' resources as children of MSC I/O and return OK, instead of seeing
>> collisions which are actually resolvable.
>
> What's the collision?  Can we see the dmesg log (which should have
> that information) and maybe the /proc/ioports contents?  Did something
> change the order in which we claim resources, so things that used to
> work now cause conflicts?
>
> I think insert_resource() (where the newly-inserted resource can
> become the parent of something that was previously inserted) is sort
> of a hack, and the fact that we need it is telling us that we're doing
> things in the wrong order.  It's nicer when we can discover and claim
> resources in a top-down hierarchical way.  But I recognize that may
> not always be possible, or at least not convenient.
>
> Bjorn
>
