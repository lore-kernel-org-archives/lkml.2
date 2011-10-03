Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1JCQV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:21:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:59533 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1JCQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:21:51 -0400
Date: Mon, 3 Oct 2011 12:21:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [Xen-devel] [PATCH 4/9] xen/events: BUG() when we can't allocate
 our event->irq array.
Message-ID: <20111003162130.GE17108@phenom.oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-5-git-send-email-konrad.wilk@oracle.com>
 <1317369353.26672.215.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317369353.26672.215.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A02020B.4E89E11B.0137,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:55:53AM +0100, Ian Campbell wrote:
> On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> > In case we can't allocate we are doomed. We should BUG_ON
> > instead of trying to dereference it later on.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/events.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 7523719..5db04bf 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -1670,6 +1670,8 @@ void __init xen_init_IRQ(void)
> >  
> >  	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
> >  				    GFP_KERNEL);
> > +	if (!evtchn_to_irq)
> > +		BUG();
> 
> AKA
> 	BUG_ON(!evtchn_to_irq);

Duh, I even say it in the description. Changed it to be BUG_ON.
> 
> but
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
