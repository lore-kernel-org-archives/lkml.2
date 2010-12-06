Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0LFUlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:41:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37741 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0LFUlK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 15:41:10 -0500
Date: Mon, 6 Dec 2010 15:40:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xen: HVM X2APIC support
Message-ID: <20101206204054.GA28678@dumpdata.com>
References: <1291621797-1483-1-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291621797-1483-1-git-send-email-sheng@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline uint32_t xen_cpuid_base(void)
> +{
> +	uint32_t base, eax, ebx, ecx, edx;
> +	char signature[13];
> +
> +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> +		cpuid(base, &eax, &ebx, &ecx, &edx);
> +		*(uint32_t *)(signature + 0) = ebx;
> +		*(uint32_t *)(signature + 4) = ecx;
> +		*(uint32_t *)(signature + 8) = edx;
> +		signature[12] = 0;
> +
> +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> +			return base;
> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_XEN
> +extern bool xen_hvm_need_lapic(void);
> +
> +static inline bool xen_para_available(void)
> +{
> +	return xen_hvm_need_lapic();
> +}
> +#else
> +static inline bool xen_para_available(void)
> +{
> +	return (xen_cpuid_base() != 0);

Would it make sense to collapse the kvm_para_available and
the xen_cpuid_base together (and maybe even the HyperV detection code)
together in one and just return "x2_apic_para_capable" ?

