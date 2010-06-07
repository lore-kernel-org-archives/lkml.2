Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab0FGOj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 10:39:56 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:37667 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0FGOjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 10:39:54 -0400
X-IronPort-AV: E=Sophos;i="4.53,378,1272844800"; 
   d="scan'208";a="278811"
Date: Mon, 7 Jun 2010 15:39:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 02/12] early PV on HVM
In-Reply-To: <20100604202311.GA28034@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006071357200.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com> <20100604202311.GA28034@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > +static uint32_t xen_cpuid_base(void)
> > +{
> > +	uint32_t base, eax, ebx, ecx, edx;
> > +	char signature[13];
> > +
> > +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
> > +		cpuid(base, &eax, &ebx, &ecx, &edx);
> > +		*(uint32_t*)(signature + 0) = ebx;
> > +		*(uint32_t*)(signature + 4) = ecx;
> > +		*(uint32_t*)(signature + 8) = edx;
> > +		signature[12] = 0;
> > +
> > +		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
> > +			return base;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> I forgot to mention this in the previous e-mail, but if you are rebasing
> this against 2.6.34 it might be worth taking a look at the Microsoft HyperV code.
> It also utilizes the cpuid code and this code could be made more generic.
> 

these patches are already based on 2.6.34, I didn't use the generic
hypervisor setup code because it is not available in 2.6.34, however
in the future rebasing to use that is going to be quite easy.

