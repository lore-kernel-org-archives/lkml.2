Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1EQRuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:50:00 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:41321 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab1EQRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:49:59 -0400
X-IronPort-AV: E=Sophos;i="4.65,226,1304294400"; 
   d="scan'208";a="5807648"
Date: Tue, 17 May 2011 18:51:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, Keir Fraser <keir@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and
 initial_memory_mapping.
In-Reply-To: <4DD19D1F.3070506@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1105171744230.12963@kaball-desktop>
References: <20110513153010.GB16519@dumpdata.com> <alpine.DEB.2.00.1105131650550.8972@kaball-desktop> <20110516154132.GA12486@dumpdata.com> <4DD19D1F.3070506@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing Keir in case he knows something I am missing.

On Mon, 16 May 2011, H. Peter Anvin wrote:
> On 05/16/2011 08:41 AM, Konrad Rzeszutek Wilk wrote:
> >> They become pagetable pages when:
> >>
> >> - they are explicitly pinned by pin_pagetable_pfn
> >>
> >> - they are hooked into the current pagetable
> > 
> > Ok, so could we use those two calls to trigger the pagetable walk
> > and mark them RO as appropiate? Which call sites are those? The
> > xen_set_pgd/xen_set_pud/xen_set_pmd ? Presumarily we don't have
> > to do that for the PTE's that are already mapped (as
> > xen_setup_kernel_pagetable, and xen_map_identity_early do this
> > already).
> > 
> >> Like you wrote, considering that the x86_64 version of
> >> kernel_physical_mapping_init hooks the pagetable pages into the
> >> currently used pagetable, it wouldn't be possible to mark the pagetable
> >> pages RO after init_memory_mapping.
> > 
> 
> Doesn't Xen have some kind of compatibility mode which could be used
> during setup?
 
Unfortunately not that I am aware.
