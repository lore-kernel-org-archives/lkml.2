Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2C0JjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:39:18 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:55709 "HELO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756166Ab2C0JjP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:39:15 -0400
From: Yevgeny Petrilin <yevgenyp@mellanox.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yael Shenhav <yaeli@mellanox.com>
Subject: RE: IRQ affinity enforced only after first interrupt.
Thread-Topic: IRQ affinity enforced only after first interrupt.
Thread-Index: AQHNC1y2rxLl684DNUalJftF5VRURpZ8gpKAgAAuH0CAAB2NAIABEm+A
Date: Tue, 27 Mar 2012 09:39:08 +0000
Message-ID: <953B660C027164448AE903364AC447D2618E24BF@MTLDAG02.mtl.com>
References: <4F7031A4.70601@mellanox.co.il>
 <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com>
 <4F707E39.50502@gmail.com>
 <953B660C027164448AE903364AC447D2618E1A8B@MTLDAG02.mtl.com>
 <alpine.LFD.2.02.1203262059070.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1203262059070.2542@ionos>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.13.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >
> > > The architecture specific code will determine whether the IRQ could be migrated
> > > in process context. For example, the IRQ_MOVE_PCNTXT flag will be set on x86
> > > systems if interrupt remapping is enabled.
> >
> > Actually I am encountering this issue with x86, and see different
> > behavior with different HW devices (NICs). On same machine I have
> > one device that responds immediately to affinity changes while the
> > other one changes the affinity only after first interrupt.
> 
> That simply depends on the underlying hardware. On certain hardware we
> can change the affinity only in hard interrupt context, that means
> right when a interrupt of that device is delivered.
> 
> On the other devices we can change it right away and the corresponding
> interrupt chips set IRQ_MOVE_PCNTXT to indicate that.
> 
> There is nothing we can do about this. It's dictated by hardware.
> 

Thanks for the explanation,
Which capabilities of the HW show whether IRQ_MOVE_PCNTXT can be set or not?
Is it done by reading configuration from PCI?

Thanks,
Yevgeny
