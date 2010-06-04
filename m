Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0FDUY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:24:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29403 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0FDUY1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 4 Jun 2010 16:24:27 -0400
Date: Fri, 4 Jun 2010 16:23:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       xen-devel@lists.xensource.com,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>, ddutile@redhat.com,
       sheng@linux.intel.com
Subject: Re: [Xen-devel] [PATCH 02/12] early PV on HVM
Message-ID: <20100604202311.GA28034@phenom.dumpdata.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4C0960EC.00D3:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static uint32_t xen_cpuid_base(void)
> +{
> +	uint32_t base, eax, ebx, ecx, edx;
> +	char signature[13];
> +
> +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> +		cpuid(base, &eax, &ebx, &ecx, &edx);
> +		*(uint32_t*)(signature + 0) = ebx;
> +		*(uint32_t*)(signature + 4) = ecx;
> +		*(uint32_t*)(signature + 8) = edx;
> +		signature[12] = 0;
> +
> +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> +			return base;
> +	}
> +
> +	return 0;
> +}

I forgot to mention this in the previous e-mail, but if you are rebasing
this against 2.6.34 it might be worth taking a look at the Microsoft HyperV code.
It also utilizes the cpuid code and this code could be made more generic.
