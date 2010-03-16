Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966485Ab0CPPD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:03:28 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:9290 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966459Ab0CPPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:03:24 -0400
Subject: Re: [PATCH v2 1/3] ipmi: Raise precedence of PNP based discovery
 mechanisms (ACPI, PCI)
From: Myron Stowe <myron.stowe@hp.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: "minyard@acm.org" <minyard@acm.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>
In-Reply-To: <1268617719.3617.9.camel@localhost.localdomain>
References: <20100313180121.20614.92547.stgit@bob.kio>
	 <20100313181342.20614.72981.stgit@bob.kio>
	 <1268617719.3617.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 09:03:20 -0600
Message-ID: <1268751800.2671.16.camel@zim>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 09:48 +0800, ykzhao wrote:
> On Sun, 2010-03-14 at 02:13 +0800, Myron Stowe wrote:
> > This raises the precedence of PNP discovery mechanisms, ACPI and  PCI,
> > above SMBIOS and SPMI as indicated by Appendix C1 of the IPMI
> > specification.
> > 
> > Reference: IPMI - Intelligent Platform Management Interface Specification
> >            v2.0, Document Revision 1.0, 05.05.2005 Markup
> > 
> >   Appendix C1 - Locating IPMI System Interfaces via SMBIOS Tables
> >       "Note that the settings that this structure reports may be over-
> >       ridden by `Plug-and-Play' reassignment by the OS.  Therefore, this
> >       structure should be used only when the interface cannot be
> >       discovered via `Plug-and-Play' discovery mechanisms incorporated
> >       in interfaces such as PCI and ACPI."
> 
> Hi,
>     The SPMI detection mechanism belongs to one of two ACPI detection
> mechanisms.  Can we put it before DMI detection mechanism?

The SPMI detection method is similar to the DMI (SMBIOS) in that they
are both static tables and thus should be after methods capable of
changes from OS reassignment.

The order between these two probably does not make a great deal of
difference.  The logic I used was to maintain the original order, just
copy and paste, which kept SPMI after SMBIOS which also seemed natural
since SMBIOS is older, a possible indication that it is the more widely
used method of the two.

Myron

>     
>     Anyway, it is right that the pnp discovery mechanism has higher
> priority than PCI/SPMI/SMBIOS.
> 
> Thanks.
>    Yakui
> > 
> > Signed-off-by: Myron Stowe <myron.stowe@hp.com>
> > ---
> > 
> >  drivers/char/ipmi/ipmi_si_intf.c |   15 ++++++++-------
> >  1 files changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> > index 176f175..86a7dd7 100644
> > --- a/drivers/char/ipmi/ipmi_si_intf.c
> > +++ b/drivers/char/ipmi/ipmi_si_intf.c
> > @@ -3197,13 +3197,6 @@ static __devinit int init_ipmi_si(void)
> >  
> >  	hardcode_find_bmc();
> >  
> > -#ifdef CONFIG_DMI
> > -	dmi_find_bmc();
> > -#endif
> > -
> > -#ifdef CONFIG_ACPI
> > -	spmi_find_bmc();
> > -#endif
> >  #ifdef CONFIG_ACPI
> >  	pnp_register_driver(&ipmi_pnp_driver);
> >  #endif
> > @@ -3220,6 +3213,14 @@ static __devinit int init_ipmi_si(void)
> >  	of_register_platform_driver(&ipmi_of_platform_driver);
> >  #endif
> >  
> > +#ifdef CONFIG_DMI
> > +	dmi_find_bmc();
> > +#endif
> > +
> > +#ifdef CONFIG_ACPI
> > +	spmi_find_bmc();
> > +#endif
> > +
> >  	if (si_trydefaults) {
> >  		mutex_lock(&smi_infos_lock);
> >  		if (list_empty(&smi_infos)) {
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Myron Stowe                             HP Open Source Linux Lab (OSLL)

