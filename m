Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2FFPJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:09:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51210 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755503Ab2FFPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:09:28 -0400
Date: Wed, 6 Jun 2012 11:09:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Tomas M." <tmezzadra@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        <preeti@linux.vnet.ibm.com>, <linux-pm@lists.linux-foundation.org>,
        Ferenc Wagner <wferi@niif.hu>,
        Arjan van de Ven <arjan@linux.intel.com>, Jean Pihet <j-pihet@ti.com>
Subject: Re: [linux-pm] Suspend/resume regressions on Lenovo S10-3
In-Reply-To: <201206061543.03537.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1206061108040.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Rafael J. Wysocki wrote:

> > --- a/drivers/acpi/processor_idle.c
> > +++ b/drivers/acpi/processor_idle.c
> > @@ -895,8 +895,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
> >  	if (unlikely(!pr))
> >  		return -EINVAL;
> >  
> > -
> >  	if (acpi_idle_suspend) {
> > +		local_irq_disable();
> > +		local_irq_enable();
> >  		cpu_relax();
> >  		return -EINVAL;
> >  	}
> 
> May I say this is ugly?  Why can't we track the status of interrupts
> properly here?

It's not just ugly; it's illogical.  What reason could there possibly
be for disabling interrupts and then enabling them again without doing
anything in between?

Alan Stern

