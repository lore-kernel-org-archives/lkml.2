Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2C0Mwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:52:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:33459 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2C0Mwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:52:38 -0400
Date: Tue, 27 Mar 2012 14:52:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yevgeny Petrilin <yevgenyp@mellanox.com>
cc: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yael Shenhav <yaeli@mellanox.com>
Subject: RE: IRQ affinity enforced only after first interrupt.
In-Reply-To: <953B660C027164448AE903364AC447D2618E24BF@MTLDAG02.mtl.com>
Message-ID: <alpine.LFD.2.02.1203271444310.2542@ionos>
References: <4F7031A4.70601@mellanox.co.il> <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com> <4F707E39.50502@gmail.com> <953B660C027164448AE903364AC447D2618E1A8B@MTLDAG02.mtl.com> <alpine.LFD.2.02.1203262059070.2542@ionos>
 <953B660C027164448AE903364AC447D2618E24BF@MTLDAG02.mtl.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Yevgeny Petrilin wrote:

> > > >
> > > > The architecture specific code will determine whether the IRQ could be migrated
> > > > in process context. For example, the IRQ_MOVE_PCNTXT flag will be set on x86
> > > > systems if interrupt remapping is enabled.
> > >
> > > Actually I am encountering this issue with x86, and see different
> > > behavior with different HW devices (NICs). On same machine I have
> > > one device that responds immediately to affinity changes while the
> > > other one changes the affinity only after first interrupt.
> > 
> > That simply depends on the underlying hardware. On certain hardware we
> > can change the affinity only in hard interrupt context, that means
> > right when a interrupt of that device is delivered.
> > 
> > On the other devices we can change it right away and the corresponding
> > interrupt chips set IRQ_MOVE_PCNTXT to indicate that.
> > 
> > There is nothing we can do about this. It's dictated by hardware.
> > 
> 
> Thanks for the explanation,
> Which capabilities of the HW show whether IRQ_MOVE_PCNTXT can be set or not?
> Is it done by reading configuration from PCI?

It's done by reading the specs of the interrupt controllers. This is
not at PCI (device) level. It's a property of the interrupt controller
(PIC, APIC, IOAPIC) and additional features like interrupt remapping.

The device merily uses an interrupt, but it does not know at all which
underlying interrupt controller is handling it. 

The only choice a device driver has is between pin based interrupts
and Message Signaled Interrupts, when the hardware supports it. This
information is retrieved from the PCI config space.

Thanks,

	tglx
