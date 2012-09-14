Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2INOCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:02:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36747 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2INOCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:02:19 -0400
Message-ID: <505338E6.4050504@arm.com>
Date: Fri, 14 Sep 2012 15:02:14 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>, "tim@xen.org" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 16/24] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-16-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1347621207-11294-16-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 14 Sep 2012 14:02:14.0797 (UTC) FILETIME=[8B3B53D0:01CD9281]
X-MC-Unique: 112091415021705701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/12 12:13, Stefano Stabellini wrote:
> Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
> default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
> irq_startup, that is responsible for calling irq_unmask at startup time.
> As a result event channels remain masked.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

This one just sent a shiver down my spine. Are you doing this for a PPI?

	M.
-- 
Jazz is not dead. It just smells funny...

