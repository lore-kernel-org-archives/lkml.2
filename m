Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2BXLMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:12:49 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:33786 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2BXLMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:12:48 -0500
X-IronPort-AV: E=Sophos;i="4.73,475,1325480400"; 
   d="scan'208";a="183271516"
Message-ID: <4F4770AD.6040703@citrix.com>
Date: Fri, 24 Feb 2012 11:12:45 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH-WIP 07/13] xen/arm: receive xen events on arm
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>  <1330019314-20865-7-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1330019314-20865-7-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/12 17:48, Stefano Stabellini wrote:
> Compile events.c and use IRQ 32 to receive events notifications.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

> +#ifdef CONFIG_ARM
> +#define IRQ_EVTCHN_CALLBACK 63
> +irqreturn_t xen_arm_callback(int irq, void *arg)
> +{
> +	__xen_evtchn_do_upcall();
> +	return 0;
> +}
> +
> +int __init xen_init_IRQ_arm(void)
> +{
> +	int rc;
> +	xen_init_IRQ();
> +	rc = request_irq(IRQ_EVTCHN_CALLBACK, xen_arm_callback,
> +			IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
> +			"events", "events");	
> +	if (rc) {
> +		printk(KERN_ERR "Error requesting IRQ %d\n", IRQ_EVTCHN_CALLBACK);
> +	}
> +	return rc;
> +}
> +core_initcall(xen_init_IRQ_arm);
> +#endif

You should (eventually) have a device tree binding for the event channel
and use a OF (device tree) device driver instead of this core_initcall()
to register the handler etc.

David

