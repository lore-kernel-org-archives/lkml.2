Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2JPRrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:47:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21033 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2JPRrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:47:07 -0400
Date: Tue, 16 Oct 2012 10:46:57 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH V2 3/7]: PVH:  mmu related changes.
Message-ID: <20121016104657.4b2478a8@mantra.us.oracle.com>
In-Reply-To: <1350404821.2460.3.camel@zakaz.uk.xensource.com>
References: <20121011145817.0d744c99@mantra.us.oracle.com>
	<1350032276.14806.53.camel@zakaz.uk.xensource.com>
	<1350404821.2460.3.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 17:27:01 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Fri, 2012-10-12 at 09:57 +0100, Ian Campbell wrote:
> > > +int xen_unmap_domain_mfn_range(struct vm_area_struct *vma)
> > > +{
> > > +       int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> > > +       struct page **pages = vma ? vma->vm_private_data : NULL;
> > 
> > I thought we agreed to keep uses of vm_private_data in the privcmd
> > driver?
> > 
> > I think you should just add pages and nr as direct parameters to
> > this function, which is symmetric with the map call.
> 
> I had to look at this while rebasing my arm patches, turned out to be
> fairly simple. Feel free to either fold in or badger me for a proper
> commit message.


I made similar change in my tree, except I am not passing vma as its
not needed. I guess you just wanna be consistend with remap, or future
use?

thanks
mukesh


