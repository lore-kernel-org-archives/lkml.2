Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0DNMHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:07:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34637 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755031Ab0DNMHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:07:19 -0400
Date: Wed, 14 Apr 2010 13:11:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joseph Krahn <joseph.krahn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trying to fix ITE-887x parallel/serial driver bugs (including 
 unhandled IRQs)
Message-ID: <20100414131140.5c6187ab@lxorguk.ukuu.org.uk>
In-Reply-To: <n2wff6de6f21004121405xd33676f8s81c12e23747b88b0@mail.gmail.com>
References: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
	<20100412174352.4e13113f@lxorguk.ukuu.org.uk>
	<n2wff6de6f21004121405xd33676f8s81c12e23747b88b0@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > for free address ranges. It's hardly 'random probing' and it isn't a
> > normal BAR or guaranteed to have been configured by anything beforehand.

> Yes, but the drivers don't use INTCBAR. They scan through a herd-coded
> list of possible port ranges:

They can't just use INTCBAR as it may not have been configured by anything
before the device is probed. We do need to find and assign suitable ports
although this should probably be done via the PCI quirks on PCI setup.

> The interrupt controller (INTC) provides IRQ status bits in a single
> I/O port byte. I only have the datasheet for IT8875F, which is 1
> parallel and no serial ports, so my understanding of UART IRQs is sort
> of reverse engineering. Polling the UART IIR register shows that it
> acts like a normal 16550 UART when set to SERIRQ mode, but I get no
> IRQs generated. Setting to standard PCI INTA interrupts, the IRQs are
> generated, but the UART IIR registers do not set the IRQ bits.

Weird design.

http://kr.ic-on-line.cn/IOL/viewpdf/IT8871F_200216.htm

provides a tiny bit of info on the uart side but I've not found any
complete documentation.

> One possibility is to install custom io_serial_in/out functions. When
> the value of IIR is requested, the INTC can be checked, and modify the
> result to what it should be for a normal UART. That is a bit of a
> hack, but makes it much easier to fit into the existing code.

Seems a good starting point. The serial side code is robust for shared
IRQs.

Alan
