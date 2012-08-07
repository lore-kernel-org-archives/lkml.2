Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2HGSlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:41:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16808 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab2HGSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:41:04 -0400
Date: Tue, 7 Aug 2012 14:31:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 16/23] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
Message-ID: <20120807183123.GS15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-16-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-16-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:19PM +0100, Stefano Stabellini wrote:
> Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
> default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
> irq_startup, that is responsible for calling irq_unmask at startup time.
> As a result event channels remain masked.

Acked by me.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/events.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 5ecb596..8ffb7b7 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -836,6 +836,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
>  		struct irq_info *info = info_for_irq(irq);
>  		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
>  	}
> +	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
>  
>  out:
>  	mutex_unlock(&irq_mapping_update_lock);
> -- 
> 1.7.2.5
