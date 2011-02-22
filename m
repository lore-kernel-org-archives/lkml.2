Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1BVVD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:03:26 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51123 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1BVVDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <1298405266-1624-4-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de> <1298405266-1624-4-git-send-email-bigeasy@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 13:59:42 -0700
X-Google-Sender-Auth: PGPwHbRLl36hnpcDzu3S5DYev1o
Message-ID: <AANLkTi=t-tN9hopx6quXUWeuGcDEPBguaJfAQJ-UQArW@mail.gmail.com>
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 1:07 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> History:
> v1..v2:
> - dropped device_type except for cpu & pci. I have the compatible string
>  for pci so I can drop the device_type once it is possible
> - I lowercased all compatible types. I will need to resend some patches
>  which have upper case intel
> - The cpu had the same compatible string as the soc node. So I added to
>  the soc node -immr for internel memory mapped registers.
> - I added generic names for all parts.
> - I reworked the i2c bars matching the way you suggested. I added a
>  compatible node for the PCI device which only the PCI ids in its
>  compatible string. The bars (each represents a complete i2c
>  controller) have a "intel,ce4100-i2c-controller" compatible node. It
>  is not used by the driver.
>  The driver is probed via PCI ids (by the pci subsystem not OF) and
>  matches the bar address against the ressource in the child node. Once
>  there is a hit the node is attached.
> - The SPI driver is also probed via pci. However I also attached a
>  compatible property based on PCI ids
>
> v2..v3:
> - intel,ce4100-immr become intel,ce4100-cp. cp stands for core
>  peripherals. The Atom data sheet talks here about ACPI devices. Since
>  we don't have ACPI this does not apply here.
> - The interrupt map is gone. There are now plenty of device nodes.
> - The "unit address string" got fixed, it uses not DD,V format.
>
> v3..v4:
> - added descriptions for compatible nodes introduced here:
>  - intel,ce4100-ioapic
>  - intel,ce4100-lapic
>  - intel,ce4100-hpet
>  - intel,ce4100
>  - intel,ce4100-cp
>  - intel,ce4100-pci
> - added a description about I2C controller magic.
> - Added gpio-controller and gpio-cells property to gpio devices. Those
>  properties are not (yet) used.
>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

plus one note below...

> ---
>  .../devicetree/bindings/i2c/ce4100-i2c.txt         |   93 +++++
>  Documentation/devicetree/bindings/x86/ce4100.txt   |   38 ++
>  .../devicetree/bindings/x86/interrupt.txt          |   29 ++
>  Documentation/devicetree/bindings/x86/timer.txt    |    6 +
>  arch/x86/platform/ce4100/falconfalls.dts           |  430 ++++++++++++++++++++

Next step will be to migrate most of the static soc data out of this
file and into a .dts include file so that multiple boards can use it;
but that can be done later (it's a relatively new feature to dtc).
