Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2EYNtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:49:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23798 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2EYNtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:49:09 -0400
Date: Fri, 25 May 2012 09:42:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/events: Add WARN_ON when quick
 lookup found invalid type.
Message-ID: <20120525134231.GB21763@phenom.dumpdata.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
 <1337795222-29946-5-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205241154150.26786@kaball-desktop>
 <20120524182817.GM24934@phenom.dumpdata.com>
 <alpine.DEB.2.00.1205251016370.26786@kaball-desktop>
 <alpine.DEB.2.00.1205251018550.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205251018550.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 10:19:10AM +0100, Stefano Stabellini wrote:
> On Fri, 25 May 2012, Stefano Stabellini wrote:
> > > @@ -939,8 +944,10 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
> > >  		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
> > >  
> > >  		bind_evtchn_to_cpu(evtchn, cpu);
> > > +	} else {
> > > +		struct irq_info *info = info_for_irq(irq);
> > > +		WARN_ON(info == NULL || info->type != IRQT_VIRQ);
> > >  	}
> > > -
> > >  out:
> > >  	mutex_unlock(&irq_mapping_update_lock);
> > >  
> > 
> > I don't want to nitpick but you removed 2 out of 3 spaced before the out
> > label.
> 
> I meant newlines.

Good eyes! The final version will have those unmolested.

> 
> > In any case:
> > 
> > Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
