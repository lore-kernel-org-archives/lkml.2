Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2JPTnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:43:12 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:21825 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab2JPTnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:43:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,595,1344211200"; 
   d="scan'208";a="15211572"
Message-ID: <1350416588.28188.0.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH V2 3/7]: PVH:  mmu related changes.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 16 Oct 2012 20:43:08 +0100
In-Reply-To: <20121016104657.4b2478a8@mantra.us.oracle.com>
References: <20121011145817.0d744c99@mantra.us.oracle.com>
	 <1350032276.14806.53.camel@zakaz.uk.xensource.com>
	 <1350404821.2460.3.camel@zakaz.uk.xensource.com>
	 <20121016104657.4b2478a8@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 10:46 -0700, Mukesh Rathor wrote:
> On Tue, 16 Oct 2012 17:27:01 +0100
> Ian Campbell <Ian.Campbell@citrix.com> wrote:
> 
> > On Fri, 2012-10-12 at 09:57 +0100, Ian Campbell wrote:
> > > > +int xen_unmap_domain_mfn_range(struct vm_area_struct *vma)
> > > > +{
> > > > +       int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> > > > +       struct page **pages = vma ? vma->vm_private_data : NULL;
> > > 
> > > I thought we agreed to keep uses of vm_private_data in the privcmd
> > > driver?
> > > 
> > > I think you should just add pages and nr as direct parameters to
> > > this function, which is symmetric with the map call.
> > 
> > I had to look at this while rebasing my arm patches, turned out to be
> > fairly simple. Feel free to either fold in or badger me for a proper
> > commit message.
> 
> 
> I made similar change in my tree, except I am not passing vma as its
> not needed. I guess you just wanna be consistend with remap, or future
> use?

Consistency mostly.


