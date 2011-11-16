Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1KPHEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:04:41 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45568 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1KPHEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:04:40 -0500
MIME-Version: 1.0
In-Reply-To: <1321410200.19828.4.camel@rui>
References: <1321410200.19828.4.camel@rui>
Date: Tue, 15 Nov 2011 23:04:39 -0800
X-Google-Sender-Auth: yTZBuAk952XDfObw8mvQsUJXs54
Message-ID: <CAE9FiQURKqgDawReoUaOw4vgSxT_01D1wThTP+xRhz1VesyDiw@mail.gmail.com>
Subject: Re: [PATCH] x86: fix an erroneous debug message
From: Yinghai Lu <yinghai@kernel.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 6:23 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> Fix an erroneous debug message.
>
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 3c31fa9..1a691f5 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3641,8 +3641,8 @@ int io_apic_set_pci_routing(struct device *dev, int irq,
>        int node;
>
>        if (!IO_APIC_IRQ(irq)) {
> -               apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
> -                           irq_attr->ioapic);
> +               apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ %d\n",
> +                           irq_attr->ioapic, irq);
>                return -EINVAL;
>        }


Acked-by: Yinghai Lu <yinghai@kernel.org>
