Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2EYJT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:19:28 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:30472 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2EYJT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:19:27 -0400
X-IronPort-AV: E=Sophos;i="4.75,655,1330905600"; 
   d="scan'208";a="12665677"
Date: Fri, 25 May 2012 10:19:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/events: Add WARN_ON when quick lookup
 found invalid type.
In-Reply-To: <alpine.DEB.2.00.1205251016370.26786@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1205251018550.26786@kaball-desktop>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com> <1337795222-29946-5-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1205241154150.26786@kaball-desktop> <20120524182817.GM24934@phenom.dumpdata.com>
 <alpine.DEB.2.00.1205251016370.26786@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Stefano Stabellini wrote:
> > @@ -939,8 +944,10 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
> >  		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
> >  
> >  		bind_evtchn_to_cpu(evtchn, cpu);
> > +	} else {
> > +		struct irq_info *info = info_for_irq(irq);
> > +		WARN_ON(info == NULL || info->type != IRQT_VIRQ);
> >  	}
> > -
> >  out:
> >  	mutex_unlock(&irq_mapping_update_lock);
> >  
> 
> I don't want to nitpick but you removed 2 out of 3 spaced before the out
> label.

I meant newlines.

> In any case:
> 
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
