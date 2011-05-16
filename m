Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1EPPlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:41:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53590 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab1EPPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:41:51 -0400
Date: Mon, 16 May 2011 11:41:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and initial_memory_mapping.
Message-ID: <20110516154132.GA12486@dumpdata.com>
References: <20110513153010.GB16519@dumpdata.com>
 <alpine.DEB.2.00.1105131650550.8972@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105131650550.8972@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DD145B9.0012:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> They become pagetable pages when:
> 
> - they are explicitly pinned by pin_pagetable_pfn
> 
> - they are hooked into the current pagetable

Ok, so could we use those two calls to trigger the pagetable walk
and mark them RO as appropiate? Which call sites are those? The
xen_set_pgd/xen_set_pud/xen_set_pmd ? Presumarily we don't have
to do that for the PTE's that are already mapped (as
xen_setup_kernel_pagetable, and xen_map_identity_early do this
already).

> Like you wrote, considering that the x86_64 version of
> kernel_physical_mapping_init hooks the pagetable pages into the
> currently used pagetable, it wouldn't be possible to mark the pagetable
> pages RO after init_memory_mapping.

<nods>
