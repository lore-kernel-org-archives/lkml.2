Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1EPVyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:54:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:43979 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab1EPVym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:54:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,221,1304319600"; 
   d="scan'208";a="643473787"
Message-ID: <4DD19D1F.3070506@linux.intel.com>
Date: Mon, 16 May 2011 14:54:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and initial_memory_mapping.
References: <20110513153010.GB16519@dumpdata.com> <alpine.DEB.2.00.1105131650550.8972@kaball-desktop> <20110516154132.GA12486@dumpdata.com>
In-Reply-To: <20110516154132.GA12486@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 08:41 AM, Konrad Rzeszutek Wilk wrote:
>> They become pagetable pages when:
>>
>> - they are explicitly pinned by pin_pagetable_pfn
>>
>> - they are hooked into the current pagetable
> 
> Ok, so could we use those two calls to trigger the pagetable walk
> and mark them RO as appropiate? Which call sites are those? The
> xen_set_pgd/xen_set_pud/xen_set_pmd ? Presumarily we don't have
> to do that for the PTE's that are already mapped (as
> xen_setup_kernel_pagetable, and xen_map_identity_early do this
> already).
> 
>> Like you wrote, considering that the x86_64 version of
>> kernel_physical_mapping_init hooks the pagetable pages into the
>> currently used pagetable, it wouldn't be possible to mark the pagetable
>> pages RO after init_memory_mapping.
> 

Doesn't Xen have some kind of compatibility mode which could be used
during setup?

	-hpa

