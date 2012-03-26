Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2CZTEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:04:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:55731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2CZTEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:04:23 -0400
Date: Mon, 26 Mar 2012 21:04:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yevgeny Petrilin <yevgenyp@mellanox.com>
cc: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yael Shenhav <yaeli@mellanox.com>
Subject: RE: IRQ affinity enforced only after first interrupt.
In-Reply-To: <953B660C027164448AE903364AC447D2618E1A8B@MTLDAG02.mtl.com>
Message-ID: <alpine.LFD.2.02.1203262059070.2542@ionos>
References: <4F7031A4.70601@mellanox.co.il> <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com> <4F707E39.50502@gmail.com> <953B660C027164448AE903364AC447D2618E1A8B@MTLDAG02.mtl.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012, Yevgeny Petrilin wrote:

> > 
> > The architecture specific code will determine whether the IRQ could be migrated
> > in process context. For example, the IRQ_MOVE_PCNTXT flag will be set on x86
> > systems if interrupt remapping is enabled.
>
> Actually I am encountering this issue with x86, and see different
> behavior with different HW devices (NICs). On same machine I have
> one device that responds immediately to affinity changes while the
> other one changes the affinity only after first interrupt.

That simply depends on the underlying hardware. On certain hardware we
can change the affinity only in hard interrupt context, that means
right when a interrupt of that device is delivered.

On the other devices we can change it right away and the corresponding
interrupt chips set IRQ_MOVE_PCNTXT to indicate that.

There is nothing we can do about this. It's dictated by hardware.

Thanks,

	tglx
