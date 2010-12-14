Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab0LNUrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:47:46 -0500
Received: from www.tglx.de ([62.245.132.106]:47531 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758836Ab0LNUro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:47:44 -0500
Date: Tue, 14 Dec 2010 21:47:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 1/4] genirq: Introduce driver-readable IRQ status
 word
In-Reply-To: <3575edb77b3e824f921b6fdbbe5a4fdb8a549e17.1292281184.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012142145480.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <3575edb77b3e824f921b6fdbbe5a4fdb8a549e17.1292281184.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Jan Kiszka wrote:
> +/**
> + *	get_irq_status - read interrupt line status word
> + *	@irq: Interrupt line of the status word
> + *
> + *	This returns the current content of the status word associated with
> + *	the given interrupt line. See IRQS_* flags for details.
> + */
> +unsigned long get_irq_status(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	return desc ? desc->irq_data.drv_status : 0;
> +}
> +EXPORT_SYMBOL_GPL(get_irq_status);

We should document that this is a snapshot and in no way serialized
against modifications of drv_status. I'll fix up the kernel doc.

Thanks,

	tglx
