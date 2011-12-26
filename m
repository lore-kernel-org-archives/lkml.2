Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1LZBcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 20:32:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:46934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab1LZBbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 20:31:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89435109"
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
Subject: RE: [Xen-devel] [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Thread-Topic: [Xen-devel] [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Thread-Index: AQHMwR8jSQj+OztfxUuz+mAW9L1uCZXtWRMw
Date: Mon, 26 Dec 2011 01:31:45 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D10145B9@SHSMSX102.ccr.corp.intel.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-4-git-send-email-konrad.wilk@oracle.com>
 <20111216220342.GC9832@phenom.dumpdata.com>
 <625BA99ED14B2D499DC4E29D8138F1506E01AABC7A@shsmsx502.ccr.corp.intel.com>
 <20111219142626.GB27772@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC03A@shsmsx502.ccr.corp.intel.com>
 <20111220153145.GB13253@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC469@shsmsx502.ccr.corp.intel.com>
 <20111223030103.GA7218@andromeda.dapyr.net>
In-Reply-To: <20111223030103.GA7218@andromeda.dapyr.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad@darnok.org]
> Sent: Friday, December 23, 2011 11:01 AM
> 
> > > OK. Lets put the # VCPU != PCPU aside. Say dom0 will boot with all
> > > CPUs and then later on the admin starts unplugging them.
> >
> > This should be communicated to major Xen based distributions, so that it's
> > an agreed approach since in majority case dom0 is configured as UP or
> > a few VCPUs.
> 
> I am not saying that is it the agreed approach. There has to be
> flexibility in supporting both. But what I want to understand whether
> the requirement for VCPU != PCPU can be put aside and put in the drivers
> later on.

sure. VCPU!=PCPU requirement is orthogonal to the basic part for gearing
ACPI information to Xen.

> 
> So that the first approach is not changing the generic drivers (much).
> The reason I am asking about this is two-fold:
>  1). For new distros (Ubuntu, Fedora), the default is all VCPUs.

good to know that.

>      Enterprising users might use dom0_max_vcpus to limit the VCPU count,
>      but most won't.
>      Which mean we can concentrate on bringing the _Pxx/_Cxx parsing
>      up to the hypervisor. Which is really neccessary on any chipset
>      which has the notion of TurboBoost (otherwise the Xen scheduler
>      won't pick this up and won't engage this mode in certain
>      workloads).
>  2). The ACPI maintainers are busy with ACPI 5.0. I don't know how
>      much work this is, but it probably means tons of stuff with
>      embedded platforms and tons of regression testing. So if there
>      is a patch that does not impact the generic code much (or any)
>      it will make their life easier. Which also means we can built
>      on top that for the VCPU != PCPU case.
> 
> That is what I am trying to understand.

no problem. this incremental approach should work.

Thanks
Kevin
