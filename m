Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2DYQ2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:28:22 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61037 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2DYQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <CADLM8XPryGVVWVruB=sZ9zxPp-nEhz8xKeMhY3u8KBShk2suBQ@mail.gmail.com>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
	<CADLM8XPryGVVWVruB=sZ9zxPp-nEhz8xKeMhY3u8KBShk2suBQ@mail.gmail.com>
Date: Wed, 25 Apr 2012 09:28:19 -0700
X-Google-Sender-Auth: U_KylyBIAqUEU3Q11riCAeORNWc
Message-ID: <CAE9FiQXLxEEu68tJvph3LB53nqycK+YctwDKMEF824koXVM5AA@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Wei Yang <weiyang.kernel@gmail.com>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 2:47 AM, Wei Yang <weiyang.kernel@gmail.com> wrote:
>> busn_alloc patchset should address your concern.
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> for-pci-busn-alloc
>>
> Yinghai
>
> You mean this patch 44b2347b fix the problem?
>
> In the comment, "do pass0 for all good bridge".
> Then there are totally two pass for a whole pci domain?

also other commits about strict checking to see if it is good.

>
> I tried "git grep busn_alloc", but not find anything.

the commit in the patchset.

  PCI: Add busn_res into struct pci_bus.
  PCI: Add busn_res operation functions
  PCI: Release busn_res when removing bus
  PCI: Insert busn_res in pci_create_root_bus()
  PCI: Checking busn_res in pci_scan_root_bus()
  PCI: Add default busn_resource
  PCI: Add default busn_res for pci_scan_bus()
  x86, PCI: Add busn_res into resources list for acpi path
  x86, PCI: Put busn resource in pci_root_info for not using _CRS path
  PCI, ia64: Register busn_res for root buses
  PCI, sparc: Register busn_res for root buses
  PCI, powerpc: Register busn_res for root buses
  PCI, parisc: Register busn_res for root buses
  resources: Add probe_resource()
  resources: Replace registered resource in tree.
  PCI: Add pci_bus_extend/shrink_top()
  PCI: Probe safe range that we can use for unassigned bridge.
  PCI: Add pci_bus_replace_busn_res()
  PCI: Allocate bus range instead of use max blindly
  PCI: Strict checking of valid range for bridge
  PCI: Kill pci_fixup_parent_subordinate_busnr()
  PCI: Seperate child bus scanning to two passes overall
  pcmcia: Remove workaround for fixing pci parent bus subordinate
  PCI: Double checking setting for bus register and bus struct.
  PCI, pciehp: Remove not needed bus number range checking
  PCI: More strict checking of valid range for bridge
  PCI: Don't shrink too much for hotplug bridge
