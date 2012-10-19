Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2JSACc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:02:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18059 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab2JSACb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:02:31 -0400
Date: Thu, 18 Oct 2012 17:02:23 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V3 6/6]: PVH:privcmd changes.
Message-ID: <20121018170223.03ef0913@mantra.us.oracle.com>
In-Reply-To: <1350556553.2460.108.camel@zakaz.uk.xensource.com>
References: <20121017173448.7ef4c0b1@mantra.us.oracle.com>
	<1350556553.2460.108.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012 11:35:53 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> 
> > @@ -439,6 +490,19 @@ static long privcmd_ioctl(struct file *file,
> >  	return ret;
> >  }
> >  
> > +static void privcmd_close(struct vm_area_struct *vma)
> > +{
> > +	struct page **pages = vma ? vma->vm_private_data : NULL;
> 
> Can VMA really be NULL?...

Good programming I thought!

> > +	int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> 
> ...I assume not since you unconditionally dereference it here.

Added this later, and just didn't change the earlier part.

> > +	if (!pages || !numpgs
> > || !xen_feature(XENFEAT_auto_translated_physmap))
> 
> In the non-xlat case pages will (or should!) be 1 here which will pass
> the first clause of the test.
> 
> Although the later clauses will catch this I think it would be worth
> ordering the checks such that they are each valid, perhaps by pulling
> the feature check to the front or by separating the !xlat case from
> the other two which are valid iff xlat == True.
> 

