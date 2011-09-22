Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1IVLHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:07:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8563 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1IVLHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:07:02 -0400
X-IronPort-AV: E=Sophos;i="4.68,422,1312156800"; 
   d="scan'208";a="8003571"
Date: Thu, 22 Sep 2011 12:06:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 0/6] xen: don't call vmalloc_sync_all()
 when mapping foreign pages
In-Reply-To: <4E7A3394.3090806@goop.org>
Message-ID: <alpine.DEB.2.00.1109221131390.8700@kaball-desktop>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com> <4E727017.4030001@goop.org> <alpine.DEB.2.00.1109211124050.8700@kaball-desktop> <4E7A3394.3090806@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Jeremy Fitzhardinge wrote:
> On 09/21/2011 03:42 AM, Stefano Stabellini wrote:
> > On Thu, 15 Sep 2011, Jeremy Fitzhardinge wrote:
> >> This series is relying on regular ram mappings are already synced to all
> >> tasks, but I'm not sure that's necessarily guaranteed (for example, if
> >> you hotplug new memory into the domain, the new pages won't be mapped
> >> into every mm unless they're synced).
> > the series is using GFP_KERNEL, so this problem shouldn't occur, right?
> 
> What properties do you think GFP_KERNEL guarantees?

That the memory is below 4G and always mapped in the kernel 1:1 region.

Regarding memory hotplug it looks like that x86_32 is mapping new memory
ZONE_HIGHMEM, therefore avoiding any problems with GFP_KERNEL allocations.
On the other hand x86_64 is mapping the memory ZONE_NORMAL and calling
init_memory_mapping on the new range right away. AFAICT changes to
the 1:1 mapping in init_mm are automatically synced across all mm's
because the pgd is shared?
