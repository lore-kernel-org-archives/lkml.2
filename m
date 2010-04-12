Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0DLQjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:39:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57122 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752469Ab0DLQjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:39:35 -0400
Date: Mon, 12 Apr 2010 17:43:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joseph Krahn <joseph.krahn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trying to fix ITE-887x parallel/serial driver bugs (including 
 unhandled IRQs)
Message-ID: <20100412174352.4e13113f@lxorguk.ukuu.org.uk>
In-Reply-To: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
References: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Both drivers (8250_pci.c and parport_pc.c) probe randomly for the
> chips control I/O port, instead of using the standard PNP-configured
> BAR, and they do so independently, stepping on the previous drivers
> configuration attempt. I think the two drivers should be merged into
> parport_serial.c because this is a combo chip. However, different

That seems reasonable.

I don't think your description is accurate entirely. The device is picked
up by PCi scans and the INTCBAR is then set up by Linux having checked
for free address ranges. It's hardly 'random probing' and it isn't a
normal BAR or guaranteed to have been configured by anything beforehand.

> The IT887x chips include an interrupt controller that maps external
> IRQ inputs to serialized IRQs. Apparently, the I/O ports only present
> a standard interrupt interface when wired for serialized IRQs. For
> normal PCI interrupts, it needs a custom interrupt handler to
> communicate directly with the interrupt-controller port. The current

I guess the obvious thing to do would be to provide one. The serial code
already supports several such things. What is actually needed or is the
'special' handler simply shared IRQ support in which case it ought t just
work.

> serial driver attempts to disable IRQs, and let the core driver revert
> to polling. However, it does this incorrectly, and can produce
> unhandled IRQs. (Maybe it was tested on a system with Ser. IRQ?) To
> avoid extra interrupt-handler code, especially for a less common chip,
> is it OK to intentionally provide polling-only support?

I'd strongly prefer it worked as well as possible if the the
documentation to fix it exists. What is involved ?

Alan
