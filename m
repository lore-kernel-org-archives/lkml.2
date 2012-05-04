Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab2EDQBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:01:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:58212 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab2EDQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:01:39 -0400
Date: Fri, 4 May 2012 18:01:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: NeilBrown <neilb@suse.de>
cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/3] IRQ: allow check_wakeup_irqs to notice level-triggered
 interrupts.
In-Reply-To: <20120504151221.6998d4e5@notabene.brown>
Message-ID: <alpine.LFD.2.02.1205041759540.6271@ionos>
References: <20120425025637.7832.14013.stgit@notabene.brown> <20120425030524.7832.85239.stgit@notabene.brown> <alpine.LFD.2.02.1204251018530.2542@ionos> <20120425193916.0db1b4b1@notabene.brown> <alpine.LFD.2.02.1204251402360.2542@ionos>
 <20120504151221.6998d4e5@notabene.brown>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

On Fri, 4 May 2012, NeilBrown wrote:

> On Wed, 25 Apr 2012 14:54:54 +0200 (CEST) Thomas Gleixner
> <tglx@linutronix.de> wrote:
> 
> > Why not simply managing the pending bit for level irqs ?
> > 
> 
> Hi Thomas,
>  thanks again for the patch.  I finally made time to test it and it works as
> expected.  I've included it below with a change-log entry and tested-by:
> in case that helps.

thanks for testing. The changelog is great. You know how to make the
live of lazy buggers easier :)
  
>  	for_each_irq_desc(irq, desc) {
> -		if (irqd_is_wakeup_set(&desc->irq_data)) {
> +		if (desc->depth == 1 &&
> +		    irqd_is_wakeup_set(&desc->irq_data)) {
>  			if (desc->istate & IRQS_PENDING)
>  				return -EBUSY;
>  			continue;

I split that part into a separate patch, as it's really a different
issue.

Thanks,

	tglx
