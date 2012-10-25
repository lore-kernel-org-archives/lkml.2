Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab2JZJBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:01:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:57225 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab2JZJBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:01:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,648,1344236400"; 
   d="scan'208";a="240200121"
Date: Thu, 25 Oct 2012 09:29:38 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <len.brown@intel.com>
Subject: Re: arch/x86/Kconfig: not select X86_MPPARSE when SFI is present
Message-ID: <20121025162937.GA38477@bingao-desk1.fm.intel.com>
References: <20121025060400.GB38419@bingao-desk1.fm.intel.com>
 <20121025075752.GE3712@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025075752.GE3712@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, your suggested descriptions more match the change.
I'm sending a new patch for your review. Thanks.

-Bin

On Thu, Oct 25, 2012 at 09:57:52AM +0200, Ingo Molnar wrote:
> 
> * Bin Gao <bin.gao@linux.intel.com> wrote:
> 
> > MPS tables are not needed for systems that have proper ACPI support.
> > This is also true for systems that have SFI in place.
> > 
> > So this patch is to exclude X86_MPPARSE when either ACPI or SFI is present.
> > 
> > Signed-off-by: Bin Gao <bin.gao@intel.com>
> > ---
> >  arch/x86/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 46c3bff..b1494bd 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -310,7 +310,7 @@ config X86_X2APIC
> >  	  If you don't know what to do here, say N.
> >  
> >  config X86_MPPARSE
> > -	bool "Enable MPS table" if ACPI
> > +	bool "Enable MPS table" if ACPI || SFI
> >  	default y
> >  	depends on X86_LOCAL_APIC
> >  	---help---
> 
> The changelog does not seem to match the patch. Did you want to 
> say:
> 
>   " So this patch allows the configuration (turning off) of
>     CONFIG_X86_MPPARSE when either ACPI or SFI is present. "
> 
> ?
> 
> 	Ingo
