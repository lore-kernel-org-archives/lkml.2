Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0LPNNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:13:33 -0500
Received: from www.tglx.de ([62.245.132.106]:44629 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab0LPNNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:13:32 -0500
Date: Thu, 16 Dec 2010 14:13:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Jan Kiszka wrote:
> +	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
> +	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
> +		/*
> +		 * Signal the old handler that is has to switch to shareable
> +		 * handling mode. Disable the line to avoid any conflict with
> +		 * a real IRQ.
> +		 */
> +		disable_irq(irq);

This is weird, really. I thought you wanted to avoid waiting for the
threaded handler to finish if it's on the fly. So this should be
disable_irq_nosync() or did you change your mind ?

Thanks,

	tglx
