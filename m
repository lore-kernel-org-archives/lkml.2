Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1CJI6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:58:11 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12175 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1CJI6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:58:09 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297036800"; 
   d="scan'208";a="4713852"
Subject: Re: [PATCH 14/14] xen: events: propagate irq allocation failure
 instead of panicking
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310053852.GE10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
	 <1299692486-28634-14-git-send-email-ian.campbell@citrix.com>
	 <20110310053852.GE10574@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 10 Mar 2011 08:58:07 +0000
Message-ID: <1299747487.17339.735.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 05:38 +0000, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 09, 2011 at 05:41:26PM +0000, Ian Campbell wrote:
> > Running out of IRQs need not be fatal to the machine as a whole.
> 
> Do the backends/frontends deal with this appropiately?
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > ---
> >  drivers/xen/events.c |   22 ++++++++++++++--------
> >  1 files changed, 14 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 51c6a5b..c6f2a2e 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -406,7 +406,7 @@ static void xen_irq_init(unsigned irq)
> >  	list_add_tail(&info->list, &xen_irq_list_head);
> >  }
> >  
> > -static int xen_allocate_irq_dynamic(void)
> > +static int __must_check xen_allocate_irq_dynamic(void)
> 
> What is the '__must_check' for?

It makes gcc warn if callers don't check the return code. Perhaps
overkill for so few callers but it made it easy to be sure I'd
propagated the error code.

Ian.



