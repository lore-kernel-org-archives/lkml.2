Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab1EQSRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:17:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44968 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1EQSRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:17:37 -0400
Date: Tue, 17 May 2011 14:17:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and initial_memory_mapping.
Message-ID: <20110517181716.GA4490@dumpdata.com>
References: <20110513153010.GB16519@dumpdata.com>
 <alpine.DEB.2.00.1105131650550.8972@kaball-desktop>
 <20110516154132.GA12486@dumpdata.com>
 <alpine.DEB.2.00.1105171745300.12963@kaball-desktop>
 <20110517180520.GC13706@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517180520.GC13706@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DD2BBB9.00EC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > xen_alloc_pte_init and xen_alloc_pmd_init are the ones that mark the
> > pagetable pages RO and pin them, calling make_lowmem_page_readonly and
> > pin_pagetable_pfn.
> > 
> > alloc_pte/pmd are called right before hooking them into the pagetable;
> > unfortunately that means that they fail at marking the pagetable pages
> > RO: make_lowmem_page_readonly uses lookup_address to find the pte
> > corresponding to a page, however at this point the pagetable pages are
> > not mapped yet (usually they are not hooked but when they are hooked, the
> > upper level pagetable page is not hooked), so lookup_address fails.
> 
> Right. We don't have to walk the hooked pagetable, I think. We are passed
> in the PMD/PGD of the PFN and we could look at the content of that PFN.

err, got that backwards. "passed in the PFN of the PMD/PGD".
