Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1CJWuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:50:15 -0500
Received: from www.tglx.de ([62.245.132.106]:38555 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1CJWuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:50:14 -0500
Date: Thu, 10 Mar 2011 23:49:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 13/21] [PATCH 13/21] Staging: hv: Rename vmbus_driver_context
 structure
In-Reply-To: <1299795131-1335-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LFD.2.00.1103102347450.2787@localhost6.localdomain6>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver> <1299795131-1335-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, K. Y. Srinivasan wrote:
> Now that struct vmbus_driver_context is properly
> cleaned up, rename this structure appropriately and
> cleanup the code.

> @@ -877,10 +873,10 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
>  	/* Schedules a dpc if necessary */
>  	if (ret > 0) {
>  		if (test_bit(0, (unsigned long *)&ret))
> -			tasklet_schedule(&vmbus_drv.msg_dpc);
> +			tasklet_schedule(&hv_bus.msg_dpc);
>  
>  		if (test_bit(1, (unsigned long *)&ret))
> -			tasklet_schedule(&vmbus_drv.event_dpc);
> +			tasklet_schedule(&hv_bus.event_dpc);

What's the plan to convert that tasklet/work stuff to threaded irqs ?

Thanks,

	tglx
