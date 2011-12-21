Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1LUAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:36:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:54541 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab1LUAgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:36:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="49184900"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "mike.mcclurg@citrix.com" <mike.mcclurg@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "liang.tang@oracle.com" <liang.tang@oracle.com>,
        "Yu, Ke" <ke.yu@intel.com>, "konrad@kernel.org" <konrad@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Date: Wed, 21 Dec 2011 08:35:34 +0800
Subject: RE: [Xen-devel] [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Thread-Topic: [Xen-devel] [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Thread-Index: Acy/LIQ3vCjZEYHGRkS1ziA4iSTX8wAShIpw
Message-ID: <625BA99ED14B2D499DC4E29D8138F1506E01AAC469@shsmsx502.ccr.corp.intel.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-4-git-send-email-konrad.wilk@oracle.com>
 <20111216220342.GC9832@phenom.dumpdata.com>
 <625BA99ED14B2D499DC4E29D8138F1506E01AABC7A@shsmsx502.ccr.corp.intel.com>
 <20111219142626.GB27772@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC03A@shsmsx502.ccr.corp.intel.com>
 <20111220153145.GB13253@andromeda.dapyr.net>
In-Reply-To: <20111220153145.GB13253@andromeda.dapyr.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad@darnok.org]
> Sent: Tuesday, December 20, 2011 11:32 PM
> 
> On Tue, Dec 20, 2011 at 10:29:12AM +0800, Tian, Kevin wrote:
> > > From: Konrad Rzeszutek Wilk [mailto:konrad@darnok.org]
> > > Sent: Monday, December 19, 2011 10:26 PM
> > >
> > > On Mon, Dec 19, 2011 at 01:48:01PM +0800, Tian, Kevin wrote:
> > > > > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > > > > Sent: Saturday, December 17, 2011 6:04 AM
> > > > >
> > > > > On Wed, Nov 30, 2011 at 12:20:59PM -0500, Konrad Rzeszutek Wilk
> wrote:
> > > > > > From: Tang Liang <liang.tang@oracle.com>
> > > > > >
> > > > > > This patch implement __acpi_processor_[un]register_driver helper,
> > > > > > so we can registry override processor driver function. Specifically
> > > > > > the Xen processor driver.
> > > > >
> > > > > Liang,
> > > > >
> > > > > Is the reason we are doing this b/c we need to call
> acpi_bus_register_driver
> > > > > and inhibit the registration of 'acpi_processor_driver' ?
> > > > >
> > > > > And the reason we don't want 'acpi_processor_driver' to run is b/c of
> what?
> > > > > If the cpuidle is disabled what is the harm of running the
> > > > > 'acpi_processor_driver'
> > > > > driver?
> > > >
> > > > IIRC, the reason why we want a Xen specific driver is because current
> driver
> > > > is integrated with OS logic too tightly, e.g. the various checks on VCPU
> related
> > > > structures. Long time ago the 1st version in Xen was to use same driver,
> by
> > > > adding various tweaking lines inside which makes it completely messed.
> Then
> > > > later it's found that it's clearer to create a Xen specific wrapping driver, by
> > > > invoking some exported functions from existing one.
> > >
> > > What I am asking is does it matter "if the current driver is integrated
> > > with OS logic to tighly" - as it is not running anyhow (b/c cpuidle is
> > > disabled).
> > >
> > > And if Xen specific driver can run along-side the generic one - since
> > > the generic one is not doing any work (b/c cpuidle is disabled).
> > >
> > > That is what I am trying to figure out - since this patch purpose is to
> > > thwart the generic driver from running and allowing the xen one to run.
> >
> > It's a separate issue from cpuidle case. Here we're talking about acpi
> processor
> > driver, not the acpi cpuidle driver. ACPI processor driver is responsible for
> > discovering ACPI processor projects, and then enumerate various methods
> > such as _PPC, _CST, etc. under those objects. So far this driver depends on
> > VCPU presence in various places, which causes trouble when dom0 is
> configured
> > with less VCPU number than physical present one.
> >
> > One example you can see from acpi_processor_add:
> >
> >         result = acpi_processor_get_info(device); // call acpi_get_cpuid
> >         if (result) {
> >                 /* Processor is physically not present */
> >                 return 0;
> >         }
> >
> > #ifdef CONFIG_SMP
> >         if (pr->id >= setup_max_cpus && pr->id != 0)
> >                 return 0;
> > #endif
> >
> >         BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
> >
> > The binding between ACPI processor objects and VCPU presence would only
> parse
> > partial objects to Xen. And there're various places within driver validating
> pr->id
> > making it messy to workaround for Xen within same driver.
> >
> > That's the major reason for coming up a Xen specific driver, which always
> parses
> > all present objects regardless of VCPU presence. :-)
> 
> OK. Lets put the # VCPU != PCPU aside. Say dom0 will boot with all
> CPUs and then later on the admin starts unplugging them.

This should be communicated to major Xen based distributions, so that it's
an agreed approach since in majority case dom0 is configured as UP or
a few VCPUs.

> 
> With that in mind, could we use a slim driver (like the one in: "ACPI:
>  add processor driver for Xen virtual CPUs.") that would just
> take the _Pxx, Cxx data and shove them to the hypervisor (handwaving
> aside the checking for quirks and such). And lets assume that we use the
> unmodified acpi_processor_[add|remove|notify] code that is present in
> processor_driver.c.

There may still have other condition checks which may fail, but yes it's possible
to reuse the interfaces. From my memory #VCPU is the major blocker...

> 
> Oh, and the processor-driver.c did try to load (with the understanding
> that it would load, but won't do much since cpuidle is turned off).

you also need consider cpufreq. IIRC, Px related information may be only
parsed from loaded acpi cpufreq driver, which is another reason why a Xen
wrapper driver is created. But of course this could be relaxed from existing
code if you want to go that way.

> 
> Would that still get the Pxx, Cxx data to the hypervisor?

yes, it's possible under the assumption you put in the start. But you need
verify more code paths to make sure some conditional checks for native
Linux still hold true for dom0.

Thanks
Kevin
