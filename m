Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0LGCBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:01:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:24696 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab0LGCBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:01:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,308,1288594800"; 
   d="scan'208";a="581196233"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2] xen: HVM X2APIC support
Date: Tue, 7 Dec 2010 10:04:22 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
References: <1291621797-1483-1-git-send-email-sheng@linux.intel.com> <20101206204054.GA28678@dumpdata.com>
In-Reply-To: <20101206204054.GA28678@dumpdata.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071004.22291.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 December 2010 04:40:54 Konrad Rzeszutek Wilk wrote:
> > +static inline uint32_t xen_cpuid_base(void)
> > +{
> > +	uint32_t base, eax, ebx, ecx, edx;
> > +	char signature[13];
> > +
> > +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> > +		cpuid(base, &eax, &ebx, &ecx, &edx);
> > +		*(uint32_t *)(signature + 0) = ebx;
> > +		*(uint32_t *)(signature + 4) = ecx;
> > +		*(uint32_t *)(signature + 8) = edx;
> > +		signature[12] = 0;
> > +
> > +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> > +			return base;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_XEN
> > +extern bool xen_hvm_need_lapic(void);
> > +
> > +static inline bool xen_para_available(void)
> > +{
> > +	return xen_hvm_need_lapic();
> > +}
> > +#else
> > +static inline bool xen_para_available(void)
> > +{
> > +	return (xen_cpuid_base() != 0);
> 
> Would it make sense to collapse the kvm_para_available and
> the xen_cpuid_base together (and maybe even the HyperV detection code)
> together in one and just return "x2_apic_para_capable" ?

Well, no hyper-v now. But put them together is a good idea.

--
regards
Yang, Sheng
