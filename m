Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab2AKPyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:54:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51509 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2AKPyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:54:10 -0500
MIME-Version: 1.0
In-Reply-To: <CABexPfGv=vkj5pq135+Jdy-E6fhppQK8Cq7FvuZV=tn8bA=SHw@mail.gmail.com>
References: <CABexPfGv=vkj5pq135+Jdy-E6fhppQK8Cq7FvuZV=tn8bA=SHw@mail.gmail.com>
Date: Wed, 11 Jan 2012 23:54:09 +0800
Message-ID: <CABexPfE0SX34uTMKn6kPhKdt8bDgDYjrK6caAOf=eEvCLTNFyA@mail.gmail.com>
Subject: Re: [8259A] Why the irq_desc->handle_irq are set as
 handle_level_irq() while the ICW1 is set 0x11, which indicates edge mode?
From: Zhihua Che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/10 Zhihua Che <zhihua.che@gmail.com>:
> hi, everyone
>
>      I'm reading kernel codes of version 3.1x and now focusing on
> interrupt subsystem. I find an interesting thing.
>      In x86 architecture, init_8259A() is invoked by init_ISA_irqs()
> to initialize the chip and precisely, the ICW1 of both master and
> slave 8259A chip are set as 0x11 which indicates that the both chip
> are enabled with edge trigger mode. However, I'm wondering why the
> irq_desc->handle_irq fields of the total 16 IRQ descriptor are set as
> handle_level_irq() in init_ISA_irqs(). As far as I know, the
> handle_level_irq() is designed to handle level-mode interrupts.
>      Please Let me know if I miss anything.
>
> Harvey

Precisely,

init_8259A()(int auto_eoi)
{
        *
        *
        *
        outb_pic(0x11, PIC_MASTER_CMD); /* bit3 of ICW1 indicates
trigger mode, here enable edge mode */
        *
        *
}

void init_ISA_irqs(void)
{
        *
        *
        *
        for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
                 irq_set_chip_and_handler_name(i, chip,
handle_level_irq, name); /* here, handle_level_irq() is intended to
handle edge trigger interrupts */
}

Is this ok?
