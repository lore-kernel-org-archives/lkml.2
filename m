Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2HFPLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:11:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26634 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab2HFPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:11:06 -0400
Date: Mon, 6 Aug 2012 10:33:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_idle: Check cpu_idle_get_driver() for NULL before
 dereferencing it.
Message-ID: <20120806143308.GC2487@phenom.dumpdata.com>
References: <1343918341-25985-1-git-send-email-konrad.wilk@oracle.com>
 <201208042356.35884.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208042356.35884.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 11:56:35PM +0200, Rafael J. Wysocki wrote:
> On Thursday, August 02, 2012, Konrad Rzeszutek Wilk wrote:
> > If the machine is booted without any cpu_idle driver set
> > (b/c disable_cpuidle() has been called) we should follow
> > other users of cpu_idle API and check the return value
> > for NULL before using it.
> > 
> > Reported-by: Mark van Dijk <mark@internecto.net>
> > Tested-by: Mark van Dijk <mark@internecto.net>
> > Suggested-by: Jan Beulich <JBeulich@suse.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/idle/intel_idle.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> > index f559088..7383aa0 100644
> > --- a/drivers/idle/intel_idle.c
> > +++ b/drivers/idle/intel_idle.c
> > @@ -607,7 +607,7 @@ static int __init intel_idle_init(void)
> >  	retval = cpuidle_register_driver(&intel_idle_driver);
> >  	if (retval) {
> 
> What about:
> 
>   		struct cpuidle_driver *drv = cpuidle_get_driver();
> 
>   		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
> 			drv ? drv->name : "none");

Much prettier. Let me spin that up.

> 
> >  		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
> > -			cpuidle_get_driver()->name);
> > +			cpuidle_get_driver() ? cpuidle_get_driver()->name : "none");
> >  		return retval;
> >  	}
> >  
> > 
> 
> Rafael
