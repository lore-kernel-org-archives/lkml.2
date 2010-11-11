Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab0KKAxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:53:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab0KKAxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:53:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] PM: Hide OPP configuration when SoCs do not provide an implementation
Date: Thu, 11 Nov 2010 01:52:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
References: <1289327056-27950-1-git-send-email-broonie@opensource.wolfsonmicro.com> <87fwvaqpb5.fsf@deeprootsystems.com>
In-Reply-To: <87fwvaqpb5.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011110152.55311.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 09, 2010, Kevin Hilman wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
> 
> > Since the OPP API is only useful with an appropraite SoC-specific
> > implementation there is no point in offering the ability to enable
> > the API on general systems. Provide an ARCH_HAS OPP Kconfig symbol
> > which masks out the option unless selected by an implementation.
> >
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

Applied to suspend-2.6/linux-next, will push to Linus next week.

Thanks,
Rafael


> > ---
> >  Documentation/power/opp.txt |    3 +++
> >  kernel/power/Kconfig        |    4 ++++
> >  2 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
> > index 44d87ad..cd44558 100644
> > --- a/Documentation/power/opp.txt
> > +++ b/Documentation/power/opp.txt
> > @@ -37,6 +37,9 @@ Typical usage of the OPP library is as follows:
> >  SoC framework	-> modifies on required cases certain OPPs	-> OPP layer
> >  		-> queries to search/retrieve information	->
> >  
> > +Architectures that provide a SoC framework for OPP should select ARCH_HAS_OPP
> > +to make the OPP layer available.
> > +
> >  OPP layer expects each domain to be represented by a unique device pointer. SoC
> >  framework registers a set of initial OPPs per device with the OPP layer. This
> >  list is expected to be an optimally small number typically around 5 per device.
> > diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> > index 29bff61..a5aff3e 100644
> > --- a/kernel/power/Kconfig
> > +++ b/kernel/power/Kconfig
> > @@ -246,9 +246,13 @@ config PM_OPS
> >  	depends on PM_SLEEP || PM_RUNTIME
> >  	default y
> >  
> > +config ARCH_HAS_OPP
> > +	bool
> > +
> >  config PM_OPP
> >  	bool "Operating Performance Point (OPP) Layer library"
> >  	depends on PM
> > +	depends on ARCH_HAS_OPP
> >  	---help---
> >  	  SOCs have a standard set of tuples consisting of frequency and
> >  	  voltage pairs that the device will support per voltage domain. This
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

