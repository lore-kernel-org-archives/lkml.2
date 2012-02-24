Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2BXMRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:17:41 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:40872 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2BXMRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:17:40 -0500
X-IronPort-AV: E=Sophos;i="4.73,475,1325462400"; 
   d="scan'208";a="10917704"
Date: Fri, 24 Feb 2012 12:23:33 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH-WIP 07/13] xen/arm: receive xen events on arm
In-Reply-To: <4F4770AD.6040703@citrix.com>
Message-ID: <alpine.DEB.2.00.1202241221440.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>  <1330019314-20865-7-git-send-email-stefano.stabellini@eu.citrix.com> <4F4770AD.6040703@citrix.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, David Vrabel wrote:
> On 23/02/12 17:48, Stefano Stabellini wrote:
> > Compile events.c and use IRQ 32 to receive events notifications.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> > +#ifdef CONFIG_ARM
> > +#define IRQ_EVTCHN_CALLBACK 63
> > +irqreturn_t xen_arm_callback(int irq, void *arg)
> > +{
> > +	__xen_evtchn_do_upcall();
> > +	return 0;
> > +}
> > +
> > +int __init xen_init_IRQ_arm(void)
> > +{
> > +	int rc;
> > +	xen_init_IRQ();
> > +	rc = request_irq(IRQ_EVTCHN_CALLBACK, xen_arm_callback,
> > +			IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
> > +			"events", "events");	
> > +	if (rc) {
> > +		printk(KERN_ERR "Error requesting IRQ %d\n", IRQ_EVTCHN_CALLBACK);
> > +	}
> > +	return rc;
> > +}
> > +core_initcall(xen_init_IRQ_arm);
> > +#endif
> 
> You should (eventually) have a device tree binding for the event channel
> and use a OF (device tree) device driver instead of this core_initcall()
> to register the handler etc.
 
Yes, that is the idea, once we have better device tree support in Xen.
We should also pass the IRQ number to be used as event injection
mechanism through the device tree.
