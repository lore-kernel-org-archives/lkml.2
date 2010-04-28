Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0D1TX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:23:27 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:21630 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab0D1TXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:23:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below    BIOS_END
Date: Wed, 28 Apr 2010 13:23:21 -0600
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com> <201004281306.05648.bjorn.helgaas@hp.com> <4BD8882A.6050307@oracle.com>
In-Reply-To: <4BD8882A.6050307@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004281323.22167.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010 01:10:34 pm Yinghai wrote:
> On 04/28/2010 12:06 PM, Bjorn Helgaas wrote:
> > On Wednesday 28 April 2010 11:14:45 am Yinghai Lu wrote:
> >> Never mind, for 2.6.34 your patch should be good enough.
> > 
> > Uh, OK.
> > 
> > I'm not trying to be a nuisance, but if there's a machine where
> > we think there's a bridge window like [mem 0xfed20000-0xffffffff],
> > I want to fix it, even if you think it's "good enough for 2.6.34."
> > 
> > I was hoping you could specifically confirm that "yes, that AMD
> > machine was fixed by d558b483d5a," or else give me some more
> > information that would help me figure out what's going on.

I can see this is going nowhere.  The information below is essentially
just what you already posted, and I'm sorry, but it's not enough for
me to fix anything.  Can you tell me the model and BIOS version?  Maybe
I can find another one somewhere and do my own poking around.

What I'd like to know is (a) what Windows reports as PCI bus resources,
and (b) what the Linux dmesg looks like with the patch here:
    https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
CONFIG_ACPI_DEBUG=y and the arguments "acpi.debug_level=0x00010000
acpi.debug_layer=0x00000100".

Bjorn

> [    0.000000]  BIOS-e820: 0000000000000100 - 0000000000098c00 (usable)
> [    0.000000]  BIOS-e820: 0000000000098c00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000d7fa0000 (usable)
> [    0.000000]  BIOS-e820: 00000000d7fae000 - 00000000d7fb0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000d7ff0000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000008028000000 (usable)
> 
> [    6.960006] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    6.984225] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-06])
> [    7.023528] pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af]
> [    7.024014] pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
> [    7.028005] pci_root PNP0A03:00: host bridge window [io  0x03bc-0x03bf]
> [    7.032005] pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
> [    7.036005] pci_root PNP0A03:00: host bridge window [io  0x03e0-0xefff]
> [    7.040011] pci_root PNP0A03:00: host bridge window [mem 0xd8000000-0xe7ffffff]
> [    7.044005] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfe9fffff]
> [    7.048005] pci_root PNP0A03:00: host bridge window [mem 0xfec00000-0xfed0ffff]
> [    7.052005] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    7.056011] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xffffffff]
> 
> 
> d7ff0000-efffffff : reserved
>   d8000000-e7ffffff : PCI Bus 0000:00
>     d8000000-dfffffff : GART
>   e8000000-efffffff : PCI Bus 0000:80
> fec00000-fed0ffff : PCI Bus 0000:00
>   fec00000-fec00fff : reserved
>     fec00000-fec003ff : IOAPIC 0
>   fed00000-fed003ff : HPET 0
> fed10000-fed1ffff : PCI Bus 0000:80
> fed20000-ffffffff : PCI Bus 0000:00
>   fee00000-fee00fff : Local APIC
>     fee00000-fee00fff : reserved
>   fefff000-feffffff : pnp 00:0a
>   ff700000-ffffffff : reserved
>     ffb80000-fffffffe : pnp 00:06
> 
> 


