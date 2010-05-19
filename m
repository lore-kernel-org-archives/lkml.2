Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0ESOW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:22:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58101 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab0ESOW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:22:57 -0400
X-IronPort-AV: E=Sophos;i="4.53,263,1272859200"; 
   d="scan'208";a="8591271"
Date: Wed, 19 May 2010 15:25:45 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 09/12] Fix possible NULL pointer dereference in
 print_IO_APIC
In-Reply-To: <4BF2D95B.2040007@goop.org>
Message-ID: <alpine.DEB.2.00.1005191520290.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-9-git-send-email-stefano.stabellini@eu.citrix.com> <4BF2D95B.2040007@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Jeremy Fitzhardinge wrote:
> On 05/18/2010 03:23 AM, Stefano Stabellini wrote:
> > Make sure chip_data is not NULL before accessing it.
> >   
> 
> You should clarify under what circumstances it can be legitimately NULL.
> 
> 

The VIRQ_TIMER handler and virq handlers in general don't have any
chip_data.


> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/kernel/apic/io_apic.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index eb2789c..c64499c 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -1732,6 +1732,8 @@ __apicdebuginit(void) print_IO_APIC(void)
> >  		struct irq_pin_list *entry;
> >  
> >  		cfg = desc->chip_data;
> > +		if (!cfg)
> > +			continue;
> >  		entry = cfg->irq_2_pin;
> >  		if (!entry)
> >  			continue;
> >   
> 
