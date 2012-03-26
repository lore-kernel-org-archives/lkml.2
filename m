Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2CZO2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:28:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56773 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2CZO21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:28:27 -0400
MIME-Version: 1.0
In-Reply-To: <4F7031A4.70601@mellanox.co.il>
References: <4F7031A4.70601@mellanox.co.il>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 26 Mar 2012 08:28:05 -0600
Message-ID: <CAErSpo7ciBYG1-jCL3F6bFcktmJj4H-SXn_1NcRnhc-gPDsHUw@mail.gmail.com>
Subject: Re: IRQ affinity enforced only after first interrupt.
To: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is not really a PCI question, so +cc Thomas, LKML.]

On Mon, Mar 26, 2012 at 3:06 AM, Yevgeny Petrilin
<yevgenyp@mellanox.co.il> wrote:
> Hello,
>
> I'm working on an issue where affinity changes to IRQ only have effect after the first interrupt which still happens on the original core.
> I understand that the decision regarding it takes place in this code:
>
>        if (irq_can_move_pcntxt(data)) {
>                ret = chip->irq_set_affinity(data, mask, false);
>                switch (ret) {
>                case IRQ_SET_MASK_OK:
>                        cpumask_copy(data->affinity, mask);
>                case IRQ_SET_MASK_OK_NOCOPY:
>                        irq_set_thread_affinity(desc);
>                        ret = 0;
>                }
>        } else {
>                irqd_set_move_pending(data);
>                irq_copy_pending(desc, mask);
>        }
>
> Which means that the "IRQD_MOVE_PCNTXT" flag is not set in irq_data->state_use_accessors.
> I was able to add this flag using irq_modify_status(), which is probably not the way to go.
> This option also doesn't exist in older kernels (2.6.32)
>
> So the question is, when irq_desc is created, how is it determined that "IRQD_MOVE_PCNTXT" flag is set?
>
> Thanks,
> Yevgeny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
